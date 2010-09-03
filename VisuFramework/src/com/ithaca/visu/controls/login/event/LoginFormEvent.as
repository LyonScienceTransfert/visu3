package com.ithaca.visu.controls.login.event
{
	import flash.events.Event;
	
	public class LoginFormEvent extends Event
	{
		// constants
		public static const LOGIN:String="onLogin";
		public static const GET_PASSWORD:String="getPassword";
		
		// properties
		public var username:String;
		public var password:String;
		
		public function LoginFormEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}