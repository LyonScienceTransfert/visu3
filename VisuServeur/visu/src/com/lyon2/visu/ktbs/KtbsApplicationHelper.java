package com.lyon2.visu.ktbs;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;

import org.liris.ktbs.client.KtbsRootClient;
import org.liris.ktbs.domain.interfaces.IBase;
import org.liris.ktbs.domain.interfaces.IStoredTrace;
import org.liris.ktbs.domain.interfaces.ITraceModel;
import org.liris.ktbs.service.MultiUserRootProvider;
import org.liris.ktbs.service.ResourceService;
import org.liris.ktbs.service.StoredTraceService;
import org.liris.ktbs.service.impl.ObselBuilder;
import org.liris.ktbs.service.impl.RootAwareService;
import org.liris.ktbs.utils.KtbsUtils;
import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.lyon2.visu.domain.model.User;

public class KtbsApplicationHelper {

	private static Logger log = Red5LoggerFactory.getLogger(KtbsApplicationHelper.class, "visu2");

	// injected by Spring
	private MultiUserRootProvider rootProvider;
	public void setRootProvider(MultiUserRootProvider rootProvider) {
		this.rootProvider = rootProvider;
	}

	// injected by Spring
	private SqlMapClient sqlMapClient;
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	// injected by Spring
	private String username;
	public void setUsername(String username) {
		this.username = username;
	}
	
	// injected by Spring
	private String passwd;
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	
	// injected by Spring
	private String retroRoomTraceModelName;
	public void setRetroRoomTraceModelName(String retroRoomTraceModelName) {
		this.retroRoomTraceModelName = retroRoomTraceModelName;
	}
	
	// injected by Spring
	private String visuTraceModelName;
	public void setVisuTraceModelName(String visuTraceModelName) {
		this.visuTraceModelName = visuTraceModelName;
	}
	
	// injected by Spring
	private String sharedBaseName;
	public void setSharedBaseName(String sharedBaseName) {
		this.sharedBaseName = sharedBaseName;
	}
	
	// the root client for the user "visu"
	private KtbsRootClient visuUserRootClient;

	// a flag, true if all KTBS resources have been created on / downloaded from the KTBS
	// false otherwise
	private boolean started = false;

	private KtbsRootClient getVisuUserRootClient() {
		if(visuUserRootClient == null) {
			if(rootProvider.hasClient(username))
				visuUserRootClient = rootProvider.getClient(username);
			else {
				if(rootProvider.openClient(username, passwd))
					visuUserRootClient = rootProvider.getClient(username);
				else
					log.error("Could not start the Ktbs service. Impossible to create a root client for the user \"share\".");
			}
		}
		return visuUserRootClient;
	}

	// invoked from Spring (destroy-method)
	public void destroy() {
		if(cacheTimer != null) {
			cacheTimer.cancel();
			cacheTimer = null;
		}
		started = false;
	}

	// invoked from Spring (init-method)
	public void init() {
		log.info("Initializing the KTBS Client.");

		// creates the KtbsRootClientObject
		KtbsRootClient client = getVisuUserRootClient();
		String notInitializedMessage = "The KTBS client service could not be initialized";
		if(client == null) {
			log.warn(notInitializedMessage + " (root client is null)");
			return;
		}

		log.info("The KTBS root is: " + getVisuUserRootClient().getRootUri());
		ResourceService resourceService = client.getResourceService();

		// creates the java object for the ktbs:Base "visuBase"
		IBase visuBase = resourceService.getBase(sharedBaseName);
		if(visuBase == null) {
			log.info("The base \""+sharedBaseName+"\" does not exist. Creating it.");
			log.debug("Root URI is DefaultResourceManager is: " + ((RootAwareService)resourceService).getRootUri());
			visuBase = resourceService.newBase(sharedBaseName, username);
			if(visuBase == null) {
				log.error("Could not create a base for the user \"visu\".");

			} else
				visuBase = resourceService.getBase(sharedBaseName);
		}

		if(visuBase == null) {
			log.warn(notInitializedMessage + " (the shared base is null)");
			return;
		}

		// creates the trace models
		retroRoomTraceModel = initializeTraceModel(visuBase, retroRoomTraceModelName, client);
		visuTraceModel = initializeTraceModel(visuBase, visuTraceModelName, client);

		if(retroRoomTraceModel == null || visuTraceModel == null) {
			log.warn(notInitializedMessage);
			return;
		}

		// init the timer that will
		int period = CACHE_CLEAN_PERIOD*60*1000; // period in ms
		cacheTimer.schedule(cleanStoredTraceCacheTask, period/2, period);

		this.started = true;
	}

	private ITraceModel initializeTraceModel(IBase base, String modelLocalName, KtbsRootClient client) {
		ITraceModel model = base.get(modelLocalName, ITraceModel.class); 
		if(model == null) {
			log.info("The trace model \""+modelLocalName+"\" does not exist. Creating it.");
			model = client.getResourceService().newTraceModel(base.getUri(), modelLocalName);
			if(model == null) 
				log.error("The trace model \""+modelLocalName+"\" could not be created."); 
			else {
				log.info("Creating the content of the \"Retro room\" trace model. May take a few seconds...");
				RetroRoomTraceModel.load(client, base.getUri(), modelLocalName);
				log.info("\"Retro room\" trace model created.");
			}
		}

		return model;
	}


	private ITraceModel retroRoomTraceModel;
	private ITraceModel visuTraceModel;

	// A cache for stored trace
	private Map<String, IStoredTrace> storedTraceCache = new ConcurrentHashMap<String, IStoredTrace>();
	private Map<Integer, IBase> baseCache = new ConcurrentHashMap<Integer, IBase>();

	// The cache cleaning period in minutes
	private static final int CACHE_CLEAN_PERIOD = 1440; // one day (24*60)
	private Timer cacheTimer = new Timer();
	private TimerTask cleanStoredTraceCacheTask = new TimerTask() {
		@Override
		public void run() {
			KtbsApplicationHelper.this.storedTraceCache.clear();
			KtbsApplicationHelper.this.baseCache.clear();
		}
	};

	public void sendToKtbs(Integer subject, String trace, String typeObsel,
			List<Object> paramsObsel, String[] traceType) throws SQLException {
		if(!started) {
			String message = "The KTBS client service is not started. The obsel will not be sent to the KTBS server: ";
			message += getObselSimpleString(subject, trace, typeObsel);
			log.warn(message);
			return;
		} else
			log.info("Sending the obsel to the KTBS: " + getObselSimpleString(subject, trace, typeObsel));

		KtbsRootClient rootClient = getRootClient(subject);
		if(rootClient == null) {
			log.warn("Could not get a root client for the user: " + subject);
			return;
		}

		// Get the base, or create it if none exists
		// Getting the base ensures that it is created when trying to create the stored trace
		IBase base = getBase(subject, rootClient.getResourceService());
		if(base == null) {
			log.warn("Could not send the obsel to the KTBS (base is null)");
			return;
		}

		// Get the stored trace, or create it if none exists
		IStoredTrace storedTrace = getStoredTrace(subject, trace, rootClient.getResourceService());
		if(storedTrace == null) {
			log.warn("Could not send the obsel to the KTBS (storedtrace is null)");
			return;
		}

		// collect this obsel to the stored trace on the KTBS
		StoredTraceService service = rootClient.getStoredTraceService();
		ObselBuilder builder = service.newObselBuilder(storedTrace);
		builder.setBeginDT(KtbsUtils.now());
		builder.setType(storedTrace.getTraceModel().getUri() + typeObsel);
		builder.setSubject(makeKtbsUserName(subject));
		for(int k=0; k<paramsObsel.size(); k+=2) {
			String attributeTypeUri = storedTrace.getTraceModel().getUri()+(String)paramsObsel.get(k);
			if(Iterable.class.isAssignableFrom(paramsObsel.get(k+1).getClass())) {
				Iterator<?> it = ((Iterable<?>)paramsObsel.get(k+1)).iterator();
				while (it.hasNext()) {
					builder.addAttribute(attributeTypeUri,it.next());
				}
			} else
				builder.addAttribute(attributeTypeUri,paramsObsel.get(k+1));
		}

		String uri = builder.create();
		if(uri == null)
			log.warn("The obsel could not be created on the KTBS server");
		else
			log.info("The obsel " + uri + " has been created on the KTBS");

	}
	
	private KtbsRootClient getRootClient(Integer subject) throws SQLException {
		String ktbsUserName = makeKtbsUserName(subject);
		KtbsRootClient rootClient = null;
		if(rootProvider.hasClient(ktbsUserName)) {
			log.debug("A root client already exists for the user " + subject + " (base name: "+ktbsUserName+")");
			rootClient = rootProvider.getClient(ktbsUserName);
		} else {
			log.debug("A root client does not exist for the user " + subject + " (base name: "+ktbsUserName+")");
			User user = (User) sqlMapClient.queryForObject("users.getUser", subject);
			log.debug("Opening a root client for the user " + subject + " (username: "+ user.getFirstname() + " " + user.getLastname() +", mail: "+user.getMail()+", passwd: "+user.getPassword()+")");
			if(rootProvider.openClient(ktbsUserName, user.getPassword())) {
				log.debug("Root client opened");
				rootClient = rootProvider.getClient(ktbsUserName);
			} else {
				log.warn("Opening failed");
			}
		}

		return rootClient;
	}

	private IBase getBase(Integer userId, ResourceService resourceService) {
		IBase base = baseCache.get(userId);
		if(base == null) {
			log.debug("No base cached for user" + userId);
			String baseName = makeKtbsUserName(userId);
			log.info("Retrieving the base " + baseName + " from the KTBS server");


			// retrieve the base from the KTBS
			base = resourceService.getBase(baseName);
			if(base == null) {
				log.debug("No base " + baseName + " exists on the KTBS server");
				// create the base
				log.info("Creating the base " + baseName + " on the KTBS server for the user " + userId);
				base = resourceService.newBase(
						baseName,
						Integer.toString(userId)
				);

				if(base == null) 
					log.error("Could not create the base " + baseName + " for the user ");
				else {
					log.debug("The base has been created");
				}
			}

		}

		if(base != null)
			baseCache.put(userId, base);
		return base;
	}

	/*
	 * Give the KTBS user name mapped to the user id in visu db.
	 */
	private String makeKtbsUserName(Integer subject) {
		return "user" + Integer.toString(subject);
	}

	private IStoredTrace getStoredTrace(
			Integer userId, 
			String traceLocalName, 
			ResourceService resourceService) throws SQLException {
		
		String baseName = makeKtbsUserName(userId);
		
		IStoredTrace storedTrace = storedTraceCache.get(traceLocalName);
		
		if(storedTrace == null) {
			log.debug("The trace " + traceLocalName + " is not in the cache");
			
			log.info("Retrieving the trace " + traceLocalName + " from the KTBS");
			storedTrace = resourceService.getResource(baseName + "/" + traceLocalName, IStoredTrace.class);
			
			if(storedTrace == null) {
				log.info("The trace " + traceLocalName + " could not be retrieved from the KTBS. Creating a new one.");
				
				storedTrace = resourceService.newStoredTrace(
						baseName, 
						traceLocalName, 
						visuTraceModel.getUri(), 
						KtbsUtils.now(), 
						Integer.toString(userId)
				);

				if(storedTrace == null) 
					log.error("Could not create the trace " + traceLocalName);
			} else 
				log.debug("The trace " + storedTrace.getUri() + " was retrieved successfully");
			storedTraceCache.put(traceLocalName, storedTrace);
			return storedTraceCache.get(traceLocalName);
		} else
			return storedTrace;
	}

	private String getObselSimpleString(Integer subject, String trace,
			String typeObsel) {
		String message = "";
		message+="[user=" + subject;
		message+=", trace=" + trace;
		message+=", type=" + typeObsel;
		message+="]";
		return message;
	}

}
