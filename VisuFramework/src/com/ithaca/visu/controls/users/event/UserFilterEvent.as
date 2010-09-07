package com.ithaca.visu.controls.users.event
{
	import flash.events.Event;
	
	public class UserFilterEvent extends Event
	{
		
		public static const VIEW_UNGROUP:String="viewUngroup";
		public static const VIEW_ALL:String="viewAll";
		public static const VIEW_PROFILE:String="viewProfile";
		
		public var profile_max:int;
		public var profile_min:int;
		
		public function UserFilterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}