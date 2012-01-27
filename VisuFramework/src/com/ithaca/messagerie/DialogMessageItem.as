package com.ithaca.messagerie
{
import com.ithaca.messagerie.model.MessageVO;
import com.ithaca.messagerie.renderer.MessageItemRenderer;
import com.ithaca.messagerie.skins.MessageItemSkin;
import com.ithaca.visu.model.User;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.core.ClassFactory;

import spark.components.Group;
import spark.components.Label;
import spark.components.List;
import spark.components.Scroller;
import spark.components.VGroup;
import spark.components.supportClasses.SkinnableComponent;

public class DialogMessageItem extends SkinnableComponent
{
    
    [SkinPart("true")]
    public var listMessage:List;
    
    [SkinPart("true")]
    public var groupMessageItem:Group;
    
    [SkinPart("true")]
    public var scrollerPanelDialogMessage:Scroller;
    
    [SkinPart("true")]
    public var roleUser:Label;
    
    [SkinPart("true")]
    public var firstName:Label;
    
    [SkinPart("true")]
    public var lastName:Label;
    
    private var _listMessage:ArrayCollection;
    private var listMessageChange:Boolean;
    
    private var _user:User;
    private var userChange:Boolean;
    
    public function DialogMessageItem()
    {
        super();
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
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
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if (instance == groupMessageItem)
        {
            if(false)
            {
                var nbrItem:int = listMessageVO.length;
                for(var nItem:int = 0; nItem < nbrItem; nItem++)
                {
                    var item:MessageVO = listMessageVO.getItemAt(nItem) as MessageVO;
                    var messageItem:MessageItem = new MessageItem();
                    messageItem.message = item.text;
                    messageItem.time =item.date;
                    messageItem.messageFromMy = item.isLoggedUserMessage;
                    messageItem.setStyle("skinClass", MessageItemSkin);
                    messageItem.percentWidth = 100;
                    groupMessageItem.addElement(messageItem);
                }
                
            }
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
                    var messageItem:MessageItem = new MessageItem();
                    messageItem.message = item.text;
                    messageItem.time =item.date;
                    messageItem.messageFromMy = item.isLoggedUserMessage;
                    messageItem.setStyle("skinClass", MessageItemSkin);
                    messageItem.percentWidth = 100;
                    groupMessageItem.addElement(messageItem);
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
    }
    //_____________________________________________________________________
    //
    // Listeners
    //
    //_____________________________________________________________________
    private function onRenderListMessage(event:Event):void
    {
        var objToRender:Object = event;
        return;
    }
    
}
}