package com.ithaca.messagerie
{
import com.ithaca.messagerie.model.MessageVO;
import com.ithaca.messagerie.skins.MessageItemSkin;
import com.ithaca.utils.UtilFunction;
import com.ithaca.visu.events.SessionSharedEvent;
import com.ithaca.visu.model.ActivityElementType;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.User;

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
    
    public function addMessage(value:MessageVO):void
    {
        listMessageVO.addItem(value);
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
            firstName.text = user.firstname;
            lastName.text = user.lastname;
            roleUser.text = "...";
            
        }
        if(heightDialogMessageChange)
        {
            heightDialogMessageChange= false;
            groupDialogMessage.height = heightDialogMessage;
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
        messageItem.messageFromMy = item.isLoggedUserMessage;
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
        var messageVO:MessageVO = new MessageVO(message, new Date(), true);
        listMessageVO.addItem(messageVO);
        // add item message 
        addItemMessage(messageVO);
        
        // empty text message
        textChatMessage.text = "";
    }   

    
}
}