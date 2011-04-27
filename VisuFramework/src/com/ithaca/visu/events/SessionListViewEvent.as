package com.ithaca.visu.events
{
	
	import com.ithaca.visu.model.Session;
	
	import flash.events.Event;
	
	public class SessionListViewEvent extends Event
	{
		// constants
		static public const SELECT_SESSION : String = 'selectSession';
		static public const CHANGE_TEXT_FILTER : String = 'changeTextFilter';
		// properties
		public var selectedSession : Session;
		public var textFilter : String;
		
		// constructor
		public function SessionListViewEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}