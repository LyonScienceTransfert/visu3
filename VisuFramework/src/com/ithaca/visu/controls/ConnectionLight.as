package com.ithaca.visu.controls
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("connected")]
	[SkinState("disconnected")]
	[SkinState("pending")]
	public class ConnectionLight extends SkinnableComponent
	{
		
		private var _status:ConnectionStatus;
		public function get status():ConnectionStatus
		{
			return _status;
		}
		public function set status(value:ConnectionStatus):void
		{
			_status = value;
			invalidateSkinState();
		}
		
		public function ConnectionLight()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String
		{
			if( _status == ConnectionStatus.CONNECTED)
				return "connected";
			
			if( _status == ConnectionStatus.PENDING)
				return "pending";
		
			return "disconnected";
		}
		
	}
}