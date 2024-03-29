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
package com.ithaca.visu.core
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.visu.controls.globalNavigation.ApplicationMenu;
	import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
	import com.ithaca.visu.controls.login.ActivateForm;
	import com.ithaca.visu.controls.login.LoginForm;
	import com.ithaca.visu.controls.login.event.LoginFormEvent;
	import com.ithaca.visu.events.AuthenticationEvent;
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.VisuModuleEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.modules.ModuleInfo;
	import com.ithaca.visu.modules.ModuleNavigator;
	import com.ithaca.visu.ui.utils.IconEnum;
	
	import flash.events.Event;
	
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarLabelPlacement;
	import mx.controls.SWFLoader;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Application;
	
	[SkinState("authentified")]
	
	public class VisuApplication extends Application
	{
		
		private static var logger:ILogger = Log.getLogger("com.ithaca.visu.core.VisuApplication");
		
		
		[SkinPart("false")]
		public var loginForm:LoginForm;
		
		[SkinPart("true")]
		public var menu:ApplicationMenu;
        
		[SkinPart("true")]
		public var activatedForm:ActivateForm;
		/**
		 * 
		 * Register Singleton Manager and other components
		 * shared in the whole application to avoid RTE
		 * 
		 * */ 
		public var moduleNavigator:ModuleNavigator;
		
		protected var _progressBar:ProgressBar; 
		protected var _progressBarBlueLine:SWFLoader
		
		protected var defaultModule:String; 

		private var _authentified:Boolean;
		private var _activated:Boolean;
        
		public function get authentified():Boolean
		{
			return _authentified;
		}

		public function set authentified(value:Boolean):void
		{
			_authentified = value;
			invalidateSkinState();
		}
		public function get activated():Boolean
		{
			return _activated;
		}

		public function set activated(value:Boolean):void
		{
            _activated = value;
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
			moduleNavigator.addEventListener(VisuModuleEvent.READY_FOR_USE, onReadyForUseModule);
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
			if( _progressBarBlueLine == null )
			{
				_progressBarBlueLine = new SWFLoader()
				_progressBarBlueLine.setStyle("verticalCenter",0);
				_progressBarBlueLine.setStyle("horizontalCenter",0);
				_progressBarBlueLine.source = IconEnum.getIconByName("loaderBlueLine");
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
				if(Model.getInstance().checkServeurVisuDev())
				{
					loginForm.setSkinVisuDev();
				}
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
			return !enabled ? "disabledWithControlBar": authentified ? "authentified" :  activated ? "activated" : "normalWithControlBar";
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
	
		protected function goHome(event:SessionEvent):void{
			moduleNavigator.navigateToModule( "home", event.session);
		}
		
		protected function joinSession(event:SessionEvent):void{
			logger.debug("The application is requested to join the session {0}", event.session.id_session);
			// set currentSession for Tutorat module
			Model.getInstance().setCurrentSessionTutoratModule(event.session);
			moduleNavigator.navigateToModule( "tutorat", event.session);
		}
		
		protected function editSession(event:SessionEvent):void{
			logger.debug("The application is requested to edit the session {0}", event.session.id_session);
			moduleNavigator.navigateToModule( "session", event.session);
			menu.onChangeModule(null, "session");
		}
		

		protected function cancelSession(event:SessionEvent):void{
			logger.debug("The application is requested to cancel the session {0}", event.session.id_session);
			moduleNavigator.navigateToModule( "retrospection", event.session);
		}
		 

		protected function goRetrospection(event:SessionEvent):void{
			logger.debug("The application is requested to go to the retrospection room of the session {0}", event.session.id_session);
			var obj:Array = new Array();
			obj[0] = "CameFromHomeModule";
			obj[1] = event.session;
			moduleNavigator.navigateToModule( "retrospection", obj);
		}
		
		protected function goBilan(event:SessionEvent):void{
			logger.debug("The application is requested to go to the bilan of the session {0}", event.session.id_session);
			var obj:Array = new Array();
			obj[0] = "CameFromHomeModule";
			obj[1] = event.session.id_session;
			moduleNavigator.navigateToModule( "bilan", obj );
			menu.onChangeModule(null, "bilan");
		}
		
		protected function goBilanFromRetrospection(event:RetroDocumentEvent):void{
			logger.debug("The application is requested to go to the bilan of the session {0} and retroDocumentId {1}", event.sessionId, event.idRetroDocument);
			var obj:Array = new Array();
			obj[0] = "CameFromRetroModule";
			obj[1] = event.sessionId;
			obj[2] = event.idRetroDocument;
			moduleNavigator.navigateToModule( "bilan", obj );
			menu.onChangeModule(null, "bilan");
		}

        protected function goBilanFromSession(event:RetroDocumentEvent):void{
			logger.debug("The application is requested to go to the bilan of the session {0} and retroDocumentId {1}", event.sessionId, event.idRetroDocument);
			var obj:Array = new Array();
			obj[0] = "CameFromSessionModule";
			obj[1] = event.sessionId;
			obj[2] = event.idRetroDocument;
			moduleNavigator.navigateToModule( "bilan", obj );
			menu.onChangeModule(null, "bilan");
		}
		
		protected function goRetroFromBilan(event:RetroDocumentEvent):void{
			logger.debug("The application is requested to go to the retro of the session {0} and retroDocumentId {1}", event.sessionId, event.idRetroDocument);
			var obj:Array = new Array();
			obj[0] = "CameFromBilanModule";
			obj[1] = event.session;
			obj[2] = event.idRetroDocument;
			moduleNavigator.navigateToModule( "retrospection", obj );
		}
        
		protected function goRetroFromSession(event:RetroDocumentEvent):void{
			logger.debug("The application is requested to go to the retro of the session {0} and retroDocumentId {1}", event.sessionId, event.idRetroDocument);
			var obj:Array = new Array();
			obj[0] = "CameFromSessionModule";
			obj[1] = event.session;
			obj[2] = event.idRetroDocument;
			moduleNavigator.navigateToModule( "retrospection", obj );
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
			 
			addElement( _progressBarBlueLine );
		} 
		private function onModuleReady(event:ModuleEvent):void
		{
			/*removeElement( _progressBarBlueLine );*/
		}
		private function onReadyForUseModule(event:VisuModuleEvent):void
		{
			
			removeElement( _progressBarBlueLine );
			// enabled buttonBar the modules
			menu.enabledButtonBarModules(true);
			
            switch(event.moduleName)
            {
            case VisuModuleEvent.RETROSPECTION_MODULE:
                menu.deselectButtonBarModules();
                menu.deselectButtonSalonBilan();
                menu.selectButtonRetroModule(true);
                menu.selectButtonTutoratModule(false);
                break;
            case VisuModuleEvent.TUTORAT_MODULE:
                menu.deselectButtonBarModules();
                menu.deselectButtonSalonBilan();
                menu.selectButtonRetroModule(false);
                menu.selectButtonTutoratModule(true);
                break;
            case VisuModuleEvent.BILAN_MODULE:
                menu.deselectButtonBarModules();
                menu.selectButtonRetroModule(false);
                menu.selectButtonTutoratModule(false);
                break;
            case VisuModuleEvent.PROFIL_MODULE:
                menu.deselectButtonBarModules();
                menu.selectButtonRetroModule(false);
                menu.selectButtonTutoratModule(false);
                break;
            default:
                menu.requireSelectionButtonBarModules();
                menu.selectButtonRetroModule(false);
                menu.selectButtonTutoratModule(false);
                break;
            }
			
			/*if(event.moduleName == VisuModuleEvent.RETROSPECTION_MODULE || event.moduleName == VisuModuleEvent.TUTORAT_MODULE)
			{
				menu.deselectButtonBarModules();
			}else
			{
				menu.requireSelectionButtonBarModules();
			}*/
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
		protected function authUser(event:LoginFormEvent):void
		{	
			var loginEvent:AuthenticationEvent = new AuthenticationEvent(AuthenticationEvent.CONNECT);
			loginEvent.rtmpSever = Model.getInstance().rtmpServer;
			loginEvent.params = {"username" : event.username, "password" : event.password};
			dispatchEvent(loginEvent);
		}
		
		/* TEMP */
		protected function userLoggedIN(event:VisuModuleEvent):void
		{		
            // defauld module name 
            var loadModuleName:String = null;
            var moduleNameSetByParam:String = Model.getInstance().getInitModule();
            
			authentified = true;
			menu.authentified = true;
			var listModules:Array = event.listModules as Array;
			var nbrModules:uint = listModules.length;
			var listModulesInfo:Array = new Array();
			var moduleList:Array = new Array();
			for(var nModule:uint = 0; nModule < nbrModules; nModule++){
				var moduleInfo:ModuleInfo = listModules[nModule] as ModuleInfo;
				listModulesInfo.push(moduleInfo);
                // check name module set by param
                if(moduleNameSetByParam == moduleInfo.name )
                {
                    loadModuleName = moduleNameSetByParam;
                }
				moduleList.push({label:moduleInfo.label, value:moduleInfo.name});				
			}
            
			// initialisation list the modules
			menu.moduleList = moduleList;
			// initialisation the modules
			moduleNavigator.initModuleNavigation(listModulesInfo);
			moduleNavigator.browserTitleBase = "VISU"
            
            // check load module name
            // FIXME : will limited load only bilan module
            if(loadModuleName && loadModuleName == "bilan")
            {
                var obj:Array = new Array();
                obj[0] = "CameOnInitApplication";
                // session id
                obj[1] = Model.getInstance().getInitSessionId();
                // bilan id
                obj[2] = Model.getInstance().getInitBilanId();
                
                moduleNavigator.navigateToModule( loadModuleName, obj );
                menu.onChangeModule(null, loadModuleName);
                return;
            }
            
            loadModuleName = "home";
            menu.initModule = loadModuleName;
            moduleNavigator.defaultModule = loadModuleName;
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
