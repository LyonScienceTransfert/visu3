package com.ithaca.visu.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class VisuActivityEvent extends Event
	{
		// constants
		static public const LOAD_LIST_ACTIVITY : String = 'loadListActivity';
		static public const SHOW_LIST_ACTIVITY : String = 'showListActivity';
		// properties
		public var sessionId:int;
		public var listActivity:ArrayCollection;
		// constructor
		public function VisuActivityEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
		}
	}
}
