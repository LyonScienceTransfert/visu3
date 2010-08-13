package com.lyon2.visu.vo
{
	[RemoteClass(alias="com.lyon2.visu.domain.model.Activity")]
	[Bindable] 	
	public class ActivityVO
	{
		public var id_activity:int;
		public var id_session:int;
		public var title:String;
		public var duration:int;
		public var ind:int;
	}
}