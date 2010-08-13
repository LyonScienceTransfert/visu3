package com.lyon2.visu.vo 
{
	[RemoteClass(alias="com.lyon2.visu.domain.model.User")]
	[Bindable]
	public class UserVO
	{
		
		public var id_user:int;
		public var lastname:String;
		public var firstname:String;
		public var mail:String;
		public var password:String;
		public var activation_key:String;
		public var recovery_key:String;
		public var avatar:String;
		public var profil:String;
		
	}
}
