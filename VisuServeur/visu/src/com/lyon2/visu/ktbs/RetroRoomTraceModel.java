package com.lyon2.visu.ktbs;

import org.liris.ktbs.client.KtbsRootClient;
import org.liris.ktbs.domain.interfaces.IAttributeType;
import org.liris.ktbs.domain.interfaces.IObselType;
import org.liris.ktbs.domain.interfaces.ITraceModel;
import org.liris.ktbs.service.TraceModelService;

public class RetroRoomTraceModel {
	
	public static void load(KtbsRootClient client, String base, String modelName) {
		TraceModelService traceModelService = client.getTraceModelService();
		ITraceModel model = traceModelService.createTraceModel(base + modelName + "/");
		
		IObselType retroEvent = traceModelService.newObselType(model,"RetroEvent");
		IAttributeType syncRoomTraceId =  traceModelService.newAttributeType(model,"syncRoomTraceId", null);
		syncRoomTraceId.getDomains().add(retroEvent);
		
		
		IObselType retroTraceVisualizationEvent = traceModelService.newObselType(model,"RetroTraceVisualizationEvent");
		retroTraceVisualizationEvent.getSuperObselTypes().add(retroEvent);
		
		IObselType retroExpandTraceLineEvent =  traceModelService.newObselType(model,"RetroExpandTraceLineEvent");
		retroExpandTraceLineEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		
		IObselType retroMinimizeTraceLineEvent =  traceModelService.newObselType(model,"RetroMinimizeTraceLineEvent");
		retroMinimizeTraceLineEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);

		IObselType retroTraceTimeScaleEvent =  traceModelService.newObselType(model,"RetroTraceTimeScaleEvent");
		retroTraceTimeScaleEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		
		IObselType retroStartScaleChangeEvent =  traceModelService.newObselType(model,"RetroStartScaleChangeEvent");
		retroStartScaleChangeEvent.getSuperObselTypes().add(retroTraceTimeScaleEvent);
		
		IObselType retroEndScaleChangeEvent =  traceModelService.newObselType(model,"RetroEndScaleChangeEvent");
		retroEndScaleChangeEvent.getSuperObselTypes().add(retroTraceTimeScaleEvent);

		IObselType retroTraceTimeSlideEvent =  traceModelService.newObselType(model,"RetroTraceTimeSlideEvent");
		retroTraceTimeSlideEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		
		IObselType retroStartTraceTimeSlideEvent =  traceModelService.newObselType(model,"RetroStartTraceTimeSlideEvent");
		retroStartTraceTimeSlideEvent.getSuperObselTypes().add(retroTraceTimeSlideEvent);
		
		IObselType retroEndTraceTimeSlideEvent =  traceModelService.newObselType(model,"RetroEndTraceTimeSlideEvent");
		retroEndTraceTimeSlideEvent.getSuperObselTypes().add(retroEndTraceTimeSlideEvent);

		IObselType retroExploreObselEvent =  traceModelService.newObselType(model,"RetroExploreObselEvent");
		retroExploreObselEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		
		IObselType retroObselTypeLineEvent =  traceModelService.newObselType(model,"RetroObselTypeLineEvent");
		retroObselTypeLineEvent.getSuperObselTypes().add(retroTraceVisualizationEvent);
		
		IObselType retroAddObselTypeToLineEvent =  traceModelService.newObselType(model,"RetroAddObselTypeToLineEvent");
		retroAddObselTypeToLineEvent.getSuperObselTypes().add(retroObselTypeLineEvent);
		
		IObselType retroDeleteObselTypeFromLineEvent =  traceModelService.newObselType(model,"RetroDeleteObselTypeFromLineEvent");
		retroDeleteObselTypeFromLineEvent.getSuperObselTypes().add(retroObselTypeLineEvent);

		IObselType retroWorkbenchEvent =  traceModelService.newObselType(model,"RetroWorkbenchEvent");
		retroWorkbenchEvent.getSuperObselTypes().add(retroEvent);
		
		IObselType retroViewResizeEvent =  traceModelService.newObselType(model,"RetroViewResizeEvent");
		retroViewResizeEvent.getSuperObselTypes().add(retroWorkbenchEvent);
		
		IObselType retroStartViewResizeEvent =  traceModelService.newObselType(model,"RetroStartViewResizeEvent");
		retroStartViewResizeEvent.getSuperObselTypes().add(retroViewResizeEvent);
		
		IObselType retroEndViewResizeEvent =  traceModelService.newObselType(model,"RetroEndViewResizeEvent");
		retroEndViewResizeEvent.getSuperObselTypes().add(retroViewResizeEvent);
		
		IObselType retroActiveTabEvent =  traceModelService.newObselType(model,"RetroActiveTabEvent");
		retroActiveTabEvent.getSuperObselTypes().add(retroWorkbenchEvent);
		
		IObselType retroCommentEvent =  traceModelService.newObselType(model,"RetroCommentEvent");
		retroCommentEvent.getSuperObselTypes().add(retroEvent);
		
		IObselType retroStartCreateCommentEvent =  traceModelService.newObselType(model,"RetroStartCreateCommentEvent");
		retroStartCreateCommentEvent.getSuperObselTypes().add(retroCommentEvent);
		
		IObselType retroClickButtonStartCreateCommentEvent =  traceModelService.newObselType(model,"RetroClickButtonStartCreateCommentEvent");
		retroClickButtonStartCreateCommentEvent.getSuperObselTypes().add(retroStartCreateCommentEvent);
		
		IObselType retroDoubleClickTraceLineStartCreateCommentEvent =  traceModelService.newObselType(model,"RetroDoubleClickTraceLineStartCreateCommentEvent");
		retroDoubleClickTraceLineStartCreateCommentEvent.getSuperObselTypes().add(retroStartCreateCommentEvent);

		IObselType retroDropObselStartCreateCommentEvent =  traceModelService.newObselType(model,"RetroDropObselStartCreateCommentEvent");
		retroDropObselStartCreateCommentEvent.getSuperObselTypes().add(retroStartCreateCommentEvent);
		
		IObselType retroStartEditEvent =  traceModelService.newObselType(model,"RetroStartEditEvent");
		retroStartEditEvent.getSuperObselTypes().add(retroCommentEvent);
		
		IObselType retroCancelEditEvent =  traceModelService.newObselType(model,"RetroCancelEditEvent");
		retroCancelEditEvent.getSuperObselTypes().add(retroCommentEvent);
		
		IObselType retroDeleteCommentEvent =  traceModelService.newObselType(model,"RetroDeleteCommentEvent");
		retroDeleteCommentEvent.getSuperObselTypes().add(retroCommentEvent);
		
		IObselType retroSaveCommentEvent =  traceModelService.newObselType(model,"RetroSaveCommentEvent");
		retroSaveCommentEvent.getSuperObselTypes().add(retroCommentEvent);
		
		IObselType retroCommentTimeEvent =  traceModelService.newObselType(model,"RetroCommentTimeEvent");
		retroCommentTimeEvent.getSuperObselTypes().add(retroCommentEvent);
		
		IObselType retroCommentStartDurationChangeEvent =  traceModelService.newObselType(model,"RetroCommentStartDurationChangeEvent");
		retroCommentStartDurationChangeEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		
		IObselType retroCommentEndDurationChangeEvent =  traceModelService.newObselType(model,"RetroCommentEndDurationChangeEvent");
		retroCommentEndDurationChangeEvent.getSuperObselTypes().add(retroCommentTimeEvent);

		IObselType retroCommentStartSlideEvent =  traceModelService.newObselType(model,"RetroCommentStartSlideEvent");
		retroCommentStartSlideEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		
		IObselType retroCommentEndSlideEvent =  traceModelService.newObselType(model,"RetroCommentEndSlideEvent");
		retroCommentEndSlideEvent.getSuperObselTypes().add(retroCommentTimeEvent);
		
		IObselType retroLoadRetrospectedSessionEvent =  traceModelService.newObselType(model,"RetroLoadRetrospectedSessionEvent");
		retroLoadRetrospectedSessionEvent.getSuperObselTypes().add(retroEvent);
		
		IObselType retroExitRetrospectedSessionEvent =  traceModelService.newObselType(model,"RetroExitRetrospectedSessionEvent");
		retroExitRetrospectedSessionEvent.getSuperObselTypes().add(retroEvent);
		
		IObselType retroVideoEvent =  traceModelService.newObselType(model,"RetroVideoEvent");
		retroVideoEvent.getSuperObselTypes().add(retroEvent);
		
		IObselType retroPauseVideoEvent =  traceModelService.newObselType(model,"RetroPauseVideoEvent");
		retroPauseVideoEvent.getSuperObselTypes().add(retroVideoEvent);
		
		IObselType retroPlayVideoEvent =  traceModelService.newObselType(model,"RetroPlayVideoEvent");
		retroPlayVideoEvent.getSuperObselTypes().add(retroVideoEvent);
		
		IObselType retroVideoGoToTimeEvent =  traceModelService.newObselType(model,"RetroVideoGoToTimeEvent");
		retroVideoGoToTimeEvent.getSuperObselTypes().add(retroPlayVideoEvent);
		
		IObselType retroPlayFromObselEvent =  traceModelService.newObselType(model,"RetroPlayFromObselEvent");
		retroPlayFromObselEvent.getSuperObselTypes().add(retroPlayVideoEvent);

		
		
		IAttributeType traceSubjectId =  traceModelService.newAttributeType(model,"traceSubjectId", null);
		traceSubjectId.getDomains().add(retroTraceVisualizationEvent);
		
		IAttributeType userName =  traceModelService.newAttributeType(model,"userName", null);
		userName.getDomains().add(retroTraceVisualizationEvent);

		IAttributeType userAvatar =  traceModelService.newAttributeType(model,"userAvatar", null);
		userAvatar.getDomains().add(retroTraceVisualizationEvent);
		
		IAttributeType timeWindowLowerBound =  traceModelService.newAttributeType(model,"timeWindowLowerBound", null);
		timeWindowLowerBound.getDomains().add(retroStartScaleChangeEvent);
		timeWindowLowerBound.getDomains().add(retroTraceTimeSlideEvent);
		
		IAttributeType timeWindowUpperBound =  traceModelService.newAttributeType(model,"timeWindowUpperBound", null);
		timeWindowUpperBound.getDomains().add(retroStartScaleChangeEvent);
		timeWindowUpperBound.getDomains().add(retroTraceTimeSlideEvent);
		
		IAttributeType scaleValue =  traceModelService.newAttributeType(model,"scaleValue", null);
		scaleValue.getDomains().add(retroStartScaleChangeEvent);
		
		IAttributeType obselId =  traceModelService.newAttributeType(model,"obselId", null);
		obselId.getDomains().add(retroExploreObselEvent);
		
		IAttributeType tooltipValue =  traceModelService.newAttributeType(model,"tooltipValue", null);
		tooltipValue.getDomains().add(retroExploreObselEvent);

		IAttributeType obselTypeName =  traceModelService.newAttributeType(model,"obselTypeName", null);
		obselTypeName.getDomains().add(retroObselTypeLineEvent);
		
		IAttributeType uiWidget =  traceModelService.newAttributeType(model,"uiWidget", null);
		uiWidget.getDomains().add(retroObselTypeLineEvent);
		
		IAttributeType newActiveTab =  traceModelService.newAttributeType(model,"newActiveTab", null);
		newActiveTab.getDomains().add(retroActiveTabEvent);
		
		IAttributeType commentValue =  traceModelService.newAttributeType(model,"commentValue", null);
		commentValue.getDomains().add(retroCommentEvent);
		
		IAttributeType commentId =  traceModelService.newAttributeType(model,"commentId", null);
		commentId.getDomains().add(retroCommentEvent);

		IAttributeType commentBeginDate =  traceModelService.newAttributeType(model,"commentBeginDate", null);
		commentBeginDate.getDomains().add(retroCommentEvent);

		IAttributeType commentEndDate =  traceModelService.newAttributeType(model,"commentEndDate", null);
		commentEndDate.getDomains().add(retroCommentEvent);

		IAttributeType videoViewWidth =  traceModelService.newAttributeType(model,"videoViewWidth", null);
		videoViewWidth.getDomains().add(retroViewResizeEvent);
		
		IAttributeType videoViewHeight =  traceModelService.newAttributeType(model,"videoViewHeight", null);
		videoViewHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType traceLineViewWidth =  traceModelService.newAttributeType(model,"traceLineViewWidth", null);
		traceLineViewWidth.getDomains().add(retroViewResizeEvent);

		IAttributeType traceLineViewHeight =  traceModelService.newAttributeType(model,"traceLineViewHeight", null);
		traceLineViewHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType tabHolderWidth =  traceModelService.newAttributeType(model,"tabHolderWidth", null);
		tabHolderWidth.getDomains().add(retroViewResizeEvent);
		
		IAttributeType tabHolderHeight =  traceModelService.newAttributeType(model,"tabHolderHeight", null);
		tabHolderHeight.getDomains().add(retroViewResizeEvent);

		IAttributeType editType =  traceModelService.newAttributeType(model,"editType", null);
		editType.getDomains().add(retroCancelEditEvent);
		
		IAttributeType sessionId =  traceModelService.newAttributeType(model,"sessionId", null);
		sessionId.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionTheme =  traceModelService.newAttributeType(model,"sessionTheme", null);
		sessionTheme.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionDescription =  traceModelService.newAttributeType(model,"sessionDescription", null);
		sessionDescription.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionStartRecordingDate =  traceModelService.newAttributeType(model,"sessionStartRecordingDate", null);
		sessionStartRecordingDate.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType sessionOwnerId =  traceModelService.newAttributeType(model,"sessionOwnerId", null);
		sessionOwnerId.getDomains().add(retroLoadRetrospectedSessionEvent);
		
		IAttributeType cause =  traceModelService.newAttributeType(model,"cause", null);
		cause.getDomains().add(retroExitRetrospectedSessionEvent);
		
		IAttributeType videoTime =  traceModelService.newAttributeType(model,"videoTime", null);
		videoTime.getDomains().add(retroVideoEvent);
		
		model.getLabels().add("Le modèle de trace du salon de rétrospection de visu");
		traceModelService.save(model, true);
	}
}
