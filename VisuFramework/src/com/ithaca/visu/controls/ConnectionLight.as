package com.ithaca.visu.controls
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
			
	[SkinState("connected")]
	[SkinState("disconnected")]
	[SkinState("pending")]
	[SkinState("recording")]
	public class ConnectionLight extends SkinnableComponent
	{
		private static var logger:ILogger = Log.getLogger("com.ithaca.visu.controls.ConnectionLight");
		
		private var _status:int;
		public function get status():int
		{
			return _status;
		}
		public function set status(value:int):void
		{
			logger.debug("Setting the status to {0}", value);
			_status = value;
			invalidateSkinState();
		}
		
		public function ConnectionLight()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String
		{
			if( _status == ConnectionStatus.CONNECTED) {
				
			logger.debug("Connection light: {0}", "connected");
				return "connected";
			}
			
			if( _status == ConnectionStatus.PENDING) {
				
			logger.debug("Connection light: {0}", "pending");
				return "pending";
			}
		
			if( _status == ConnectionStatus.DISCONNECTED) {
				
			logger.debug("Connection light: {0}", "disconnected");
				return "disconnected";
			}
			
			logger.debug("Connection light: {0}", "recording");
			
			return "recording";
		}
	}
}