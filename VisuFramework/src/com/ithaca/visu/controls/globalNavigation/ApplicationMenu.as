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
package com.ithaca.visu.controls.globalNavigation
{
	import com.ithaca.messagerie.MessagerieWindow;
	import com.ithaca.utils.VisuToolTip;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.User;
	
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.LinkButton;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.ButtonBar;
	import spark.components.DropDownList;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.ToggleButton;
	import spark.events.IndexChangeEvent;
	
	[SkinState(name="normal")]
	[SkinState(name="authentified")]
	[SkinState(name="disabled")]
	
	[Event(name="navigate", type="com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent")]
	[Event(name="disconnect", type="com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent")]
	[Event(name="chat", type="com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent")]
	
	public class ApplicationMenu extends SkinnableContainer
	{
		[SkinPart("true")]
		public var disconnect:LinkButton;
		
		[SkinPart("false")]
		public var chat:Button;

		[SkinPart("true")]
		public var language:Label;
		
		[SkinPart("true")]
		public var dropListLang:DropDownList;
		
		[SkinPart("true")]
		public var logo:Label;
		
		[SkinPart("true")]
		public var labelLoggedUser:Label;

		[SkinPart("true")]
		public var buttonHomeModule:Button;
		[SkinPart("true")]
		public var buttonUserModule:Button;
		[SkinPart("true")]
		public var buttonSessionModule:Button;
		[SkinPart("true")]
		public var buttonProfilModule:Button;
		[SkinPart("true")]
		public var buttonBilanModule:Button;
		[SkinPart("true")]
		public var buttonTutoratModule:Button;
		[SkinPart("true")]
		public var buttonRetrospectionModule:Button;
		

		public var listLang:ArrayCollection = new ArrayCollection()
		public var listLabelModule:Array = new Array();
		
		/**
		 * @private 
		 */
		private var _listModulesButton:Array = new Array();
		private var buttonBarModules:ButtonBar = new ButtonBar();
		/*private var buttonBarTutoratSynchrone:ButtonBar = new ButtonBar();
		*/
		private var buttonSalonTutorat:ToggleButton = new ToggleButton();
		private var buttonSalonRetro:ToggleButton = new ToggleButton();
		private var buttonSalonBilan:ToggleButton = new ToggleButton();
		private var buttonSalonRetroState:Boolean;
		private var buttonSalonTutoratState:Boolean;
		private var buttonsModule:ArrayCollection = new ArrayCollection();
		//private var buttonsModuleTutoratSynchrone:ArrayCollection = new ArrayCollection();
		// initial module
		private var _initModule:String;
		private var initModuleChange:Boolean;
		
		public function get listModulesButton():Array
		{
			// FIXME : TODO : change the algo update the labes of the modules
			return 	_listModulesButton;
		}
		/**
		 * @private 
		 * handle the state of the 
		 * application menu (authentified / not authentified)
		 */
		public var _authentified:Boolean
		
		/**
		 * @private
		 */
		public function get authentified():Boolean
		{
			return _authentified;
		}
		
		public function set authentified(value:Boolean):void
		{
			_authentified = value; 
			invalidateSkinState();  
		}
		
		/**
		 * @private
		 * handle modules list
		 */
		private var moduleListChanged:Boolean;
		
		private var _moduleList:Array;		
		
		/**
		 * @private
		 */
		public function get moduleList():Array
		{
			return _moduleList;
		} 
		
		public function set moduleList(value:Array):void
		{
			_moduleList = value;
			moduleListChanged = true;
			invalidateProperties();
		}

		public function set initModule(value:String):void
		{
			_initModule = value;
			initModuleChange = true;
			invalidateProperties();
		}
		public function get initModule():String
		{
			return  _initModule;
		}
		 
		
		public function ApplicationMenu()
		{
			super();
		}
		
		
		
		/*----------------------------------------
					Overriden methods
		-----------------------------------------*/
		/**
		 * 
		 * @private 
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == disconnect)
			{
				disconnect.addEventListener(MouseEvent.CLICK, onDisconnect);
			}
			if (instance == dropListLang)
			{
				dropListLang.addEventListener(IndexChangeEvent.CHANGE, onChangeLange);
				// set enabled lang
                // disactivate for Unidistance
				dropListLang.enabled = true;
			}
			if (instance == contentGroup)
			{
				if (moduleListChanged) 
				{
					moduleListChanged = false;			
					addModuleButton();
				}
			}
			if (instance == logo)
			{
				logo.toolTip = ".";
				logo.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, onCreateToolTipVisu);
				logo.addEventListener(MouseEvent.CLICK, onClickLogo);
			}
			
			if (instance == labelLoggedUser)
			{
				var user:User = Model.getInstance().getLoggedUser();
				var nameUser:String = VisuUtils.getUserLabelLastName(user,true);
				labelLoggedUser.text = nameUser;
			}
            
			if (instance == chat)
			{
				chat.addEventListener(MouseEvent.CLICK, onClickButtonChat);
			}
			if (instance == buttonHomeModule)
			{
				buttonHomeModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}
			if (instance == buttonUserModule)
			{
				buttonUserModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}		
			if (instance == buttonSessionModule)
			{
				buttonSessionModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}
			if (instance == buttonProfilModule)
			{
				buttonProfilModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}
			if (instance == buttonBilanModule)
			{
				buttonBilanModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}
			if (instance == buttonTutoratModule)
			{
				buttonTutoratModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}
			if (instance == buttonRetrospectionModule)
			{
				buttonRetrospectionModule.addEventListener(MouseEvent.CLICK, onClickButtonModule);
			}
		}
		
		/**
		 * 
		 * @private 
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == disconnect)
			{
				disconnect.removeEventListener(MouseEvent.CLICK, onDisconnect);
			}
			if (instance == dropListLang)
			{
				dropListLang.removeEventListener(IndexChangeEvent.CHANGE, onChangeLange);
			}
		}
		
		/**
		 * 
		 * @private 
		 */
		override protected function getCurrentSkinState():String
		{
			trace("skin invalidating");
			return authentified? "authentified" : enabled ? "normal" : "disabled"; 
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			trace("commitproperties " )
			if (moduleListChanged && null != contentGroup)
			{
				moduleListChanged = false;
				addModuleButton();
			}
			if(initModuleChange)
			{
				initModuleChange = false;
				var labelModule:String;
				var nbrModule:int = _moduleList.length;
				for(var nModule:int = 0 ; nModule < nbrModule ; nModule++)
				{
					var item:Object = _moduleList[nModule];
					if(item.value == this._initModule)
					{
						labelModule = item.label;
						break;
					}
				}
				buttonBarModules.selectedItem = labelModule;
				// load module
				onChangeModule();
			}
		}
		/*----------------------------------------
					Protected Methods
		-----------------------------------------*/
		
		
		/**
		 * @private
		 * add module navigation buttons
		 */
		protected function addModuleButton():void
		{
			var bt:Button;
			for each (var o:Object in _moduleList)
			{
                    switch(o.value)
                    {
                    case "home" :
						buttonHomeModule.name = o.value;
                        break;
                    case "tutorat" :
						buttonTutoratModule.name = o.value;
						Model.getInstance().setButtonSalonTutorat(buttonTutoratModule);
						Model.getInstance().setEnabledButtonSalonTutorat(false);
                        break;
                    case "profil" :
						buttonProfilModule.name = o.value;
                        break;
                    case "retrospection" :
						buttonRetrospectionModule.name = o.value;
						Model.getInstance().setButtonSalonRetro(buttonRetrospectionModule);
						Model.getInstance().setEnabledButtonSalonRetro(false);
                        break;
                    case "bilan" :
						buttonBilanModule.name = o.value;
                        break;
                    case "user" :
						buttonUserModule.name = o.value;
						buttonUserModule.includeInLayout = buttonUserModule.visible = true;
                        break;
                    case "session" :
						buttonSessionModule.name = o.value;
						buttonSessionModule.includeInLayout = buttonSessionModule.visible = true;
                        break;
                    }
			}			
		}
		/**
		 * @private
		 * add module navigation buttons
		 */
		protected function addModuleButtonOld():void
		{
			/*var bt:Button;
			for each (var o:Object in _moduleList)
			{
				if (o is Array)
				{
					 
					var cb:DropDownList = new DropDownList();
					cb.dataProvider = new ArrayList(o as Array);
					cb.selectedIndex = 0
					//bt.addEventListener(MouseEvent.CLICK, navigateToModule);
					addElement( cb );
				}
				else
				{
                    switch(o.value)
                    {
                    case "tutorat" :
                        buttonSalonTutorat.label = o.label;
                        buttonSalonTutorat.addEventListener(MouseEvent.CLICK, onClickButtonSalonTutorat);
                        Model.getInstance().setButtonSalonTutorat(buttonSalonTutorat);
                        Model.getInstance().setEnabledButtonSalonTutorat(false);
                        break;
                    case "retrospection" :
                        buttonSalonRetro.label = o.label;
                        buttonSalonRetro.selected = false;
                        buttonSalonRetro.addEventListener(MouseEvent.CLICK, onClickButtonSalonRetro);
                        Model.getInstance().setButtonSalonRetro(buttonSalonRetro);
                        Model.getInstance().setEnabledButtonSalonRetro(false);
                        break;
                    case "bilan" :
                        buttonSalonBilan.label = o.label;
                        buttonSalonBilan.selected = false;
                        buttonSalonBilan.addEventListener(MouseEvent.CLICK, onClickButtonSalonBilan);
                        break
                    default :
                        // TODO : translate the labels of the buttons
                        buttonsModule.addItem(o.label);
                        break;
                    }
				}*/
		//	}
            // set buttonBar
/*            buttonBarModules.dataProvider = buttonsModule;
            buttonBarModules.requireSelection = true;
            buttonBarModules.addEventListener(IndexChangeEvent.CHANGE, onChangeModule);
            addElement(buttonBarModules);
            
            // add group the too buttons : salon synchro and salon retro
            var groupTutoratRetroButtons:HGroup = new HGroup();
            groupTutoratRetroButtons.gap = 0;
            groupTutoratRetroButtons.addElement(buttonSalonTutorat);
            groupTutoratRetroButtons.addElement(buttonSalonRetro);
            addElement(groupTutoratRetroButtons);
            
            // add button salon bilan
            addElement(buttonSalonBilan);*/
			
		}

		/*----------------------------------------
					Event handler
		-----------------------------------------*/
        /**
        * activate window chat message
        */
        private function onClickButtonChat(event:MouseEvent):void
        {
            var messagerie:MessagerieWindow = new MessagerieWindow();
            PopUpManager.addPopUp(messagerie, this);
            PopUpManager.centerPopUp(messagerie);
            messagerie.y = 10;
            // set logged user
            messagerie.loggedUser = Model.getInstance().getLoggedUser();
            // set list messages
            var listChatMessage:ArrayCollection = Model.getInstance().getlistChatMessage(); 
            messagerie.listMessage = listChatMessage;
        }
        
		/**
		 * diconnect event handler
		 * dispatch an ApplicationMenuEvent.DISCONNECT
		 */
		protected function onDisconnect(event:MouseEvent):void
		{
			dispatchEvent( new ApplicationMenuEvent( ApplicationMenuEvent.DISCONNECT));
		}		
		/**
		 * change lang event handler
		 * dispatch an ApplicationMenuEvent.CHANGE_LANGUAGE
		 */
		 protected function onChangeLange(event:IndexChangeEvent):void
		 {
			 var newIndex:int = event.newIndex as int;
			 var tempDropDownList:DropDownList = event.currentTarget as DropDownList;
			 var obj:Object = tempDropDownList.dataProvider[newIndex] as Object;
			 var language:String = obj.data;
			 var applicationMenuEvent:ApplicationMenuEvent = new ApplicationMenuEvent(ApplicationMenuEvent.CHANGE_LANGUAGE);
			 applicationMenuEvent.moduleName = language;
			 dispatchEvent(applicationMenuEvent); 
		 }

		/**
		 * navigateToModule event handler
		 * call navigate function with the module name
		 */
		protected function navigateToModule(event:MouseEvent):void
		{
			navigate(event.target.name);
		}
		/**
		 * Event handler click on button modules
		 */
		private function onClickButtonModule(event:MouseEvent):void
		{
			var nameModule:String = (event.currentTarget as Button).name;
			navigate(nameModule);
		}
		/**
		 * event handler the switche the modules
		 */
		public function onChangeModule(event:IndexChangeEvent = null, nameModule:String = null):void
		{
			var label:String="";
			if(event != null)
			{
				var buttonBar:ButtonBar = event.currentTarget as ButtonBar;
				label = buttonBar.selectedItem;
			}else
			{
				label = buttonBarModules.selectedItem;
			}
			
			if(nameModule)
			{
				var nbrModule:int = _moduleList.length;
				for(var nModule:int = 0 ; nModule < nbrModule ; nModule++)
				{
					var item:Object = _moduleList[nModule];
					if(item.value == nameModule)
					{
						var labelModule:String = item.label;
						buttonBarModules.selectedItem = labelModule;
						return;
					}
				}
			}else
			{
				var selectedLabel:String = label;
				var nbrModule:int = _moduleList.length;
				for(var nModule:int = 0 ; nModule < nbrModule ; nModule++)
				{
					var item:Object = _moduleList[nModule];
					if(item.label == selectedLabel)
					{
						var name:String = item.value;
						// enabled buttonBar the modules
						enabledButtonBarModules(false);
						navigate(name);
						return;
					}
				}
			}
			
		}
		/**
		 * event handler the button salon Tutorat
		 */
		private function onClickButtonSalonTutorat(even:MouseEvent):void
		{
			// check if button selected
			if(buttonSalonTutoratState)
			{
				buttonSalonTutorat.selected = true;
			}else
			{
				navigateByLabelButton(buttonSalonTutorat.label)
			}
		}
		
        /**
         * event handler the button salon Retrospection
         */
        private function onClickButtonSalonRetro(even:MouseEvent):void
        {
            // check if button selected
            if(buttonSalonRetroState)
            {
                buttonSalonRetro.selected = true;
            }else
            {
                navigateByLabelButton(buttonSalonRetro.label);
            }
        }
        /**
        * Handler button bilan module
        */
        private function onClickButtonSalonBilan(event:MouseEvent):void
        {
            navigateByLabelButton(buttonSalonBilan.label);
        }
        
		/**
		 * navigate by label the button
		 * FIXME : when will change the languge, can't identifate le label
		 * TODO : othe algo 
		 */
		private function navigateByLabelButton(label:String):void
		{
			// get name module by label the button
			var nbrModule:int = _moduleList.length;
			for(var nModule:int = 0 ; nModule < nbrModule ; nModule++)
			{
				var item:Object = _moduleList[nModule];
				if(item.label == label)
				{
					var name:String = item.value;
					navigate(name);
					return;
				}
			}
		}
		/**
		 * disconnect event handler
		 */
		protected function navigate(moduleName:String):void
		{
			var e:ApplicationMenuEvent = new ApplicationMenuEvent( ApplicationMenuEvent.NAVIGATE );
			e.moduleName = moduleName;
			dispatchEvent(e); 
		}
			
		private function onClickLogo(event:MouseEvent):void
		{
			Security.showSettings( SecurityPanel.CAMERA );
		}
		
		private function onCreateToolTipVisu(event:ToolTipEvent):void
		{
			var visuToolTip:VisuToolTip = new VisuToolTip();
			visuToolTip.localVersionGit = Model.getInstance().getLocalVersionGit();
			visuToolTip.remoteVersionGit = Model.getInstance().getRemoteVersionGit();
			visuToolTip.dateCompliled = Model.getInstance().getDateCompiled();
			
			event.toolTip = visuToolTip;
		}
		///////////////
		/// Utils
		//////////////
		public function enabledButtonBarModules(value:Boolean):void
		{
			buttonBarModules.enabled = value;
		}
		/**
		 * deselection the buttonBar
		 */
        public function deselectButtonBarModules():void
        {
            buttonBarModules.requireSelection = false;
            buttonBarModules.selectedIndex = -1;
        }
        /**
         * 
         */
        public function requireSelectionButtonBarModules():void
        {
            buttonBarModules.requireSelection = true;
            buttonSalonBilan.selected = false;
        }
        /**
         * Deselect button salon bilan
         */
        public function deselectButtonSalonBilan():void
        {
            buttonSalonBilan.selected = false;
        }
		/**
	 	* 
		*/
		public function selectButtonRetroModule(value:Boolean):void
		{
			buttonSalonRetro.selected = value;
			buttonSalonRetroState = value;
		}
		
		/**
	 	* 
		*/
		public function selectButtonTutoratModule(value:Boolean):void
		{
			buttonSalonTutorat.selected = value;
			buttonSalonTutoratState = value;
		}
	
		
	
	}
}