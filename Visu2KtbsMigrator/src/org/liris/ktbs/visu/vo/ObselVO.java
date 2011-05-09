package org.liris.ktbs.visu.vo;

import java.io.StringReader;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.TimeZone;

import org.liris.ktbs.client.KtbsConstants;
import org.liris.ktbs.domain.AttributePair;
import org.liris.ktbs.domain.PojoFactory;
import org.liris.ktbs.domain.interfaces.IAttributePair;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.visu.VisuToKtbsUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.rdf.model.StmtIterator;
import com.hp.hpl.jena.vocabulary.RDF;

public class ObselVO {

	private static Logger logger = LoggerFactory.getLogger(ObselVO.class);

	private Integer id;
	private String trace;
	private String type;
	private Date begin;
	private String rdf;

	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getTrace() {
		return trace;
	}
	public void setTrace(String trace) {
		this.trace = trace;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getBegin() {
		return begin;
	}
	public void setBegin(Date begin) {
		this.begin = begin;
	}
	public String getRdf() {
		return rdf;
	}
	public void setRdf(String rdf) {
		this.rdf = rdf;
	}


	private String beginDT;
	private String endDT;
	private String subject;
	private String typeUri;
	private Set<IAttributePair> attributes = new HashSet<IAttributePair>();

	public String getBeginDT() {
		return beginDT;
	}
	public String getEndDT() {
		return endDT;
	}
	public String getSubject() {
		return subject;
	}
	public String getTypeUri() {
		return typeUri;
	}
	public Set<IAttributePair> getAttributes() {
		return attributes;
	}

	private PojoFactory factory = new PojoFactory();

	private String fixedRdf;

	public String getFixedRdf() {
		return fixedRdf;
	}
	
	public void parseRdf(String traceModelUri, String userbaseUri) throws Exception {
		logger.debug("Parsing the rdf field content of obsel {}", id);

		fixedRdf = VisuToKtbsUtils.fixRdfString(rdf, traceModelUri, userbaseUri);
		model = ModelFactory.createDefaultModel();
		model.read(new StringReader(fixedRdf), "", KtbsConstants.JENA_TURTLE);


		StmtIterator it2 = model.listStatements();
		obselResource = null;
		while (it2.hasNext()) {
			Statement statement = (Statement) it2.next();
			logger.debug("New statement: {}", statement);
			String predicateUri = statement.getPredicate().getURI();
			String pHasTrace = KtbsConstants.P_HAS_TRACE;
			if(predicateUri.equals(pHasTrace)) {
				obselResource = statement.getSubject();
				break;
			}
		}

		if(obselResource != null) {
			logger.debug("Obsel resource found in RDF model");
			StmtIterator propIt = obselResource.listProperties();
			while (propIt.hasNext()) {
				Statement statement = (Statement) propIt.next();

				// is an attribute statement ?
				if(statement.getPredicate().getURI().startsWith(traceModelUri)) {
					if(statement.getObject().isLiteral()) {
						
					attributes.add(new AttributePair(
							factory.createResource(statement.getPredicate().getURI(), IAttributeType.class), 
							statement.getObject().asLiteral().getValue()));
					} else if(statement.getObject().isResource()) {
						Resource asResource = statement.getObject().asResource();
						if(asResource.getProperty(RDF.first) != null && asResource.getProperty(RDF.rest) != null) {
							Set<Object> values = new HashSet<Object>();
							
							while(!asResource.equals(RDF.nil)) {
								Statement value = asResource.getProperty(RDF.first);
								if(value != null && value.getObject().isLiteral()) {
									values.add(value);
									asResource = asResource.getProperty(RDF.rest).getObject().asResource();
								} else
									logger.warn("Unexpected value type in RDF collection {}", statement);
							}
							
							for(Object o:values) {
								attributes.add(new AttributePair(
										factory.createResource(statement.getPredicate().getURI(), IAttributeType.class), 
										o));
							}
						} else if(asResource.equals(RDF.nil)) {
							// do nothing: the resource is an empty RDF collection 
						} else
							logger.warn("Obsel {}: Unexpected resource type for the object of statement {}", id, statement);
					} else {
						logger.warn("Obsel {}: Unexpected object type in obsel statement {}", id, statement);
					}
				}
			}

			this.typeUri = obselResource.getProperty(RDF.type).getObject().asResource().getURI();
			Statement beginDTStmt = obselResource.getProperty(model.getProperty(KtbsConstants.P_HAS_BEGIN));
			this.beginDT = getXSDDateTime(beginDTStmt);
			
			Statement endDTStmt = obselResource.getProperty(model.getProperty(KtbsConstants.P_HAS_END));
			this.endDT = getXSDDateTime(endDTStmt);
			
			Statement subjectStmt = obselResource.getProperty(model.getProperty(KtbsConstants.P_HAS_SUBJECT));
			this.subject = subjectStmt.getObject().asLiteral().getString();
			
		} else {
			logger.error("Unable to find the ktbs:hasTrace statement");
			logger.error("RDF:\n{}", fixedRdf);
		}
	}
	private String getXSDDateTime(Statement stmt) {
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		cal.setTimeInMillis(stmt.getObject().asLiteral().getLong());
//		XSDDateTime xsdDateTime = new XSDDateTime(beginDtCal);
		return KtbsConstants.XSD_DATETIME_FORMAT.format(cal.getTime());
	}
	
	
	public Resource asRdfResource() {
		return obselResource;
	}
	
	public Model getModel() {
		return model;
	}
	private boolean parseFailed = false;

	private Model model;

	private Resource obselResource;
	public void setParseFailed(boolean parseFailed) {
		this.parseFailed = parseFailed;
	}
	
	public boolean isParseFailed() {
		return parseFailed;
	}
	
	public void consume() {
		this.model = null;
		this.rdf = null;
	}
}
