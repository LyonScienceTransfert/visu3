package com.ithaca.traces.model.vo
{
	public class KtbsObselVO
	{
		[RemoteClass(alias="com.ithaca.domain.model.KtbsObsel")]
		[Bindable]
		
		public var uri:String;
		public var obselType:String;
		public var begin:Number;
		public var beginDT:String;
		public var end:Number
		public var endDT:String;
		public var hasTrace:String;
		public var subject:String;
		public var attributes:Array;
	}
}