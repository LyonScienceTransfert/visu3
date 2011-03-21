package  com.ithaca.visu.events
{
	import com.ithaca.visu.model.vo.SessionUserVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	
	public class SessionUserEvent extends Event
	{
		// constants
		static public const REMOVE_SESSION_USER : String = 'removeSessionUser';		
		static public const UPDATE_SESSION_USER : String = 'updateSessionUser';
		static public const ADD_SESSION_USER : String = 'addSessionUser';
		static public const GET_LIST_SESSION_USER : String = 'getListSessionUser';
		static public const LOAD_LIST_SESSION_USER : String = 'loadListSessionUser';
		// properties
		public var oldSessionUser : SessionUserVO;
		public var newSessionUser : SessionUserVO;
		public var sessionId:int;
		public var listUser:ArrayCollection;
		
		// constructor
		public function SessionUserEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
		public override function toString() : String
		{ return "events.SessionUserEvent"; }
	}
}