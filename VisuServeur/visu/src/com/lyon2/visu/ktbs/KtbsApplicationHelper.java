package com.lyon2.visu.ktbs;

import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;

import org.liris.ktbs.client.ClientFactory;
import org.liris.ktbs.client.KtbsClient;
import org.liris.ktbs.domain.interfaces.IBase;
import org.liris.ktbs.domain.interfaces.IKtbsResource;
import org.liris.ktbs.domain.interfaces.IObsel;
import org.liris.ktbs.domain.interfaces.IStoredTrace;
import org.liris.ktbs.domain.interfaces.ITrace;
import org.liris.ktbs.domain.interfaces.ITraceModel;
import org.liris.ktbs.service.ResourceService;
import org.liris.ktbs.service.StoredTraceService;
import org.liris.ktbs.service.impl.ObselBuilder;
import org.liris.ktbs.utils.KtbsUtils;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;
import org.slf4j.Logger;

public class KtbsApplicationHelper {

	private static Logger log = Red5LoggerFactory.getLogger(
			KtbsApplicationHelper.class, "visu2");

	// injected by Spring
	private ClientFactory clientFactory;

	public void setClientFactory(ClientFactory clientFactory) {
		this.clientFactory = clientFactory;
	}

	// injected by Spring
	private String rootUri;

	public void setRootUri(String rootUri) {
		this.rootUri = rootUri;
	}

	// injected by Spring
	private String sharedUsername;

	public void setSharedUsername(String sharedUsername) {
		this.sharedUsername = sharedUsername;
	}

	// injected by Spring
//	private String retroRoomTraceModelName;

//	public void setRetroRoomTraceModelName(String retroRoomTraceModelName) {
//		this.retroRoomTraceModelName = retroRoomTraceModelName;
//	}

	// injected by Spring
	private String visuTraceModelName;

	public void setVisuTraceModelName(String visuTraceModelName) {
		this.visuTraceModelName = visuTraceModelName;
	}

	// a flag, true if all KTBS resources have been created on / downloaded from
	// the KTBS
	// false otherwise
	private boolean started = false;

	public boolean isStarted() {
		return started;
	}

	private Map<String, KtbsClient> ktbsClients = new HashMap<String, KtbsClient>();

	private KtbsClient getUserKtbsClient(Integer subject) throws SQLException {
		String ktbsUserName = makeKtbsUserName(subject);
		String ktbsUserPassword = ktbsUserName;
		KtbsClient ktbsClientClient = getKtbsClient(ktbsUserName,
				ktbsUserPassword);
		return ktbsClientClient;
	}

	private KtbsClient getSharedKtbsClient() {
		return getKtbsClient(sharedUsername, sharedUsername);
	}

	private KtbsClient getKtbsClient(String userName, String userPassword) {
		if (ktbsClients.get(userName) == null) {
			KtbsClient ktbsClient = clientFactory.createRestCachingClient(
					rootUri, userName, userPassword, 1000, 10000l);
			ktbsClients.put(userName, ktbsClient);
			String baseUri = ktbsClient.getResourceService().newBase(userName);

			if (log.isDebugEnabled()) {
				if (baseUri != null)
					log.debug("The base {} has been created on KTBS", baseUri);
				else
					log
							.debug(
									"A base already exists on the KTBS for the user {}. No need to create one",
									userName);
			}
		}
		return ktbsClients.get(userName);
	}

	// invoked from Spring (destroy-method)
	public void destroy() {
		if (cacheTimer != null) {
			cacheTimer.cancel();
			cacheTimer = null;
		}
		started = false;
	}

	// invoked from Spring (init-method)
	public void init() {
		log.info("Initializing the KTBS Client.");

		// creates the KtbsClientObject
		KtbsClient client = getSharedKtbsClient();
		String notInitializedMessage = "The KTBS client service could not be initialized";
		if (client == null) {
			log.warn(notInitializedMessage + " (root client is null)");
			return;
		}

		log.info("The KTBS root is: " + getSharedKtbsClient().getRootUri());
		ResourceService resourceService = client.getResourceService();

		// creates the java object for the ktbs:Base "visuBase"
		IBase visuBase = resourceService.getBase(sharedUsername);
		if (visuBase == null) {
			log.info("The base \"" + sharedUsername
					+ "\" does not exist. Creating it.");
			log.debug("Root URI is DefaultResourceManager is: "
					+ resourceService.getRootUri());

			String visuBaseUri = resourceService.newBase(sharedUsername);
			if (visuBaseUri == null) {
				log.error("Could not create a base for the user \"visu\".");
			} else
				visuBase = resourceService.getBase(visuBaseUri);
		}

		if (visuBase == null) {
			log.warn(notInitializedMessage + " (the shared base is null)");
			return;
		}

		// creates the trace models
//		retroRoomTraceModel = initializeTraceModel(visuBase,
//				retroRoomTraceModelName, client);
		visuTraceModel = initializeTraceModel(visuBase, visuTraceModelName,
				client);

		if (visuTraceModel == null) {
			log.warn(notInitializedMessage);
			return;
		}

		// init the timer that will
		int period = CACHE_CLEAN_PERIOD * 60 * 1000; // period in ms
		cacheTimer.schedule(cleanStoredTraceCacheTask, period / 2, period);

		this.started = true;
	}

	private ITraceModel initializeTraceModel(IBase base, String modelLocalName,
			KtbsClient client) {
		ITraceModel model = base.get(modelLocalName, ITraceModel.class);
		if (model == null) {
			log.info("The trace model \"" + modelLocalName
					+ "\" does not exist. Creating it.");
			String modelUri = client.getResourceService().newTraceModel(
					base.getUri(), modelLocalName);
			if (modelUri == null)
				log.error("The trace model \"" + modelLocalName
						+ "\" could not be created.");
			else {
				model = client.getResourceService().getTraceModel(modelUri);
			}
		}

		log
				.info(
						"Creating the content of the \"{}\" trace model. May take a few seconds...",
						modelLocalName);
		RetroRoomTraceModel.load(client, base.getUri(), modelLocalName);
		log.info("trace model created.");

		return model;
	}

//	private ITraceModel retroRoomTraceModel;
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

	public void sendToKtbs(IConnection conn, Integer subject, String trace,
			String typeObsel, List<Object> paramsObsel, String[] traceType)
			throws SQLException {
		if (!started) {
			String message = "The KTBS client service is not started. The obsel will not be sent to the KTBS server: ";
			message += getObselSimpleString(subject, trace, typeObsel);
			log.warn(message);
			return;
		} else
			log.info("Sending the obsel to the KTBS: "
					+ getObselSimpleString(subject, trace, typeObsel));

		KtbsClient rootClient = getUserKtbsClient(subject);
		if (rootClient == null) {
			log.warn("Could not get a root client for the user: " + subject);
			return;
		}

		// Get the base, or create it if none exists
		// Getting the base ensures that it is created when trying to create the
		// stored trace
		IBase base = getBase(subject, rootClient.getResourceService());
		if (base == null) {
			log.warn("Could not send the obsel to the KTBS (base is null)");
			return;
		}

		// Get the stored trace, or create it if none exists
		IStoredTrace storedTrace = getStoredTrace(subject, trace, rootClient
				.getResourceService());
		if (storedTrace == null) {
			log
					.warn("Could not send the obsel to the KTBS (storedtrace is null)");
			return;
		}

		// collect this obsel to the stored trace on the KTBS
		StoredTraceService service = rootClient.getStoredTraceService();
		ObselBuilder builder = service.newObselBuilder(storedTrace);
		String now = KtbsUtils.now();
		builder.setBeginDT(now);
		builder.setEndDT(now);
		builder.setType(storedTrace.getTraceModel().getUri() + typeObsel);
		builder.setSubject(makeKtbsUserName(subject));
		for (int k = 0; k < paramsObsel.size(); k += 2) {
			String attributeTypeUri = storedTrace.getTraceModel().getUri()
					+ (String) paramsObsel.get(k);
			if (Iterable.class.isAssignableFrom(paramsObsel.get(k + 1)
					.getClass())) {
				Iterator<?> it = ((Iterable<?>) paramsObsel.get(k + 1))
						.iterator();
				while (it.hasNext()) {
					builder.addAttribute(attributeTypeUri, it.next());
				}
			} else
				builder.addAttribute(attributeTypeUri, paramsObsel.get(k + 1));
		}

		String uri = builder.create();
		if (uri == null) {

			log.warn("The obsel could not be created on the KTBS server");
		} else {
			log.info("The obsel " + uri + " has been created on the KTBS");
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;

			if (conn != null) {

				IObsel o = null;
				for (IObsel obsel : getTraceObsels((Integer) conn.getClient()
						.getAttribute("uid"), trace)) {
					if (obsel.getUri().equals(uri)) {
						o = obsel;
						break;
					}
				}
				sc.invoke("obselAdded", new Object[] { o });
			} else {
				log
						.warn("Unable to notify clients of the new added obsel without a Red5 Connection");
			}
		}

	}

	private IBase getBase(Integer userId, ResourceService resourceService) {
		IBase base = baseCache.get(userId);
		if (base == null) {
			log.debug("No base cached for user" + userId);
			String baseName = makeKtbsUserName(userId);
			log.info("Retrieving the base " + baseName
					+ " from the KTBS server");

			// retrieve the base from the KTBS
			base = resourceService.getBase(baseName);
			if (base == null) {
				log.error("No base " + baseName + " exists on the KTBS server");
				log.error("Ktbs response status: {}", resourceService
						.getLastResponse().getHttpStatusCode());
				log.error("Ktbs response message: \n{}", resourceService
						.getLastResponse().getServerMessage());
			}
		} else
			baseCache.put(userId, base);
		return base;
	}

	/*
	 * Give the KTBS user name mapped to the user id in visu db.
	 */
	private String makeKtbsUserName(Integer subject) {
		return "user" + Integer.toString(subject);
	}

	private IStoredTrace getStoredTrace(Integer userId, String traceLocalName,
			ResourceService resourceService) throws SQLException {

		String baseName = makeKtbsUserName(userId);

		IStoredTrace storedTrace = storedTraceCache.get(traceLocalName);

		if (storedTrace == null) {
			log.info("The trace " + traceLocalName + " is not in the cache");

			log.info("Retrieving the trace " + traceLocalName
					+ " from the KTBS");
			storedTrace = resourceService.getResource(baseName + "/"
					+ traceLocalName, IStoredTrace.class);

			if (storedTrace == null) {
				log
						.info("The trace "
								+ traceLocalName
								+ " could not be retrieved from the KTBS. Creating a new one.");

				String storedTraceUri = resourceService.newStoredTrace(
						baseName, traceLocalName, visuTraceModel.getUri(),
						KtbsUtils.now(), null, null, null, null, Integer
								.toString(userId));

				if (storedTraceUri == null)
					log.error("Could not create the trace " + traceLocalName);
				else
					storedTrace = resourceService
							.getStoredTrace(storedTraceUri);
			} else
				log.info("The trace " + storedTrace.getUri()
						+ " was retrieved successfully");
			storedTraceCache.put(traceLocalName, storedTrace);
			return storedTraceCache.get(traceLocalName);
		} else
			return storedTrace;
	}

	private String getObselSimpleString(Integer subject, String trace,
			String typeObsel) {
		String message = "";
		message += "[user=" + subject;
		message += ", trace=" + trace;
		message += ", type=" + typeObsel;
		message += "]";
		return message;
	}

	public Collection<IObsel> getTraceObsels(Integer uid, String traceId) {
		IBase base = getBase(uid);
		IKtbsResource trace = base.get(traceId);
		if (trace != null && trace instanceof ITrace)
			return ((ITrace) trace).getObsels();
		else
			return null;
	}

	private IBase getBase(Integer uid) {
		IBase base = getKtbsClient(uid).getResourceService().getBase(
				makeKtbsUserName(uid));
		if (base == null) {
			String baseUri = getKtbsClient(uid).getResourceService().newBase(
					makeKtbsUserName(uid));
			base = getKtbsClient(uid).getResourceService().getBase(baseUri);
		}
		return base;
	}

	private KtbsClient getKtbsClient(Integer uid) {
		String username = makeKtbsUserName(uid);
		KtbsClient client = ktbsClients.get(username);
		if (client == null)
			ktbsClients.put(username, clientFactory.createRestCachingClient(
					rootUri, username, username, 1000, 10000l));
		return ktbsClients.get(username);
	}

	public Collection<ITrace> getTraces(Integer uid) {
		IBase base = getBase(uid);
		Collection<ITrace> traces = new HashSet<ITrace>();
		traces.addAll(base.getStoredTraces());
		traces.addAll(base.getComputedTraces());
		return traces;
	}
}
