package com.ithaca.visu.view.video
{
import com.ithaca.utils.VisuUtils;
import com.ithaca.visu.events.PanelEditInfoEvent;
import com.ithaca.visu.model.User;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.controls.Image;

import spark.components.Button;
import spark.components.Label;
import spark.components.TextArea;
import spark.components.supportClasses.SkinnableComponent;

public class PanelEditChatMessage extends SkinnableComponent
{
	
	[SkinPart("true")]
	public var imageUser:Image;
	[SkinPart("true")]
	public var textInfo:TextArea;
	[SkinPart("true")]
	public var nameUser:Label;
	[SkinPart("true")]
	public var buttonOk:Button;
	[SkinPart("true")]
	public var buttonCancel:Button;
	
	private var _user:User;
	private var userChange:Boolean;
	
	public function PanelEditChatMessage()
	{
		super();
	}
	
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	
	public function set user(value:User):void
	{
		_user = value;
		userChange = true;
		invalidateProperties();
	}
	public function get user():User
	{
		return this._user;
	}
	
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == imageUser)
		{
			if(user != null)
			{
				imageUser.source = user.avatar;
			}
		}
		if (instance == nameUser)
		{
			if(user != null)
			{
				nameUser.text = VisuUtils.getUserLabelLastName(user, true);	
			}
		}
		if (instance == buttonOk)
		{
			buttonOk.addEventListener(MouseEvent.CLICK, onClickButtonOk);
		}
		if (instance == buttonCancel)
		{
			buttonCancel.addEventListener(MouseEvent.CLICK, onClickButtonCancel);
		}
		if (instance == textInfo)
		{
			textInfo.addEventListener(KeyboardEvent.KEY_UP, onClickButtonOk)
		}
		
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(userChange)
		{
			userChange = false;
			if(imageUser != null)
			{
				imageUser.source = user.avatar;
			}
			if(nameUser != null)
			{
				nameUser.text = VisuUtils.getUserLabelLastName(user, true);	
			}
		}
	}
	
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________
	
	private function onClickButtonOk(event:*):void
	{
		var infoText:String = textInfo.text;
		if(event is MouseEvent){
			setMyInfo(false, infoText);
		}else if (event is KeyboardEvent) 
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				setMyInfo(true, infoText);
			}
		}
		
	}
	
	private function setMyInfo(cutLastCharMessage:Boolean, message:String):void
	{
		// cut last char if was click on button "Enter"
		if(cutLastCharMessage)
		{
			message = message.slice(0, message.length-1);
		}
		
		var clickButtonOkEvent:PanelEditInfoEvent = new PanelEditInfoEvent(PanelEditInfoEvent.CLICK_BUTTON_OK);
		clickButtonOkEvent.user = user;
		clickButtonOkEvent.text = message;
		this.dispatchEvent(clickButtonOkEvent);
	}

		
	
	private function onClickButtonCancel(event:MouseEvent):void
	{
		var clickButtonCancelEvent:PanelEditInfoEvent = new PanelEditInfoEvent(PanelEditInfoEvent.CLICK_BUTTON_CANCEL);
		this.dispatchEvent(clickButtonCancelEvent);
	}
}
}