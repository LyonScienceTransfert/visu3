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
         resivedMessage = !value;
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
      return UtilFunction.getHourMinDate(this._time);
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