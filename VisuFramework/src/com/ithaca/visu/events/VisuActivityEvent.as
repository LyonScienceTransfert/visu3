package com.ithaca.visu.events
{
	import com.lyon2.visu.model.Activity;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class VisuActivityEvent extends Event
	{
		// constants
		static public const LOAD_LIST_ACTIVITY : String = 'loadListActivity';
		static public const SHOW_LIST_ACTIVITY : String = 'showListActivity';
		static public const START_ACTIVITY : String = 'startActivity';
		static public const UPDATE_ACTIVITY : String = 'updateActivity';
		
		// properties
		public var sessionId:int;
		public var listActivity:ArrayCollection;
		public var activity:Activity;
		public var activityId:int;
		
		// constructor
		public function VisuActivityEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
		}
	}
}
