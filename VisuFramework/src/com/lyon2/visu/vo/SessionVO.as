package com.lyon2.visu.vo
{
	[RemoteClass(alias="com.lyon2.visu.domain.model.Session")]
	[Bindable]	
	public class SessionVO
	{
			public var id_session:int;
			public var id_user:int;
			public var theme:String;
			public var date_session:Date;
			public var isModel:Boolean;
			public var description:String;
			public var start_recording:Date;
			public var status_session:int;
	}
}