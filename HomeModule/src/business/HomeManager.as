package business
{

import com.ithaca.visu.events.SessionEvent;
import com.ithaca.visu.events.UserEvent;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.SessionVO;
import com.ithaca.visu.model.vo.UserVO;

import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;
import mx.logging.ILogger;
import mx.logging.Log;


public class HomeManager
{
	// properties
	
	[Bindable]
	public var connectedUsers : ArrayCollection;

	/*[Bindable]
	public var listSessionDate : ArrayCollection = new ArrayCollection();
	*/
	[Bindable]
	public var fluxActivity : ArrayCollection;
	
	[Bindable]
	public var listSessionView:ArrayCollection;

	
	private var logger : ILogger = Log.getLogger('HomeManager');
	
	private var dispatcher:IEventDispatcher;
	
	// constructor
	public function HomeManager(dispatcher:IEventDispatcher)
	{
		this.dispatcher = dispatcher;
	}

	// methods
	/**
	 * Set user list for a session
	 */ 
	public function onLoadListUsersSession(listUsers: Array, sessionId : int, sessionDate: String):void
	{
		// set users session
	    Model.getInstance().setListUsersSession(listUsers, sessionId);
		
		var sessionEvent:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_SESSION);
		var listSession:ArrayCollection = Model.getInstance().getListSessionByDate(sessionDate);
		
		sessionEvent.listSession = listSession;
		sessionEvent.sessionDate = sessionDate;
		dispatcher.dispatchEvent(sessionEvent);	
	}
	
	/**
	 * init flux activity
	 */ 
	public function getFluxActivity():void{
		// initialisation flux activity
		this.fluxActivity = Model.getInstance().getFluxActivity();
	}


	public function onLoadListUsers(value:Array):void
	{
		var ar:Array = []
		for each (var vo:UserVO in value)
		{
			ar.push(new User(vo));
		}		
		var onLoadedAllUsers:UserEvent = new UserEvent(UserEvent.LOADED_ALL_USERS_SALON_HOME,true);
		onLoadedAllUsers.listUser = ar;
		this.dispatcher.dispatchEvent(onLoadedAllUsers);
	}	
		
	public function onUpdateUser(userVO:UserVO):void
	{
		
	}
	
	public function onError(session:* = null):void
	{
		
	}
}
}