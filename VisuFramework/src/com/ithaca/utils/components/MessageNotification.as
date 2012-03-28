package com.ithaca.utils.components
{
import com.ithaca.visu.model.Notification;

import flash.events.MouseEvent;

import mx.controls.Image;
import mx.events.CloseEvent;

import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class MessageNotification extends SkinnableComponent
{
    [SkinPart("true")]
    public var icon:Image
    
    [SkinPart("true")]
    public var buttonClose:IconDelete;
    
    [SkinPart("true")]
    public var titreNotification:Label;
    
    [SkinPart("true")]
    public var message:Label;
    
    private var _notification:Notification;
    private var notificationChange:Boolean;
    
    private var mouseOver:Boolean = false;
    
    public function MessageNotification()
    {
        super();
        this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverNotificator)
        this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutNotificator)
    }
    
    public function set notification(value:Notification):void
    {
        this._notification = value;
        notificationChange = true;
        this.invalidateProperties();
    }
    public function get notification():Notification
    {
        return this._notification;
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if(instance == icon)
        {
            if(notification)
            {
                icon.source = notification.sourceIcon;
            }
        }
        if(instance == titreNotification)
        {
            if(notification)
            {
                titreNotification.text = notification.titreNotification;
            }
        }
        if(instance == message)
        {
            if(notification)
            {
                message.text = notification.message;
            }
        }
        if(instance == buttonClose)
        {
            buttonClose.addEventListener(MouseEvent.CLICK, onClickButtonCloseNotification);
        }
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();
        if(notificationChange)
        {
            notificationChange = false;
            if(icon)
            {
                icon.source = notification.sourceIcon; 
            }
            if(titreNotification)
            {
                titreNotification.text = notification.titreNotification;
            }
            if(message)
            {
                message.text = notification.message;
            }
        }
    }
    
    /**
    * Handler close notification view
    */
    private function onClickButtonCloseNotification(event:MouseEvent):void
    {
        var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
        dispatchEvent(closeEvent);
    }
    /**
    * Handler mouse over notificator
    */
    private function onMouseOverNotificator(event:MouseEvent):void
    {
        mouseOver = true;
        invalidateSkinState();
    }
    /**
    * Handler mouse out notificator
    */
    private function onMouseOutNotificator(event:MouseEvent):void
    {
        mouseOver = false;
        invalidateSkinState();
    }
    
    override protected function getCurrentSkinState():String
    {
        var skinName:String;
        if(mouseOver)
        {
            skinName = "hovered";
        }else
        {
            skinName = "normal";
        }
        return skinName;
    }
}
}