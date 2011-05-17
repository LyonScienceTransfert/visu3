package com.ithaca.visu.events
{
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.vo.ActivityElementVO;
	import com.ithaca.visu.model.vo.ActivityVO;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.model.vo.SessionWithoutListUserVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class VideoPanelEvent extends Event
	{
		// constants
		static public const VIDEO_PANEL_ZOOM : String = 'videoPanelZoom';
		// properties
		
		// constructor
		public function VideoPanelEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
	}
}
