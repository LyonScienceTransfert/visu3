package com.ithaca.visu.view.video
{
	import com.ithaca.visu.model.User;
	
	import flash.events.Event;
	
	public class VisuVisioAdvancedEvent extends Event
	{
		public static const UPDATE_TIME:String="updateTime";
		public static const CLICK_PANEL_VIDEO:String="clickPanelVideo";
		public static const CLICK_BUTTON_MARKER:String="clickButtonMarker";
		public static const CLICK_BUTTON_CHAT:String="clickButtonChat";
		
		public var beginTime:Number;
		public var user:User;
		
		
		public function VisuVisioAdvancedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}