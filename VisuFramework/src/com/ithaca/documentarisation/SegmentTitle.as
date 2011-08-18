package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.utils.components.IconDelete;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.controls.Image;
import mx.events.StateChangeEvent;

import spark.components.Label;
import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;

public class SegmentTitle extends SkinnableComponent
{
	[SkinState("edit")]
	[SkinState("normal")]
		
	[SkinPart("true")]
	public var 	labelSegment:Label;
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
	public function SegmentTitle()
	{
		super();
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
		if(instance == labelSegment)
		{
			labelSegment.text = "t";
			labelSegment.setStyle("fontWeight", "normal");
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
			}else
			{
				skinName = "edit";
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
		textSegment.setStyle("fontStyle","normal");
		textSegment.setStyle("backgroundColor", colorBackGround);
		
		textSegment.selectAll();
		
		if(this.stage != null)
		{
			this.stage.focus = textSegment;
		}
		
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
			segment.comment = textSegment.text;
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
		textSegment.text = "ajoutez le texte ici";
		textSegment.setStyle("fontStyle","italic");
		textSegment.setStyle("backgroundColor", _backGroundColorRichEditableText);
	}	
	
	private function setFont(value:Object):void
	{
		var fontValue:String = "normal";
		var textAlign:String = "left";
		var labelText:String = "t";
		if(_fontBold)
		{
			fontValue = "bold";
			textAlign = "center";
			labelText = "T";
		}
		value.setStyle("fontWeight", fontValue);
		value.setStyle("textAlign", textAlign);
		if(labelSegment)
		{
			labelSegment.setStyle("fontWeight", fontValue);
			labelSegment.text = labelText;
		}
	}
}
}