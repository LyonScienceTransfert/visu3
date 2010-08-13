package com.ithaca.visu.modules
{
	[RemoteClass(alias="com.lyon2.visu.domain.model.Module")]
	public class ModuleInfo
	{
		public var name:String;
		public var label:String;
		public var url:String;
		public var css:String;
		public var profileUser:int;
		[Transine]
		public function get hasStyles():Boolean
		{
			return css != null && (css.lastIndexOf(".css")==css.length-4) ;
		}
	}
}