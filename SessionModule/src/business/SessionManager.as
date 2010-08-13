package business
{
	import flash.events.IEventDispatcher;

	public class SessionManager
	{

		private var dispatcher:IEventDispatcher;
		
		public function SessionManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function onError():void{
			
		}

	}
}