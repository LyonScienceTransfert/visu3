package com.ithaca.visu.events
{
	import flash.events.Event;
	
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;

	public class VisuModuleEvent extends ModuleEvent
	{
		 public function VisuModuleEvent(type:String, 
		 						bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                bytesLoaded:uint = 0, bytesTotal:uint = 0,
								errorText:String = null, module:IModuleInfo = null)
		{
		    super(type, bubbles, cancelable, bytesLoaded, bytesTotal,errorText,module);
		}
		
		public static const CONFIGURE:String = "configure";
		public static const LOAD:String = "load";
		public static const LOAD_LIST_MODULES:String = "loadListModules";
		public static const WALK_OUT_MODULE:String = "walkOutModule";
		public static const GO_IN_MODULE:String = "goInModule";
		public static const READY_FOR_USE:String = "readyForUse";
		
		public static const TUTORAT_MODULE:String = "tutoratModule";
		public static const RETROSPECTION_MODULE:String = "retrospectionModule";
		public static const USER_MODULE:String = "userModule";
		public static const SESSION_MODULE:String = "sessionModule";
		public static const BILAN_MODULE:String = "bilanModule";
		public static const HOME_MODULE:String = "homeModule";
		public static const PROFIL_MODULE:String = "profilModule";
		
		public var listModules:Array;
		public var moduleName:String;
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			var event:VisuModuleEvent = new VisuModuleEvent(type, bubbles, cancelable,
				bytesLoaded, bytesTotal, errorText, module);
			event.listModules = this.listModules;
			event.moduleName = this.moduleName;
			return event;
		}
	}
}