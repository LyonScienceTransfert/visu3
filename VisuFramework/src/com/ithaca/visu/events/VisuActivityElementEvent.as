package com.ithaca.visu.events
{
	import flash.events.Event;
	
	public class VisuActivityElementEvent extends Event
	{
		// constants
		static public const LOAD_LIST_ACTIVITY_ELEMENTS : String = 'loadListActivityElements';
		// properties
		public var activityId:int;
		// constructor
		public function VisuActivityElementEvent(type : String,
										  bubbles : Boolean = true,
										  cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
		}
	}
}
