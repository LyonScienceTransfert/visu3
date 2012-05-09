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
import com.ithaca.messagerie.model.MessageVO;
import com.ithaca.messagerie.skins.MessageItemSkin;
import com.ithaca.utils.UtilFunction;
import com.ithaca.visu.events.SessionSharedEvent;
import com.ithaca.visu.model.ActivityElementType;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.UserVO;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import gnu.as3.gettext._FxGettext;

import mx.collections.ArrayCollection;
import mx.controls.Button;

import spark.components.Group;
import spark.components.Label;
import spark.components.List;
import spark.components.Scroller;
import spark.components.TextArea;
import spark.components.VGroup;
import spark.components.supportClasses.SkinnableComponent;

public class DialogMessageItem extends SkinnableComponent
{
    
    [SkinPart("true")]
    public var listMessage:List;
    
    [SkinPart("true")]
    public var groupMessageItem:Group;

    [SkinPart("true")]
    public var groupDialogMessage:VGroup;
    
    [SkinPart("true")]
    public var groupDialogInfo:VGroup;
    
    [SkinPart("true")]
    public var scrollerPanelDialogMessage:Scroller;
    
    [SkinPart("true")]
    public var roleUser:Label;
    
    [SkinPart("true")]
    public var firstName:Label;
    
    [SkinPart("true")]
    public var lastName:Label;
    
    [SkinPart("true")]
    public var textChatMessage:TextArea;

    [SkinPart("true")]
    public var buttonChatMessage:Button;    
    
    private var _listMessage:ArrayCollection;
    private var listMessageChange:Boolean;
    
    private var _user:User;
    private var userChange:Boolean;
    
    private var _heightDialogMessage:int;
    private var heightDialogMessageChange:Boolean;
    
    private var _loggedUser:User;
    
    
    public function DialogMessageItem()
    {
        super();
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function set heightDialogMessage(value:int):void
    {
        _heightDialogMessage = value;
        heightDialogMessageChange = true;
        invalidateProperties();
    }
    public function get heightDialogMessage():int
    {
        return _heightDialogMessage;
    }
    public function set listMessageVO(value:ArrayCollection):void
    {
        _listMessage = value;
        listMessageChange = true;
        invalidateProperties();
    }
    public function get listMessageVO():ArrayCollection
    {
        return _listMessage;
    }
    public function set user(value:User):void
    {
        _user = value;
        userChange = true;
        invalidateProperties();
    }
    public function get user():User
    {
        return _user;
    }
    public function set loggedUser(value:User):void
    {
        _loggedUser = value;
    }
    public function get loggedUser():User
    {
        return _loggedUser;
    }
    
    public function addMessage(value:MessageVO):void
    {
  //      listMessageVO.addItem(value);
        // add item message 
        addItemMessage(value);
    }
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        
        if( instance == textChatMessage)
        {
            textChatMessage.addEventListener(KeyboardEvent.KEY_UP, onSendMessage);
        }
        if( instance == buttonChatMessage)
        {
            buttonChatMessage.addEventListener(MouseEvent.CLICK, onSendMessage);
        }
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();	
        if(listMessageChange)
        {
            listMessageChange = false;
            if(groupMessageItem)
            {
                var nbrItem:int = listMessageVO.length;
                for(var nItem:int = 0; nItem < nbrItem; nItem++)
                {
                    var item:MessageVO = listMessageVO.getItemAt(nItem) as MessageVO;
                    // add item message 
                    addItemMessage(item);
                }
            }
        }	
        if(userChange)
        {
            userChange = false;
            if(user.id_user == 0)
            {
                groupDialogInfo.includeInLayout = groupDialogInfo.visible = false;
            }else
            {
                firstName.text = user.firstname;
                lastName.text = user.lastname;
                roleUser.text = "...";
            }
            
        }
        if(heightDialogMessageChange)
        {
            heightDialogMessageChange= false;
            groupDialogMessage.height = heightDialogMessage;
            groupDialogMessage.percentWidth = 100;
        }
    }
    //_____________________________________________________________________
    //
    // Listeners
    //
    //_____________________________________________________________________
    private function addItemMessage(item:MessageVO):void
    {
        var messageItem:MessageItem = new MessageItem();
        messageItem.message = item.text;
        messageItem.time =item.date;
        var messageFromMy:Boolean = false;
        if(item.senderVO.id_user == this.loggedUser.id_user )
        {
            messageFromMy = true;
        }
        messageItem.messageFromMy = messageFromMy;
        messageItem.setStyle("skinClass", MessageItemSkin);
        messageItem.percentWidth = 100;
        groupMessageItem.addElement(messageItem);
    }
    /**
     * Checking that sending the message by click on button or click by "enter"
     */
    protected function onSendMessage(event:*):void
    {
        var message:String = textChatMessage.text;
        message = message.split("\n").join("");
        message = message.split("\r").join("");
        if(event is MouseEvent){
            sendMessage(message);
        }else if (event is KeyboardEvent) 
        {
            if(event.keyCode == Keyboard.ENTER)
            {
                sendMessage(message);
            }
        }
    }
    
    /**
     * Sending message
     */
    private function sendMessage(message:String):void
    {
        var idUserFor:int = _user.id_user;
        var listUsersId:Array = new Array();
        var sessionSharedEvent:SessionSharedEvent = new SessionSharedEvent(SessionSharedEvent.SEND_SHARED_INFO);
        /*var sessionId:int = this.currentSession.id_session;
        if (this.visio.status == VisuVisioAdvanced.STATUS_NONE)
        {
            // all connected users
            listUsersId = Model.getInstance().getListUsersIdByConnectedSession(sessionId);
            sessionSharedEvent.status = -1;	
        }else
        {
            // send message to all recording users
            if(idUserFor == 0)
            {
                listUsersId = Model.getInstance().getListUsersIdByRecordingSession(sessionId);
            }else
            {
                // send message to one user, message private
                listUsersId.push(idUserFor);
            }
            sessionSharedEvent.status = this.visio.status;
        }*/
        
        sessionSharedEvent.typeInfo = ActivityElementType.valueOf(ActivityElementType.MESSAGE);
        
        // check if message empty
        if(UtilFunction.isEmptyMessage(message))
        {
            // don't send empty message
            return;
        }
        sessionSharedEvent.info = message;
        sessionSharedEvent.listUsers = listUsersId;
        sessionSharedEvent.idUserFor = idUserFor;
        dispatchEvent(sessionSharedEvent);
        
        // add message VO;
        var messageVO:MessageVO = new MessageVO(message, new Date(), loggedUser as UserVO, user as UserVO, true);
//        listMessageVO.addItem(messageVO);
        // add item message 
        addItemMessage(messageVO);
        
        // empty text message
        textChatMessage.text = "";
    }   

    
}
}