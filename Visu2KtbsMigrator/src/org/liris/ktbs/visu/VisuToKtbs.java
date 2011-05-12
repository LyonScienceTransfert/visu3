package org.liris.ktbs.visu;

import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.TreeSet;

import org.liris.ktbs.client.Ktbs;
import org.liris.ktbs.client.KtbsConstants;
import org.liris.ktbs.client.KtbsClient;
import org.liris.ktbs.domain.interfaces.IBase;
import org.liris.ktbs.domain.interfaces.ITraceModel;
import org.liris.ktbs.service.MultiUserRootProvider;
import org.liris.ktbs.service.ResourceService;
import org.liris.ktbs.utils.KtbsUtils;
import org.liris.ktbs.visu.vo.ObselVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;


public class VisuToKtbs {

	private static Logger logger = LoggerFactory.getLogger(VisuToKtbs.class);

	private String visuUserName;
	private String visuPasswd;
	private String visuSharedBaseName;
	private String retroRoomModelLocalName;
	private String visuModelLocalName;

	private MultiUserRootProvider rootProvider;

	private SqlMapClient sqlMap;

	public VisuToKtbs(SqlMapClient sqlMap, String userName, String userPasswd,
			String shareBase, String retroRoomModelLocalName,
			String visuModelLocalName) {

		super();
		this.sqlMap = sqlMap;
		this.visuUserName = userName;
		this.visuPasswd = userPasswd;
		this.visuSharedBaseName = shareBase;
		this.retroRoomModelLocalName = retroRoomModelLocalName;
		this.visuModelLocalName = visuModelLocalName;

		this.rootProvider = Ktbs.getMultiUserRestRootProvider();
	}

	public static void main(String[] args) throws IOException, SQLException {

		Reader reader = Resources.getResourceAsReader("ibatis/sqlMapConfig.xml");
		SqlMapClient sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);


		Properties properties = new Properties();
		properties.load(ClassLoader.getSystemResourceAsStream("visu2ktbs.properties"));
		logger.info("Migration config:\n {}", properties.toString());

		VisuToKtbs visuToKtbs = new VisuToKtbs(
				sqlMap,
				properties.getProperty("ktbs.root.username"),
				properties.getProperty("ktbs.root.passwd"),
				properties.getProperty("ktbs.shared.base"),
				properties.getProperty("ktbs.model.retroroom"),
				properties.getProperty("ktbs.model.visu"));

		visuToKtbs.doMigration();
	}

	private int totalObselNb = -1;
	private int obselCnt = 0;

	@SuppressWarnings("unchecked")
	private void createTrace(String traceName) throws SQLException {
		List<ObselVO> obsels = (List<ObselVO>)sqlMap.queryForList("obsel.getObselsInTrace", "%" + traceName + "%");

		Integer userId = VisuToKtbsUtils.parseUserId(traceName);
		KtbsClient client = rootProvider.getClient(VisuToKtbsUtils.makeKtbsUserId(userId));
		ResourceService service = client.getResourceService();

		String username = VisuToKtbsUtils.makeKtbsUserId(VisuToKtbsUtils.parseUserId(traceName));

		Calendar originCal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		originCal.setTimeInMillis(VisuToKtbsUtils.parseTraceOrigin(traceName).getTime());
		String origin = KtbsConstants.XSD_DATETIME_FORMAT.format(originCal.getTime());

		logger.info("{}% - Creating the stored trace {}", new Object[]{(obselCnt*100)/totalObselNb, traceName});
		String storedTraceUri = service.newStoredTrace(
				username, 
				traceName,
				getVisuTraceModelURI(service), 
				origin, 
				username);

		if(storedTraceUri == null) {
			logger.info("The KTBS failed to create the trace {}. It may already exist.", traceName);
			return;
		}


		List<ObselVO> orderedByendDTObsels = new LinkedList<ObselVO>();
		// parse all rdf first
		for(ObselVO vo:obsels) {
			try {
				vo.parseRdf(getVisuTraceModelURI(service), KtbsUtils.resolveParentURI(storedTraceUri));
				orderedByendDTObsels.add(vo);
			} catch (Exception e) {
				logger.error("Error creating the obsel {}. RDF: \n{}\nfixed:\n{}", new Object[]{vo.getId(), vo.getRdf(), vo.getFixedRdf()});
				logger.error("",e);
				vo.setParseFailed(true);
			}
		}


		Collections.sort(orderedByendDTObsels, new Comparator<ObselVO>() {
			@Override
			public int compare(ObselVO o1, ObselVO o2) {
				try {
					if(o1.isParseFailed() && o2.isParseFailed())
						return 0;
					else if(o1.isParseFailed())
						return 1;
					else if(o2.isParseFailed())
						return -1;
					Date date1 = KtbsUtils.parseXsdDate(o1.getEndDT());
					Date date2 = KtbsUtils.parseXsdDate(o2.getEndDT());
					return date1.compareTo(date2);
				} catch (ParseException e) {
					logger.error("Failed to compare endDT dates", e);
					return 0;
				}
			}
		});

		for(ObselVO vo:orderedByendDTObsels) {
			obselCnt++;

			if(vo.isParseFailed()) {
				logger.warn("The obsel {} will not be posted on the trace {}, since Jena could not parse the rdf field.", vo.getId(), traceName);
				continue;
			} else {
				String obselURI = service.newObsel(
						storedTraceUri, 
						null, 
						vo.getTypeUri(), 
						vo.getBeginDT(), 
						vo.getEndDT(), 
						null, 
						null, 
						vo.getSubject(), 
						vo.getAttributes());


				if(obselURI == null) {
					logger.error("The KTBS failed or rejected the creation of the obsel {}");
					logger.error("KTBS response status (KTBS status: {}, HTTP status: {})", new Object[]{service.getLastResponse().getKtbsStatus(), service.getLastResponse().getHttpStatusCode()});
					logger.error("KTBS message {}", new Object[]{service.getLastResponse().getServerMessage()});
					logger.error("The KTBS failed or rejected the creation of the obsel {}. RDF: \n{}\nfixed:\n{}", new Object[]{vo.getId(), vo.getRdf(), vo.getFixedRdf()});
				} 
			}
		}
	}

	private String lazyVisuTraceModelUri = null;
	private String getVisuTraceModelURI(ResourceService service) {
		if(lazyVisuTraceModelUri == null) {
			IBase base = service.getBase(visuSharedBaseName);
			ITraceModel tm = base.get(visuModelLocalName, ITraceModel.class);
			lazyVisuTraceModelUri = tm.getUri();
		}
		return lazyVisuTraceModelUri;
	}

	private void doMigration() throws SQLException {
		createSharedBaseAndModels();
		createKtbsBases(sqlMap);
		createTraces(sqlMap);
	}

	private void createSharedBaseAndModels() {
		rootProvider.openClient(visuUserName, visuUserName);
		ResourceService service = rootProvider.getClient(visuUserName).getResourceService();
		logger.info("Creating the shared base {}.", visuSharedBaseName);
		String baseUri = service.newBase(visuSharedBaseName, visuUserName);
		if(baseUri == null) {
			logger.info("Could not create the base {}. It may already exist", visuSharedBaseName);
		} else {
			logger.info("Creating the trace model {}.", visuModelLocalName);
			service.newTraceModel(baseUri, visuModelLocalName);
		}
	}

	@SuppressWarnings("unchecked")
	private void createKtbsBases(SqlMapClient sqlMap) throws SQLException {

		List<String> traces = (List<String>)sqlMap.queryForList("obsel.getTraces");

		Set<Integer> userIds = new TreeSet<Integer>();
		for(String trace:traces) {
			userIds.add(VisuToKtbsUtils.parseUserId(trace));
		}

		for(Integer userId:userIds) {
			String userName = VisuToKtbsUtils.makeKtbsUserId(userId);
			rootProvider.openClient(userName, userName);
			KtbsClient client = rootProvider.getClient(userName);
			String uri = client.getResourceService().newBase(userName, userName);
			logger.info("Created ktbs:Base at {}", uri);
		}
	}

	@SuppressWarnings("unchecked")
	private void createTraces(SqlMapClient sqlMap) throws SQLException {
		List<ObselVO> allObsels = (List<ObselVO>)sqlMap.queryForList("obsel.getObsels");
		logger.info("Number of obsels in visu database: {}", allObsels.size());
		totalObselNb = allObsels.size();

		List<String> allTraces = (List<String>)sqlMap.queryForList("obsel.getTraces");
		logger.info("Number of traces in visu database: {}", allTraces.size());

		// Ensures that the traces are not processed in the same order each time
		Collections.shuffle(allTraces);
		for(String trace:allTraces) {
			String traceName = trace.replaceAll("<","").replaceAll(">","");
			createTrace(traceName);
		}
	}
}
