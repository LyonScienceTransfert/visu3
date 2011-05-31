package org.liris.ktbs.visu.vo;

import java.io.StringReader;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.IOUtils;
import org.liris.ktbs.client.Ktbs;
import org.liris.ktbs.client.KtbsConstants;
import org.liris.ktbs.domain.AttributePair;
import org.liris.ktbs.domain.PojoFactory;
import org.liris.ktbs.domain.interfaces.IAttributePair;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.domain.interfaces.IObsel;
import org.liris.ktbs.utils.KtbsUtils;
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

	private void parseManually(String traceModelUri, String userbaseUri) throws Exception {
		List<String> lines = IOUtils.readLines(new StringReader(rdf));
		
		PojoFactory factory = Ktbs.getPojoFactory();
		IObsel obsel = factory.createAnonObsel();

		Set<IAttributePair> attributePairs = new HashSet<IAttributePair>();

		// for multiline attribute values
		String multilineAttributeName = null;
		boolean inMultiLineValue = false;
		String multiLineValue = "";
		
		// for collection attributes
		boolean inACollection = false;
		String collectionAttributeName = null;
		for(String line:lines) {
			if(inACollection) {
				if(Pattern.matches("\t\\);",line)) {
					inACollection = false;
					continue;
				} else {
					Matcher matcher = Pattern.compile("\\W*\"(.*)\"").matcher(line);
					if(matcher.find()) {
						String attributeValue = matcher.group(1);
						AttributePair pair = new AttributePair();
						pair.setAttributeType(factory.createAttributeType(traceModelUri + collectionAttributeName));
						pair.setValue(getAttributeValue(attributeValue));
						attributePairs.add(pair);
					} else 
						throw new IllegalStateException();
					continue;
				}
			}

			if(inMultiLineValue) {
				if(line.endsWith("\";")) {
					// this is the end of the multiline value
					Matcher matcher = Pattern.compile("(\\w*)\";").matcher(line);
					if(matcher.find() && matcher.groupCount() == 1)
						multiLineValue+=matcher.group(1);
					else 
						throw new IllegalStateException();
					
					AttributePair pair = new AttributePair();
					pair.setAttributeType(factory.createAttributeType(traceModelUri + multilineAttributeName));
					pair.setValue(getAttributeValue(multiLineValue));
					attributePairs.add(pair);
					
					inMultiLineValue = false;
					multiLineValue = "";
				} else
					multiLineValue+=line+"\r";
				continue;
					
				
			}
			
			if(line.startsWith("@prefix"))
				continue;
			if(line.trim().isEmpty())
				continue;
			if(line.startsWith(". a") || line.startsWith("[] a")) {
				String type = null;
				if(line.startsWith(". a")) 
					type = line.substring(5, line.length()-1);
				else
					type = line.substring(6, line.length()-1);
				obsel.setObselType(factory.createObselType(traceModelUri + type));
				continue;
			}
			if(line.startsWith("ktbs:hasTrace")) {
				// ignore because useless
				continue;
			}

			if(line.startsWith("ktbs:hasBegin ")) {
				long begin = Long.parseLong(line.replaceAll("ktbs:hasBegin ", "").replaceAll(";", ""));
				Calendar c = Calendar.getInstance();
				c.setTimeInMillis(begin);
				KtbsUtils.xsdDate(c.getTime());
				obsel.setBeginDT(KtbsUtils.xsdDate(c.getTime()));
				continue;
			}
			if(line.startsWith("ktbs:hasEnd ")) {
				long end = Long.parseLong(line.replaceAll("ktbs:hasEnd ", "").replaceAll(";", ""));
				Calendar c = Calendar.getInstance();
				c.setTimeInMillis(end);
				KtbsUtils.xsdDate(c.getTime());
				obsel.setEndDT(KtbsUtils.xsdDate(c.getTime()));
				continue;
			}
			if(line.startsWith("ktbs:hasSubject")) {
				String subject = line.replaceAll("ktbs:hasSubject \"", "").replaceAll("\";", "");
				obsel.setSubject("user" + subject);
				continue;
			}
			if(line.startsWith("ktbs:hasTraceType")) {
				// ignore
				continue;
			}
			if(line.startsWith(":")) {
				// an attribute
				Pattern attributeInOneLinePattern = Pattern.compile(":(\\w+) \"(.*)\";");
				Matcher matcher = attributeInOneLinePattern.matcher(line);
				if(matcher.find()) {
					if(matcher.groupCount() == 2) {
						String attributeType = matcher.group(1);
						String attributeValue = matcher.group(2);
						AttributePair pair = new AttributePair();
						pair.setAttributeType(factory.createAttributeType(traceModelUri + attributeType));
						pair.setValue(getAttributeValue(attributeValue));
						attributePairs.add(pair);
					} else
						throw new IllegalStateException("");
				} else {
					// test if this is the start of a collection
					Pattern attributeInMultipleLinePattern = Pattern.compile(":(\\w+) \\(");
					matcher = attributeInMultipleLinePattern.matcher(line);

					if(matcher.find() && matcher.groupCount() == 1) {
						collectionAttributeName = matcher.group(1);
						inACollection = true;
					} else {
						// test if this is the start of a multiline value
						if(!line.endsWith("\";")) {
							inMultiLineValue = true;
							
							Pattern startMultilineValuePattern = Pattern.compile(":(\\w+) \"(.*)");
							matcher = startMultilineValuePattern.matcher(line);
							if(matcher.find() && matcher.groupCount() == 2) {
								multilineAttributeName = matcher.group(1);
								multiLineValue += matcher.group(2) + "\r";
							} else
								throw new IllegalStateException();
						}
						
						
					}

				}
			}
		}
		this.attributes = attributePairs;
		this.beginDT = obsel.getBeginDT();
		this.endDT = obsel.getEndDT();
		this.subject = obsel.getSubject();
		this.typeUri = obsel.getObselType().getUri();
	}

	private Object getAttributeValue(String attributeValue) {
		Object value = attributeValue;
		try {
			value = Integer.parseInt(attributeValue);
		} catch(Exception e) {
			try {
				value = Long.parseLong(attributeValue);
			} catch(Exception e1) {}
		}
		return value;
	}
	public void parseRdf(String traceModelUri, String userbaseUri) throws Exception {
		parseManually(traceModelUri, userbaseUri);
	}

	public void parseWithJena(String traceModelUri, String userbaseUri) throws Exception {
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

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Obsel");
		sb.append("\n\ttypeUri: " + this.typeUri);
		sb.append("\n\tbeginDT: " + this.beginDT);
		sb.append("\n\tendDT: " + this.endDT);
		sb.append("\n\tsubject: " + this.subject);
		for(IAttributePair pair:this.attributes)
			sb.append("\n\t\t- "+pair.getAttributeType().getUri()+": " + pair.getValue());
		return sb.toString();
	}

}
