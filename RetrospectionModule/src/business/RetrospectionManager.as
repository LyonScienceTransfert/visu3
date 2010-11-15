package business
{
	import flash.events.IEventDispatcher;
	import mx.logging.ILogger;
	import mx.logging.Log;

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