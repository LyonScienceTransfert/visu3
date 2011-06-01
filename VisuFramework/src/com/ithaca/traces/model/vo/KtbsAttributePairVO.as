package com.ithaca.traces.model.vo
{

	public class KtbsAttributePairVO
	{
		[RemoteClass(alias="com.ithaca.domain.model.KtbsAttributePair")]
		[Bindable]
		public var attributeType:String;
		public var value:Object;
	}
}