package com.ithaca.visu.controls
{
import com.ithaca.visu.events.MarkerEvent;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.controls.Button;
import mx.controls.TextArea;
import mx.events.EffectEvent;

import spark.components.supportClasses.SkinnableComponent;
import spark.effects.Fade;

[Event(name="sendMarker",type="com.ithaca.visu.events.MarkerEvent")]
[Event(name="startAnimationSendMarker",type="com.ithaca.visu.events.MarkerEvent")]
[Event(name="stopAnimationSendMarker",type="com.ithaca.visu.events.MarkerEvent")]

public class SendMarkerAnimation extends SkinnableComponent
{
    private var showMarker:Boolean;
    
    
    [SkinPart("true")]
    public var markerAnimation:TextArea;
    [SkinPart("true")]
    public var textMarker:TextArea;
    [SkinPart("true")]
    public var buttonSendMarker:Button;
    
    [SkinPart("true")]
    public var fadeStartAnimation:Fade;
    [SkinPart("true")]
    public var fadeEndAnimation:Fade;
    
    private var _textMarkerAnimation:String;
    private var textMarkerAnimationChange:Boolean;
    private var _text:String;
    private var textChange:Boolean;
    private var _textMarkerAnimationColor:String;
    private var textMarkerAnimationColorChange:Boolean;
    private var _enabled:Boolean;
    private var enabledChange:Boolean;
    
    
    public function get textMarkerAnimation():String
    {
        return _textMarkerAnimation;
    }
    public function set textMarkerAnimation(value:String):void
    {
        _textMarkerAnimation = value;
        textMarkerAnimationChange = true;
        invalidateProperties();
    }
    public function get text():String
    {
        return _text;
    }
    public function set text(value:String):void
    {
        _text = value;
        textChange = true;
        invalidateProperties();
    }
    public function get textMarkerAnimationColor():String
    {
        return _textMarkerAnimationColor;
    }
    public function set textMarkerAnimationColor(value:String):void
    {
        _textMarkerAnimationColor = value;
        textMarkerAnimationColorChange = true;
        invalidateProperties();
    }
    override public function set enabled(value:Boolean):void
    {
        _enabled = value;
        enabledChange = true;
        invalidateProperties();
    }
    override public function get enabled():Boolean
    {
        return _enabled;
    }
    
    
    public function SendMarkerAnimation()
    {
        super();
    }
    
    public function goAnimation():void
    {
        
        showMarker = true;
        this.invalidateSkinState();
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if(instance == markerAnimation)
        {
            markerAnimation.text = textMarkerAnimation;
        }
        if(instance == textMarker)
        {
            textMarker.addEventListener(KeyboardEvent.KEY_UP, onSendMarker);
            textMarker.enabled = enabled;
            textMarker.text = text;
        }
        if(instance == buttonSendMarker)
        {
            buttonSendMarker.addEventListener(MouseEvent.CLICK, onSendMarker);
            buttonSendMarker.enabled = enabled;
        }
        if(instance == fadeStartAnimation)
        {
            fadeStartAnimation.addEventListener(EffectEvent.EFFECT_START, onStartAnimation);
        }
        if(instance == fadeEndAnimation)
        {
            fadeEndAnimation.addEventListener(EffectEvent.EFFECT_END, onEndAnimation);
        }
    }
    override protected function commitProperties():void
    {
        super.commitProperties();
        if(textMarkerAnimationChange)
        {
            textMarkerAnimationChange = false;
            if(markerAnimation)
            {
                markerAnimation.text = textMarkerAnimation;
            }
        }
        if(textMarkerAnimationColorChange)
        {
            textMarkerAnimationColorChange = false;
            if(markerAnimation)
            {
                markerAnimation.setStyle("contentBackgroundColor", textMarkerAnimationColor);
            }
        }
        if(enabledChange)
        {
            enabledChange = false;
            if(textMarker)
            {
                textMarker.enabled = enabled;
            }
            buttonSendMarker.enabled = enabled;
        }
        if(textChange)
        {
            textChange = false;
            if(textMarker)
            {
                textMarker.text = text;
            }
        }
        
    }
    override protected function getCurrentSkinState():String
    {
        var skinName:String = "normal";
        if (showMarker)
        {
            skinName = "showMarker";
        }
        return skinName;
    }
    ///////////////
    ////// Listeners
    //////////////
    private function onSendMarker(event:*):void
    {
        var message:String = textMarker.text; 
        if(event is MouseEvent){
            sendMarker(message);
        }else if (event is KeyboardEvent) 
        {
            if(event.keyCode == Keyboard.ENTER)
            {
                sendMarker(message);
            }
        }
    }
    
    private function onStartAnimation(event:EffectEvent):void
    {
       var startAnimationEvent:MarkerEvent = new MarkerEvent(MarkerEvent.START_ANIMATION_SEND_MARKER);
       dispatchEvent(startAnimationEvent);
    }
    private function onEndAnimation(event:EffectEvent):void
    {
       var stopAnimationEvent:MarkerEvent = new MarkerEvent(MarkerEvent.STOP_ANIMATION_SEND_MARKER);
       dispatchEvent(stopAnimationEvent);
    }
    ///////////////
    ////// Utils
    //////////////
    private function sendMarker(value:String):void
    {
        var message:String = value.replace("\n", "").replace("\r", "");
        var sendMarkerEvent:MarkerEvent = new MarkerEvent(MarkerEvent.SEND_MARKER);
        sendMarkerEvent.text = message;
        dispatchEvent(sendMarkerEvent);
        
        textMarker.text = "";
    }
}
}