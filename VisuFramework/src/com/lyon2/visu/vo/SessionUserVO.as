package com.lyon2.visu.vo 
{
	[RemoteClass(alias="com.lyon2.visu.domain.model.SessionUser")]
	[Bindable]
	public class SessionUserVO
	{
		public var id_session_user:int;
		public var id_session:int;
		public var id_user:int;
		public var mask:int;
				
	}

}
