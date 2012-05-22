package com.lyon2.visu.ktbs;

import java.text.ParseException;
import java.util.HashSet;
import java.util.Set;

import org.liris.ktbs.domain.interfaces.IAttributePair;
import org.liris.ktbs.domain.interfaces.IObsel;
import org.liris.ktbs.utils.KtbsUtils;
import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import com.ithaca.domain.model.KtbsAttributePair;
import com.ithaca.domain.model.KtbsObsel;

public class KtbsResourceVOFactory {
	protected static final Logger log = Red5LoggerFactory.getLogger(
			KtbsResourceVOFactory.class, "visu2");
	public static KtbsObsel createKtbsObsel(IObsel obsel) {
		KtbsObsel ktbsObsel = new KtbsObsel();
		ktbsObsel.setUri(obsel.getUri());
		ktbsObsel.setObselType(obsel.getObselType().getUri());
		ktbsObsel.setBegin(obsel.getBegin().longValue());
		ktbsObsel.setEnd(obsel.getEnd().longValue());
		ktbsObsel.setBeginDT(obsel.getBeginDT());
		ktbsObsel.setEndDT(obsel.getEndDT());
		try {
			ktbsObsel.setBeginDTMS(KtbsUtils.parseXsdDate(obsel.getBeginDT()).getTime());
		} catch (ParseException e) {
			log.warn("Could not parse the beginDT property as an xsd:dateTime", e);
		}
		try {
			ktbsObsel.setEndDTMS(KtbsUtils.parseXsdDate(obsel.getEndDT()).getTime());
		} catch (ParseException e) {
			log.warn("Could not parse the endDT property as an xsd:dateTime", e);
		}
		
		ktbsObsel.setSubject(obsel.getSubject());
		ktbsObsel.setHasTrace(obsel.getParentResource().getUri());
		
		Set<KtbsAttributePair> attributes = new HashSet<KtbsAttributePair>();
		for(IAttributePair pair:obsel.getAttributePairs()) {
			attributes.add(createKtbsAttributePair(pair));
		}
		ktbsObsel.setAttributes(attributes);
		
		return ktbsObsel;
	}

	public static KtbsAttributePair createKtbsAttributePair(IAttributePair pair) {
		KtbsAttributePair ktbsPair = new KtbsAttributePair();
		ktbsPair.setAttributeType(pair.getAttributeType().getUri());
		ktbsPair.setValue(pair.getValue());
		return ktbsPair;
	}
}
