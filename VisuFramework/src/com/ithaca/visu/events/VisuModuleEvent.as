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
		
		public var listModules:Array;
		
	}
}