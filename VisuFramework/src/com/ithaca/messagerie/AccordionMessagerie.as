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

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

public class AccordionMessagerie extends SkinnableComponent
{
	[Bindable]
	private var fxgt: _FxGettext = FxGettext;

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
        var userId:int = value.senderVO.id_user;
        // check if message is public
        if(value.resiverVO.id_user == 0)
        {
            userId = 0;
        }
        var navContent:NavigatorContent = accordionMessage.getChildByName(userId.toString()) as NavigatorContent;
        if(navContent)
        {
            var dialogMessageItem:DialogMessageItem = navContent.getElementAt(0) as DialogMessageItem;
            dialogMessageItem.addMessage(value);
        }else
        {
            var arr:ArrayCollection = new ArrayCollection();
            arr.addItem(value);
            var dialog:DialogVO = new DialogVO(new User(value.senderVO), new User(value.resiverVO), "toto", arr);
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
            messageUnwatch = " (" + nbrMessageUnwatch.toString() + " " + fxgt.gettext("non lus") + ")";
        }
        var labelNavContent:String = fxgt.gettext("Les messages publics");
        var nameNavContent:String = "0";
        var dialogMessageItemForUser:User = value.resiver;
        // set label nav content
        if(value.resiver.id_user != 0)
        {
            labelNavContent = VisuUtils.getUserLabelFirstName(value.sender, true);
            nameNavContent = value.sender.id_user.toString();
            dialogMessageItemForUser = value.sender;
        }
        navContent.label =  labelNavContent + messageUnwatch;
            
        navContent.name = nameNavContent
        
        var dialogMessageItem:DialogMessageItem = createDialogMessageItem(value.listMessageVO, dialogMessageItemForUser);
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
