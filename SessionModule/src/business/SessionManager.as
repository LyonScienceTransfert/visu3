package business
{
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.visu.model.Model;
	import com.ithaca.visu.model.User;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class SessionManager
	{

		private var dispatcher:IEventDispatcher;
		
		public var model:Model; 
		
		public function SessionManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function onError():void{
			
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