package com.ithaca.visu.controls
{
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.EventPhase;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import spark.components.Label;
import spark.components.TextInput;
import spark.events.TextOperationEvent;


[SkinState("normal")]
[SkinState("prompt")]
[SkinState("disabled")]

/**
 *  The alpha of the focus ring for this component.
 */
[Style(name="promptColor", type="uint", format="Color", inherit="yes", theme="spark")]

public class AdvancedTextInput extends TextInput
{
	
	[Bindable] public var prompt:String=""; 
	
	
	[SkinPart("false")]
	public var clearIcon:InteractiveObject;
	
	[SkinPart("false")]
	public var _promptDisplay:Label;
	
	protected var showPrompt:Boolean=true;
	
	public function AdvancedTextInput()
	{
		super();
	}
	
	//-----------------------------------------------------------
	// 
	// Overridden Methods
	// 
	//-----------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == textDisplay)
		{
			textDisplay.addEventListener(FocusEvent.FOCUS_IN, textDisplay_focusInHandler);
			textDisplay.addEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler);
			textDisplay.addEventListener(TextOperationEvent.CHANGE, textDisplay_changeHandler);
		}
		if (instance == clearIcon )
		{
			clearIcon.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);	
		}
		if (instance == _promptDisplay)
		{
			if (prompt.length > 0) 
				_promptDisplay.text = prompt;
		}
	}
	
	/**
	 * @private
	 */
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		if (instance == textDisplay)
		{
			textDisplay.removeEventListener(FocusEvent.FOCUS_IN, textDisplay_focusInHandler);
			textDisplay.removeEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler);
			textDisplay.removeEventListener(TextOperationEvent.CHANGE, textDisplay_changeHandler);
		}
		if (instance == clearIcon )
		{
			clearIcon.removeEventListener(MouseEvent.CLICK, clearButton_clickHandler);	
		}
	}
	
	/**
	 * @private
	 */
	override protected function createChildren():void
	{
		super.createChildren();
	}
	
	/**
	 * @private
	 */
	override protected function getCurrentSkinState():String
	{
		return !enabled? "disabled" : 
				showPrompt ? "prompt" : "normal";
	}
	//-----------------------------------------------------------
	// 
	// Event handlers
	// 
	//-----------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function textDisplay_focusInHandler(event:FocusEvent):void
	{
		if( _promptDisplay && prompt.length > 0 )
		{
			showPrompt = false;
			invalidateSkinState();
		}
	}
	
	/**
	 * @private
	 */
	protected function textDisplay_focusOutHandler(event:FocusEvent):void
	{
		if( _promptDisplay && prompt.length > 0 
			&& text.length==0)
		{
			showPrompt = true;
			invalidateSkinState();
		}
		
	}
	
	/**
	 * @private
	 */
	protected function textDisplay_changeHandler(event:TextOperationEvent):void
	{
		showPrompt = text.length == 0;
		invalidateSkinState();
	}
	
	/**
	 * @private
	 */
	protected function clearButton_clickHandler(event:MouseEvent):void
	{
		clear();
	}
	
	
	//-----------------------------------------------------------
	// 
	// Methods
	// 
	//-----------------------------------------------------------
	/**
	 * Clear the inputText
	 */
	public function clear(keepFocus:Boolean=false):void
	{
		
		textDisplay.text = "";
		showPrompt = keepFocus;
		invalidateSkinState();
	}
}
}