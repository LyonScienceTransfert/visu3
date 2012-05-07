/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
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
        return textMarker.text;
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

       // clear text input
       textMarker.text = "";
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