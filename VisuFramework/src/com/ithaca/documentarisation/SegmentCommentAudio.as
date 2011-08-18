package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.AudioRecorderEvent;
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.utils.VisuUtils;
import com.ithaca.utils.components.IconDelete;
import com.ithaca.visu.ui.utils.IconEnum;

import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.ui.Mouse;
import flash.utils.Timer;

import mx.controls.Button;
import mx.controls.Image;
import mx.events.FlexEvent;

import spark.components.Label;
import spark.components.RichEditableText;
import spark.components.VGroup;
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
			trace("partAdd => audioRecorder");
			audioRecorder.stream = _stream;
			audioRecorder.streamId = streamId;
			audioRecorder.streamPath = streamPath;
			audioRecorder.userId = userId;

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
		}else if(editOver)
		{
			skinName = "editOver";
		}else if(selected)
		{
			skinName = "editSelected"
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
		if(richEditableText.text == "Ajoutez du texte à cet enregistrement")
		{
			richEditableText.text = "";
			richEditableText.setStyle("fontStyle","normal");
			richEditableText.setStyle("color","#000000");
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
	
	private function setRichEditText():void
	{
		richEditableText.text = "Ajoutez du texte à cet enregistrement";
		richEditableText.setStyle("fontStyle","italic");
		var colorText:String = "#000000";
		richEditableText.setStyle("color", colorText);
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);
	}
	/**
	 * params: value - time in ms
	 */
	private function getTimeInMinSec(value:int):String
	{
		var result:String;
		var minutes:int = value/60000;
		var seconds:int = (value - minutes*60000)/1000;
		var secondsString:String = seconds.toString();
		if(seconds < 10)
		{
			secondsString = "0"+secondsString;
		}
		result = minutes.toString() + ":"+ secondsString.toString();
		return result;
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