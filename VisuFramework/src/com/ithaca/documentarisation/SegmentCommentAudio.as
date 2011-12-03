package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.AudioRecorderEvent;
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.components.IconDelete;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Image;
import mx.events.FlexEvent;

import spark.components.HGroup;
import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;

public class SegmentCommentAudio extends SkinnableComponent
{	

	[SkinPart("true")]
	public var iconDelete:IconDelete;
	
	[SkinPart("true")]
	public var richEditableText:RichEditableText;
	
	[SkinPart("true")]
	public var audioRecorder:AudioRecorder;
	
	[SkinPart("true")]
	public var iconSegment:Image;
	
	[SkinPart("true")]
	public var groupAudioRecorder:HGroup;
	[SkinPart("true")]
	public var groupText:HGroup;
	
	private var _text:String;
	private var textChange:Boolean;
	private var _streamId:String;
	private var _userId:String;
	private var streamIdChange:Boolean;
	// path audio file
	private var _streamPath:String;
	
	private var _connection:NetConnection;
	private var connectionChange:Boolean; 	
	private var _segment:Segment;
	private var segmentChange:Boolean;

	private var durationAudio:int;// ms
	private var durationAudioChange:Boolean;

	private var timer:Timer;
	private static var UPDATE_TIME_INTERVAL:int = 250;
	
	
	private var editOver:Boolean = false;
	private var edit:Boolean = false;
	private var shared:Boolean = false;
	private var sharedOver:Boolean = false;
	private var selected:Boolean;
	
	private var _modeEdit:Boolean = true;

	// net Stream
	private var _stream:NetStream;
	
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
	public function set editabled(value:Boolean):void
	{
		richEditableText.editable = value;
	}
	public function set connection(value:NetConnection):void
	{
		if(value)
		{
			_connection = value;
			_stream = new NetStream(value);
			connectionChange = true;
			invalidateProperties();
		}else
		{
			trace("error set the connection")
		}
	}
	public function get connection():NetConnection
	{
		return _connection;
	}
	public function set streamId(value:String):void
	{
		_streamId = value;
		streamIdChange = true;
		invalidateProperties();
	}
	public function get streamId():String
	{
		return _streamId;
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
	public function set streamPath(value:String):void
	{
		_streamPath = value;
	}
	public function get streamPath():String
	{
		return _streamPath;
	}
	public function set userId(value:String):void
	{
		_userId = value;
	}
	public function get userId():String
	{
		return _userId;
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
		audioRecorder.skinNormal();
		invalidateSkinState();
	}
	public function rendererOver():void
	{
		if(modeEdit)
		{
			audioRecorder.skinOver();
			initSkinVars();
			editOver = true;
			invalidateSkinState();
		}else
		{
			audioRecorder.skinOverShare();
			initSkinVars();
			editOver = false;
			invalidateSkinState();
		}		
	}
	public function rendererSelected():void
	{
		if(modeEdit)
		{
			audioRecorder.skinOver();
			initSkinVars();
			selected = true;
			invalidateSkinState();
		}else
		{
			
		}	
	}
	public function SegmentCommentAudio()
	{
		super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        // check tracage when block remove from the stage
        this.addEventListener(Event.REMOVED_FROM_STAGE, checkTracage);
	}
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);

		if(instance == iconDelete)
		{
			iconDelete.addEventListener(MouseEvent.CLICK, onClickIconDelete);
		}

		if(instance == audioRecorder)
		{
			audioRecorder.stream = _stream;
			audioRecorder.streamId = streamId;
			audioRecorder.streamPath = streamPath;
			audioRecorder.userId = userId;
			audioRecorder.modeShare = !modeEdit;
			
			// set update time interval 
			audioRecorder.updateTimeInterval = UPDATE_TIME_INTERVAL;
			audioRecorder.addEventListener(AudioRecorderEvent.UPDATE_PATH_COMMENT_AUDIO, onUpdatePathCommentAudio);
			audioRecorder.addEventListener(AudioRecorderEvent.UPDATE_DURATION_COMMENT_AUDIO, onUpdateDuratioCommentAudio);
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
			iconSegment.toolTip = "Bloc commentaire audio";
			// TODO : message "Vous pouver deplace cet block en haut en bas",
			// show this message only if has many blocs
			// MouseCursor = HAND just if has many blocs
		}
	}	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(connectionChange)
		{
			connectionChange = false;
			if(audioRecorder)
			{
				audioRecorder.stream = _stream;
			}
		}
		if(streamIdChange)
		{
			streamIdChange = false;
			if(audioRecorder)
			{
				audioRecorder.streamId = streamId;
			}
		}
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
			}
			if(modeEdit)
			{
				richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
				richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
			}

			streamPath = segment.pathCommentAudio;
			// set user id
			audioRecorder.userId = userId;
			// set duration audio
			durationAudio = segment.durationCommentAudio;
			
			if(audioRecorder)
			{

				audioRecorder.streamPath = streamPath;
				audioRecorder.durationAudio = durationAudio;
			}
			
			// check duration audio 
			if(!modeEdit && durationAudio == 0)
			{
				groupAudioRecorder.includeInLayout = groupAudioRecorder.visible = false;
			}
			// check text
			if(!modeEdit && text == "")
			{
				groupText.includeInLayout = groupText.visible = false;
			}
		}
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(shared)
		{
			skinName = "shared";
		}else if(sharedOver)
		{
			skinName = "sharedOver";
		}else if(edit)
		{
			skinName = "edit";
            // stop tracage timer
            stopTracageTimer();
		}else if(editOver)
		{
			skinName = "editOver";
		}else if(selected)
		{
			skinName = "editSelected"
            // start tracage timer
            startTracageTimer();
		}
		return skinName;
	}
	
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	// delete
	private function onClickIconDelete(event:MouseEvent):void
	{
		var removeSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_REMOVE_SEGMENT);
		removeSegmentEvent.segment = segment;
		this.dispatchEvent(removeSegmentEvent);
	}
	// richText
	public function onFocusInRichEditableText(event:*=null):void
	{
		if(richEditableText.text == "Cliquer ici pour enregistrer un commentaire")
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
		richEditableText.setStyle("backgroundColor", colorBackGround);
		richEditableText.addEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
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
		
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);
		richEditableText.removeEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
	}
	
	private function onChangeRichEditableText(event:TextOperationEvent):void
	{
		segment.comment = richEditableText.text;
		notifyUpdateSegment();
	}
	
	private function onUpdatePathCommentAudio(event:AudioRecorderEvent):void
	{
		segment.pathCommentAudio = event.pathAudio;
	}
	private function onUpdateDuratioCommentAudio(event:AudioRecorderEvent):void
	{
		segment.durationCommentAudio = event.durationTimeAudio;
		notifyUpdateSegment();
	}
	private function onMouseDownIconSegment(event:MouseEvent):void
	{
		var mouseDownIconSegment:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.READY_TO_DRAG_DROP_SEGMENT);
		dispatchEvent(mouseDownIconSegment);
	}

    // creation the segment
	private function onCreationComplete(event:FlexEvent = null):void
	{
        // save clone the segment for tracage the modifications
        _tracedSegment = new Segment(segment.parentRetroDocument);
        _tracedSegment.setSegmentXML(segment.getSegmentXML());
	}
    // check tracage modification the segment
    private function checkTracage(event:* = null):void
    {
        trace("check tracage block audio => "+segment.segmentId);
        // list modifications
        var arr:ArrayCollection = new ArrayCollection();
        var tempString:String;
        // save modifications in format JSON
        var diff:String = "{ ";
        
        // check modifications the comment
        if(segment.comment != _tracedSegment.comment)
        {
            tempString = "'"+ RetroDocumentConst.TAG_COMMENT+"': '"+segment.comment+"'";
            arr.addItem(tempString);
        }
        // check modification the duration audio
        if(segment.durationCommentAudio != _tracedSegment.durationCommentAudio)
        {
            tempString = "'"+ RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO+"': "+segment.durationCommentAudio.toString();
            arr.addItem(tempString);
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
            // tracage modifications the audio block
            var audioBlockTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
            audioBlockTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EDIT;
            audioBlockTracageEvent.id = segment.segmentId;
            audioBlockTracageEvent.serialisation = this._tracedSegment.getSegmentXML();
            audioBlockTracageEvent.diff = diff
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(audioBlockTracageEvent);
            
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
		richEditableText.text = "Cliquer ici pour enregistrer un commentaire";
		richEditableText.setStyle("fontStyle","italic");
		richEditableText.setStyle("textAlign","right");
		var colorText:String = "#000000";
		richEditableText.setStyle("color", colorText);
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);
	}
	
	private function initSkinVars():void
	{
		shared = sharedOver = edit = editOver = selected = false;
	}
	public function onMetaData(infoObject:Object):void {
		trace("metadata");
		for (var propName:String in infoObject) 
		{
			trace(propName + " = " + infoObject[propName]);
		}
	}
	
	public function onCuePoint(infoObject:Object):void {
		trace("onCuePoint:");
		for (var propName:String in infoObject) 
		{
			if (propName != "parameters")
			{
				trace(propName + " = " + infoObject[propName]);
			}
			else
			{
				trace("parameters =");
				if (infoObject.parameters != undefined) {
					for (var paramName:String in infoObject.parameters)
					{
						trace("   " + paramName + ": " + infoObject.parameters[paramName]);
					}
				}
				else
				{
					trace("undefined");
				}
			}        
		}
	}
	
	public function onPlayStatus(infoObject:Object):void {
		trace("on play status");
		for (var prop: String in infoObject) {
			trace("\t"+prop+":\t"+infoObject[prop]);
		}
		trace("---");
	}
}
}