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

	public static void main(String[] args) throws IOException, SQLException {
		String rootUri = Ktbs.getRestClient().getRootUri();
		logger.info("Creating Visu trace models on the kTBS root {}", rootUri);
		
		Properties properties = new Properties();
		properties.load(ClassLoader.getSystemResourceAsStream("visu2ktbs.properties"));

		String bName = properties.getProperty("ktbs.shared.base");
		String visuTMName= properties.getProperty("ktbs.model.visu");
		
		ITraceModel visuTM = createTraceModel(bName, visuTMName);
		visuTM.getObselTypes().clear();
		visuTM.getAttributeTypes().clear();
		visuTM.getRelationTypes().clear();
		new RetroRoomTraceModelFiller().fill(visuTM, Ktbs.getPojoFactory());
		new VisuModelFillerFromScratch().fill(visuTM, Ktbs.getPojoFactory());
		Ktbs.getRestClient().getResourceService().saveResource(visuTM, true);
	}


	private static ITraceModel createTraceModel(String bLocalName, String tmLocalName) {
		ResourceService service = Ktbs.getRestClient().getResourceService();
		service.newBase(bLocalName);
		logger.info("Creating the trace model");
		String uri = service.newTraceModel(bLocalName, tmLocalName);
		if(uri != null)
			logger.info("Trace model created: {}", uri);
		
		ITraceModel traceModel = service.getTraceModel(bLocalName+"/"+tmLocalName);
		logger.info("Working trace model: {}", traceModel.getUri());
		
		return traceModel;
	}

}
