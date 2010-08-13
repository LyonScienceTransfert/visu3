package business
{
	public class RetrospectionManager
	{
		private var logger : ILogger = Log.getLogger('TutoratManager');
		
		private var dispatcher:IEventDispatcher;
		
		public function RetrospectionManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function error(event:Object):void
		{
			
		}
	}
}