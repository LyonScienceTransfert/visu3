package  com.ithaca.visu.events
{
	import com.lyon2.visu.model.User;
	
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		// constants
		static public const LOAD_LIST_USERS_SESSION : String = 'loadListUsersSession';
		static public const LOAD_USERS : String = 'loadUsers';
		// properties
		public var sessionId : int;
		public var sessionDate : String;
		public var user : User;
		
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