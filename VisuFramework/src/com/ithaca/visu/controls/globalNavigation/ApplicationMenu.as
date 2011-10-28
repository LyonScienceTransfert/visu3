package com.ithaca.visu.controls.globalNavigation
{
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
	import mx.events.ToolTipEvent;
	
	import spark.components.Button;
	import spark.components.ButtonBar;
	import spark.components.DropDownList;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
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
		public var disconnect:Button;
		
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

		public var listLang:ArrayCollection = new ArrayCollection()
		public var listLabelModule:Array = new Array();
		
		/**
		 * @private 
		 */
		private var _listModulesButton:Array = new Array();
		private var buttonBar:ButtonBar = new ButtonBar();
		private var buttonsModule:ArrayCollection = new ArrayCollection();
		// initial module
		private var _initModule:String;
		private var initModuleChange:Boolean;
		
		public function get listModulesButton():Array
		{
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
				dropListLang.enabled = false;
			}
/*			if (instance == home)
			{
				home.addEventListener(MouseEvent.CLICK, navigateToHome);
			}*/
			
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
/*			if (instance == home)
			{
				home.removeEventListener(MouseEvent.CLICK, navigateToHome);
			}*/
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
				buttonBar.selectedItem = labelModule;
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
					// general case
					bt = new Button();
					bt.label = o.label;
					bt.name = o.value;
					// 
					//FIXME : enabled module tutorat
					 if(o.value == "tutorat")
					 {
						 bt.enabled = false;
						 Model.getInstance().setButtonSalonSynchrone(bt);
						 Model.getInstance().setEnabledButtonSalonSynchrone(false);
					 }
					// FIXME : enabled module retrospection
					if(o.value == "retrospection")
					{
						bt.enabled = false; bt.visible = false; bt.includeInLayout = false;
					}
					// FIXME : enabled module session
					if(o.value == "session"){bt.enabled = true;}
					bt.addEventListener(MouseEvent.CLICK, navigateToModule);
				//	addElement( bt );
					
					_listModulesButton[o.value]=bt;
					// don't show tutorat and retrospection module
					if(!(o.value == "tutorat"  ||  o.value == "retrospection"))
					{
						// TODO : translate the labels of the buttons
						buttonsModule.addItem(o.label);
					}
					
				}
			}
			// set buttonBar
			buttonBar.dataProvider = buttonsModule;
			buttonBar.requireSelection = true;
			buttonBar.addEventListener(IndexChangeEvent.CHANGE, onChangeModule);
			addElement(buttonBar);
						
			bt=null;
		}

		/*----------------------------------------
					Event handler
		-----------------------------------------*/
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
		 * event handler the switche the modules
		 */
		protected function onChangeModule(event:IndexChangeEvent = null):void
		{
			var selectedLabel:String = buttonBar.selectedItem;
			var nbrModule:int = _moduleList.length;
			for(var nModule:int = 0 ; nModule < nbrModule ; nModule++)
			{
				var item:Object = _moduleList[nModule];
				if(item.label == selectedLabel)
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
		
	}
}