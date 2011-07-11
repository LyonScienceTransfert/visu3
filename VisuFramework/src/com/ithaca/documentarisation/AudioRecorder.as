package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.AudioRecorderEvent;
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

import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.Rect;

public class AudioRecorder extends SkinnableComponent
{
	private static var logger:ILogger = Log.getLogger("com.ithaca.documentarisation.SegmentVideo");
	
	[SkinState("empty")]
	[SkinState("normal")]
	[SkinState("recording")]
	[SkinState("playing")]
	
	[SkinPart("true")]
	public var progressBar:Rect;
	
	[SkinPart("true")]
	public var buttonPlay:Button;
	[SkinPart("true")]
	public var buttonRecord:Button;
	
	private var empty:Boolean = true;
	private var play:Boolean = false;
	private var record:Boolean = false;
	private var normal:Boolean = false;
	
	// net Stream
	private var _stream:NetStream;
	//Publish parameters
	private var _streamId:String;
	private var _connection:NetConnection;
	
	private var micro:Microphone;
	private var timer:Timer;
	
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
	public function set connection(value:NetConnection):void
	{
		if(value != null)
		{
			_connection = value;
			_stream = new NetStream(_connection);
		}
	}
	public function get connection():NetConnection
	{
		return _connection;
	}
	public function set streamId(value:String):void
	{
		_streamId = value;
	}
	public function get streamId():String
	{
		return _streamId;
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
	}
	
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		
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

	private function onClickButtonPlay(event:MouseEvent):void
	{
		if(normal)
		{
			record = false;
			play = true;
			normal = false;
		}else if(play)
		{
			record = play = false;
			normal = true;
		}
		else if(record)
		{
			record = play = false;
			normal = true;
		}
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
			audioStartRecordEvent.pathAudio = null;
			this.dispatchEvent(audioStartRecordEvent);
			
		}else if(normal)
		{
			play = false;
			record = true;
			normal = false;
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
		
		timer = new Timer(100);
		timer.addEventListener(TimerEvent.TIMER, microLevel);
		timer.start();
	}
	
	private function microLevel(event:TimerEvent):void {
		progressBar.percentWidth = micro.activityLevel;
	}
	//_____________________________________________________________________
	//
	// 
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
}
}