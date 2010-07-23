package com.ithaca.visu.core
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.ithaca.visu.controls.globalNavigation.ApplicationMenu;
	import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
	import com.ithaca.visu.controls.login.LoginForm;
	import com.ithaca.visu.controls.login.event.LoginEvent;
	import com.ithaca.visu.events.VisuModuleEvent;
	import com.ithaca.visu.modules.ModuleInfo;
	import com.ithaca.visu.modules.ModuleNavigator;
	import com.lyon2.visu.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	
	import flashx.textLayout.elements.GlobalSettings;
	import flashx.textLayout.events.ModelChange;
	
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarLabelPlacement;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	
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
				loginForm.addEventListener(LoginEvent.LOGIN,authUser);
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
				loginForm.removeEventListener(LoginEvent.LOGIN,authUser);
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
			trace("authenticate ",loginForm.loginField.text," as ",loginForm.passField.text);
			userLoggedIN();
		}
		
		/* TEMP */
		protected function userLoggedIN():void
		{
			authentified = true;
			menu.authentified = true;
			menu.moduleList = [ {label:"Utilisateur",value:"user"},
								{label:"Séances",value:"session"},
									[{label:"Salon1",value:"salon#id=1"},
									{label:"Les identités nationnales",value:"salon#id=2"},
									{label:"La bise",value:"salon#id=3"}],
								{label:"Debriefing",value:"retrospection"}];
			
			var h:ModuleInfo = new ModuleInfo();
			h.name 	= "home";
			h.label	= "Accueil";
			h.url 	= "modules/HomeModule.swf";
			
			var m:ModuleInfo = new ModuleInfo();
			m.name 	= "user";
			m.label	= "Utilisateur";
			m.url 	= "modules/UserModule.swf";
			
			moduleNavigator.defaultModule = "home";
			moduleNavigator.initModuleNavigation( [h,m] );
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