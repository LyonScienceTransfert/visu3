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
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.internationalisation.InternationalisationEvent;
import com.ithaca.internationalisation.InternationalisationEventDispatcherFactory;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.components.IconDelete;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.visu.ui.utils.IconEnum;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.Timer;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.collections.ArrayCollection;
import mx.controls.Image;
import mx.events.FlexEvent;
import mx.managers.CursorManager;

import spark.components.HGroup;
import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;
import spark.primitives.Line;

public class SegmentCommentAudio extends SkinnableComponent
{
	[Bindable]
	private var fxgt: _FxGettext = FxGettext;

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
    
	[SkinPart("true")]
	public var lineBottom:Line;

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
    // cursor id
    private var _cursorID:int;
    // mockup
    private var _bilanModule:Object
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
			trace("Error when seting connection")
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
        if(audioRecorder)
        {
    		audioRecorder.skinNormal();
        }
		invalidateSkinState();
	}
	public function rendererOver():void
	{
		if(modeEdit)
		{
            if(audioRecorder)
            {
    			audioRecorder.skinOver();
            }
			initSkinVars();
			editOver = true;
			invalidateSkinState();
		}else
		{
            if(audioRecorder)
            {
    			audioRecorder.skinOverShare();
            }
			initSkinVars();
			editOver = false;
			invalidateSkinState();
		}
	}
	public function rendererSelected():void
	{
		if(modeEdit)
		{
            if(audioRecorder)
            {
    			audioRecorder.skinOver();
            }
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
        
        // init internalisation
        fxgt = FxGettext;
        
        this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        // check tracage when block remove from the stage
        this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
        // set change language listener
        InternationalisationEventDispatcherFactory.getEventDispatcher().addEventListener(InternationalisationEvent.CHANGE_LANGUAGE, onChangeLanguage);
        // set bilanModule 
        //_bilanModule = Model.getInstance().getCurrentBilanModule();
        _bilanModule = new Object();
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
			iconDelete.toolTip = fxgt.gettext("Suprimer ce bloc");	
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
            if(modeEdit)
            {
                // can drag/drop this segment
                iconSegment.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownIconSegment);
                iconSegment.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverIconSegment);
                iconSegment.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutIconSegment);
                var messageDND:String = fxgt.gettext("Glisser-déplacer ce bloc");
                iconSegment.toolTip = messageDND+ " "  + fxgt.gettext("audio");
                // TODO : message "Vous pouver deplace cet block en haut en bas",
                // show this message only if has many blocs
                // MouseCursor = HAND just if has many blocs
            }else
            {
                iconSegment.toolTip = fxgt.gettext("Bloc audio");
            }
            
            if(_bilanModule == null)
            {
                iconSegment.includeInLayout = iconSegment.visible = false;
            }
        }
        if(instance == groupAudioRecorder)
        {
            if(_bilanModule == null)
            {
                groupAudioRecorder.paddingLeft = 10;      
            }
        }
        if(instance == lineBottom)
        {
            if(_bilanModule == null)
            {
                lineBottom.includeInLayout = lineBottom.visible = false;
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

                // set segment id for tracage audioRecorder
                audioRecorder.parentSegmentId = segment.segmentId;
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
            // tracage over block
            traceBlockOver();
		}else if(selected)
		{
			skinName = "editSelected"
            // start tracage timer
            startTracageTimer();
            // tracage selected block
            traceSelectedBlock();
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
//		if(richEditableText.text == fxgt.gettext("Cliquer ici pour enregistrer un commentaire"))
		if(segment.comment == "")
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
        CursorManager.removeCursor(_cursorID);
        _cursorID = CursorManager.setCursor(IconEnum.getIconByName('hand_close'));
		var mouseDownIconSegment:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.READY_TO_DRAG_DROP_SEGMENT);
		dispatchEvent(mouseDownIconSegment);
	}
    private function onMouseOverIconSegment(event:MouseEvent):void
    {
        _cursorID = CursorManager.setCursor(IconEnum.getIconByName('hand_open'));
    }
    private function onMouseOutIconSegment(event:MouseEvent):void
    {
        CursorManager.removeCursor(_cursorID);
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
    /**
    * check tracage modification the segment
    */
    private function checkTracage(event:* = null):void
    {
        trace("check tracage block audio => "+segment.segmentId);
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
            // check modification the duration audio
            if(segment.durationCommentAudio != _tracedSegment.durationCommentAudio)
            {
                tempString = "'"+ RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO+"': "+segment.durationCommentAudio.toString();
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
    /**
     * Change language listener
     */
    private function onChangeLanguage(even:InternationalisationEvent):void
    {
        // update prompt richEditableText
        if( segment.comment == "")
        {
            richEditableText.text = fxgt.gettext("Cliquer ici pour enregistrer un commentaire");
        }
        // update toolTips icon delete
        if(iconDelete)
        {
            iconDelete.toolTip = fxgt.gettext("Suprimer ce bloc");	
        }
        // update toolTips bloc icon 
        if(modeEdit)
        {
            var messageDND:String = fxgt.gettext("Glisser-déplacer ce bloc");
            iconSegment.toolTip = messageDND+ " "  + fxgt.gettext("audio");
        }else
        {
            iconSegment.toolTip = fxgt.gettext("Bloc audio");
        }
    }

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
		richEditableText.text = fxgt.gettext("Cliquer ici pour enregistrer un commentaire");
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
