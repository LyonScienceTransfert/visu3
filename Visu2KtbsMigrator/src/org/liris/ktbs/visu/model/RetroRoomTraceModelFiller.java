package org.liris.ktbs.visu.model;

import org.apache.commons.lang.StringUtils;
import org.liris.ktbs.domain.PojoFactory;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.domain.interfaces.IObselType;
import org.liris.ktbs.domain.interfaces.ITraceModel;

public class RetroRoomTraceModelFiller extends TraceModelFiller {

	private ITraceModel model;
	private PojoFactory factory;
	
	@Override
	public void fill(ITraceModel model, PojoFactory factory) {
		this.model = model;
		this.factory = factory;
		
		IObselType retroEvent = factory.createObselType(model.getUri(), "RetroEvent");
		model.getObselTypes().add(retroEvent);
		
		IAttributeType syncRoomTraceId =  attribute("syncRoomTraceId");
		syncRoomTraceId.getDomains().add(retroEvent);
		
		IObselType retroTraceVisualizationEvent = factory.createObselType(model.getUri(), "RetroTraceVisualizationEvent");
		retroTraceVisualizationEvent.getSuperObselTypes().add(retroEvent);
		model.getObselTypes().add(retroTraceVisualizationEvent);
		
		IObselType retroExpandTraceLineEvent =  factory.createObselType(model.getUri(), "RetroExpandTraceLineEvent");
		retroExpandTraceLineEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		model.getObselTypes().add(retroExpandTraceLineEvent);
		
		IObselType retroMinimizeTraceLineEvent =  factory.createObselType(model.getUri(), "RetroMinimizeTraceLineEvent");
		retroMinimizeTraceLineEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		model.getObselTypes().add(retroMinimizeTraceLineEvent);

		IObselType retroTraceTimeScaleEvent =  factory.createObselType(model.getUri(), "RetroTraceTimeScaleEvent");
		retroTraceTimeScaleEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		model.getObselTypes().add(retroTraceTimeScaleEvent);
		
		IObselType retroStartScaleChangeEvent =  factory.createObselType(model.getUri(), "RetroStartScaleChangeEvent");
		retroStartScaleChangeEvent.getSuperObselTypes().add(retroTraceTimeScaleEvent);
		model.getObselTypes().add(retroStartScaleChangeEvent);
		
		IObselType retroEndScaleChangeEvent =  factory.createObselType(model.getUri(), "RetroEndScaleChangeEvent");
		retroEndScaleChangeEvent.getSuperObselTypes().add(retroTraceTimeScaleEvent);
		model.getObselTypes().add(retroEndScaleChangeEvent);

		IObselType retroTraceTimeSlideEvent =  factory.createObselType(model.getUri(), "RetroTraceTimeSlideEvent");
		retroTraceTimeSlideEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		model.getObselTypes().add(retroTraceTimeSlideEvent);
		
		IObselType retroStartTraceTimeSlideEvent =  factory.createObselType(model.getUri(), "RetroStartTraceTimeSlideEvent");
		retroStartTraceTimeSlideEvent.getSuperObselTypes().add(retroTraceTimeSlideEvent);
		model.getObselTypes().add(retroStartTraceTimeSlideEvent);
		
		IObselType retroEndTraceTimeSlideEvent =  factory.createObselType(model.getUri(), "RetroEndTraceTimeSlideEvent");
		retroEndTraceTimeSlideEvent.getSuperObselTypes().add(retroEndTraceTimeSlideEvent);
		model.getObselTypes().add(retroEndTraceTimeSlideEvent);

		IObselType retroExploreObselEvent =  factory.createObselType(model.getUri(), "RetroExploreObselEvent");
		retroExploreObselEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		model.getObselTypes().add(retroExploreObselEvent);
		
		IObselType retroObselTypeLineEvent =  factory.createObselType(model.getUri(), "RetroObselTypeLineEvent");
		retroObselTypeLineEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		model.getObselTypes().add(retroObselTypeLineEvent);
		
		IObselType retroAddObselTypeToLineEvent =  factory.createObselType(model.getUri(), "RetroAddObselTypeToLineEvent");
		retroAddObselTypeToLineEvent.getSuperObselTypes().add(retroObselTypeLineEvent);
		model.getObselTypes().add(retroAddObselTypeToLineEvent);
		
		IObselType retroDeleteObselTypeFromLineEvent =  factory.createObselType(model.getUri(), "RetroDeleteObselTypeFromLineEvent");
		retroDeleteObselTypeFromLineEvent.getSuperObselTypes().add(retroObselTypeLineEvent);
		model.getObselTypes().add(retroDeleteObselTypeFromLineEvent);

		IObselType retroWorkbenchEvent =  factory.createObselType(model.getUri(), "RetroWorkbenchEvent");
		retroWorkbenchEvent.getSuperObselTypes().add(retroEvent);
		model.getObselTypes().add(retroWorkbenchEvent);
		
		IObselType retroViewResizeEvent =  factory.createObselType(model.getUri(), "RetroViewResizeEvent");
		retroViewResizeEvent.getSuperObselTypes().add(retroWorkbenchEvent);
		model.getObselTypes().add(retroViewResizeEvent);
		
		IObselType retroStartViewResizeEvent =  factory.createObselType(model.getUri(), "RetroStartViewResizeEvent");
		retroStartViewResizeEvent.getSuperObselTypes().add(retroViewResizeEvent);
		model.getObselTypes().add(retroStartViewResizeEvent);
		
		IObselType retroEndViewResizeEvent =  factory.createObselType(model.getUri(), "RetroEndViewResizeEvent");
		retroEndViewResizeEvent.getSuperObselTypes().add(retroViewResizeEvent);
		model.getObselTypes().add(retroEndViewResizeEvent);
		
		IObselType retroActiveTabEvent =  factory.createObselType(model.getUri(), "RetroActiveTabEvent");
		retroActiveTabEvent.getSuperObselTypes().add(retroWorkbenchEvent);
		model.getObselTypes().add(retroActiveTabEvent);
		
		IObselType retroCommentEvent =  factory.createObselType(model.getUri(), "RetroCommentEvent");
		retroCommentEvent.getSuperObselTypes().add(retroEvent);
		model.getObselTypes().add(retroCommentEvent);
		
		IObselType retroStartCreateCommentEvent =  factory.createObselType(model.getUri(), "RetroStartCreateCommentEvent");
		retroStartCreateCommentEvent.getSuperObselTypes().add(retroCommentEvent);
		model.getObselTypes().add(retroStartCreateCommentEvent);
		
		IObselType retroClickButtonStartCreateCommentEvent =  factory.createObselType(model.getUri(), "RetroClickButtonStartCreateCommentEvent");
		retroClickButtonStartCreateCommentEvent.getSuperObselTypes().add(retroStartCreateCommentEvent);
		model.getObselTypes().add(retroClickButtonStartCreateCommentEvent);
		
		IObselType retroDoubleClickTraceLineStartCreateCommentEvent =  factory.createObselType(model.getUri(), "RetroDoubleClickTraceLineStartCreateCommentEvent");
		retroDoubleClickTraceLineStartCreateCommentEvent.getSuperObselTypes().add(retroStartCreateCommentEvent);
		model.getObselTypes().add(retroDoubleClickTraceLineStartCreateCommentEvent);

		IObselType retroDropObselStartCreateCommentEvent =  factory.createObselType(model.getUri(), "RetroDropObselStartCreateCommentEvent");
		retroDropObselStartCreateCommentEvent.getSuperObselTypes().add(retroStartCreateCommentEvent);
		model.getObselTypes().add(retroDropObselStartCreateCommentEvent);
		
		IObselType retroStartEditEvent =  factory.createObselType(model.getUri(), "RetroStartEditEvent");
		retroStartEditEvent.getSuperObselTypes().add(retroCommentEvent);
		model.getObselTypes().add(retroStartEditEvent);
		
		IObselType retroCancelEditEvent =  factory.createObselType(model.getUri(), "RetroCancelEditEvent");
		retroCancelEditEvent.getSuperObselTypes().add(retroCommentEvent);
		model.getObselTypes().add(retroCancelEditEvent);
		
		IObselType retroDeleteCommentEvent =  factory.createObselType(model.getUri(), "RetroDeleteCommentEvent");
		retroDeleteCommentEvent.getSuperObselTypes().add(retroCommentEvent);
		model.getObselTypes().add(retroDeleteCommentEvent);
		
		IObselType retroSaveCommentEvent =  factory.createObselType(model.getUri(), "RetroSaveCommentEvent");
		retroSaveCommentEvent.getSuperObselTypes().add(retroCommentEvent);
		model.getObselTypes().add(retroSaveCommentEvent);
		
		IObselType retroCommentTimeEvent =  factory.createObselType(model.getUri(), "RetroCommentTimeEvent");
		retroCommentTimeEvent.getSuperObselTypes().add(retroCommentEvent);
		model.getObselTypes().add(retroCommentTimeEvent);
		
		IObselType retroCommentStartDurationChangeEvent =  factory.createObselType(model.getUri(), "RetroCommentStartDurationChangeEvent");
		retroCommentStartDurationChangeEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		model.getObselTypes().add(retroCommentStartDurationChangeEvent);
		
		IObselType retroCommentEndDurationChangeEvent =  factory.createObselType(model.getUri(), "RetroCommentEndDurationChangeEvent");
		retroCommentEndDurationChangeEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		model.getObselTypes().add(retroCommentEndDurationChangeEvent);

		IObselType retroCommentStartSlideEvent =  factory.createObselType(model.getUri(), "RetroCommentStartSlideEvent");
		retroCommentStartSlideEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		model.getObselTypes().add(retroCommentStartSlideEvent);
		
		IObselType retroCommentEndSlideEvent =  factory.createObselType(model.getUri(), "RetroCommentEndSlideEvent");
		retroCommentEndSlideEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		model.getObselTypes().add(retroCommentEndSlideEvent);
		
		IObselType retroLoadRetrospectedSessionEvent =  factory.createObselType(model.getUri(), "RetroLoadRetrospectedSessionEvent");
		retroLoadRetrospectedSessionEvent.getSuperObselTypes().add(retroEvent);
		model.getObselTypes().add(retroLoadRetrospectedSessionEvent);
		
		IObselType retroExitRetrospectedSessionEvent =  factory.createObselType(model.getUri(), "RetroExitRetrospectedSessionEvent");
		retroExitRetrospectedSessionEvent.getSuperObselTypes().add(retroEvent);
		model.getObselTypes().add(retroExitRetrospectedSessionEvent);
		
		IObselType retroVideoEvent =  factory.createObselType(model.getUri(), "RetroVideoEvent");
		retroVideoEvent.getSuperObselTypes().add(retroEvent);
		model.getObselTypes().add(retroVideoEvent);
		
		IObselType retroPauseVideoEvent =  factory.createObselType(model.getUri(), "RetroPauseVideoEvent");
		retroPauseVideoEvent.getSuperObselTypes().add(retroVideoEvent);
		model.getObselTypes().add(retroPauseVideoEvent);
		
		IObselType retroPlayVideoEvent =  factory.createObselType(model.getUri(), "RetroPlayVideoEvent");
		retroPlayVideoEvent.getSuperObselTypes().add(retroVideoEvent);
		model.getObselTypes().add(retroPlayVideoEvent);
		
		IObselType retroVideoGoToTimeEvent =  factory.createObselType(model.getUri(), "RetroVideoGoToTimeEvent");
		retroVideoGoToTimeEvent.getSuperObselTypes().add(retroPlayVideoEvent);
		model.getObselTypes().add(retroVideoGoToTimeEvent);
		
		IObselType retroPlayFromObselEvent =  factory.createObselType(model.getUri(), "RetroPlayFromObselEvent");
		retroPlayFromObselEvent.getSuperObselTypes().add(retroPlayVideoEvent);
		model.getObselTypes().add(retroPlayFromObselEvent);

		
		
		IAttributeType traceSubjectId =  attribute("traceSubjectId");
		traceSubjectId.getDomains().add(retroTraceVisualizationEvent);
		
		IAttributeType userName =  attribute( "userName");
		userName.getDomains().add(retroTraceVisualizationEvent);

		IAttributeType userAvatar =  attribute("userAvatar");
		userAvatar.getDomains().add(retroTraceVisualizationEvent);
		
		IAttributeType timeWindowLowerBound =  attribute("timeWindowLowerBound");
		timeWindowLowerBound.getDomains().add(retroStartScaleChangeEvent);
		timeWindowLowerBound.getDomains().add(retroTraceTimeSlideEvent);
		
		IAttributeType timeWindowUpperBound =  attribute("timeWindowUpperBound");
		timeWindowUpperBound.getDomains().add(retroStartScaleChangeEvent);
		timeWindowUpperBound.getDomains().add(retroTraceTimeSlideEvent);
		
		IAttributeType scaleValue =  attribute("scaleValue");
		scaleValue.getDomains().add(retroStartScaleChangeEvent);
		
		IAttributeType obselId =  attribute( "obselId");
		obselId.getDomains().add(retroExploreObselEvent);
		
		IAttributeType tooltipValue =  attribute("tooltipValue");
		tooltipValue.getDomains().add(retroExploreObselEvent);

		IAttributeType obselTypeName =  attribute("obselTypeName");
		obselTypeName.getDomains().add(retroObselTypeLineEvent);
		
		IAttributeType uiWidget =  attribute("uiWidget");
		uiWidget.getDomains().add(retroObselTypeLineEvent);
		
		IAttributeType newActiveTab =  attribute("newActiveTab");
		newActiveTab.getDomains().add(retroActiveTabEvent);
		
		IAttributeType commentValue =  attribute("commentValue");
		commentValue.getDomains().add(retroCommentEvent);
		
		IAttributeType commentId =  attribute("commentId");
		commentId.getDomains().add(retroCommentEvent);

		IAttributeType commentBeginDate =  attribute("commentBeginDate");
		commentBeginDate.getDomains().add(retroCommentEvent);

		IAttributeType commentEndDate =  attribute("commentEndDate");
		commentEndDate.getDomains().add(retroCommentEvent);

		IAttributeType videoViewWidth =  attribute("videoViewWidth");
		videoViewWidth.getDomains().add(retroViewResizeEvent);
		
		IAttributeType videoViewHeight =  attribute("videoViewHeight");
		videoViewHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType traceLineViewWidth =  attribute("traceLineViewWidth");
		traceLineViewWidth.getDomains().add(retroViewResizeEvent);

		IAttributeType traceLineViewHeight =  attribute("traceLineViewHeight");
		traceLineViewHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType tabHolderWidth =  attribute("tabHolderWidth");
		tabHolderWidth.getDomains().add(retroViewResizeEvent);
		
		IAttributeType tabHolderHeight =  attribute("tabHolderHeight");
		tabHolderHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType editType =  attribute("editType");
		editType.getDomains().add(retroCancelEditEvent);
		
		IAttributeType sessionId =  attribute("sessionId");
		sessionId.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionTheme = attribute("sessionTheme");
		sessionTheme.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionDescription =  attribute("sessionDescription");
		sessionDescription.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionStartRecordingDate = attribute("sessionStartRecordingDate");
		sessionStartRecordingDate.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionOwnerId =  attribute("sessionOwnerId");
		sessionOwnerId.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType cause = attribute("cause");
		cause.getDomains().add(retroExitRetrospectedSessionEvent);
		
		IAttributeType videoTime =  attribute("videoTime");
		videoTime.getDomains().add(retroVideoEvent);
		
		model.getLabels().add("Le modèle de trace du salon de rétrospection de visu");
		
	}

	private IAttributeType attribute(String localName) {
		IAttributeType att = factory.createAttributeType(model.getUri(), "has" + StringUtils.capitalize(localName));
		model.getAttributeTypes().add(att);
		return att;
	}
}
