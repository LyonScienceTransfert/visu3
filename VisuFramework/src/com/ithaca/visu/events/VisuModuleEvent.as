package com.ithaca.visu.events
{
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
		
		public var listModules:Array;
		
	}
}