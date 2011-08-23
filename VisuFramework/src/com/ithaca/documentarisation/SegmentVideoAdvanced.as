package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.Segment;
import com.ithaca.utils.components.IconDelete;

import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.controls.Image;

import spark.components.Label;
import spark.components.RichEditableText;
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
	public var labelCurrentTime:Label;
	[SkinPart("true")]
	public var labelDuration:Label;
	
	[SkinPart("true")]
	public var richEditableText:RichEditableText;

	private var shared:Boolean = false;
	private var sharedOver:Boolean = false;
	private var sharedPlay:Boolean = false;
	private var sharedPause:Boolean = false;
	private var edit:Boolean = false;
	private var editOver:Boolean = false;
	private var editSelected:Boolean = false;
	private var editPlay:Boolean = false;
	private var editPause:Boolean = false;
	
	private var _modeEdit:Boolean = true;
	
	private var _text:String ="";
	private var textChange:Boolean;
	
	private var _segment:Segment;
	private var segmentChange:Boolean;
	
	// init backGroundColor
	private var _backGroundColorRichEditableText:String = "#FFFFFF";
	// selected backgroundColor
	private var colorBackGround:String = "#FFEBCC";
	
	public function SegmentVideoAdvanced()
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
			}
			if(modeEdit)
			{
				richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
				richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
			}
		}
		if (instance == iconSegment)
		{
			// can drag/drop this segment
			iconSegment.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownIconSegment);
			iconSegment.toolTip = "Bloc vidéo + texte";
			// TODO : message "Vous pouver deplace cet block en haut en bas",
			// show this message only if has many blocs
			// MouseCursor = HAND just if has many blocs
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
			}
			if(modeEdit)
			{
				richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
				richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
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
		}else if(editOver)
		{
			skinName = "editOver";
		}else if(editSelected)
		{
			skinName = "editSelected";
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

	private function onClickImagePlay(event:MouseEvent):void
	{
		initSkinVars();
		if(modeEdit)
		{
			editPlay = true;
		}else
		{
			sharedPlay = true;
		}
		invalidateSkinState();
	}
	private function onClickImagePause(event:MouseEvent):void
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
	}
	private function onClickImageJumpStart(event:MouseEvent):void
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
	}
	private function onClickIconDelete(event:MouseEvent):void
	{
		var removeSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_REMOVE_SEGMENT);
		removeSegmentEvent.segment = segment;
		this.dispatchEvent(removeSegmentEvent);
	}
	// richText
	private function onFocusInRichEditableText(event:FocusEvent):void
	{		
		if(richEditableText.text == "Cliquer ici pour ajouter du text")
		{
			richEditableText.text = "";
			richEditableText.setStyle("fontStyle","normal");
			richEditableText.setStyle("color","#000000");
		}
		richEditableText.selectAll();
		if(this.stage != null)
		{
			this.stage.focus = richEditableText;
		}
		richEditableText.addEventListener(TextOperationEvent.CHANGE, onChangeRichEditableText);
		richEditableText.setStyle("backgroundColor", colorBackGround);
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
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);

	}
	private function onChangeRichEditableText(event:TextOperationEvent):void
	{
		segment.comment = richEditableText.text;
		notifyUpdateSegment();
	}
	
	private function onMouseDownIconSegment(event:MouseEvent):void
	{
		var mouseDownIconSegment:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.READY_TO_DRAG_DROP_SEGMENT);
		dispatchEvent(mouseDownIconSegment);
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
	
	private function setRichEditText():void
	{
		richEditableText.text = "Cliquer ici pour ajouter du text";
		richEditableText.setStyle("fontStyle","italic");
		var colorText:String = "#000000";
		richEditableText.setStyle("color", colorText);
		richEditableText.setStyle("backgroundColor", _backGroundColorRichEditableText);
	}
	
	private function initSkinVars():void
	{
		shared = sharedOver = sharedPlay = sharedPause = edit = editOver = editSelected = editPlay = editPause = false;
	}
}
}