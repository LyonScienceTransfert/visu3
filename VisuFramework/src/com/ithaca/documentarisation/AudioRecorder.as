/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.AudioRecorderEvent;
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.traces.model.TraceModel;
import com.ithaca.utils.VisuUtils;
import com.ithaca.utils.components.IconButton;
import com.ithaca.visu.events.VideoPanelEvent;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.User;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.lyon2.controls.VideoComponent;
import com.lyon2.controls.utils.TimeUtils;

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
	private static var logger:ILogger = Log.getLogger("com.ithaca.documentarisation.AudioRecorder");
	
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
	private var _modeShare:Boolean;
    // parent segment id
    private var _parentSegmentId:String;
	
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
	public function set parentSegmentId(value:String):void
	{
        _parentSegmentId = value;
	}
	public function get parentSegmentId():String
	{
		return _parentSegmentId;
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
	public function set modeShare(value:Boolean):void
	{
		_modeShare = value;
	}
	public function get modeShare():Boolean
	{
		return _modeShare;
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
		_modeShare = true;
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
		// dispatche that click on butoon play
		var playSegmentAudioEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PLAY_RETRO_SEGMENT);
		dispatchEvent(playSegmentAudioEvent);
        
        // tracage play audio block
        var audioRecorderTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        audioRecorderTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        audioRecorderTracageEvent.exploreType = RetroTraceModel.LISTEN_BLOCK_AUDIO;
        audioRecorderTracageEvent.id = parentSegmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(audioRecorderTracageEvent);
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
        
        // tracage play audio block
        var audioRecorderTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        audioRecorderTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        audioRecorderTracageEvent.exploreType = RetroTraceModel.STOP_BLOCK_AUDIO;
        audioRecorderTracageEvent.id = parentSegmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(audioRecorderTracageEvent);
		
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
        
        // tracage play audio block
        var audioRecorderTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        audioRecorderTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        audioRecorderTracageEvent.exploreType = RetroTraceModel.RECORD_BLOCK_AUDIO;
        audioRecorderTracageEvent.id = parentSegmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(audioRecorderTracageEvent);
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
			if(_modeShare)
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
		if(!_modeShare)
		{
			micro = Microphone.getMicrophone();
			micro.rate = 44;
			micro.setSilenceLevel(0);
			
			micro.setUseEchoSuppression(true);
			micro.soundTransform = new SoundTransform(0,0);
			micro.setLoopBack(true);
		}
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
		
		return TimeUtils.formatTimeString(seconds);
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