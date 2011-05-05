package org.liris.ktbs.visu;
import java.io.StringReader;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.liris.ktbs.client.KtbsConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;


public class VisuToKtbsUtils {

	private static Logger logger = LoggerFactory.getLogger(VisuToKtbsUtils.class);

	public static Pattern traceNamePattern = Pattern.compile("trace-(\\d{4})(\\d{2})(\\d{2})(\\d{2})(\\d{2})(\\d{2})-(\\d+)");

	public static Date parseTraceOrigin(String traceName) {
		Matcher matcher = getMatcher(traceName);

		int year  = Integer.parseInt(matcher.group(1));
		int month  = Integer.parseInt(matcher.group(2));
		int day  = Integer.parseInt(matcher.group(3));
		int hour  = Integer.parseInt(matcher.group(4));
		int minute  = Integer.parseInt(matcher.group(5));
		int second  = Integer.parseInt(matcher.group(6));

		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Europe/Paris"));
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month-1);
		cal.set(Calendar.DAY_OF_MONTH, day);
		cal.set(Calendar.HOUR, hour);
		cal.set(Calendar.MINUTE, minute);
		cal.set(Calendar.SECOND, second);

		return cal.getTime();
	}

	private static Matcher getMatcher(String traceName) {
		Matcher matcher = traceNamePattern.matcher(traceName);

		if(!matcher.find()) 
			logger.warn("Could not match the trace name {} to the pattern {}", traceName, traceNamePattern.toString());
		return matcher;
	}

	public static Integer parseUserId(String traceName) {
		Matcher matcher = getMatcher(traceName);

		int userId  = Integer.parseInt(matcher.group(7));
		return userId;
	}

	public static String makeKtbsUserId(Integer userId) {
		return "user" + userId;
	}


	public static Model buildObselModel(String rdf) {
		Model model = ModelFactory.createDefaultModel();
		model.read(new StringReader(rdf), KtbsConstants.JENA_TURTLE, "");
		return model;
	}


	private static Map<String, String> getReplacements(String traceModelUri, String userbaseUri) {
		Map<String, String> replacements = new HashMap<String, String>();

		replacements.put("<../visu/>", "<"+traceModelUri+">");
		replacements.put("^\\. a", "[] a");
		replacements.put("<(trace-\\d{4}\\d{2}\\d{2}\\d{2}\\d{2}\\d{2}-\\d+)>", "<"+userbaseUri+"$1/>");
		replacements.put("http://liris.cnrs.fr/silex/2009/ktbs/", "http://liris.cnrs.fr/silex/2009/ktbs#");
		
		replacements.put("\"\\W*\"Vouvoyer 'ou 'tutoyer'\"", "\"'Vouvoyer 'ou 'tutoyer'\"");
		replacements.put("\"\\W*\"famme'\"", "\"'famme'\"");
		replacements.put("\" \"Introduction' à l'Art\"", "\" 'Introduction' à l'Art\"");
		replacements.put("\" \"ce' problème\"", "\"'ce' problème\"");
		replacements.put("\" \"un' problème", "\" 'un' problème");
		replacements.put("\" \"la vie", "\" 'la vie");
		replacements.put("\" \"verliebt in berlin'\"", "\" 'verliebt in berlin'\"");
		replacements.put("\" \"film", "\" 'film");

		return replacements;
	}


	public static String fixRdfString(String rdf, String traceModelUri,  String userbaseUri) {
		String fixedRdf = rdf;

		// escape strings in string-typed attributes
		String stringAttributePattern = "(^:\\w+\\W+)\"((?:[^\n\r;\\\\\t\\\"]*(?:\r|\n|\t|\\\\|\\\"))+[^\n\\\\\t\r\\\"]*)\";$";
		Pattern pattern = Pattern.compile(stringAttributePattern, Pattern.MULTILINE);
		Matcher matcher = pattern.matcher(fixedRdf);
		if(matcher.find() && matcher.groupCount() >= 2) {
			String stringValue = matcher.group(2);
			String stringValueEscaped = stringToTurtleString(stringValue);
			
			fixedRdf = matcher.replaceFirst(Matcher.quoteReplacement(matcher.group(1) + " \"" + stringValueEscaped + "\";"));
		}		
		
		
		// applies other replacements
		for(Entry<String, String> entry:getReplacements(traceModelUri, userbaseUri).entrySet()) {
			pattern = Pattern.compile(entry.getKey(), Pattern.MULTILINE);
			matcher = pattern.matcher(fixedRdf);
			fixedRdf = matcher.replaceFirst(entry.getValue());
		}

		return fixedRdf;
	}

	public static String stringToTurtleString(String string) {
		StringBuffer sb = new StringBuffer();
		int len = string.length();
		char c;

		for (int i = 0; i < len; i++) {
			c = string.charAt(i);
			if (c == '\\') {
//				sb.append('\\');
//				sb.append('\\');
				sb.append('_');
			} else if (c == '\r') {
//				sb.append('\\');
//				sb.append('r');
				sb.append('_');
			} else if (c == '"') {
//				sb.append('\\');
//				sb.append('"');
				sb.append('\'');
			} else if (c == '\t') {
//				sb.append('\\');
//				sb.append('t');
				sb.append(' ');
			} else if (c == '\n') {
//				sb.append('\\');
//				sb.append('n');
				sb.append('_');
			} else
				sb.append(c);
		}

		return sb.toString();
	}
}
