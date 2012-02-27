package com.ithaca.messagerie
{
import com.ithaca.messagerie.model.DialogVO;
import com.ithaca.messagerie.model.MessageVO;
import com.ithaca.messagerie.skins.DialogMessageItemSkin;
import com.ithaca.utils.UtilFunction;
import com.ithaca.utils.VisuUtils;
import com.ithaca.visu.model.User;

import mx.collections.ArrayCollection;
import mx.containers.TabNavigator;

import spark.components.NavigatorContent;
import spark.components.supportClasses.SkinnableComponent;

public class TabNavigatorMessagerie extends SkinnableComponent
{
    [SkinPart("true")]
    public var tabNavigatorMessage:TabNavigator;
    
    private var _listDialog:ArrayCollection;
    private var listDialogChange:Boolean;
    
    public function TabNavigatorMessagerie()
    {
        super();
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
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
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if (instance == tabNavigatorMessage)
        {
            
        }
       
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();	
        if(listDialogChange)
        {
            listDialogChange = false;
            if(tabNavigatorMessage)
            {
                var nbrDialog:int = listDialog.length;
                for(var nDialog:int = 0; nDialog < nbrDialog ; nDialog++)
                {
                    var dialogVO:DialogVO = listDialog.getItemAt(nDialog) as DialogVO;
                    var navContent:NavigatorContent = new NavigatorContent();
                   /* navContent.percentHeight = 100;
                    navContent.percentWidth = 100;*/
                    navContent.label =  VisuUtils.getUserLabelFirstName(dialogVO.sender,  true);
                    var dialogMessageItem:DialogMessageItem = createDialogMessageItem(dialogVO.listMessageVO, dialogVO.sender);
                    navContent.addElement(dialogMessageItem);
                    
                    tabNavigatorMessage.addElement(navContent);
                }
            }
        }	
        
    }
    //_____________________________________________________________________
    //
    // Utils
    //
    //_____________________________________________________________________
    private function createDialogMessageItem(list:ArrayCollection, user:User):DialogMessageItem
    {
        var dialogMessageItem:DialogMessageItem = new DialogMessageItem();
        dialogMessageItem.listMessageVO  = list;
        dialogMessageItem.user  = user;
        dialogMessageItem.height = 300;
        dialogMessageItem.percentWidth = 100;
        dialogMessageItem.setStyle("skinClass", DialogMessageItemSkin); 
        return dialogMessageItem;
    }
}
}