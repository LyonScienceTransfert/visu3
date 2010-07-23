package com.ithaca.visu.controls.login.event
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN:String="onLogin";
		public static const GET_PASSWORD:String="getPassword";
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}