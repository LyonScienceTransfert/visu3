package com.lyon2.utils
{
	public class TimeUnit
	{
		public var value:uint;
		public var short_unit:String;
		public var long_unit:String;
		public function TimeUnit(v:uint=0, s:String="", l:String="")
		{
			value		= v;
			short_unit	= s;
			long_unit	= l;
		}
	}
}