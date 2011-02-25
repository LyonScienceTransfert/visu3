package business
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	
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
		
		public function onLoadListUsers(value:Array):void
		{
			var ar:Array = []
			for each (var vo:UserVO in value)
			{
				ar.push(new User(vo)) ;
			}
			
			var onLoadedAllUsers:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOADED_ALL_USERS);
			onLoadedAllUsers.listUser = ar;
			this.dispatcher.dispatchEvent(onLoadedAllUsers);
		}
		
		public function error(event:Object):void
		{
			
		}
	}
}