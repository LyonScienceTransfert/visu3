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
	
	public class PanelEditInfoEvent extends Event
	{
		// constants
		static public const CLICK_BUTTON_OK : String = 'clickButtonOk';
		static public const CLICK_BUTTON_CANCEL : String = 'clickButtonCancel';
		// properties
		public var user:User;
		public var text:String;
		// constructor
		public function PanelEditInfoEvent(type : String,
			bubbles : Boolean = true,
			cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
	}
}
