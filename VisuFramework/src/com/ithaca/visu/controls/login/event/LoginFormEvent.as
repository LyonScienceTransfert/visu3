package com.ithaca.visu.controls.login.event
{
	import com.ithaca.visu.model.vo.UserVO;
	
	import flash.events.Event;
	
	public class LoginFormEvent extends Event
	{
		// constants
		public static const LOGIN:String="onLogin";
		public static const GET_PASSWORD:String="getPassword";
		public static const UPDATE_PASSWORD:String="updatePassword";
		public static const PRE_UPDATE_PASSWORD:String="preUpdatePassword";
		public static const CHECK_ACTIVATED_KEY:String="checkActivatedKey";
		public static const GET_USER_ACTIVATED_KEY:String="getUserActivatedKey";
		public static const UPDATE_PASSWORD_DELETE_ACTIVATED_KEY:String="updatePasswordDeleteActivatedKey";
		public static const SET_PASSWORD:String="setPassword";
		
		// properties
		public var username:String;
		public var password:String;
		public var activatedKey:String;
        public var userVO:UserVO;
        public var userId:int;
        
		public function LoginFormEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}