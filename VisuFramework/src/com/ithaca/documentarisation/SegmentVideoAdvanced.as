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
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.documentarisation.skins.SegmentVideoIconMarkerSkin;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.traces.model.TraceModel;
import com.ithaca.utils.UtilFunction;
import com.ithaca.utils.VisuUtils;
import com.ithaca.utils.components.IconDelete;
import com.ithaca.utils.components.SegmentVideoOwnerObselDNDToolTip;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.User;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.visu.ui.utils.IconEnum;
import com.lyon2.controls.utils.TimeUtils;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.Timer;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.collections.ArrayCollection;
import mx.controls.Image;
import mx.events.FlexEvent;
import mx.events.ToolTipEvent;
import mx.managers.CursorManager;
import mx.utils.StringUtil;

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
    // remove screen-shot
	/*[SkinPart("true")]
	public var screenShot:Image;
    */
    [SkinPart("true")]
    public var hgroupDndOwnerObsel:HGroup;
    
    [SkinPart("true")]
    public var iconDndObsel:SegmentVideoIconMarker;
    
    [SkinPart("true")]
    public var labelDndObsel:Label;
    
    [SkinPart("true")]
    public var labelDndObselTempsContent:Label;

    [Bindable]
	private var fxgt: _FxGettext = FxGettext;

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
    // cursor id
    private var _cursorID:int;
	
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
    public function set currentTime(value:Number):void{
        _currentTime = value;
        currentTimeChange = true;
        invalidateProperties();
    };
    public function get currentTime():Number{return _currentTime;};
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
            if(modeEdit)
            {
                // can drag/drop this segment
                iconSegment.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownIconSegment);
                iconSegment.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverIconSegment);
                iconSegment.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutIconSegment);
                var messageDND:String = fxgt.gettext("Glisser-déplacer ce bloc");
                iconSegment.toolTip = messageDND + " " + fxgt.gettext("vidéo");
                // TODO : message "Vous pouver deplace cet block en haut en bas",
                // show this message only if has many blocs
                // MouseCursor = HAND just if has many blocs
            }else
            {
                iconSegment.toolTip = fxgt.gettext("Bloc vidéo");
            }
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
		if(instance == hgroupDndOwnerObsel)
		{
            hgroupDndOwnerObsel.includeInLayout = hgroupDndOwnerObsel.visible = false;
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
            
            // check NaN time
            updateTimeBeginTimeEndBloc();
            
            if(labelDuration)
            {
                var durationMs:Number = _timeEnd - _timeBegin;
                var duration:Number = Math.floor(durationMs / 1000);
                labelDuration.text = TimeUtils.formatTimeString(duration); 
            }
            // check text
            if(!modeEdit && text == "")
            {
                groupText.includeInLayout = groupText.visible = false;
            }
            // show icon and owner obsel ref only if was DND obsel and video bloc
            if(segment.obselRef && (segment.obselRef.type == TraceModel.SET_MARKER || segment.obselRef.type == TraceModel.RECEIVE_MARKER))
            {
                // set skin
                hgroupDndOwnerObsel.includeInLayout = hgroupDndOwnerObsel.visible = true;
                // icon of obsel ref
                iconDndObsel.obsel = segment.obselRef;
                var ownerObsel:User = Model.getInstance().getUserPlateformeByUserId(segment.obselRef.uid); 
                var dateCreateParentObsel:Date = new Date(this._segment.obselRef.begin);
                labelDndObsel.text = StringUtil.substitute(fxgt.gettext("Créé le {0} {1} par {2}"), 
                                                                        TimeUtils.formatDDMMYYYY(dateCreateParentObsel),
                                                                        TimeUtils.formatHHMM(dateCreateParentObsel),
                                                                        VisuUtils.getUserLabelLastName(ownerObsel,true));
                labelDndObselTempsContent.text = segment.obselRef.props[TraceModel.TEXT]; 
                // tooltips 
                hgroupDndOwnerObsel.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, onCreateToopTipHgroupDndOwnerObsel);
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

    private function onCreateToopTipHgroupDndOwnerObsel(event:ToolTipEvent):void
    {
        var toolTip:SegmentVideoOwnerObselDNDToolTip = new SegmentVideoOwnerObselDNDToolTip();
        toolTip.obsel = segment.obselRef;
        toolTip.timeCreateObsel = this._timeBegin;
        event.toolTip = toolTip;
    }
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
		if(richEditableText.text == fxgt.gettext("Cliquer ici pour ajouter du texte"))
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
        fxgt = FxGettext;
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
		richEditableText.text = fxgt.gettext("Cliquer ici pour ajouter du texte");
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
	private function updateTimeBeginTimeEndBloc():void
	{
        // set start time session selected retroDocument
        this._startDateSession = _segment.parentRetroDocument.session.date_start_recording.time;
        
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
    }
}
}
