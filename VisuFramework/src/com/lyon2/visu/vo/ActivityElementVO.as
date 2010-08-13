package com.lyon2.visu.vo
{
	[RemoteClass(alias="com.lyon2.visu.domain.model.ActivityElement")]
	[Bindable] 	
	public class ActivityElementVO
	{
		public var id_element:int;
		public var id_activity:int;
		public var data:String;
		public var url_element:String;
		public var type_element:String;
		public var type_mime:String;
		
	}
}