package business
{
import com.ithaca.visu.events.SessionEvent;
import com.ithaca.visu.events.VisuModuleEvent;
import com.ithaca.visu.ui.utils.ConnectionStatus;
import com.ithaca.visu.ui.utils.RightStatus;
import com.lyon2.visu.model.Model;
import com.lyon2.visu.model.Session;
import com.lyon2.visu.model.User;
import com.lyon2.visu.vo.SessionUserVO;
import com.lyon2.visu.vo.SessionVO;
import com.lyon2.visu.vo.UserVO;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.net.NetConnection;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.logging.ILogger;
import mx.logging.Log;


public class MainManager
{
	// properties
	
	[Bindable]
	public var connectedUsers : ArrayCollection;

	[Bindable]
	public var dateSession : ArrayCollection = new ArrayCollection();
	
	[Bindable]
	public var fluxActivity : ArrayCollection;
	
	[Bindable]
	public var testSessionUser:SessionUserVO = new SessionUserVO();
	
	[Bindable]
	public var listSessionView:ArrayCollection = new ArrayCollection();
	
	[Bindable]
	private var fxgt:_FxGettext = FxGettext;
	
	[Bindable]
	public var netConnection:NetConnection;

	private var logger : ILogger = Log.getLogger('MainManager');

	private var dispatcher:IEventDispatcher;
	
	// constructor
	public function MainManager(dispatcher:IEventDispatcher)
	{
		this.dispatcher = dispatcher;
	}
	// methods
	
	/**
	 * set logged user
	 * @param
	 * user - 
	 * listModules - list modules for this user according with rights
	 * listSessionToday - will using ?, list session for today
	 */
	public function onSetLoggedUser(user:UserVO, listModules:Array, listSessionToday:Array, profiles:Array):void
	{

		logger.info('onLogin [' + user + ']');
		if (user == null)
		{
			// TODO MESSAGE 
			return;
		}
		// set logged user to the model
		Model.getInstance().setLoggedUser(user);
		
		Model.getInstance().profiles = profiles;
		
		var event:VisuModuleEvent = new VisuModuleEvent(VisuModuleEvent.LOAD_LIST_MODULES);
		event.listModules = listModules;
		dispatcher.dispatchEvent(event);
	}

	/**
 	 * new user connected to the DECK
	 * @param
	 * arg - connected userVO
 	 */
	public function onJoinDeck(arg : Object) : void
	{
		// add connected user to the list connected users end to the list swap users
		var userVO:UserVO = arg as UserVO;
		Model.getInstance().addConnectedUsers(userVO);
		
		// update list user
		var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
		this.dispatcher.dispatchEvent(eventUpdateSessionView);
		
		// add flux activity
		Model.getInstance().addFluxActivity(userVO.id_user,userVO.firstname,userVO.avatar,fxgt.gettext(" a rejoint le DECK "),new Date());
	}
	
	/**
	 * user discconnected, walk out from the DECK
	 * @param
	 * arg - disconnected user
	 */ 
	public function onOutDeck(arg : Object) : void
	{
		var userVO:UserVO = arg as UserVO;
		// remove user from the list connected users
		Model.getInstance().removeConnectedUser(userVO.id_user);
		
		// update list user
		var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
		this.dispatcher.dispatchEvent(eventUpdateSessionView);
		
		// add flix activity
		Model.getInstance().addFluxActivity(userVO.id_user, userVO.firstname, userVO.avatar, fxgt.gettext(" est parti du DECK "),new Date());
		
		// remove stream from TutoratModule
		var oldUserOutSession:SessionEvent = new SessionEvent(SessionEvent.OLD_USER_OUT_SESSION);			
		oldUserOutSession.userId = userVO.id_user;
		this.dispatcher.dispatchEvent(oldUserOutSession);
	}
	
	public function onResivePrivateMessage(message : String, sender: UserVO):void
	{
		Model.getInstance().addFluxActivity(sender.id_user,sender.firstname, sender.avatar,fxgt.gettext("[personnel] ")+message,new Date());		
	} 
	
	public function onResivePublicMessage(message : String, sender: UserVO):void
	{
		Model.getInstance().addFluxActivity(sender.id_user,sender.firstname, sender.avatar,fxgt.gettext("[public] ")+message ,new Date());	
	}	
	/**
	 * set connected users 
	 * @param 
	 * ar - list connected users:UserVO, list client id of the connected users, list status of the connected users
	 */
	public function getConnectedClients(ar:Array):void
	{
		Model.getInstance().setConnectedUsers(ar);
		this.connectedUsers = Model.getInstance().getConnectedUsers();
		// set netConnection
		Model.getInstance().setNetConnection(this.netConnection);
		// FIXME , can get all iformation from the list connected users
		this.dispatcher.dispatchEvent(new Event("clientInfo"));
		// DEBUG
		this.dispatcher.dispatchEvent(new Event("testApp"));
	}
	
	/**
	 * message for user, if someone connected on the DECK with the same identifiants
	 */
	public function onSameUserId():void
	{
		Alert.show(fxgt.gettext("L'utilisateur avec le même identifiant deja connecté sur la platefirme...."),fxgt.gettext("Information"));
	}
	
	/**
	 * notification when start recording session
	 */
	public function onStartRecording():void
	{
		var eventRecordingSession:SessionEvent = new SessionEvent(SessionEvent.START_RECORDING_SESSION);
		dispatcher.dispatchEvent(eventRecordingSession);
	}
	
	
	/**
	 * set client id of logged user
	 */
	public function getClientInfo(ar:Array):void
	{
		var userIdClient:String = ar['id'];
		Model.getInstance().setUserIdClient(userIdClient);		
	}
	
	/**
	 * notification to all connected users for updating list users
	 * @param 
	 * sessionVO
	 * ar - list participants of this session
	 */
	public function onCheckUpdateSession(sessionVO:SessionVO , ar:Array):void{		
		// checking if logged user has this session
		var sessionId:uint = sessionVO.id_session;
		var session:Session = Model.getInstance().hasSessionById(sessionId);
		var loggedUser:User = Model.getInstance().getLoggedUser();
		var loggedUserId:int = loggedUser.id_user;
		if(session){
			session.setUsers(ar);
			// add swap Users
			Model.getInstance().setSwapUsers(session.participants);
			// check if logged user sing out from session and logged user can right 
			if((!session.hasUser(loggedUserId)) && (!RightStatus.hasRight(loggedUser.profil, RightStatus.CAN_MODIFY_OTHER_SESSION)) )
			{
				// delete session from list session 
				var labelDateRemovedSession:String = Model.getInstance().removeSession(sessionVO);
				if(labelDateRemovedSession != "")
				{
					// add flux 
					Model.getInstance().addFluxActivity(userId,user.firstname, user.avatar,fxgt.gettext("a quité la séance : ")+sessionVO.theme, new Date());	
					// notification for removing session
					var eventRemoveSession:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_SESSION);
					// get list sessionDate
					eventRemoveSession.listSession = Model.getInstance().getListSessionByDate(labelDateRemovedSession);
					eventRemoveSession.sessionDate = labelDateRemovedSession;
					dispatcher.dispatchEvent(eventRemoveSession);				
				}
			}
		}else{
			// check if loggedUser in this session
			var nbrUser:uint = ar.length;
			for(var nUser:uint = 0; nUser < nbrUser; nUser++){
				var user:UserVO = ar[nUser];
				var userId:uint = user.id_user;
				if(userId == loggedUserId){
					// add session , add swap users
					var labelDate:String = Model.getInstance().addSession(sessionVO, ar);					
					// add flux 
					Model.getInstance().addFluxActivity(userId,user.firstname, user.avatar,fxgt.gettext("a rejoint la séance : ")+sessionVO.theme, new Date());	
					// notification for adding session
					var event:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_SESSION);
					// get list sessionDate
					event.listSession = Model.getInstance().getListSessionByDate(labelDate);
					event.sessionDate = labelDate;
					dispatcher.dispatchEvent(event);
				}
			}
			// TODO Flux Activity
		}
		// update list user 		
		var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
		this.dispatcher.dispatchEvent(eventUpdateSessionView);
	}
	
	/**
	 * call if user join the session
	 * @param
	 * userVO
	 * userIdClient 
	 */
	public function onJoinSession(userVO:UserVO, userIdClient:String, sessionId:int, status:int):void{
		if(userVO.id_user != Model.getInstance().getLoggedUser().id_user)
		{
			// update status user 
			Model.getInstance().updateStatusUser(userVO, status);
			// update idClient
			Model.getInstance().updateUserIdClient(userVO, userIdClient);
			// update list user
			var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
			this.dispatcher.dispatchEvent(eventUpdateSessionView);
			
			var newUserJoinSessionEvent:SessionEvent = new SessionEvent(SessionEvent.NEW_USER_JOIN_SESSION);			
			newUserJoinSessionEvent.userId = userVO.id_user;
			newUserJoinSessionEvent.userIdClient = userIdClient;
			newUserJoinSessionEvent.sessionId = sessionId;
			newUserJoinSessionEvent.status = status;
			this.dispatcher.dispatchEvent(newUserJoinSessionEvent);		
		}else
		{
			// check if session in mode recording
			
		}
	}
	
	/**
	 * set status recording
	 * @param
	 * userVO
	 * userIdClient 
	 */
	public function onSetStatusRecording(userId:int, status:int):void{
		if(userId != Model.getInstance().getLoggedUser().id_user)
		{
			// FIXME : have to fine other solution
			var userVO:UserVO = new UserVO();
			userVO.id_user = userId;
			// update status user 
			Model.getInstance().updateStatusUser(userVO, status);
			// update list user
			var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
			this.dispatcher.dispatchEvent(eventUpdateSessionView);	
		}
	}
	
	
	/**
	 *  call if user walk out from session
	 * @param
	 * userVO
	 * status
	 */
	public function onOutSession(userVO:UserVO, status:int):void
	{
		// update status user 
		Model.getInstance().updateStatusUser(userVO, status);
		// update list user
		var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
		this.dispatcher.dispatchEvent(eventUpdateSessionView);
		
		var oldUserOutSession:SessionEvent = new SessionEvent(SessionEvent.OLD_USER_OUT_SESSION);			
		oldUserOutSession.userId = userVO.id_user;
		this.dispatcher.dispatchEvent(oldUserOutSession);
		
	}
	public function onError(event : Object) : void
	{
		
	}

	public function toString() : String
	{ return 'MainManager'; }
	
	public function testParams(... rest):void
	{
		trace("testParams")
		for each( var o:Object in rest)
		trace("++ " + o);	
	}
	
}
}