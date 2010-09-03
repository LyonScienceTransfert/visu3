package com.lyon2.visu.model
{
	import mx.utils.URLUtil;

	public class ServerInfo
	{
		protected var protocol : String 	= "http"
		protected var server : String 		= "localhost"; 
		protected var webapp : String 		= "visu2";
		protected var defaultRoom: String 	= "";
		
		protected var _rtmpServer:String;
		protected var _amfGateway:String;
		
		
		public function ServerInfo(url:String="")
		{
			//reading server and port number
			if(URLUtil.getServerNameWithPort(url) != "")
				server = URLUtil.getServerName(url)
			 
			//Reading webapp name
			var ar:Array = url.match(/\/(\w+)\/\w.swf/);
			if (ar) webapp = ar[1];
			
			_rtmpServer = "rtmp://"+server+"/"+webapp+defaultRoom;
			_amfGateway = protocol+"://"+server+"/"+webapp+"/"+defaultRoom+"/gateway";
		}
		
		public function get rtmpServer():String{ return _rtmpServer;}
		public function get amfGateway():String{ return _rtmpServer;}
		
		public function toString():String
		{
			return "Class ServerInfo\n\t>>"+_rtmpServer+"\n\t>>"+_amfGateway; 
		}
	}
}