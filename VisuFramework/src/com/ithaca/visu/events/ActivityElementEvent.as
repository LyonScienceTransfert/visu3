package com.ithaca.visu.events
{
	import com.lyon2.visu.model.ActivityElement;
	
	import flash.events.Event;
	
	public class ActivityElementEvent extends Event
	{
		public static const SHARE_ELEMENT:String = "shareElement";
		
		public var element:ActivityElement;
		
		public function ActivityElementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}