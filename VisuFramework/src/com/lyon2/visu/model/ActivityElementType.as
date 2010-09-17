package com.lyon2.visu.model
{
	public class ActivityElementType
	{
		public static const MEMO 		: String = "memo";
		public static const KEYWORD 	: String = "keyword";
		public static const STATEMENT 	: String = "consigne";
		public static const DOCUMENT 	: String = "document";
		
		protected var value:int;
		protected var name:String;
		
		public static function valueOf(value:String):int
		{
			switch (value)
			{
				case ActivityElementType.STATEMENT:
					return 1;
					break;
				case ActivityElementType.KEYWORD:
					return 2;
					break;
				case ActivityElementType.DOCUMENT:
					return 3;
					break;
				default:
					return -1;
					break;
			}
		}
	}
}