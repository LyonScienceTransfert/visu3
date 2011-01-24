package com.ithaca.visu.controls.globalNavigation
{
	import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
	import com.ithaca.visu.model.Model;
	
	import flash.events.MouseEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import spark.components.Button;
	import spark.components.ComboBox;
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
		
		public var listLang:ArrayCollection = new ArrayCollection()
		public var listLabelModule:Array = new Array();
		
		/**
		 * @private 
		 */
		private var _listModulesButton:Array = new Array();
		
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
						 Model.getInstance().setButtonSalonSynchrone(bt);
						 Model.getInstance().setEnabledButtonSalonSynchrone(false);
					 }
					// FIXME : enabled module retrospection
//					if(o.value == "retrospection"){bt.enabled = false;}
					// FIXME : enabled module session
					if(o.value == "session"){bt.enabled = false;}
					bt.addEventListener(MouseEvent.CLICK, navigateToModule);
					addElement( bt );
					// list buttons for translate the labels
					_listModulesButton[o.value]=bt;
				}
			}
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
		 * disconnect event handler
		 */
		protected function navigate(moduleName:String):void
		{
			var e:ApplicationMenuEvent = new ApplicationMenuEvent( ApplicationMenuEvent.NAVIGATE );
			e.moduleName = moduleName;
			dispatchEvent(e); 
		}
				
		
	}
}