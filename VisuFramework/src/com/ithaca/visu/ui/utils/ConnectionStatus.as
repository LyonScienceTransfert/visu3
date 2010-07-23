package com.ithaca.visu.ui.utils
{
	public class ConnectionStatus
	{
		public static const CONNECTED:ConnectionStatus = new ConnectionStatus(0);
		public static const DISCONNECTED:ConnectionStatus = new ConnectionStatus(1);
		public static const PENDING:ConnectionStatus = new ConnectionStatus(2);
		
		private var value:int;
		
		public function ConnectionStatus(value:int)
		{
			this.value = value;
		}
		
		public function valueOf():int
		{
			return value;	
		}
		public function toString():String
		{
			
			return value==0 
				? "connected " 
				: (value == 1)
					? "disconnected"
					: "pending" ;
		}
	}
}