package  com.ithaca.visu.events
{
	import com.lyon2.visu.model.Session;
	import com.lyon2.visu.model.User;
	
	import flash.events.Event;
	
	public class SessionHomeElementEvent extends Event
	{
		// constants
		static public const CHANGE_SESSION_USER : String = 'changeSessionUser';
		static public const CLICK_ACTION_LOGGED_USER : String = 'clickActionLoggedUser';
		static public const ACTION_CANCEL_SESSION : String = 'actionCancelSession';
		static public const ACTION_EDIT_SESSION : String = 'actionEditSession';
		static public const ACTION_JOIN_SESSION : String = 'actionJoinSession';
		
		// properties
		public var oldSessionUser:User;
		public var newSessionUser:User;
		public var session:Session;
		public var typeAction:String
		
		// constructor
		public function SessionHomeElementEvent(type : String,
										 bubbles : Boolean = true,
										 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
		public override function toString() : String
		{ return "events.SessionHomeElementEvent"; }
	}
}