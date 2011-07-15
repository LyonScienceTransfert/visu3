package com.ithaca.documentarisation
{
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.Image;

import spark.components.Label;
import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;

public class SegmentVideoAdvanced extends SkinnableComponent
{
	
	/*<s:states>
		<s:State name="normal" />
		<s:State name="normalOver" />
		<s:State name="edit"/>
		<s:State name="editPlay"/>
		<s:State name="editPaused"/>
		<s:State name="shared"/>
	</s:states>*/
		
	[SkinPart("true")]
	public var imageEdit:Image;
	[SkinPart("true")]
	public var imagePlay:Image;
	[SkinPart("true")]
	public var imageDelete:Image;
	
	[SkinPart("true")]
	public var labelSave:Label;
	[SkinPart("true")]
	public var buttonSave:Button;
	
	[SkinPart("true")]
	public var labelCurrentTime:Label;
	[SkinPart("true")]
	public var labelDuration:Label;
	
	[SkinPart("true")]
	public var buttonStop:Button;
	[SkinPart("true")]
	public var buttonPlay:Button;
	[SkinPart("true")]
	public var buttonPause:Button;
	
	[SkinPart("true")]
	public var richEditableText:RichEditableText;
	
	private var edit:Boolean = false;
	private var editPlay:Boolean = false;
	private var editPause:Boolean = false;
	
	private var _text:String ="";
	private var textChange:Boolean;
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
	
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == imageEdit)
		{
			imageEdit.addEventListener(MouseEvent.CLICK, onClickImageEdit);	
		}
		if (instance == imagePlay)
		{
			imagePlay.addEventListener(MouseEvent.CLICK, onClickImagePlay);	
		}
		if (instance == imageDelete)
		{
			imageDelete.addEventListener(MouseEvent.CLICK, onClickImageDelete);	
		}
		if (instance == buttonSave)
		{
			buttonSave.addEventListener(MouseEvent.CLICK, onClickButtonSave);	
		}
		if (instance == buttonPlay)
		{
			buttonPlay.addEventListener(MouseEvent.CLICK, onClickButtonPlay);	
		}
		if (instance == buttonStop)
		{
			buttonStop.addEventListener(MouseEvent.CLICK, onClickButtonStop);	
		}
		if (instance == buttonPause)
		{
			buttonPause.addEventListener(MouseEvent.CLICK, onClickButtonPause);	
		}
		if (instance == richEditableText)
		{
			// set text message
			if(text == "")
			{
				setRichEditText();
			}else
			{
				richEditableText.text = text;
			}
			richEditableText.addEventListener(FocusEvent.FOCUS_IN, onFocusInRichEditableText);
			richEditableText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRichEditableText);
		}
		
	}
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		
	}
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(true)
		{
		}
		
		
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(edit)
		{
			skinName = "edit";
		}else if(editPlay)
		{
			skinName = "editPlay";
		}else if(editPause)
		{
			skinName = "editPaused";
		}
		
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	// images
	private function onClickImageEdit(event:*=null):void
	{
		edit = true;
		invalidateSkinState();
	}
	private function onClickImagePlay(event:MouseEvent):void
	{
		edit = false;
		editPlay = true;
		invalidateSkinState();
	}
	private function onClickImageDelete(event:MouseEvent):void
	{
		return;
	}
	private function onClickButtonSave(event:MouseEvent):void
	{
		return;
	}
	// buttons
	private function onClickButtonPlay(event:MouseEvent):void
	{
		edit = false;
		editPlay = true;
		editPause = false;
		invalidateSkinState();
	}
	private function onClickButtonStop(event:MouseEvent):void
	{
		edit = true;
		editPlay = false;
		editPause = false;
		invalidateSkinState();
	}
	private function onClickButtonPause(event:MouseEvent):void
	{
		edit = false;
		editPlay = false;
		editPause = true;
		invalidateSkinState();
	}
	// richText
	private function onFocusInRichEditableText(event:FocusEvent):void
	{
		// change skin to "edit"
		onClickImageEdit();
		
		if(richEditableText.text == "ajoutez une nouvelle commentaire ici")
		{
			richEditableText.text = "";
			richEditableText.setStyle("fontStyle","normal");
			richEditableText.setStyle("color","#000000");
		}
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
	}
	
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________
	
	private function setRichEditText():void
	{
		richEditableText.text = "ajoutez une nouvelle commentaire ici";
		richEditableText.setStyle("fontStyle","italic");
		var colorText:String = "#000000";
/*		if(edit)
		{
			colorText = "#000000";
		}*/
		richEditableText.setStyle("color", colorText);
	}
	
}
}