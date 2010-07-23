package com.ithaca.visu.modules
{
	public class ModuleInfo
	{
		public var name:String;
		public var label:String;
		public var url:String;
		public var css:String;
		
		public function get hasStyles():Boolean
		{
			return css != null && (css.lastIndexOf(".css")==css.length-4) ;
		}
	}
}