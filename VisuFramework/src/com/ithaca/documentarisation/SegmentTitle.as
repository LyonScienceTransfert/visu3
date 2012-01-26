package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.components.IconDelete;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.visu.ui.utils.IconEnum;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Image;
import mx.events.FlexEvent;

import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;


public class SegmentTitle extends SkinnableComponent
{
	[SkinState("edit")]
	[SkinState("normal")]

	[SkinPart("true")]
	public var 	iconSegment:Image;
	
	[SkinPart("true")]
	public var 	textSegment:RichEditableText;
	[SkinPart("true")]
	public var 	iconDelete:IconDelete;
	
	private var _text:String ="text init";
	private var _editabled:Boolean = false; 
	private var selected:Boolean = false; 
	private var _fontBold:Boolean  = false;
	private var fontBoldChange:Boolean;
	private var textChange:Boolean;
	
	private var _segment:Segment;
	private var segmentChange:Boolean;
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
    
	public function SegmentTitle()
	{
		super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        // check tracage when block remove from the stage
        this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
        // add tracage mouse over the block
        this.addEventListener(MouseEvent.MOUSE_OVER, traceBlockOver)
	}
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set text(value:String):void
	{
		_text = value;
		textChange = true;
		invalidateProperties();
	}
	public function get text():String
	{
		return _text;
	}
	public function set editabled(value:Boolean):void
	{
		_editabled = value;
		invalidateSkinState();
	}
	public function get editabled():Boolean
	{
		return _editabled;
	}
	public function set fontBold(value:Boolean):void
	{
		_fontBold = value;
		fontBoldChange = true;
		invalidateProperties()
	}
	public function get fontBold():Boolean
	{
		return _fontBold;
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
	
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if(instance == textSegment)
		{
			textSegment.text =text;
			setFont(textSegment);
			if(editabled)
			{
				textSegment.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
				textSegment.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
			}
		}
		if(instance == iconDelete)
		{
			iconDelete.addEventListener(MouseEvent.CLICK, onClickIconDelete);
		}
		
		if (instance == iconSegment)
		{
			// can drag/drop this segment
			iconSegment.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownIconSegment);
			var toolTipText:String = "Bloc texte";
			// TODO : message "Vous pouver deplace cet block en haut en bas",
			// show this message only if has many blocs
			// MouseCursor = HAND just if has many blocs
			var iconName:String ="iconLettre_t_16x16";
			if(_fontBold)
			{
				toolTipText = "Bloc titre";
				iconName = "iconLettre_T_16x16";
			}
			iconSegment.source = IconEnum.getIconByName(iconName);
			iconSegment.toolTip = toolTipText;
		}
	}
	
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(fontBoldChange)
		{
			fontBoldChange = false;
			setFont(textSegment);
		}
		if(textChange)
		{
			textChange = false;
			textSegment.text = text;
		}
		if(segmentChange)
		{
			segmentChange = false;
			_text = segment.comment;
			textSegment.text = text;
			if(textSegment.text == "" && editabled)
			{
				setRichEditText();
			}
			if(segment.typeSource == RetroDocumentConst.TITLE_SEGMENT)
			{
				_fontBold = true;
				setFont(textSegment);
			}
		}
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(editabled)
		{
			if(selected)
			{
				skinName = "editSelected";
                // start tracage timer
                startTracageTimer();
                // tracage selected block
                traceSelectedBlock();
			}else
			{
				skinName = "edit";
                // stop tracage timer
                stopTracageTimer();
			}
		}
		else {
			skinName = "normal"
		}
		
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________
	// richText
	
	public function onFocusInRichEditableText(event:* = null):void
	{	
		
		if(textSegment.text == "Cliquer ici pour ajouter du texte")
		{
			textSegment.text = "";
			if(!_fontBold)
			{
				textSegment.setStyle("textAlign", "left");
			}
		}
		
		textSegment.selectAll();
		
		if(this.stage != null)
		{
			this.stage.focus = textSegment;
		}
		
		textSegment.setStyle("backgroundColor", colorBackGround);
		textSegment.setStyle("fontStyle","normal");
		textSegment.addEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
	}
	public function onFocusOutRichEditableText(event:* = null):void
	{
		textSegment.setStyle("backgroundColor", _backGroundColorRichEditableText);
		if(textSegment.text == "")
		{
			setRichEditText();
		}else
		{
            _text = textSegment.text;
		}
		textSegment.removeEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
	}
	private function onChangeRichEditableText(event:TextOperationEvent):void
	{
		segment.comment = textSegment.text;
		notifyUpdateSegment();
	}
	
	private function onClickIconDelete(event:MouseEvent):void
	{
		var removeSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_REMOVE_SEGMENT);
		removeSegmentEvent.segment = segment;
		this.dispatchEvent(removeSegmentEvent);
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
    private function onRemoveFromStage(event:Event):void
    {
        checkTracage();
        // stop tracage timer
        stopTracageTimer();
    }
    // check tracage modification the segment
    private function checkTracage(event:* = null):void
    {
        trace("check tracage block title/text => "+segment.segmentId);
        // list modifications
        var arr:ArrayCollection = new ArrayCollection();
        var tempString:String;
        // save modifications in format JSON
        var diff:String = "{ ";
        
        // check modifications the comment
        if(_tracedSegment && segment.comment != _tracedSegment.comment)
        {
            tempString = "'"+ RetroDocumentConst.TAG_COMMENT+"': '"+segment.comment+"'";
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
            // tracage modifications the title/text block
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
    /**
     * tracage over block
     */
    private function traceBlockOver(event:MouseEvent):void
    {
        // tracage block audio
        var blockAudioTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK);
        blockAudioTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE;
        blockAudioTracageEvent.exploreType = RetroTraceModel.OVER;
        blockAudioTracageEvent.id = segment.segmentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(blockAudioTracageEvent);
        
        trace("over title block");
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
	public function selectRenderer():void
	{
		selected = true;
		invalidateSkinState();
	}
	public function deselectRenderer():void
	{
		selected = false;
		invalidateSkinState();
	}
	
	public function setRichEditText():void
	{
		textSegment.text = "Cliquer ici pour ajouter du texte";
		textSegment.setStyle("fontStyle","italic");
		textSegment.setStyle("backgroundColor", _backGroundColorRichEditableText);
		if(!_fontBold)
		{
			textSegment.setStyle("textAlign", "right");
		}
	}	
	
	private function setFont(value:Object):void
	{
		var fontValue:String = "normal";
		var textAlign:String = "left";		
		var toolTipText:String = "Bloc texte";
		// TODO : message "Vous pouver deplace cet block en haut en bas",
		// show this message only if has many blocs
		// MouseCursor = HAND just if has many blocs
		var iconName:String = "iconLettre_t_16x16";
		if(_fontBold)
		{
			fontValue = "bold";
			textAlign = "center";
			toolTipText = "Bloc titre";
			iconName = "iconLettre_T_16x16";
		}
		value.setStyle("fontWeight", fontValue);
		value.setStyle("textAlign", textAlign);
		if(iconSegment)
		{
			iconSegment.toolTip = toolTipText;
			iconSegment.source = IconEnum.getIconByName(iconName);
		}		
	}
}
}