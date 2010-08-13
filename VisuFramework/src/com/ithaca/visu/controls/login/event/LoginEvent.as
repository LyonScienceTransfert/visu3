package com.ithaca.visu.controls.login.event
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		// constants
		public static const LOGIN:String="onLogin";
		public static const GET_PASSWORD:String="getPassword";
		
		// properties
		// DEBUG MODE
		public var ar:Array;

		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}