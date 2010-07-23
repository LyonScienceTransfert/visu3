package com.ithaca.visu.controls.globalNavigation.event
{
	import flash.events.Event;
	
	public class ApplicationMenuEvent extends Event
	{
		public static const NAVIGATE:String = "navigate";
		public static const CHAT:String = "chat";
		public static const DISCONNECT:String = "disconnect";
		
		public var moduleName:String;
		
		public function ApplicationMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}