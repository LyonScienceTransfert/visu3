package com.lyon2.visu.model
{
	import mx.collections.IList;

	[RemoteClass(alias="com.lyon2.visu.domain.model.Session")]
	
	[Bindable]	
	public class Session
	{

			public var id_session:int = 10;
			public var id_user:int = 4;
			public var theme:String= "T-----TOK";
			public var date_session:Date;
			public var isModel:Boolean = false;
			public var description:String = "sdsdsdsds";
			public var participants:IList;
	}
}