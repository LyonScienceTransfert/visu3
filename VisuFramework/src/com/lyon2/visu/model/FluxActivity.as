package com.lyon2.visu.model
{
	public class FluxActivity
	{
		public var pathImage:String;
		public var userId:int;
		public var firstname:String;
		public var message:String;
		public var time:String;
		
		public function FluxActivity( id:int, name:String, path:String, message:String, time:String)
		{
			this.pathImage = path;
			this.userId = id;
			this.firstname = name;
			this.message = message;
			this.time = time;
		}
	}
}