package  com.ithaca.visu.events
{
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		// constants
		static public const LOAD_LIST_USERS_SESSION : String = 'loadListUsersSession';
		
		// properties
		public var sessionId : int;
		public var sessionDate : String;
		
		// constructor
		public function UserEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
		public override function toString() : String
		{ return "events.UserEvent"; }
	}
}