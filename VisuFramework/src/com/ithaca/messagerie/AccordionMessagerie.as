package com.ithaca.messagerie
{
import com.ithaca.messagerie.model.DialogVO;
import com.ithaca.messagerie.model.MessageVO;
import com.ithaca.messagerie.skins.DialogMessageItemSkin;
import com.ithaca.utils.VisuUtils;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.UserVO;

import mx.collections.ArrayCollection;
import mx.containers.Accordion;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

import spark.components.Group;
import spark.components.NavigatorContent;
import spark.components.VScrollBar;
import spark.components.supportClasses.SkinnableComponent;


public class AccordionMessagerie extends SkinnableComponent
{

    [SkinPart("true")]
    public var accordionMessage:Accordion;
    
    private var _listDialog:ArrayCollection = new ArrayCollection();
    private var listDialogChange:Boolean;
    
    private var  _widthMessagerie:int = 400;
    private var widthMessagerieChange:Boolean;
    
    private var  _heightMessagerie:int = 400;
    private var heightMessagerieChange:Boolean;
    
    // have to get really height
    private var HEIGHT_LABEL_NAVIGATOR_CONTENT:int = 21;
    
    // logged user
    private var _loggedUser:User;
    
    public function AccordionMessagerie()
    {
        super();
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function set loggedUser(value:User):void
    {
        _loggedUser = value;
    }
    public function get loggedUser():User
    {
        return _loggedUser;
    }
    
    public function set widthMessagerie(value:int):void
    {
        _widthMessagerie = value;
        widthMessagerieChange = true;
        invalidateProperties();
    }
    public function get widthMessagerie():int
    {
        return _widthMessagerie;
    }
    public function set heightMessagerie(value:int):void
    {
        _heightMessagerie = value;
        heightMessagerieChange = true;
        invalidateProperties();
    }
    public function get heightMessagerie():int
    {
        return _heightMessagerie;
    }
    
    public function set listDialog(value:ArrayCollection):void
    {
        _listDialog = value;
        listDialogChange = true;
        invalidateProperties();
    }
    public function get listDialog():ArrayCollection
    {
        return _listDialog;
    }
    
    public function set listMessage(value:ArrayCollection):void
    {
        for each (var message:MessageVO in value)
        {
            addMessage(message);
        }
    }
    public function addMessage(value:MessageVO):void
    {
        var userId:int = value.userVO.id_user;
        var navContent:NavigatorContent = accordionMessage.getChildByName(userId.toString()) as NavigatorContent;
        if(navContent)
        {
            var dialogMessageItem:DialogMessageItem = navContent.getElementAt(0) as DialogMessageItem;
            dialogMessageItem.addMessage(value);
        }else
        {
            var arr:ArrayCollection = new ArrayCollection();
            arr.addItem(value);
            var dialog:DialogVO = new DialogVO(new User(value.userVO), "toto", arr);
            listDialog.addItem(dialog);
            addNavContent(dialog);
            // resize dialogMessageItem
            resizeAllDialogMessageItem();
        }
        
    }
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if (instance == accordionMessage)
        {
           /* accordionMessage.width = widthMessagerie;
            accordionMessage.height = heightMessagerie;*/
            accordionMessage.addEventListener(IndexChangedEvent.CHANGE, onChangeIndexAccordion);
        }
        
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();	
        if(listDialogChange)
        {
            listDialogChange = false;
            if(accordionMessage)
            {
                
                var nbrDialog:int = listDialog.length;
                for(var nDialog:int = 0; nDialog < nbrDialog ; nDialog++)
                {
                    var dialogVO:DialogVO = listDialog.getItemAt(nDialog) as DialogVO;
                    addNavContent(dialogVO);
                }
            }
        }
        
        if(heightMessagerieChange)
        {
            heightMessagerieChange = false;
            if(accordionMessage)
            {
                accordionMessage.height = heightMessagerie;
            }
        }
        
        if(widthMessagerieChange)
        {
            widthMessagerieChange = false;
            if(accordionMessage)
            {
                accordionMessage.width = widthMessagerie;
            }
        }
        
    }
    //_____________________________________________________________________
    //
    // Listeners
    //
    //_____________________________________________________________________
    private function onChangeIndexAccordion(event:IndexChangedEvent):void
    {
        var navContent:NavigatorContent = event.relatedObject as NavigatorContent;
        var dialogMessageItem:DialogMessageItem = navContent.getElementAt(0) as DialogMessageItem;
        // set messages watche
        setMessageWatch(dialogMessageItem.listMessageVO);
        navContent.label = navContent.label.split("(")[0];
        
    }

    //_____________________________________________________________________
    //
    // Utils
    //
    //_____________________________________________________________________
    
    private function setMessageWatch(value:ArrayCollection):void
    {
        for each(var messageVO:MessageVO in value)
        {
            if(!messageVO.isWatch)
            {
                messageVO.isWatch = true;
            }
        }
    }
    private function checkMessageUnwatch(value:ArrayCollection):int
    {
        var result:int = 0;
        for each(var messageVO:MessageVO in value)
        {
            if(!messageVO.isWatch)
            {
                result++;
            }
        }
        return result;
    }
    
    private function addNavContent(value:DialogVO):void
    {
        var navContent:NavigatorContent = new NavigatorContent();
        var nbrMessageUnwatch:int = checkMessageUnwatch(value.listMessageVO);
        
        var messageUnwatch:String = "";
        if (nbrMessageUnwatch > 0)
        {
            messageUnwatch = " ("+nbrMessageUnwatch.toString()+" non lu)";
        }
        // set label nav content
        navContent.label =  VisuUtils.getUserLabelFirstName(value.user, true) + messageUnwatch;
            
        navContent.name = value.user.id_user.toString();
        
        var dialogMessageItem:DialogMessageItem = createDialogMessageItem(value.listMessageVO, value.user);
        navContent.addElement(dialogMessageItem);
        
        navContent.addEventListener(FlexEvent.ADD, onAddedNavContent);
        accordionMessage.addElement(navContent);
    }
    
    /**
    * navigator content adde on the stage
    */
    private function onAddedNavContent(event:FlexEvent):void
    {
        var navContent:NavigatorContent = event.currentTarget as NavigatorContent;
        setHeightDialogMessage(navContent);
    }
    private function setHeightDialogMessage(value:NavigatorContent):void
    {
        var dialogMessageItem:DialogMessageItem = value.getElementAt(0) as DialogMessageItem;
        // set height of the dialog message item
        dialogMessageItem.heightDialogMessage = this.height - listDialog.length*HEIGHT_LABEL_NAVIGATOR_CONTENT;
    }
    
    private function createDialogMessageItem(list:ArrayCollection, user:User):DialogMessageItem
    {
        var dialogMessageItem:DialogMessageItem = new DialogMessageItem();
        dialogMessageItem.listMessageVO  = list;
        dialogMessageItem.user  = user;
        dialogMessageItem.loggedUser  = loggedUser;
        dialogMessageItem.percentWidth = 100;
        dialogMessageItem.setStyle("skinClass", DialogMessageItemSkin); 
        return dialogMessageItem;
    }
    /**
    * update height the dialogMessageItem
    */
    private function resizeAllDialogMessageItem():void
    {
        for each(var navContent:NavigatorContent in accordionMessage.getChildren())
        {
            setHeightDialogMessage(navContent);
        }
    }
}
}