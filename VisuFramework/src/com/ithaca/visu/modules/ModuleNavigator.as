package com.ithaca.visu.modules
{
	import com.asual.swfaddress.SWFAddress;
	import com.ithaca.visu.events.VisuModuleEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.core.IContainer;
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	import mx.managers.CursorManager;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	[Event(name="load",     type="com.ithaca.visu.events.VisuModuleEvent")]
	[Event(name="progress", type="mx.events.ModuleEvent")]
	[Event(name="ready",    type="mx.events.ModuleEvent")]
	[Event(name="unload",    type="mx.events.ModuleEvent")]
	
	public class ModuleNavigator extends EventDispatcher
	{
		public var _moduleMap:Dictionary;
		private var _container:SkinnableContainer;
		private var _containerStyleManager:IStyleManager2;
		private var moduleParameters:Object;
		
		public var defaultModule:String;
		public var browserTitleBase:String;
		
		private var info:IModuleInfo;
		private var currentModule:ModuleInfo;
		private var module:VisuModuleBase;
		
		public function ModuleNavigator(container:SkinnableContainer)
		{
			super();
			_moduleMap = new Dictionary();
			_container = container;
			_containerStyleManager = container.styleManager;
			
		}
		
		private function onReadyForUseModule(event:Event):void
		{
			dispatchEvent( event.clone() );
		}
		
		public function initModuleNavigation(value:Array):void
		{
			var m:ModuleInfo;
			for each( m in value)
			{
				registerModule( m.name, m);
			}
			defaultModule = value[0].name;
		}

		protected function registerModule(name:String,info:ModuleInfo):void
		{
			trace("Module Navigator: register module " + name )
			_moduleMap[name]=info;
		}
		protected function unregisterModule(name:String):void
		{
			_moduleMap[name] = null;
		}		
		protected function getModuleInfo(name:String):ModuleInfo
		{
			return ModuleInfo(_moduleMap[name]);
		}
		
		public function navigateToModule(name:String,params:Object=null):void
		{
			var mod:ModuleInfo =  getModuleInfo( name );
			moduleParameters = params;
			
			if( mod == null )
			{
				throw new Error("Module not found");
				return;
			}
			
			if( !haveAccess(mod) ) 
			{
				throw new Error("User don't have sufficient permission to access to this module");
				return;
			}
			
			
			var urlparams:String="";
			if( params != null ) urlparams = "?";
			
			
			
			for(var p:Object in params)
			{
				urlparams+=p+"="+params[p];
			}
			
			if( !isCurrentModule(mod) )
			{
				SWFAddress.setTitle(mod.name +" | "+ browserTitleBase) 
				//SWFAddress.setValue(mod.name+urlparams);
				
				if( info != null ) unloadModule();
				
				currentModule = mod;
				loadModule();				
			}
			else
			{
				trace("Do nothing, requested module already loaded")
			}
			// set busy cursor
			//CursorManager.setBusyCursor();
			
		}
		
		public function isCurrentModule(mod:ModuleInfo):Boolean
		{
			return info!=null && info.url == mod.url;
		}
		public function haveAccess(info:ModuleInfo):Boolean
		{
			return true;
		}
		
		private function loadModule():void
		{
			
			trace("Module Navigator : loadModule " + currentModule.name);

			info = ModuleManager.getModule( currentModule.url )

			addModuleListenner();
			
			//TODO : loadStyleDeclaration
			var childDomain:ApplicationDomain = 
    				new ApplicationDomain(ApplicationDomain.currentDomain);
			
			info.load(childDomain);
			
			if( currentModule.hasStyles ) 
			{
				_containerStyleManager.loadStyleDeclarations(currentModule.css, true,false, childDomain);
			}	
			
			var event:VisuModuleEvent 
					= new VisuModuleEvent(VisuModuleEvent.LOAD,
											false, false,
											0,0,
											null,
											info);
			
			dispatchEvent(event)
		}
		private function unloadModule():void
		{
			trace("Module Navigator unloadModule " + info.url); 
			_container.removeElement( module );
			
			if( currentModule.hasStyles ) 
			{
				_containerStyleManager.unloadStyleDeclarations(currentModule.css);
			}
			info.release();
			info.unload();
			info = null;
		}

		/**
		 * 
		 * 
		 * 
		 */
		private function addModuleListenner():void
		{
			info.addEventListener( ModuleEvent.ERROR, onModuleError);
			info.addEventListener( ModuleEvent.PROGRESS, onModuleProgress);
			info.addEventListener( ModuleEvent.READY, onModuleReady);
			info.addEventListener( ModuleEvent.SETUP, onModuleSetup);
			info.addEventListener( ModuleEvent.UNLOAD, onModuleUnload);
		}
		private function removeModuleListenner():void
		{
			info.removeEventListener( ModuleEvent.ERROR, onModuleError);
			info.removeEventListener( ModuleEvent.PROGRESS, onModuleProgress);
			info.removeEventListener( ModuleEvent.READY, onModuleReady);
			info.removeEventListener( ModuleEvent.SETUP, onModuleSetup);
			info.removeEventListener( ModuleEvent.UNLOAD, onModuleUnload);
		}
		
		/**
		 * 
		 * ModuleProxy Event Listeners
		 * 
		 */
		private function onModuleError(event:ModuleEvent):void
		{
			trace("modulenavigator " + event)
		}
		private function onModuleProgress(event:ModuleEvent):void
		{
			trace("modulenavigator " + event)
			if( event.bytesLoaded == event.bytesTotal ) 
			dispatchEvent( event.clone() );
			
		}
		private function onModuleReady(event:ModuleEvent):void
		{
			trace("modulenavigator " + event)
			
			dispatchEvent( event.clone() );
			dispatchEvent( new ModuleEvent(ModuleEvent.PROGRESS,false,false,0,100));
			
			var temp:IVisualElement = info.factory.create() as IVisualElement;
			module = VisuModuleBase(_container.addElement( info.factory.create() as IVisualElement ));
			
			trace(module);
			
			module.moduleName = currentModule.name ;
			
			if(module.hasEventListener("readyForUse"))
			{
				module.removeEventListener("readyForUse", onReadyForUseModule);	
			}
			module.addEventListener("readyForUse", onReadyForUseModule);
			
			module.handle_parameter( moduleParameters ); 
		}

		private function onModuleSetup(event:ModuleEvent):void
		{
			trace("modulenavigator " + event)
		}

		private function onModuleUnload(event:ModuleEvent):void
		{
			trace("modulenavigator " + event)
			dispatchEvent( event.clone() );
			removeModuleListenner();
		}
	}
}