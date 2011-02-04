package com.ithaca.visu.core
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.ithaca.visu.controls.globalNavigation.ApplicationMenu;
	import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
	import com.ithaca.visu.controls.login.LoginForm;
	import com.ithaca.visu.controls.login.event.LoginFormEvent;
	import com.ithaca.visu.events.AuthenticationEvent;
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.VisuModuleEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.modules.ModuleInfo;
	import com.ithaca.visu.modules.ModuleNavigator;
	
	import flash.events.Event;
	
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarLabelPlacement;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	
	import spark.components.Application;
	
	[SkinState("authentified")]
	
	public class VisuApplication extends Application
	{
		[SkinPart("false")]
		public var loginForm:LoginForm;
		
		[SkinPart("true")]
		public var menu:ApplicationMenu;
		/**
		 * 
		 * Register Singleton Manager and other components
		 * shared in the whole application to avoid RTE
		 * 
		 * */ 
		public var moduleNavigator:ModuleNavigator;
		
		protected var _progressBar:ProgressBar; 
		
		protected var defaultModule:String; 

		private var _authentified:Boolean;
		public function get authentified():Boolean
		{
			return _authentified;
		}

		public function set authentified(value:Boolean):void
		{
			_authentified = value;
			invalidateSkinState();
		}
		public function VisuApplication()
		{
			super();
			addEventListener(FlexEvent.INITIALIZE, onInitialize);
			addEventListener(FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);

			moduleNavigator = new ModuleNavigator(this);
			moduleNavigator.addEventListener(VisuModuleEvent.LOAD, onModuleLoad);
			moduleNavigator.addEventListener(ModuleEvent.READY,onModuleReady);
			moduleNavigator.addEventListener(ModuleEvent.UNLOAD,onModuleUnload);
		}
		
		

		override protected function createChildren():void
		{
			super.createChildren();
			
			if( _progressBar == null )
			{
				_progressBar = new ProgressBar();
				_progressBar.setStyle("verticalCenter",0);
				_progressBar.setStyle("horizontalCenter",0);
				_progressBar.source = moduleNavigator;
				_progressBar.label="";
				_progressBar.labelPlacement=ProgressBarLabelPlacement.CENTER;
			} 
			 
		}
		
		protected function onInitialize(event:FlexEvent):void
		{
			trace(event)
			SWFAddress.addEventListener(SWFAddressEvent.INIT, swfAddressInit);
			SWFAddress.addEventListener(SWFAddressEvent.INTERNAL_CHANGE, urlChangedFromSwf);
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, urlChangedFromBrowser);
		}
		protected function onApplicationComplete(event:FlexEvent):void
		{ 
			trace(event)
			trace("visu app complete " + defaultModule)
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == loginForm)
			{
				loginForm.addEventListener(LoginFormEvent.LOGIN,authUser);
			}
			if (instance == menu)
			{
				menu.addEventListener( ApplicationMenuEvent.NAVIGATE, handleNavigateRequest );
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if( instance == loginForm)
			{
				loginForm.removeEventListener(LoginFormEvent.LOGIN,authUser);
			}
			if (instance == menu)
			{
				menu.removeEventListener( ApplicationMenuEvent.NAVIGATE, handleNavigateRequest );
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled ? "disabledWithControlBar": authentified ? "authentified" : "normalWithControlBar";
		}
		/**
		 * 
		 * SWFAddress handler
		 * 
		 */		
		protected function swfAddressInit(event:SWFAddressEvent):void
		{
			trace(event)
			moduleNavigator.browserTitleBase = SWFAddress.getTitle();
			trace("SWFADRESS browserTitleBase " + moduleNavigator.browserTitleBase)
			if( event.pathNames.length > 0)
			{
				defaultModule = event.pathNames[0] ;
			}
			else
			{
				defaultModule = moduleNavigator.defaultModule; 
			}
		}
		protected function urlChangedFromSwf(event:SWFAddressEvent):void
		{
			trace(event);
			
		}
		protected function urlChangedFromBrowser(event:SWFAddressEvent):void
		{
			trace(event)
			if( event.path != "/" )
				moduleNavigator.navigateToModule( event.pathNames[0], event.parameters );
			
		}
	
		protected function joinSession(event:SessionEvent):void{
			moduleNavigator.navigateToModule( "tutorat", event.session);
		}
		
		protected function editSession(event:SessionEvent):void{
			moduleNavigator.navigateToModule( "session", event.session);
		}

		protected function cancelSession(event:SessionEvent):void{
			moduleNavigator.navigateToModule( "retrospection", event.session);
		}
		 
		
		/**
		 * 
		 * Module Navigator Event Hanlder
		 * 
		 */
		private function onModuleLoad(event:ModuleEvent):void
		{
			//Add the preloader on top of display list
			trace("VISU APP : start loading module " + event.module)
			 
			addElement( _progressBar );
		} 
		private function onModuleReady(event:ModuleEvent):void
		{
			removeElement( _progressBar );
		}
		private function onModuleUnload(event:ModuleEvent):void
		{
			trace("VISU APP unload module:  " + event)
		} 	
		
		
		
		/**
		 * loginForm submit login handler
		 *  
		 * 
		 */
		protected function authUser(event:Event):void
		{	
			var loginEvent:AuthenticationEvent = new AuthenticationEvent(AuthenticationEvent.CONNECT);
			loginEvent.rtmpSever = Model.getInstance().rtmpServer;
			loginEvent.params = {"username" : loginForm.loginField.text, "password" : loginForm.passField.text};
			dispatchEvent(loginEvent);
		}
		
		/* TEMP */
		protected function userLoggedIN(event:VisuModuleEvent):void
		{		
			authentified = true;
			menu.authentified = true;
			var listModules:Array = event.listModules as Array;
			var nbrModules:uint = listModules.length;
			var listModulesInfo:Array = new Array();
			var moduleList:Array = new Array();
			for(var nModule:uint = 0; nModule < nbrModules; nModule++){
				var moduleInfo:ModuleInfo = listModules[nModule] as ModuleInfo;
				listModulesInfo.push(moduleInfo);
				moduleList.push({label:moduleInfo.label, value:moduleInfo.name});				
			}
			// initialisation list the modules
			menu.moduleList = moduleList;
			// initialisation the modules
			moduleNavigator.initModuleNavigation(listModulesInfo);
			moduleNavigator.defaultModule = "home";
			moduleNavigator.browserTitleBase = "VISU"
			moduleNavigator.navigateToModule( "home" );
		}
		protected function userLoggedOUT():void
		{
			authentified = false;
			menu.authentified = false;
		}
		
		
		/*---------------------------------------------------------------
			Application Menu handler
		---------------------------------------------------------------*/
		
		
		protected function handleNavigateRequest(event:ApplicationMenuEvent ):void
		{
			trace("navigate to " + event.moduleName)
			moduleNavigator.navigateToModule( event.moduleName );
		}
		
		
	}
}