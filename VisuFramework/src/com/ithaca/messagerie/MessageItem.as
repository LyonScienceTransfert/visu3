package com.ithaca.messagerie
{


import com.ithaca.utils.UtilFunction;

import flash.events.Event;

import mx.controls.TextArea;
import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.Group;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class MessageItem extends SkinnableComponent
{
    [SkinPart("true")]
    public var textMessage:TextArea;
    [SkinPart("true")]
    public var timeMessage:Label;
    [SkinPart("true")]
    public var groupItem:Group;
    
    private var _message:String;
    private var messageChange:Boolean;
    
    private var _time:Date;
    private var timeChange:Boolean;

    private var resivedMessage:Boolean;
    
    public function MessageItem()
    {
        super();
       
    }
    
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function set message(value:String):void
    {
        _message = value;
        messageChange = true;
        invalidateProperties();
    }
    public function get message():String
    {
        return _message;
    }
    public function set time(value:Date):void
    {
        _time = value;
        timeChange = true;
        invalidateProperties();
    }
    public function get time():Date
    {
        return _time;
    }
    
    public function set messageFromMy(value:Boolean):void
     {
         resivedMessage = value;
         invalidateSkinState();
     }
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if (instance == textMessage)
        {
            textMessage.addEventListener(FlexEvent.UPDATE_COMPLETE, onAddedOnStage)
            textMessage.text = message;
        }
        if (instance == timeMessage)
        {
            timeMessage.text = getTime();
        }
    }

    override protected function commitProperties():void
    {
        super.commitProperties();	
        if(messageChange)
        {
            messageChange = false;
            if(textMessage)
            {
                textMessage.text = message;
            }
        }	
        if(timeChange)
        {
            timeChange = false;
            
            if(timeMessage)
            {
                timeMessage.text = getTime();
            }
        }	
    }
    override protected function getCurrentSkinState():String
    {
        var skinName:String;
        if(!enabled)
        {
            skinName = "myMessage";
        }else if(resivedMessage)
        {
            skinName = "otherMessage";
        }
        return skinName;
    }
    //_____________________________________________________________________
    //
    // Utils
    //
    //_____________________________________________________________________
    private function getTime():String
    {
      return UtilFunction.getHeurMinDate(this._time);
    }
    private function onAddedOnStage(event:FlexEvent):void
    {
        var textMessage:TextArea = event.currentTarget as TextArea;
        var nLines:uint = textMessage.mx_internal::getTextField().numLines;
        textMessage.height = nLines*20;
        groupItem.height = nLines*20;
    }
}
}