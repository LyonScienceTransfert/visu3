package  com.ithaca.visu.events
{
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		// constants
		static public const LOAD_LIST_USERS_SESSION : String = 'loadListUsersSession';
		static public const LOAD_USERS : String = 'loadUsers';
		static public const LOADED_ALL_USERS : String = 'loadedAllUsers';
		static public const UPDATE_USER : String = 'updateUser';
		static public const ADD_USER : String = 'addViewUser';
		static public const DELETE_USER : String = 'deleteViewUser';
		static public const SELECTED_USER : String = 'selectedUser';
		
		// properties
		public var sessionId : int;
		public var sessionDate : String;
		public var user : User;
		public var userVO: UserVO;
		public var listUser:Array;
		
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