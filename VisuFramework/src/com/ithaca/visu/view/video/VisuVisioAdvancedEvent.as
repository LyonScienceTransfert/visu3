package com.ithaca.visu.view.video
{
	import flash.events.Event;
	
	public class VisuVisioAdvancedEvent extends Event
	{
		public static const UPDATE_TIME:String="updateTime";
		public static const CLICK_PANEL_VIDEO:String="clickPanelVideo";
		
		public var beginTime:Number;
		
		
		public function VisuVisioAdvancedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}