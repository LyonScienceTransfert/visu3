package com.lyon2.visu.model
{
	
	public class ActivityElement
	{
		public var id_element:int;
		public var id_activity:int;
		public var data:String;
		public var url_element:String;
		public var type_element:String;
		public var type_mime:String;
			
		public function ActivityElement(value:Object)
		{
			this.id_element = value.id_element;
			this.id_activity = value.id_activity;
			this.data = value.data;
			this.url_element = value.url_element;
			this.type_element = value.type_element;
			this.type_mime = value.type_mime;
		}
	}
}