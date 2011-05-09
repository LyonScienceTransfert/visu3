package org.liris.ktbs.visu.model;

import java.io.Reader;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import org.liris.ktbs.client.Ktbs;
import org.liris.ktbs.domain.PojoFactory;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.domain.interfaces.IObselType;
import org.liris.ktbs.domain.interfaces.ITraceModel;
import org.liris.ktbs.utils.KtbsUtils;
import org.liris.ktbs.visu.vo.ObselVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Multimap;
import com.google.common.collect.TreeMultimap;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.rdf.model.StmtIterator;
import com.hp.hpl.jena.vocabulary.RDF;
import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

public class VisuModelFiller extends TraceModelFiller {

	private static Logger logger = LoggerFactory.getLogger(VisuModelFiller.class);

	@SuppressWarnings("unchecked")
	@Override
	public void fill(ITraceModel traceModel, PojoFactory factory) {
		Reader reader;
		try {
			reader = Resources.getResourceAsReader("ibatis/sqlMapConfig.xml");
			SqlMapClient sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);

			Properties properties = new Properties();
			properties.load(ClassLoader.getSystemResourceAsStream("visu2ktbs.properties"));

			List<ObselVO> allObsels = (List<ObselVO>)sqlMap.queryForList("obsel.getObsels");
			logger.info("Number of obsels in visu database: {}", allObsels.size());


			Multimap<String, String> attributesPerType = TreeMultimap.create();


			int cnt = 0;
			for(ObselVO obselVO:allObsels) {
				cnt++;
				if(cnt>24000)
					break;
				if(cnt%1000 == 0) {
					
					logger.info("Obsel {} on {}. Multimap: {} types, {} attributes", new Object[]{
							cnt, 
							allObsels.size(),
							attributesPerType.keySet().size(),
							attributesPerType.values().size()
							});
				}

				try {
					obselVO.parseRdf(
							traceModel.getUri(),
							KtbsUtils.resolveParentURI(traceModel.getUri()));

					Model model = obselVO.getModel();

					StmtIterator it = model.listStatements(obselVO.asRdfResource(), null, (RDFNode)null);
					while (it.hasNext()) {
						Statement statement = (Statement) it.next();
						Property p = statement.getPredicate();
						if(p.getURI().startsWith(traceModel.getUri())) {
							Resource typeUri = obselVO.asRdfResource().getPropertyResourceValue(RDF.type);
							attributesPerType.put(typeUri.getLocalName(), p.getLocalName());
						}
					}
					
					obselVO.consume();
				} catch (Exception e) {
					logger.error("Error with obsel {}", obselVO.getId());
					logger.info(e.getMessage());
					logger.debug("RDF: \n{}", obselVO.getRdf());
					logger.debug("Fixed RDF: \n{}", obselVO.getRdf());
				}
			}

			ITraceModel rrtm = factory.createTraceModel(KtbsUtils.resolveParentURI(traceModel.getUri()));
			fillTraceModel(traceModel, filterMultimap(attributesPerType, rrtm));
		} catch (Exception e) {
			logger.error("",e);
		}
	}


	private Multimap<String, String> filterMultimap(Multimap<String, String> map, ITraceModel model) {
		Multimap<String, String> filtered = TreeMultimap.create();
		filtered.putAll(map);

		for(IObselType obselType:model.getObselTypes()) {

			String attLocalName = KtbsUtils.resolveLocalName(obselType.getUri());
			filtered.removeAll(attLocalName);
		}

		return filtered;
	}

	private static void fillTraceModel(ITraceModel model,
			Multimap<String, String> attributesPerType) {

		PojoFactory f = Ktbs.getPojoFactory();

		// Create all attributes
		Set<String> attributes = new HashSet<String>();
		attributes.addAll(attributesPerType.values());
		logger.info("Creating attributes");
		for(String att:attributes) {
			logger.debug("Creating the attribute {}", att);
			IAttributeType attType = f.createAttributeType(model.getUri(), att);
			model.getAttributeTypes().add(attType);
		}

		logger.info("Creating obsel types");
		for(String type:attributesPerType.keySet()) {
			logger.debug("Creating the obsel type {}", type);
			IObselType obselType = f.createObselType(model.getUri(), type);
			for(String att:attributesPerType.get(type)) {
				IAttributeType attType = model.get(att, IAttributeType.class);
				attType.getDomains().add(obselType);
			}
		}
	}
}
