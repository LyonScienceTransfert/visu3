package org.liris.ktbs.visu.model;

import org.apache.commons.lang.StringUtils;
import org.liris.ktbs.domain.PojoFactory;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.domain.interfaces.IObselType;
import org.liris.ktbs.domain.interfaces.ITraceModel;

public class VisuModelFillerFromScratch extends TraceModelFiller {

	private static final String[] VISU_MODEL_TYPES = new String[] {
		"SetMarker", "ReceiveMarker", "UpdateMarker", "SystemUpdateMarker", "DeleteMarker", "SystemDeleteMarker",
		"ReceiveKeyword", "SendChatMessage", "SendKeyword", "SendInstructions", "ReceiveInstructions", "SendDocument", 
		"ReadDocument", "ReceiveDocument", "ReceiveChatMessage", "SessionEnter", "SessionStart", "Disconnected", "SessionExit", 
		"SessionPause", "SessionOut", "SessionOutVoidDuration", "SessionIn", "ActivityStart", "ActivityStop", 
		"RecordFilename", "SetTextComment", "DeleteTextComment", "UpdateTextComment", "PlayDocumentVideo", "PauseDocumentVideo", 
		"EndDocumentVideo", "StopDocumentVideo", "SliderPressDocumentVideo", "SliderReleaseDocumentVideo"
	};
	
	private static final String[] VISU_MODEL_ATTRIBUTES = new String[] {
		"shared", "uid", "sender", "text", "content", "presentids", "presentavatars", "presentnames", "presentcolors", 
		"presentcolorscode", "subject", "keyword", "instructions", "url", "senderdocument", "typedocument", "activityid", 
		"path", "sessionTheme", "session", "timestamp", "iddocument", "currenttime", "image", "video", "commentforuserid"
	};
	
	@Override
	public void fill(ITraceModel model, PojoFactory factory) {
		IObselType visuEvent = factory.createObselType(model.getUri(), "VisuEvent");
		model.getObselTypes().add(visuEvent);

		for(String obselTypeName:VISU_MODEL_TYPES) 
			type(factory, model, visuEvent, obselTypeName);
		
		for(String attTypeName:VISU_MODEL_ATTRIBUTES) 
			attribute(factory, model, visuEvent, "has" + StringUtils.capitalize(attTypeName));
	}

	private void type(PojoFactory factory, ITraceModel model, IObselType visuEvent, String localName) {
		IObselType type = factory.createObselType(model.getUri(), localName);
		type.getSuperObselTypes().add(visuEvent);
		model.getObselTypes().add(type);
	}

	private void attribute(PojoFactory factory, ITraceModel model, IObselType retroEvent,
			String localName) {
		IAttributeType att = factory.createAttributeType(model.getUri(), localName);
		att.getDomains().add(retroEvent);
		model.getAttributeTypes().add(att);
	}
}
