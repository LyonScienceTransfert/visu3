package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.model.Segment;

import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.controls.Image;

import spark.components.Label;
import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;

public class SegmentTitle extends SkinnableComponent
{
	[SkinState("edit")]
	[SkinState("normal")]
	
	/*[SkinPart("true")]
	public var 	labelSegment:Label;*/
	
	[SkinPart("true")]
	public var 	textSegment:RichEditableText;
	[SkinPart("true")]
	public var 	imageDrag:Image;
	[SkinPart("true")]
	public var 	imageDelete:Image;
	
	private var _text:String ="text init";
	private var _editabled:Boolean = false; 
	private var _fontBold:Boolean  = false;
	private var fontBoldChange:Boolean;
	private var textChange:Boolean;
	
	private var _segment:Segment;
	private var segmentChange:Boolean;
	
	
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
/*		addListenerLabelSegment();*/
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
/*		if(instance == labelSegment)
		{
			labelSegment.text =text;
			setFont(labelSegment);
			addListenerLabelSegment();
		}*/
		if(instance == textSegment)
		{
			textSegment.text =text;
			setFont(textSegment);
			textSegment.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
			textSegment.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
		}
		if(instance == imageDelete)
		{
			imageDelete.addEventListener(MouseEvent.CLICK, onClickImageDelete);
		}
		if(instance == imageDrag)
		{
			imageDrag.addEventListener(MouseEvent.MOUSE_DOWN, onMouseImageDrag);
		}
	}
	
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(fontBoldChange)
		{
			fontBoldChange = false;
/*			setFont(labelSegment);*/
			setFont(textSegment);
		}
		if(textChange)
		{
			textChange = false;
			/*labelSegment.text = text;*/
			textSegment.text = text;
		}
		if(segmentChange)
		{
			segmentChange = false;
			_text = segment.comment;
		/*	labelSegment.text = text;*/
			textSegment.text = text;
			if(textSegment.text == "")
			{
				setRichEditText();
			}
			if(segment.typeSource == "TitleSegment")
			{
				_fontBold = true;
			/*	setFont(labelSegment);*/
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
			skinName = "edit";
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
	
/*	private function onClickLabelSegment(event:MouseEvent):void
	{
		labelSegment.includeInLayout = labelSegment.visible = false;
		textSegment.includeInLayout = textSegment.visible = true;
		textSegment.selectAll();
		// FIXME : hasn't focus if too segment selected
		textSegment.text = text;
		if(this.stage != null)
		{
			this.stage.focus = textSegment;
		}
		textSegment.addEventListener(FocusEvent.FOCUS_OUT, onTextSegmentFocusOut);
	}*/
/*	private function onTextSegmentFocusOut(event:FocusEvent):void
	{
		textSegment.removeEventListener(FocusEvent.FOCUS_OUT, onTextSegmentFocusOut);
		text = textSegment.text;
		
		textSegment.includeInLayout = textSegment.visible = false;
		labelSegment.includeInLayout = labelSegment.visible = true;
		
		// TODO Update RetroDocument 
		segment.comment = text;
	}*/
	// richText
	private function onFocusInRichEditableText(event:FocusEvent):void
	{	
		if(textSegment.text == "ajoutez le texte ici")
		{
			textSegment.text = "";
			textSegment.setStyle("fontStyle","normal");
			textSegment.setStyle("color","#000000");
		}else
		{
			textSegment.selectAll();
			// FIXME : hasn't focus if too segment selected
			if(this.stage != null)
			{
				this.stage.focus = textSegment;
			}
		}
		textSegment.addEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
	}
	private function onFocusOutRichEditableText(event:FocusEvent):void
	{
		if(textSegment.text == "")
		{
			setRichEditText();
		}else
		{
			segment.comment = textSegment.text;
		}
	}
	private function onChangeRichEditableText(event:TextOperationEvent):void
	{
		segment.comment = textSegment.text;
	}
	
	private function onClickImageDelete(event:MouseEvent):void
	{
		return;
	}
	
	private function onMouseImageDrag(event:MouseEvent):void
	{
		return;
	}
	
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________
	
	private function setRichEditText():void
	{
		textSegment.text = "ajoutez le texte ici";
		textSegment.setStyle("fontStyle","italic");
		var colorText:String = "#000000";
		textSegment.setStyle("color", colorText);
	}	
	
	private function setFont(value:Object):void
	{
		var fontValue:String = "normal";
		var textAlign:String = "left";
		if(_fontBold)
		{
			fontValue = "bold";
			textAlign = "center";
		}
		value.setStyle("fontWeight", fontValue);
		value.setStyle("textAlign", textAlign);
	}
	
	/*private function addListenerLabelSegment():void
	{
		if(editabled && labelSegment)
		{
			labelSegment.addEventListener(MouseEvent.CLICK, onClickLabelSegment);
		}
	}*/
}
}