package com.ithaca.visu.controls.globalNavigation
{
	import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.DropDownList;
	import spark.components.SkinnableContainer;
	
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
		
		[SkinPart("true")]
		public var home:Button;
		
		[SkinPart("false")]
		public var chat:Button;
		 
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
			if (instance == home)
			{
				home.addEventListener(MouseEvent.CLICK, navigateToHome);
			}
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
			if (instance == home)
			{
				home.removeEventListener(MouseEvent.CLICK, navigateToHome);
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
					bt.addEventListener(MouseEvent.CLICK, navigateToModule);
					addElement( bt );
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
		 * navigateToHome event handler
		 * call navigate function with the module name
		 */
		protected function navigateToHome(event:MouseEvent):void
		{
			navigate("home");
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