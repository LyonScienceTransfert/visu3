package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.components.IconDelete;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.visu.ui.utils.IconEnum;
import com.lyon2.controls.utils.TimeUtils;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Image;
import mx.events.FlexEvent;

import flash.ui.Mouse;
import flash.ui.MouseCursor;

import spark.components.HGroup;
import spark.components.Label;
import spark.components.RichEditableText;
import spark.components.Spinner;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;


public class SegmentVideoAdvanced extends SkinnableComponent
{		
	[SkinPart("true")]
	public var iconSegment:Image;
	[SkinPart("true")]
	public var imagePlay:Image;
	[SkinPart("true")]
	public var imagePause:Image;
	[SkinPart("true")]
	public var imageJumpStart:Image;
	
	[SkinPart("true")]
	public var iconDelete:IconDelete;
	
	[SkinPart("true")]
	public var labelCurrentTime:Label
	
	[SkinPart("true")]
	public var labelDuration:Label
	
	[SkinPart("true")]
	public var startSpinner:Spinner;
	
	[SkinPart("true")]
	public var endSpinner:Spinner;
	
	[SkinPart("true")]
	public var labelStartSpinner:Label;
	[SkinPart("true")]
	public var labelEndSpinner:Label;
	
	[SkinPart("true")]
	public var richEditableText:RichEditableText;

    [SkinPart("true")]
    public var groupText:HGroup;
    
	[SkinPart("true")]
	public var screenShot:Image;

	private var shared:Boolean = false;
	private var sharedOver:Boolean = false;
	private var sharedPlay:Boolean = false;
	private var sharedPause:Boolean = false;
	private var edit:Boolean = false;
	private var editOver:Boolean = false;
	private var editSelected:Boolean = false;
	private var editPlay:Boolean = false;
	private var editPause:Boolean = false;
	
	private var currentTimeChange:Boolean;
	private var durationChange:Boolean;
	private var timeSegmentChange:Boolean;
	
	private var _modeEdit:Boolean = true;
	
	private var _text:String ="";
	private var textChange:Boolean;
	
	private var _segment:Segment;
	private var segmentChange:Boolean;
	
	private var _startDateSession:Number = 0;
	private var _durationSession:Number;
	private var _timeBegin:Number=0;
	private var _timeEnd:Number=0;
	private var _currentTime:Number = 0;
	
	// init backGroundColor
	private var _backGroundColorRichEditableText:String = "#FFFFFF";
	// selected backgroundColor
	private var colorBackGround:String = "#FFEBCC";
    // current segment 
    private var _tracedSegment:Segment;
    // tracege interval in ms
    private var TRACAGE_INTERVAL:Number = 10*1000;
    // timer the trasage
    private var _tracageTimer:Timer; 
    // cursor
    private var _cursor:String;
	
	public function SegmentVideoAdvanced()
	{
		super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        // check tracage when block remove from the stage
        this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
	}
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set text(value:String):void
	{
		_text = value;
/*		textChange = true;
		invalidateProperties();*/
	}
	public function get text():String
	{
		return _text;
	}
	public function set segment(value:Segment):void
	{
		if(value && value != segment)
		{
			_segment = value;
			segmentChange = true;
			invalidateProperties();
		}
	}
	public function get segment():Segment
	{
		return _segment;
	}
	public function set modeEdit(value:Boolean):void
	{
		_modeEdit = value;
	}
	public function get modeEdit():Boolean
	{
		return _modeEdit;
	}
	public function rendererNormal():void
	{
		initSkinVars();
		if(modeEdit)
		{
			edit = true;
		}else
		{
			edit = false;
		}
		invalidateSkinState();
		// if click on button play the other SegmentVideo
		currentTime = 0
		durationChange = true;
		invalidateProperties();
	}
	public function rendererOver():void
	{
		if(modeEdit)
		{
			initSkinVars();
			editOver = true;
			invalidateSkinState();
		}else
		{
			initSkinVars();
			sharedOver = true;
			invalidateSkinState();
		}		
	}
	public function rendererSelected():void
	{
		if(modeEdit)
		{
			initSkinVars();
			editSelected = true;
			invalidateSkinState();
		}else
		{
			initSkinVars();
			sharedOver = true;
			invalidateSkinState();
		}	
	}
	
	public function set startDateSession(value:Number):void
	{
		_startDateSession = value;
	};
	public function get startDateSession():Number{return _startDateSession;};
	public function set durationSession(value:Number):void
	{
		_durationSession = value;
	};
	public function get durationSession():Number{return _durationSession;};
	
	public function set currentTime(value:Number):void{
		_currentTime = value;
		currentTimeChange = true;
		invalidateProperties();
	};
	public function get currentTime():Number{return _currentTime;};
	
	public function setBeginEndTime():void
	{
		/*durationChange = true;
		invalidateProperties();
		*/
		onClickImageJumpStart();
	}
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == imagePlay)
		{
			imagePlay.addEventListener(MouseEvent.CLICK, onClickImagePlay);	
		}
		if (instance == imagePause)
		{
			imagePause.addEventListener(MouseEvent.CLICK, onClickImagePause);	
		}
		if (instance == imageJumpStart)
		{
			imageJumpStart.addEventListener(MouseEvent.CLICK, onClickImageJumpStart);	
		}
		if (instance == iconDelete)
		{
			iconDelete.addEventListener(MouseEvent.CLICK, onClickIconDelete);	
		}
		if (instance == richEditableText)
		{
			// set text message
			if(text == "" && modeEdit)
			{
				setRichEditText();
			}else
			{
				richEditableText.text = text;
				richEditableText.setStyle("textAlign","left");
			}
			if(modeEdit)
			{
				richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
				richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
			}
		}
        if (instance == iconSegment)
        {
            // can drag/drop this segment
            iconSegment.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownIconSegment);
            iconSegment.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverIconSegment);
            iconSegment.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutIconSegment);
            var messageDND:String = "Glisser-déplacer ce bloc";
            iconSegment.toolTip = messageDND + " vidéo";
            // TODO : message "Vous pouver deplace cet block en haut en bas",
            // show this message only if has many blocs
            // MouseCursor = HAND just if has many blocs
        }
		
		if(instance == startSpinner)
		{
			startSpinner.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletStartSpinner);
			startSpinner.addEventListener(Event.CHANGE, onChange);
		}
		if(instance == endSpinner)
		{
			endSpinner.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletEndSpinner);
			endSpinner.addEventListener(Event.CHANGE, onChange);
		}
		if(instance == labelStartSpinner)
		{
			labelStartSpinner.text = TimeUtils.formatTimeString(Math.floor(_timeBegin / 1000)); 
		}
		if(instance == labelEndSpinner)
		{
			labelEndSpinner.text = TimeUtils.formatTimeString(Math.floor(_timeEnd / 1000)); 
		}

		if(instance == labelDuration)
		{
			var durationMs:Number = _timeEnd - _timeBegin;
			var duration:Number = Math.floor(durationMs / 1000); 
			labelDuration.text = TimeUtils.formatTimeString(duration); 
		}
		if(instance == labelCurrentTime)
		{
			// set current time
			updateLabelCurrentTime();
		}
		
		if(instance == screenShot)
		{
			if(segment.byteArray != null)
			{
				screenShot.source = segment.byteArray;
			}else
			{
				screenShot.source = IconEnum.getIconByName('ScreenShot80x60'); 
			}
		}
	}
	
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		
	}
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(segmentChange)
		{
			segmentChange = false;
			
			text = segment.comment;
			// set text message
			if(text == "" && modeEdit)
			{
				setRichEditText();
			}else
			{
				richEditableText.text = text;
				richEditableText.setStyle("textAlign","left");
			}
			if(modeEdit)
			{
				richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
				richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
			}
			
			/////////////////////////
			// check NaN time
			if(isNaN(this._segment.beginTimeVideo))
			{
				this._timeBegin = 0;
			}else
			{
				this._timeBegin = this._segment.beginTimeVideo - this._startDateSession;
			}
			
			if( isNaN(this._segment.endTimeVideo))
			{
				this._timeEnd = 0;		
			}else
			{
				this._timeEnd = this._segment.endTimeVideo - this._startDateSession;
			}
			//this._title = this._segment.title;
			// enabled button playStop
		//	setEnabledButtonPlayStop();
		//	labelStartDuration.text = getLabelStartDuration();
		//	labelStartDuration.setStyle("fontWeight","normal");
			/////////////////////////
			if(labelDuration)
			{
				var durationMs:Number = _timeEnd - _timeBegin;
				var duration:Number = Math.floor(durationMs / 1000);
				labelDuration.text = TimeUtils.formatTimeString(duration); 
			}
			
			if(segment.byteArray != null)
			{
				if(screenShot)
				{
					screenShot.source = segment.byteArray;
				}
			}else
			{
				if(screenShot)
				{
					screenShot.source = IconEnum.getIconByName('ScreenShot80x60'); 
				}
			}
            
            // check text
            if(!modeEdit && text == "")
            {
                groupText.includeInLayout = groupText.visible = false;
            }
		}
		if(currentTimeChange)
		{
			currentTimeChange = false;
			
			// set current time
			updateLabelCurrentTime();
		}
		if(durationChange)
		{
			durationChange = false;
			// set duration
			updateLabelDuration();
		}
		if(timeSegmentChange)
		{
			timeSegmentChange = false;
			
			var newBegin:Number = Math.floor(_timeBegin / 1000);
			var newEnd:Number = Math.floor(_timeEnd / 1000);
			
			if(startSpinner != null)
			{
				startSpinner.value = newBegin;
				startSpinner.maximum = newEnd;
				
			}
			if(endSpinner != null)
			{
				endSpinner.value = newEnd;
				endSpinner.minimum = newBegin;
			}
			if(labelStartSpinner != null)
			{
				labelStartSpinner.text  = TimeUtils.formatTimeString(newBegin); 
			}
			if(labelEndSpinner != null)
			{
				labelEndSpinner.text  = TimeUtils.formatTimeString(newEnd); 
			}
			if(labelDuration)
			{
				updateLabelDuration();
			}
		}
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(sharedOver)
		{
			skinName = "sharedOver";
		}else if(sharedPlay)
		{
			skinName = "sharedPlay";
		}else if(sharedPause)
		{
			skinName = "sharedPause";
		}else if(edit)
		{
			skinName = "edit";
            // stop tracage timer
            stopTracageTimer();
		}else if(editOver)
		{
			skinName = "editOver";
            // tracage over block
            traceBlockOver();
		}else if(editSelected)
		{
			skinName = "editSelected";
            // start tracage timer
            startTracageTimer();
            // tracage selected block
            traceSelectedBlock();
		}else if(editPlay)
		{
			skinName = "editPlay";
		}else if(editPause)
		{
			skinName = "editPause";
		}else
		{
			skinName = "shared";
		}
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	private function onClickImagePlay(event:MouseEvent):void
	{
		var playSegmentVideoEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PLAY_RETRO_SEGMENT);
		var playTime:Number = this._timeBegin;
		if(currentTime > playTime)
		{
			playTime = currentTime;
			updateLabelCurrentTime();
		}else
		{
			currentTime = playTime;
		}
		
		playSegmentVideoEvent.beginTime = playTime;
		playSegmentVideoEvent.endTime = this._timeEnd;
		dispatchEvent(playSegmentVideoEvent);
		
		initSkinVars();
		if(modeEdit)
		{
			editPlay = true;
		}else
		{
			sharedPlay = true;
		}
		invalidateSkinState();
		
		var endTimeS:Number = Math.floor(_timeEnd / 1000); 
		labelDuration.text = TimeUtils.formatTimeString(endTimeS); 
        
        // tracage block video
        var blockVideoTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        blockVideoTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        blockVideoTracageEvent.exploreType = RetroTraceModel.WATCH_BLOCK_VIDEO;
        blockVideoTracageEvent.id = segment.segmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(blockVideoTracageEvent);
	}
	
	private function onClickImagePause(event:MouseEvent):void
	{
		
		setPause();
		
		var playSegmentVideoEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PAUSE_RETRO_SEGMENT);
		dispatchEvent(playSegmentVideoEvent);
        
        // tracage block video
        var blockVideoTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        blockVideoTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        blockVideoTracageEvent.exploreType = RetroTraceModel.PAUSE_BLOCK_VIDEO;
        blockVideoTracageEvent.id = segment.segmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(blockVideoTracageEvent);
	}
	
	private function onClickImageJumpStart(event:*=null):void
	{
		initSkinVars();
		if(modeEdit)
		{
			editOver = true;
		}else
		{
			sharedOver = true;
		}
		invalidateSkinState();
		
		var durationMs:Number = _timeEnd - _timeBegin;
		var duration:Number = Math.floor(durationMs / 1000); 
		labelDuration.text = TimeUtils.formatTimeString(duration); 
		
		this.currentTime = this._timeBegin;
		
		var playSegmentVideoEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.STOP_RETRO_SEGMENT);
		dispatchEvent(playSegmentVideoEvent);
        
        // tracage block video
        var blockVideoTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        blockVideoTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        blockVideoTracageEvent.exploreType = RetroTraceModel.STOP_BLOCK_VIDEO;
        blockVideoTracageEvent.id = segment.segmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(blockVideoTracageEvent);
	}
    
	private function onClickIconDelete(event:MouseEvent):void
	{
		var removeSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_REMOVE_SEGMENT);
		removeSegmentEvent.segment = segment;
		this.dispatchEvent(removeSegmentEvent);
	}
	// richText
	public function onFocusInRichEditableText(event:*=null):void
	{		
		if(richEditableText.text == "Cliquer ici pour ajouter du texte")
		{
			richEditableText.text = "";
			richEditableText.setStyle("fontStyle","normal");
			richEditableText.setStyle("color","#000000");
			richEditableText.setStyle("textAlign","left");
		}
		richEditableText.selectAll();
		if(this.stage != null)
		{
			this.stage.focus = richEditableText;
		}
		richEditableText.addEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
		richEditableText.setStyle("backgroundColor", colorBackGround);
	}
	public function onFocusOutRichEditableText(event:*=null):void
	{
		if(richEditableText.text == "")
		{
			setRichEditText();
		}else
		{
			text = richEditableText.text;
		}
		richEditableText.removeEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);

	}
	private function onChangeRichEditableText(event:TextOperationEvent):void
	{
		segment.comment = richEditableText.text;
		notifyUpdateSegment();
	}
	
    private function onMouseDownIconSegment(event:MouseEvent):void
    {
        var mouseDownIconSegment:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.READY_TO_DRAG_DROP_SEGMENT);
        dispatchEvent(mouseDownIconSegment);
    }
    private function onMouseOverIconSegment(event:MouseEvent):void
    {
        _cursor =  Mouse.cursor;
        Mouse.cursor = MouseCursor.HAND;
    }
    private function onMouseOutIconSegment(event:MouseEvent):void
    {
        Mouse.cursor = _cursor;
    }
	private function onCreationCompletStartSpinner(event:FlexEvent):void
	{
		startSpinner.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletStartSpinner);
		startSpinner.value = Math.floor(_timeBegin / 1000);
		startSpinner.maximum = Math.floor(_timeEnd / 1000);
	}
	private function onCreationCompletEndSpinner(event:FlexEvent):void
	{
		endSpinner.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletEndSpinner);
		endSpinner.value = Math.floor(_timeEnd / 1000);
		endSpinner.minimum = Math.floor(_timeBegin / 1000);
	}

	private function onChange(event:Event):void
	{
		_timeBegin = startSpinner.value * 1000; 
		_timeEnd = endSpinner.value * 1000; 
		timeSegmentChange = true;
		invalidateProperties();
		// update segment
		segment.beginTimeVideo = _timeBegin + _startDateSession;
		segment.endTimeVideo = _timeEnd + _startDateSession;
		notifyUpdateSegment();
		
		currentTime = 0;
	}
    
    // creation the segment
    private function onCreationComplete(event:FlexEvent = null):void
    {
        // save clone the segment for tracage the modifications
        _tracedSegment = new Segment(segment.parentRetroDocument);
        _tracedSegment.setSegmentXML(segment.getSegmentXML());
    }
    // remove from stage 
    private function onRemoveFromStage(event:Event):void
    {
        checkTracage();
        // stop tracage timer
        stopTracageTimer();
    }
    // check tracage modification the segment
    private function checkTracage(event:* = null):void
    {
        trace("check tracage block video => "+segment.segmentId);
        // list modifications
        var arr:ArrayCollection = new ArrayCollection();
        var tempString:String;
        // save modifications in format JSON
        var diff:String = "{ ";
        // check if has _tracedSegment
        if(_tracedSegment)
        {
            // check modifications the comment
            if( segment.comment != _tracedSegment.comment)
            {
                tempString = "'"+ RetroDocumentConst.TAG_COMMENT+"': '"+segment.comment+"'";
                arr.addItem(tempString);
            }
            // check modification the begin time video
            if(segment.beginTimeVideo != _tracedSegment.beginTimeVideo)
            {
                tempString = "'"+ RetroDocumentConst.TAG_FROM_TIME+"': "+segment.beginTimeVideo.toString();
                arr.addItem(tempString);
            }
            // check modification the end time video
            if(segment.endTimeVideo != _tracedSegment.endTimeVideo)
            {
                tempString = "'"+ RetroDocumentConst.TAG_TO_TIME+"': "+segment.endTimeVideo.toString();
                arr.addItem(tempString);
            }
        }
        // nbr property of the segment was modified
        var nbrElm:int = arr.length;
        // tracage the modification
        if(nbrElm > 0)
        {
            for(var nElm:int = 0; nElm < nbrElm-1; nElm++ )
            {
                diff = diff+arr.getItemAt(nElm) +",\n\t\t";
            }
            diff = diff + arr.getItemAt(nbrElm-1) + " }"; 
            trace("tracage =>"+ diff);
            // tracage modifications the video block
            var videoBlockTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
            videoBlockTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EDIT;
            videoBlockTracageEvent.id = segment.segmentId;
            videoBlockTracageEvent.serialisation = this._tracedSegment.getSegmentXML();
            videoBlockTracageEvent.diff = diff
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(videoBlockTracageEvent);
            
            // save modifications of the segment 
            onCreationComplete();
        }
    }
	
	//_____________________________________________________________________
	//
	// Dispatchers
	//
	//_____________________________________________________________________
	
	private function notifyUpdateSegment():void
	{
		var notifyUpdateEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_RETRO_SEGMENT);
		this.dispatchEvent(notifyUpdateEvent);
	}
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________
	
    /**
     * tracage over block
     */
    private function traceBlockOver():void
    {
        // tracage block audio
        var blockAudioTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        blockAudioTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        blockAudioTracageEvent.exploreType = RetroTraceModel.OVER;
        blockAudioTracageEvent.id = segment.segmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(blockAudioTracageEvent);
    }
    /**
     * tracage selected block
     */
    private function traceSelectedBlock():void
    {
        // tracage block audio
        var blockAudioTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        blockAudioTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        blockAudioTracageEvent.exploreType = RetroTraceModel.SELECTED;
        blockAudioTracageEvent.id = segment.segmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(blockAudioTracageEvent);
    }
    private function startTracageTimer():void
    {
        if(!_tracageTimer)
        {
            _tracageTimer = new Timer(this.TRACAGE_INTERVAL,0);
            _tracageTimer.addEventListener(TimerEvent.TIMER, checkTracage);
        }
        _tracageTimer.start();
    }
    private function stopTracageTimer():void
    {
        if(_tracageTimer && _tracageTimer.running)
        {
            // check tracage if user deselected segment
            checkTracage();
            _tracageTimer.stop();
        }
    }
	private function setRichEditText():void
	{
		richEditableText.text = "Cliquer ici pour ajouter du texte";
		richEditableText.setStyle("fontStyle","italic");
		richEditableText.setStyle("textAlign","right");
		var colorText:String = "#000000";
		richEditableText.setStyle("color", colorText);
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);
	}
	
	private function initSkinVars():void
	{
		shared = sharedOver = sharedPlay = sharedPause = edit = editOver = editSelected = editPlay = editPause = false;
	}
	
	public function setPause():void
	{		
		initSkinVars();
		if(modeEdit)
		{
			editPause = true;
		}else
		{
			sharedPause = true;
		}	
		invalidateSkinState();
		
		currentTimeChange  = true;
		invalidateProperties();
		
	}
	private function updateLabelCurrentTime():void
	{
		var currnetTimeS:Number = Math.floor(this.currentTime / 1000);
		if(labelCurrentTime)
		{
			labelCurrentTime.text = TimeUtils.formatTimeString(currnetTimeS);  
		}
	}
	private function updateLabelDuration():void
	{
		var durationMs:Number = _timeEnd - _timeBegin;
		var duration:Number = Math.floor(durationMs / 1000); 
		labelDuration.text = TimeUtils.formatTimeString(duration); 
	}
}
}