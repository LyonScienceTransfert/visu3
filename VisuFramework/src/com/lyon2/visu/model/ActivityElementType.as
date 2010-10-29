package com.lyon2.visu.model
{
	public class ActivityElementType
	{
		public static const MEMO 		: String = "memo";
		public static const KEYWORD 	: String = "keyword";
		public static const STATEMENT 	: String = "consigne";
		public static const IMAGE 	    : String = "image";
		public static const VIDEO 	    : String = "video";
		public static const MESSAGE 	: String = "chatMessage";
		public static const MARKER 	    : String = "marker";
		public static const READ_DOCUMENT_IMAGE : String = "readDocumentImage";
		public static const READ_DOCUMENT_VIDEO : String = "readDocumentVideo";
		public static const START_ACTIVITY : String = "startActivity";
		public static const STOP_ACTIVITY : String = "stopActivity";
		
		protected var value:int;
		protected var name:String;
		public static function getStringOfType(type:int):String
		{
			switch (type)
			{
				case 1:
					return ActivityElementType.STATEMENT;
					break;
				case 2:
					return ActivityElementType.KEYWORD;
					break;
				case 3:
					return ActivityElementType.IMAGE;
					break;
				case 4:
					return ActivityElementType.VIDEO;
					break;
				case 5:
					return ActivityElementType.MESSAGE;
					break;
				case 6:
					return ActivityElementType.MARKER;
					break;
				case 7:
					return ActivityElementType.READ_DOCUMENT_IMAGE;
					break;
				case 8:
					return ActivityElementType.READ_DOCUMENT_VIDEO;
					break;
				case 9:
					return ActivityElementType.START_ACTIVITY;
					break;
				case 10:
					return ActivityElementType.STOP_ACTIVITY;
					break;
				default:
					return "void";
					break;
			}
		}
		
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
				case ActivityElementType.IMAGE:
					return 3;
					break;
				case ActivityElementType.VIDEO:
					return 4;
					break;
				case ActivityElementType.MESSAGE:
					return 5;
					break;
				case ActivityElementType.MARKER:
					return 6;
					break;
				case ActivityElementType.READ_DOCUMENT_IMAGE:
					return 7;
					break;
				case ActivityElementType.READ_DOCUMENT_VIDEO:
					return 8;
					break;
				case ActivityElementType.START_ACTIVITY:
					return 9;
					break;
				case ActivityElementType.STOP_ACTIVITY:
					return 10;
					break;
				default:
					return -1;
					break;
			}
		}
	}
}