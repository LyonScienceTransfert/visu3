package com.ithaca.visu.events
{
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
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
		static public const CHANGE_VOLUME : String = 'changeVolume';
		static public const UPDATE_VOLUME : String = 'updateVolume';
		static public const CLICK_VIDEO_PANEL : String = 'clickVideoPanel';
		static public const CLICK_BUTTON_MARKER_VIDEO_PANEL : String = 'clickButtonMarkerVideoPanel';
		static public const CLICK_BUTTON_CHAT_VIDEO_PANEL : String = 'clickButtonChatVideoPanel';
		// properties
		public var volume:Number;
		public var userId:int;
		public var user:User;
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
