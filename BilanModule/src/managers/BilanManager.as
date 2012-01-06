package managers
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	
	import flash.events.Event;
	
	import managers.BilanManager;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class BilanManager
	{
		import flash.events.IEventDispatcher;
		
		protected static var log:ILogger = Log.getLogger("managers.BilanManager");
		
		private var dispatcher:IEventDispatcher;
		
		public function BilanManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		/**
		 * Default error Handler for rtmp method call
		 */
		public function onError(event:Event):void
		{
			log.error(event.toString());
		}
		
		public function onOwnedBilanListRetrieved(event:Event):void
		{
			log.info("Owned bilan list retrieved");
		}
		
		
		/**
		 * Default error Handler for rtmp method call
		 */
		public function onSharedBilanListRetrieved(event:Event):void
		{
			log.info("Shared bilan list retrieved");
		}
        
        /**
        * Load list users for share dialog
        */
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
	}
}
