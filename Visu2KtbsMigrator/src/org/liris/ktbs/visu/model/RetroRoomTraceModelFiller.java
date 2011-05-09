package org.liris.ktbs.visu.model;

import org.liris.ktbs.domain.PojoFactory;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.domain.interfaces.IObselType;
import org.liris.ktbs.domain.interfaces.ITraceModel;

public class RetroRoomTraceModelFiller extends TraceModelFiller {

	@Override
	public void fill(ITraceModel model, PojoFactory factory) {
		IObselType retroEvent = factory.createObselType(model.getUri(), "RetroEvent");
		IAttributeType syncRoomTraceId =  factory.createAttributeType(model.getUri(), "syncRoomTraceId");
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

		
		
		IAttributeType traceSubjectId =  factory.createAttributeType(model.getUri(), "traceSubjectId");
		traceSubjectId.getDomains().add(retroTraceVisualizationEvent);
		
		IAttributeType userName =  factory.createAttributeType(model.getUri(), "userName");
		userName.getDomains().add(retroTraceVisualizationEvent);

		IAttributeType userAvatar =  factory.createAttributeType(model.getUri(), "userAvatar");
		userAvatar.getDomains().add(retroTraceVisualizationEvent);
		
		IAttributeType timeWindowLowerBound =  factory.createAttributeType(model.getUri(), "timeWindowLowerBound");
		timeWindowLowerBound.getDomains().add(retroStartScaleChangeEvent);
		timeWindowLowerBound.getDomains().add(retroTraceTimeSlideEvent);
		
		IAttributeType timeWindowUpperBound =  factory.createAttributeType(model.getUri(), "timeWindowUpperBound");
		timeWindowUpperBound.getDomains().add(retroStartScaleChangeEvent);
		timeWindowUpperBound.getDomains().add(retroTraceTimeSlideEvent);
		
		IAttributeType scaleValue =  factory.createAttributeType(model.getUri(), "scaleValue");
		scaleValue.getDomains().add(retroStartScaleChangeEvent);
		
		IAttributeType obselId =  factory.createAttributeType(model.getUri(), "obselId");
		obselId.getDomains().add(retroExploreObselEvent);
		
		IAttributeType tooltipValue =  factory.createAttributeType(model.getUri(), "tooltipValue");
		tooltipValue.getDomains().add(retroExploreObselEvent);

		IAttributeType obselTypeName =  factory.createAttributeType(model.getUri(), "obselTypeName");
		obselTypeName.getDomains().add(retroObselTypeLineEvent);
		
		IAttributeType uiWidget =  factory.createAttributeType(model.getUri(), "uiWidget");
		uiWidget.getDomains().add(retroObselTypeLineEvent);
		
		IAttributeType newActiveTab =  factory.createAttributeType(model.getUri(), "newActiveTab");
		newActiveTab.getDomains().add(retroActiveTabEvent);
		
		IAttributeType commentValue =  factory.createAttributeType(model.getUri(), "commentValue");
		commentValue.getDomains().add(retroCommentEvent);
		
		IAttributeType commentId =  factory.createAttributeType(model.getUri(), "commentId");
		commentId.getDomains().add(retroCommentEvent);

		IAttributeType commentBeginDate =  factory.createAttributeType(model.getUri(), "commentBeginDate");
		commentBeginDate.getDomains().add(retroCommentEvent);

		IAttributeType commentEndDate =  factory.createAttributeType(model.getUri(), "commentEndDate");
		commentEndDate.getDomains().add(retroCommentEvent);

		IAttributeType videoViewWidth =  factory.createAttributeType(model.getUri(), "videoViewWidth");
		videoViewWidth.getDomains().add(retroViewResizeEvent);
		
		IAttributeType videoViewHeight =  factory.createAttributeType(model.getUri(), "videoViewHeight");
		videoViewHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType traceLineViewWidth =  factory.createAttributeType(model.getUri(), "traceLineViewWidth");
		traceLineViewWidth.getDomains().add(retroViewResizeEvent);

		IAttributeType traceLineViewHeight =  factory.createAttributeType(model.getUri(), "traceLineViewHeight");
		traceLineViewHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType tabHolderWidth =  factory.createAttributeType(model.getUri(), "tabHolderWidth");
		tabHolderWidth.getDomains().add(retroViewResizeEvent);
		
		IAttributeType tabHolderHeight =  factory.createAttributeType(model.getUri(), "tabHolderHeight");
		tabHolderHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType editType =  factory.createAttributeType(model.getUri(), "editType");
		editType.getDomains().add(retroCancelEditEvent);
		
		IAttributeType sessionId =  factory.createAttributeType(model.getUri(), "sessionId");
		sessionId.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionTheme =  factory.createAttributeType(model.getUri(), "sessionTheme");
		sessionTheme.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionDescription =  factory.createAttributeType(model.getUri(), "sessionDescription");
		sessionDescription.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionStartRecordingDate =  factory.createAttributeType(model.getUri(), "sessionStartRecordingDate");
		sessionStartRecordingDate.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionOwnerId =  factory.createAttributeType(model.getUri(), "sessionOwnerId");
		sessionOwnerId.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType cause =  factory.createAttributeType(model.getUri(), "cause");
		cause.getDomains().add(retroExitRetrospectedSessionEvent);
		
		IAttributeType videoTime =  factory.createAttributeType(model.getUri(), "videoTime");
		videoTime.getDomains().add(retroVideoEvent);
		
		model.getAttributeTypes().add(traceSubjectId);
		model.getAttributeTypes().add(userName);
		model.getAttributeTypes().add(userAvatar);
		model.getAttributeTypes().add(timeWindowLowerBound);
		model.getAttributeTypes().add(timeWindowUpperBound);
		model.getAttributeTypes().add(scaleValue);
		model.getAttributeTypes().add(obselId);
		model.getAttributeTypes().add(tooltipValue);
		model.getAttributeTypes().add(obselTypeName);
		model.getAttributeTypes().add(uiWidget);
		model.getAttributeTypes().add(newActiveTab);
		model.getAttributeTypes().add(commentValue);
		model.getAttributeTypes().add(commentId);
		model.getAttributeTypes().add(commentBeginDate);
		model.getAttributeTypes().add(commentEndDate);
		model.getAttributeTypes().add(videoViewWidth);
		model.getAttributeTypes().add(videoViewHeight);
		model.getAttributeTypes().add(traceLineViewWidth);
		model.getAttributeTypes().add(traceLineViewHeight);
		model.getAttributeTypes().add(tabHolderWidth);
		model.getAttributeTypes().add(tabHolderHeight);
		model.getAttributeTypes().add(editType);
		model.getAttributeTypes().add(sessionId);
		model.getAttributeTypes().add(sessionTheme);
		model.getAttributeTypes().add(sessionDescription);
		model.getAttributeTypes().add(sessionStartRecordingDate);
		model.getAttributeTypes().add(sessionOwnerId);
		model.getAttributeTypes().add(cause);
		model.getAttributeTypes().add(videoTime);
		
		model.getLabels().add("Le modèle de trace du salon de rétrospection de visu");
		
	}
}
