package com.ithaca.utils
{
	public class XMLUtils
	{
		private static var QUOT:String = "&quot;";
		private static var APOS:String = "&apos;";
		private static var LEFT_TAG:String = "&lt;";
		private static var RIGHT_TAG:String = "&gt;";
		private static var AMP:String = "&amp;";
		private static var SLASH:String = "&#47;";
		private static var BACK_SLASH:String = "&#92;";
		
		
		private static var quot:RegExp = new RegExp('"',"g");
		private static var apos:RegExp = new RegExp("'","g");
		private static var leftTag:RegExp = new RegExp("<","g");
		private static var rightTag:RegExp = new RegExp(">","g");
		private static var amp:RegExp = new RegExp("&","g");
		private static var slash:RegExp = new RegExp("/","g");
		private static var backSlash:RegExp = new RegExp("\\","g");
		
		public static function toXMLString(value:String):String
		{
			value = value.replace(amp,AMP);
			value = value.replace(apos,APOS);
			value = value.replace(leftTag,LEFT_TAG);	
			value = value.replace(rightTag,RIGHT_TAG);
			value = value.replace(slash,SLASH);
			value = value.replace(backSlash,BACK_SLASH);
			value = value.replace(quot,QUOT);
			return value;
		}

	}
}