package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.AudioRecorderEvent;
import com.ithaca.utils.VisuUtils;
import com.ithaca.utils.components.IconButton;
import com.ithaca.visu.model.Model;

import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.media.Microphone;
import flash.media.SoundTransform;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.Timer;

import mx.controls.Button;
import mx.events.FlexEvent;
import mx.logging.ILogger;
import mx.logging.Log;

import spark.components.HSlider;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.Rect;

public class AudioRecorder extends SkinnableComponent
{
	private static var logger:ILogger = Log.getLogger("com.ithaca.documentarisation.SegmentVideo");
	
	[SkinState("empty")]
	[SkinState("normal")]
	[SkinState("recording")]
	[SkinState("playing")]
	
/*	[SkinPart("true")]
	public var progressBar:Rect;*/
	
	[SkinPart("true")]
	public var buttonPlay:Button;
	[SkinPart("true")]
	public var buttonRecord:Button;
	[SkinPart("true")]
	public var currentTimeAudioLabel:Label;
	[SkinPart("true")]
	public var durationTimeAudioLabel:Label;
	[SkinPart("true")]
	public var currentTimeAudionSlider:HSlider;
	
	private var empty:Boolean = true;
	private var play:Boolean = false;
	private var record:Boolean = false;
	private var normal:Boolean = false;
	
	// net Stream
	private var _stream:NetStream;
	// publish parameters
	private var _streamId:String;
	// path audio file
	private var _streamPath:String;
	// user id
	private var micro:Microphone;
	private var timer:Timer;
	
	// duration audio file in ms
	private var _durationAudio:int = 0;
	private var durationAudioChange:Boolean;
	// current time audion in ms
	private var _currentTimeAudio:int = 0;
	private var currentTimeAudioChange:Boolean;
	// update time interval in ms
	private var _updateTimeInterval:int;
//	private var modePlayingChange:Boolean;
	
	public function AudioRecorder()
	{
		super();
		this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
	}
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set stream(value:NetStream):void
	{
		if(value != null)
		{
			_stream = value
		}
	}
	public function get stream():NetStream
	{
		return _stream;
	}
	public function set streamId(value:String):void
	{
		_streamId = value;
	}
	public function get streamId():String
	{
		return _streamId;
	}
	public function set streamPath(value:String):void
	{
		_streamPath = value;
	}
	public function get streamPath():String
	{
		return _streamPath;
	}
	public function set durationAudio(value:int):void
	{
		_durationAudio = value;
		durationAudioChange = true;
		invalidateProperties();
	}
	public function get durationAudio():int
	{
		return _durationAudio;
	}
	public function set currentTimeAudio(value:int):void
	{
		_currentTimeAudio = value;
		currentTimeAudioChange = true;
		invalidateProperties();
	}
	public function get currentTimeAudio():int
	{
		return _currentTimeAudio;
	}
	public function set updateTimeInterval(value:int):void
	{
		_updateTimeInterval = value;
	}
	public function get updateTimeInterval():int
	{
		return _updateTimeInterval;
	}
	public function set userId(value:String):void
	{
	//	_userId = value;
	}
	public function get userId():String
	{
		return "e";
	}
	// init skin states
	public function skinNormal():void
	{
		initSkinVars();
		normal = true;
		invalidateSkinState();
	}
	public function skinPlaying():void
	{
		initSkinVars();
		play = true;
		invalidateSkinState();
	}
	public function skinEmpty():void
	{
		initSkinVars();
		empty = true;
		invalidateSkinState();
	}
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if(instance == buttonPlay)
		{
			buttonPlay.addEventListener(MouseEvent.CLICK, onClickButtonPlay);
		}
		if(instance == buttonRecord)
		{
			buttonRecord.addEventListener(MouseEvent.CLICK, onClickButtonRecord);
		}
		if(instance == durationTimeAudioLabel)
		{
			durationTimeAudioLabel.text = "-"+getTimeInMinSec(durationAudio-currentTimeAudio);
		}
		if(instance == currentTimeAudioLabel)
		{
			currentTimeAudioLabel.text =  getTimeInMinSec(currentTimeAudio);
		}
		if(instance == currentTimeAudionSlider)
		{
			currentTimeAudionSlider.minimum =  0;
			currentTimeAudionSlider.maximum =  durationAudio;
			currentTimeAudionSlider.value = currentTimeAudio;
		}
	}
	
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(durationAudioChange)
		{
			durationAudioChange = false;
			durationTimeAudioLabel.text = "-"+getTimeInMinSec(durationAudio-currentTimeAudio);
			currentTimeAudionSlider.maximum =  durationAudio;
		}
		
		if(currentTimeAudioChange)
		{
			currentTimeAudioChange = false;
			currentTimeAudioLabel.text = getTimeInMinSec(currentTimeAudio);
			durationTimeAudioLabel.text = "-"+getTimeInMinSec(durationAudio-currentTimeAudio);
			currentTimeAudionSlider.value = currentTimeAudio;
		}
		/*if(modePlayingChange)
		{
			modePlayingChange = false;
			if(timer && timer.running)
			{
				var playAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.PLAY_AUDIO);
				dispatchEvent(playAudioEvent);
			}else
			{
				var stopAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.STOP_PLAY_AUDIO);
				dispatchEvent(stopAudioEvent);
			}
		}*/
		
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(play)
		{
			skinName = "playing";
		}
		else if(record)
		{
			skinName = "recording";
		}
		else if(empty)
		{
			skinName = "empty";
		}
		else
		{
			skinName = "normal"
		}
		
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	private function onClickButtonPlay(event:*=null):void
	{
		if(normal)
		{
			record = false;
			play = true;
			normal = false;
			
			stream.client = this;
			var streamPathFull:String = VisuUtils.FOLDER_AUDIO_COMMENT_FILES+"/"+"21"+"/"+streamPath;
			stream.play(streamPathFull);
			// set timer
			timer = new Timer(updateTimeInterval,0);
			timer.addEventListener(TimerEvent.TIMER, updateCurrentTimeAudio);
			timer.start();
			
			/*modePlayingChange = true;
			invalidateProperties();*/
			var playAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.PLAY_AUDIO);
			dispatchEvent(playAudioEvent);
			
		}else if(play)
		{
			record = play = false;
			normal = true;
			// stop playing
			stopPlayAudio();
		}
		else if(record)
		{
			record = play = false;
			normal = true;
		}
	    invalidateSkinState();
	}
	
	private function updateCurrentTimeAudio(event:*=null):void
	{
		currentTimeAudioChange = true;
		invalidateProperties();
		
		currentTimeAudio += updateTimeInterval;
		// notify current time change
		if(timer && timer.running)
		{
			var playingAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.PLAYING_AUDIO);
			playingAudioEvent.currentTimeAudio = currentTimeAudio;
			dispatchEvent(playingAudioEvent);
		}
		
		if(currentTimeAudio >= durationAudio)
		{
			stopPlayAudio();
		}
	}
	
	public function stopPlayAudio(event:*=null):void
	{
		trace("stop playing audio on AudioPlayer");
		if(timer && timer.running)
		{
			timer.stop();
		}
		var stopAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.STOP_PLAY_AUDIO);
		dispatchEvent(stopAudioEvent);
		_stream.close();
		currentTimeAudio = 0;
		//modePlayingChange = true;
		currentTimeAudioChange = true;
		//invalidateProperties();
		initSkinVars();
		normal = true;
		invalidateSkinState();
	}
	private function onClickButtonRecord(event:MouseEvent):void
	{
		if(empty)
		{
			empty = false;
			play = false;
			record = true;
			normal = false;
			// publish stream
			publishStream();
			// start record
			var audioStartRecordEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.RECORD_AUDIO);
			// path the audio file empty, serveur will give new name
			audioStartRecordEvent.pathAudio = null;
			this.dispatchEvent(audioStartRecordEvent);
			
		}else if(normal)
		{
			play = false;
			record = true;
			normal = false;
			publishStream();
			// start record
			var audioStartRecordEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.RECORD_AUDIO);
			audioStartRecordEvent.pathAudio = streamPath;
			this.dispatchEvent(audioStartRecordEvent);
		}else if(record)
		{
			record = play = false;
			normal = true;
			// stop publish stream
			closeStream();
			// FIXME : can do on server side,
			// for this have to stop recording on server side,
			// send notification here,
			// close stream
			/*var audioStopRecordEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.STOP_RECORD_AUDIO);
			this.dispatchEvent(audioStopRecordEvent);*/
		}
		invalidateSkinState();
	}
	private function onCreationComplete(event:FlexEvent):void
	{
		micro = Microphone.getMicrophone();
		micro.rate = 44;
		micro.setSilenceLevel(0);
		
		micro.setUseEchoSuppression(true);
		micro.soundTransform = new SoundTransform(0,0);
		micro.setLoopBack(true);
		
		/*timer = new Timer(100);
		timer.addEventListener(TimerEvent.TIMER, microLevel);
		timer.start();*/
	}
	
	private function microLevel(event:TimerEvent):void {
		/*progressBar.percentWidth = micro.activityLevel;*/
	}
	//_____________________________________________________________________
	//
	//  Utils
	//
	//_____________________________________________________________________
	private function publishStream():void
	{
		// TODO : check _connection, _stream not null
		_stream.attachAudio(micro);
		_stream.publish(streamId);
	}
	private function closeStream():void
	{
		if(_stream)
		{
			_stream.attachAudio(null);
			_stream.close();
		}
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
		normal = record = empty  = play =  false;
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