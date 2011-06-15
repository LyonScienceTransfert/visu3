package com.ithaca.visu.view.video
{
import com.ithaca.utils.VisuUtils;
import com.ithaca.visu.events.PanelEditInfoEvent;
import com.ithaca.visu.model.User;

import flash.events.MouseEvent;

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
				nameUser.text = VisuUtils.getUserLabel(user, true);	
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
				nameUser.text = VisuUtils.getUserLabel(user, true);	
			}
		}
	}
	
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________
	
	private function onClickButtonOk(event:MouseEvent):void
	{
		var clickButtonOkEvent:PanelEditInfoEvent = new PanelEditInfoEvent(PanelEditInfoEvent.CLICK_BUTTON_OK);
		clickButtonOkEvent.user = user;
		// TODO : remove text "marker ici"
		clickButtonOkEvent.text = textInfo.text;
		this.dispatchEvent(clickButtonOkEvent);
	}
	
	private function onClickButtonCancel(event:MouseEvent):void
	{
		var clickButtonCancelEvent:PanelEditInfoEvent = new PanelEditInfoEvent(PanelEditInfoEvent.CLICK_BUTTON_CANCEL);
		this.dispatchEvent(clickButtonCancelEvent);
	}
}
}