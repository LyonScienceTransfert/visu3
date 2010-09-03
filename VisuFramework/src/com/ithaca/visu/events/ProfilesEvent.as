package com.ithaca.visu.events
{
	import flash.events.Event;
	
	public class ProfilesEvent extends Event
	{
		// constants
		static public const LOAD_PROFILES : String = 'loadProfiles';
		
		public function ProfilesEvent(
							type:String, 
							bubbles:Boolean=false, 
							cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}