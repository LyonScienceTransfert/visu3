package org.liris.ktbs.visu.model;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Properties;

import org.liris.ktbs.client.Ktbs;
import org.liris.ktbs.domain.interfaces.ITraceModel;
import org.liris.ktbs.service.ResourceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CreateVisuTraceModels {

	private static Logger logger = LoggerFactory.getLogger(CreateVisuTraceModels.class);

	@SuppressWarnings("unchecked")
	public static void main(String[] args) throws IOException, SQLException {
		String rootUri = Ktbs.getRestClient().getRootUri();
		
		Properties properties = new Properties();
		properties.load(ClassLoader.getSystemResourceAsStream("visu2ktbs.properties"));

		String bName = properties.getProperty("ktbs.shared.base");

		String visuTMName= properties.getProperty("ktbs.model.visu");
//		String rrTMName = properties.getProperty("ktbs.model.retroroom");
		
		ITraceModel rrTM = createTraceModel(bName, visuTMName);
		new RetroRoomTraceModelFiller().fill(rrTM, Ktbs.getPojoFactory());
		Ktbs.getRestClient().getResourceService().saveResource(rrTM, true);
		
		ITraceModel visuTM = createTraceModel(bName, visuTMName);
		new VisuModelFiller().fill(visuTM, Ktbs.getPojoFactory());
		Ktbs.getRestClient().getResourceService().saveResource(visuTM, true);
		
		logger.info("rootUri: {}", rootUri);
	}


	private static ITraceModel createTraceModel(String bLocalName, String tmLocalName) {
		ResourceService service = Ktbs.getRestClient().getResourceService();
		service.newBase(bLocalName);
		String uri = service.newTraceModel(bLocalName, tmLocalName);
		logger.debug("Trace model created: {}", uri);
		ITraceModel traceModel = service.getTraceModel(bLocalName+"/"+tmLocalName);
		logger.debug("Returning the trace model {}", traceModel);
		return traceModel;
	}

}
