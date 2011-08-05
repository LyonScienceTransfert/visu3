package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.AudioRecorderEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.utils.VisuUtils;
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
	public var groupSegmentAudio:VGroup;
	[SkinPart("true")]
	public var labelSave:Label;
	[SkinPart("true")]
	public var labelDurationInfo:Label;
	[SkinPart("true")]
	public var labelDurationDigit:Label;
	[SkinPart("true")]
	public var labelCurrentTimeDigit:Label;
	[SkinPart("true")]
	public var imageSave:Image;
	[SkinPart("true")]
	public var imageEdit:Image;
	[SkinPart("true")]
	public var imagePlay:Image;
	[SkinPart("true")]
	public var imageMinimaze:Image;
	[SkinPart("true")]
	public var imageDelete:Image;
	
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
	private var currentTimeAudio:int= 0;// ms
	private var currentTimeAudioChange:Boolean;
	
	
	private var durationAudioChange:Boolean;
	private var modePlayingChange:Boolean;
	private var audioPlaying:Boolean;
	
	// TODO change mequinisme the timer
	private var timer:Timer;
	private static var UPDATE_TIME_INTERVAL:int = 250;
	
	
	private var normal:Boolean = true;
	private var edit:Boolean = false;
	private var normalOver:Boolean = false;

	// net Stream
	private var _stream:NetStream;
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
		if(instance == groupSegmentAudio)
		{
			groupSegmentAudio.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverSegment);
			groupSegmentAudio.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutSegment);
		}
		if(instance == labelSave)
		{
			
		}
		if(instance == imageSave)
		{
			imageSave.addEventListener(MouseEvent.CLICK, onClickButtonSave);
		}
		if(instance == imageEdit)
		{
			imageEdit.addEventListener(MouseEvent.CLICK, onClickImageEdit);
		}
		if(instance == imagePlay)
		{
			imagePlay.addEventListener(MouseEvent.CLICK, onClickImagePlay);
			imagePlay.toolTip = "Ecouter audio";
		}
		if(instance == imageDelete)
		{
			imageDelete.addEventListener(MouseEvent.CLICK, onClickImageDelete);
		}
		if(instance == imageMinimaze)
		{
			imageMinimaze.addEventListener(MouseEvent.CLICK, onClickImageMinimaze);
		}
		if(instance == audioRecorder)
		{
			trace("partAdd => audioRecorder");
			audioRecorder.stream = _stream;
			audioRecorder.streamId = streamId;
			audioRecorder.streamPath = streamPath;
			audioRecorder.durationAudio = durationAudio;
			audioRecorder.currentTimeAudio = currentTimeAudio;
			if(audioPlaying)
			{
				audioRecorder.skinPlaying();
			}else
			{
				if(durationAudio > 0)
				{
					audioRecorder.skinNormal();
				}else
				{
					audioRecorder.skinEmpty();
				}
			}
			// set update time interval 
			audioRecorder.updateTimeInterval = UPDATE_TIME_INTERVAL;
			audioRecorder.addEventListener(AudioRecorderEvent.PLAY_AUDIO, onPlayAudioRecorder);
			audioRecorder.addEventListener(AudioRecorderEvent.STOP_PLAY_AUDIO, onStopAudioRecorder);
			audioRecorder.addEventListener(AudioRecorderEvent.PLAYING_AUDIO, onPlayingAudioRecorder);
			
		}
		if (instance == richEditableText)
		{
			// set text message
			if(text == "")
			{
				setRichEditText();
			}else
			{
				richEditableText.text = text;
			}
			richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
			richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
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
		if(currentTimeAudioChange)
		{
			currentTimeAudioChange = false;
			if(labelCurrentTimeDigit)
			{
				labelCurrentTimeDigit.text = getTimeInMinSec(currentTimeAudio);
				labelCurrentTimeDigit.visible = true;
				labelDurationInfo.text = "/";
			}
			if(audioRecorder && timer && timer.running)
			{
				audioRecorder.currentTimeAudio = currentTimeAudio;
			}
		}
		if(segmentChange)
		{
			segmentChange = false;
			
			text = segment.comment;
			// set text message
			if(text == "")
			{
				setRichEditText();
			}else
			{
				richEditableText.text = text;
			}
			richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
			richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
			
/*			if(segment.link != "")
			{
				streamId = "usersAudioRetroDocument/21/"+segment.link;
				streamIdChange = true;
				invalidateProperties();
			}*/
			streamPath = segment.link;
			if(audioRecorder)
			{
				audioRecorder.streamPath = streamPath;
			}
			
		}
		if(durationAudioChange)
		{
			durationAudioChange = false;
			if(audioRecorder)
			{
				audioRecorder.durationAudio = durationAudio;
				// has audio file to listen
				if(durationAudio > 0)
				{
					audioRecorder.skinNormal();
				}else
				{
					audioRecorder.skinEmpty();
				}
			}
			if( durationAudio > 0 )
			{
				// show buttons play,edit and labels
				imagePlay.visible = imageEdit.visible = true;
				labelDurationDigit.text = getTimeInMinSec(durationAudio);
				labelDurationDigit.visible = true;
				labelDurationInfo.visible = true;
				labelDurationInfo.text = "Durée";
				if(timer && timer.running)
				{
					labelDurationInfo.text = "/";
					labelCurrentTimeDigit.text = getTimeInMinSec(currentTimeAudio);
					labelCurrentTimeDigit.visible = true;
				}
			}else
			{
				// show lable, button edit
				labelDurationInfo.text = "Pas d'audio";
				labelDurationInfo.visible = true;
				imageEdit.visible = true;
			}
		}
		if(modePlayingChange)
		{
			modePlayingChange = false;
			if((timer && timer.running) || audioPlaying)
			{
				imagePlay.source = IconEnum.getIconByName('iconStop_16x16');
				imagePlay.toolTip = "Arrêter audio";
				labelCurrentTimeDigit.text = getTimeInMinSec(currentTimeAudio);
				labelCurrentTimeDigit.visible = true;
				labelDurationInfo.text = "/";
				if(audioRecorder)
				{
					audioRecorder.skinPlaying();
				}
			}else
			{
				imagePlay.source = IconEnum.getIconByName('iconPlay_16x16');
				imagePlay.toolTip = "Ecouter audio";
				labelCurrentTimeDigit.visible = false;
				labelDurationInfo.text = "Durée";
				if(audioRecorder && audioRecorder.currentTimeAudio != 0 && !audioPlaying)
				{
					audioRecorder.stopPlayAudio();
					audioRecorder.skinNormal();
					trace("call stop to audioRecorder");
				}
			}
			
		}
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(normal)
		{
			skinName = "normal";
		}else if(edit)
		{
			skinName = "edit";
		}else if(normalOver)
		{
			skinName = "normalOver";
		}
		return skinName;
	}
	
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________
	// segment
	public function onMouseOverSegment(event:MouseEvent):void
	{
		if(edit)
		{
			labelSave.visible = imageSave.visible = imageMinimaze.visible = imageDelete.visible = true;
		}else if(normal)
		{
			//trace("OVER normal")
			initSkinVars();
			durationAudioChange = true;
			modePlayingChange = true;
			normalOver = true;
			invalidateSkinState();
		}
	}
	public function onMouseOutSegment(event:MouseEvent):void
	{
		if(edit)
		{
			//trace("OUT edit")
			labelSave.visible = imageSave.visible = imageDelete.visible = imageMinimaze.visible = false;
		}else if(normalOver)
		{
			//trace("OUT else edit")
			initSkinVars();
			modePlayingChange = true;
			normal = true;
			invalidateSkinState();
		}else
		{
			
		}
	}
	//save
	private function onClickButtonSave(event:MouseEvent):void
	{
		return;
	}
	// play
	private function onClickImagePlay(event:MouseEvent):void
	{
		if(!audioPlaying)
		{
			// start playing			
			_stream.client = this;
			var streamPathFull:String = VisuUtils.FOLDER_AUDIO_COMMENT_FILES+"/"+userId+"/"+streamPath;
			_stream.play(streamPathFull);
			
			timer = new Timer(UPDATE_TIME_INTERVAL,0);
			timer.addEventListener(TimerEvent.TIMER, updateCurrentTimeAudio);
			timer.start();
			modePlayingChange = true;
			audioPlaying = true;
			invalidateProperties();
		}else
		{
			stopPlayAudio();
		}
	}
	private function updateCurrentTimeAudio(event:*=null):void
	{
		currentTimeAudioChange = true;
		invalidateProperties();
		
		currentTimeAudio += UPDATE_TIME_INTERVAL;
		
		if(currentTimeAudio > durationAudio)
		{
			stopPlayAudio();
		}
	}
	private function stopPlayAudio(event:*=null):void
	{
		//trace("stop playing audio");
		if(timer)
		{
			timer.stop();
		}
		_stream.close();
		currentTimeAudio = 0;
		currentTimeAudioChange = true;
		audioPlaying = false;
		modePlayingChange = true;
		invalidateProperties();
	}
	// play on audiorecorder
	private function onPlayAudioRecorder(event:*=null):void
	{
		modePlayingChange = true;
		audioPlaying = true;
		invalidateProperties();
	}
	// stop on audiorecorder
	private function onStopAudioRecorder(event:*=null):void
	{
		stopPlayAudio();
	}
	// plying audiorecorder, notification update current time
	private function onPlayingAudioRecorder(event:AudioRecorderEvent):void
	{
		currentTimeAudio = event.currentTimeAudio;
		currentTimeAudioChange = true;
		invalidateProperties();
	}
	// delete
	private function onClickImageDelete(event:MouseEvent):void
	{
		// TODO conformation deleting
		return;
	}
	// minimaze
	private function onClickImageMinimaze(event:MouseEvent):void
	{
		initSkinVars();
		normal = true;
		invalidateSkinState();
/*		modePlayingChange = true;*/
		/*if(audioRecorder.currentTimeAudio != 0)
		{
			timer = new Timer(UPDATE_TIME_INTERVAL,0);
			timer.addEventListener(TimerEvent.TIMER, updateCurrentTimeAudio);
			timer.start();
		}*/
	}

	// edit
	private function onClickImageEdit(event:*=null):void
	{
		initSkinVars();
		edit = true;
		invalidateSkinState();
	}
	// richText
	private function onFocusInRichEditableText(event:FocusEvent):void
	{
		// change skin to "edit"
		onClickImageEdit();
		
		if(richEditableText.text == "ajoutez une nouvelle commentaire ici")
		{
			richEditableText.text = "";
			richEditableText.setStyle("fontStyle","normal");
			richEditableText.setStyle("color","#000000");
		}
		richEditableText.addEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
	}
	private function onFocusOutRichEditableText(event:FocusEvent):void
	{
		if(richEditableText.text == "")
		{
			setRichEditText();
		}else
		{
			text = richEditableText.text;
		}
		richEditableText.removeEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
	}
	
	private function onChangeRichEditableText(event:TextOperationEvent):void
	{
		segment.comment = richEditableText.text;
	}
	
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________
	
	private function setRichEditText():void
	{
		richEditableText.text = "ajoutez une nouvelle commentaire ici";
		richEditableText.setStyle("fontStyle","italic");
		var colorText:String = "#000000";
		/*		if(edit)
		{
		colorText = "#000000";
		}*/
		richEditableText.setStyle("color", colorText);
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
		normal = edit = normalOver  = false;
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