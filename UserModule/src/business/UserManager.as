package business
{
	public class UserManager
	{
		import flash.events.IEventDispatcher;
		
		private var dispatcher:IEventDispatcher;
		
		public function HomeManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function error(event:Object):void
		{
			
		}
	}
}