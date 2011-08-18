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
import mx.controls.Image;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.logging.ILogger;
import mx.logging.Log;

import spark.components.HSlider;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.Rect;

public class AudioRecorder extends SkinnableComponent
{
	private static var logger:ILogger = Log.getLogger("com.ithaca.documentarisation.SegmentVideo");
	
/*	[SkinPart("true")]
	public var progressBar:Rect;*/
	
	[SkinPart("true")]
	public var buttonPlay:Button;
	[SkinPart("true")]
	public var buttonRecord:Button;
	[SkinPart("true")]
	public var imagePlay:Image;
	[SkinPart("true")]
	public var imageStop:Image;
	[SkinPart("true")]
	public var imageRecord:Image;
	
	[SkinPart("true")]
	public var labelCurrnetTime:Label;
	[SkinPart("true")]
	public var lableDuration:Label;
	[SkinPart("true")]
	public var currentTimeAudionSlider:HSlider;
	
	private var empty:Boolean = false;
	private var play:Boolean = false;
	private var record:Boolean = false;
	private var normal:Boolean = false;
	private var normalEmpty:Boolean = false;
	private var overEmpty:Boolean = false;
	private var over:Boolean = false;
	private var overShare:Boolean = false;
	private var overShareEmpty:Boolean = false;
	
	// net Stream
	private var _stream:NetStream;
	// publish parameters
	private var _streamId:String;
	// path audio file
	private var _streamPath:String;
	// user id
	private var _userId:String;
	private var micro:Microphone;
	private var timer:Timer;
	
	// max duration recording audio, ms
	private var MAXIMUM_DURATION_AUDIO:int = 60*1000;
	// duration audio file in ms
	private var _durationAudio:int = 0;
	private var durationAudioChange:Boolean;
	// current time audion in ms
	private var _currentTimeAudio:int = 0;
	private var currentTimeAudioChange:Boolean;
	// update time interval in ms
	private var _updateTimeInterval:int;
	private var mouseOver:Boolean;
	private var modeShare:Boolean;
	
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
		initSimpleSkinVars();
		_durationAudio = value;
		if(_durationAudio > 0)
		{
			normal = true;
		}else
		{
			normalEmpty = true;
		}
		invalidateSkinState();
		
		addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCurrentStateChange);
	}
	private function onCurrentStateChange(event:StateChangeEvent):void
	{
		removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCurrentStateChange);
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
		_userId = value;
	}
	public function get userId():String
	{
		return _userId;
	}
	// init skin states
	public function skinNormal():void
	{
		initSimpleSkinVars();
		mouseOver = false;
		// do nothing if play or record
		if(!(play || record))
		{
			if(durationAudio > 0)
			{
				normal = true;
			}else
			{
				normalEmpty = true;
			}
			invalidateSkinState();
		}
	}
	
	public function skinOver():void
	{
		initSimpleSkinVars();
		mouseOver = true;
		// do nothing if play or record
		if(!(play || record))
		{
			if(durationAudio > 0)
			{
				over = true;
			}else
			{
				overEmpty = true;
			}
			invalidateSkinState();
		}
	}
	public function skinOverShare():void
	{
		initSimpleSkinVars();
		mouseOver = true;
		modeShare = true;
		// do nothing if play or record
		if(!play)
		{
			if(durationAudio > 0)
			{
				overShare = true;
			}else
			{
				overShareEmpty= true;
			}
			invalidateSkinState();
		}
	}
	
	public function skinPlaying():void
	{
		initSkinVars();
		play = true;
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
		if(instance == lableDuration)
		{
			lableDuration.text = getTimeInMinSec(durationAudio-currentTimeAudio);
		}
		if(instance == labelCurrnetTime)
		{
			labelCurrnetTime.text =  getTimeInMinSec(currentTimeAudio);
		}
		if(instance == currentTimeAudionSlider)
		{
			currentTimeAudionSlider.minimum =  0;
			currentTimeAudionSlider.maximum =  durationAudio;
			currentTimeAudionSlider.value = currentTimeAudio;
		}
		
		if(instance == imagePlay)
		{
			imagePlay.addEventListener(MouseEvent.CLICK, onClickImagePlay);
		}
		if(instance == imageStop)
		{
			imageStop.addEventListener(MouseEvent.CLICK, onClickImageStop);
		}
		if(instance == imageRecord)
		{
			imageRecord.addEventListener(MouseEvent.CLICK, onClickImageRecord);
		}
	}
	
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(durationAudioChange)
		{
			durationAudioChange = false;
			if(lableDuration)
			{
				lableDuration.text = getTimeInMinSec(durationAudio-currentTimeAudio);
			}
			if(currentTimeAudionSlider)
			{
				currentTimeAudionSlider.maximum =  durationAudio;
			}
		}
		
		if(currentTimeAudioChange)
		{
			currentTimeAudioChange = false;
			if(labelCurrnetTime)
			{
				labelCurrnetTime.text = getTimeInMinSec(currentTimeAudio);
			}
			if(currentTimeAudionSlider)
			{
				currentTimeAudionSlider.value = currentTimeAudio;
			}
		}
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(play)
		{
			skinName = "play";
		}
		else if(record)
		{
			skinName = "record";
		}
		else if(empty)
		{
			skinName = "empty";
		}
		else if(normalEmpty)
		{
			skinName = "normalEmpty";
		}
		else if(overEmpty)
		{
			skinName = "overEmpty";
		}
		else if(over)
		{
			skinName = "over";
		}
		else if(overShare)
		{
			skinName = "overShare";
		}
		else if(overShareEmpty)
		{
			skinName = "overShareEmpty";
		}
		else
		{
			skinName = "normal"
		}
		trace("skinName = ", skinName);
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	private function onClickImagePlay(even:*=null):void
	{
		stream.client = this;
		// TODO if i partage avec qq
		var streamPathFull:String = VisuUtils.FOLDER_AUDIO_COMMENT_FILES+"/"+userId.toString()+"/"+streamPath;
		stream.play(streamPathFull);
		// set timer
		timer = new Timer(updateTimeInterval,0);
		timer.addEventListener(TimerEvent.TIMER, updateCurrentTimeAudio);
		timer.start();
		initSimpleSkinVars();
		// TODO modeEdit
		play = true;
		invalidateSkinState();
		
	}
	private function onClickImageStop(even:*=null):void
	{
		if(record)
		{
			// stop publish stream
			closeStream();
			
			_durationAudio = currentTimeAudio;
		}
		stopPlayAudio();
		
	}
	private function onClickImageRecord(even:*=null):void
	{
		stopPlayAudio();
		initSimpleSkinVars();
		record = true;
		invalidateSkinState();
		
		publishStream();
		
		// start record
		var audioStartRecordEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.RECORD_AUDIO);
		var nameFileWithoutExtention:String = ""; 
		if(durationAudio > 0)
		{
			nameFileWithoutExtention = streamPath.split(".")[0];
		}else
		{
			// generate file name audio
			var date:Date = new Date();
			nameFileWithoutExtention = "audio-"+date.time.toString()+'-'+userId;
			streamPath = nameFileWithoutExtention+".flv";
			//  dispatchEvent update streamPath
			var updatePathCommentAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.UPDATE_PATH_COMMENT_AUDIO);
			updatePathCommentAudioEvent.pathAudio = streamPath;
			this.dispatchEvent(updatePathCommentAudioEvent);
		}
		
		audioStartRecordEvent.pathAudio = nameFileWithoutExtention;
		this.dispatchEvent(audioStartRecordEvent);
		
		_durationAudio = MAXIMUM_DURATION_AUDIO;
		durationAudioChange = true;
		
		// set timer
		timer = new Timer(updateTimeInterval,0);
		timer.addEventListener(TimerEvent.TIMER, updateRecordTimeAudio);
		timer.start();
		
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
	
	private function updateRecordTimeAudio(event:*=null):void
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
		
		if(currentTimeAudio >= MAXIMUM_DURATION_AUDIO)
		{
			_durationAudio = MAXIMUM_DURATION_AUDIO;
			stopPlayAudio();
		}
	}
	
	
	
	public function stopPlayAudio(event:*=null):void
	{
		trace("stop playing audio on AudioPlayer");
		if(timer && timer.running)
		{
			timer.stop();
			_stream.close();
		}
		initSimpleSkinVars();
		
		currentTimeAudio = 0;
		currentTimeAudioChange = true;
		
		if(mouseOver)
		{
			if(modeShare)
			{
				overShare = true;
			}else
			{
				over = true;
			}
			
		}else
		{
			normal = true;
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
	private function initSimpleSkinVars():void
	
	{
		if(play || record)
		{
			if(record)
			{
				// stop publish stream
				closeStream();
				_durationAudio = currentTimeAudio;
				durationAudioChange = true;
				invalidateProperties();
				// dispatch
				var updateDurationCommentAudioEvent:AudioRecorderEvent = new AudioRecorderEvent(AudioRecorderEvent.UPDATE_DURATION_COMMENT_AUDIO);
				updateDurationCommentAudioEvent.durationTimeAudio = _durationAudio;
				this.dispatchEvent(updateDurationCommentAudioEvent);
			}
			
			record  = play =  false;
			// stop audion if listen
			stopPlayAudio();
		}
		normalEmpty = normal = overEmpty = over = record  = play = overShare = overShareEmpty =   false;
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