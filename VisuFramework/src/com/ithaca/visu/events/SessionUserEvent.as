package  com.ithaca.visu.events
{
	import com.ithaca.visu.model.vo.SessionUserVO;
	
	import flash.events.Event;
	
	
	public class SessionUserEvent extends Event
	{
		// constants
		static public const REMOVE_SESSION_USER : String = 'removeSessionUser';
		static public const UPDATE_SESSION_USER : String = 'updateSessionUser';
		
		// properties
		public var oldSessionUser : SessionUserVO;
		public var newSessionUser : SessionUserVO;
		
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