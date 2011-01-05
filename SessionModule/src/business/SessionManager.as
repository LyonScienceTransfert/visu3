package business
{
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;

	public class SessionManager
	{

		private var dispatcher:IEventDispatcher;
		
		protected static var log:ILogger = Log.getLogger("managers.SessionManager");

		public var model:Model; 
		
		[Bindable] 
		public var sessions:Array=[];
		
		public function SessionManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
	
		public function setSessionAndPlan(value:Array):void 
		{ 
			log.debug( ObjectUtil.toString(value));
			var ar:Array = []
			for each (var sessionVO:SessionVO in value)
			{
				var session:Session = new Session(sessionVO);
				session.statusSession
				ar.push(session);   
			}
			sessions = ar;
			log.debug("setSessionAndPlan "+ sessions);
		}
		
		/**
		 * Default error Handler for rtmp method call
		 */
		public function onError(event:Event):void
		{
			log.error(event.toString());
		}
		
		public function notifyOutSession():void
		{
			var loggedUser:User =  model.getLoggedUser();
			var statusLoggedUser:int = loggedUser.status; 
			
			if(statusLoggedUser == ConnectionStatus.CONNECTED)
			{
				model.updateStatusLoggedUser(ConnectionStatus.PENDING);
				var outSession:SessionEvent = new SessionEvent(SessionEvent.OUT_SESSION);
				outSession.userId = loggedUser.id_user;
				dispatcher.dispatchEvent(outSession);
			}
		}
		
	}
}