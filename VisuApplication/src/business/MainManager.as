package business
{
import com.ithaca.traces.Obsel;
import com.ithaca.traces.model.TraceModel;
import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
import com.ithaca.visu.events.SessionEvent;
import com.ithaca.visu.events.SessionSharedEvent;
import com.ithaca.visu.events.UserEvent;
import com.ithaca.visu.events.VisuActivityEvent;
import com.ithaca.visu.events.VisuModuleEvent;
import com.ithaca.visu.ui.utils.ColorEnum;
import com.ithaca.visu.ui.utils.ConnectionStatus;
import com.ithaca.visu.ui.utils.RightStatus;
import com.ithaca.visu.ui.utils.SessionStatusEnum;
import com.lyon2.visu.model.Model;
import com.lyon2.visu.model.Session;
import com.lyon2.visu.model.User;
import com.lyon2.visu.vo.ObselVO;
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
		fxgt = FxGettext;
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
		// remove stream from TutoratModule
		var oldUserOutSession:SessionEvent = new SessionEvent(SessionEvent.OLD_USER_OUT_SESSION);	
		oldUserOutSession.userId = userVO.id_user;
		oldUserOutSession.userIdClient = Model.getInstance().getIdClient(userVO.id_user);
		this.dispatcher.dispatchEvent(oldUserOutSession);
		
		// remove user from the list connected users
		Model.getInstance().removeConnectedUser(userVO.id_user);
		
		// update list user
		var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
		this.dispatcher.dispatchEvent(eventUpdateSessionView);
		
		// add flix activity
		Model.getInstance().addFluxActivity(userVO.id_user, userVO.firstname, userVO.avatar, fxgt.gettext(" est parti du DECK "),new Date());
		
	}
	
	public function onResivePrivateMessage(message : String, sender: UserVO):void
	{
		Model.getInstance().addFluxActivity(sender.id_user,sender.firstname, sender.avatar,fxgt.gettext("[personnel] ")+message,new Date());		
	} 
	
	public function onResivePublicMessage(message : String, sender: UserVO):void
	{
		Model.getInstance().addFluxActivity(sender.id_user,sender.firstname, sender.avatar,fxgt.gettext("[public] ")+message ,new Date());	
	}	

	public function onCheckListDates(listDate : Array):void
	{
		var eventListDate:SessionEvent = new SessionEvent(SessionEvent.SHOW_LIST_DATE_SESSION);
		eventListDate.listDate = listDate;
		dispatcher.dispatchEvent(eventListDate);
	}	
	
	public function onCheckListSession(listSession : Array, sessionDate: String):void
	{
		var eventListSession:SessionEvent = new SessionEvent(SessionEvent.SHOW_LIST_SESSION);
		eventListSession.listDate = listSession;
		eventListSession.sessionDate = sessionDate;
		dispatcher.dispatchEvent(eventListSession);	
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
	public function onStartRecording(timeStart:Number):void
	{
		var eventRecordingSession:SessionEvent = new SessionEvent(SessionEvent.START_RECORDING_SESSION);
		eventRecordingSession.timeStartStop = timeStart;
		dispatcher.dispatchEvent(eventRecordingSession);
	}
	
	/**
	 * notification when start recording session
	 */
	public function onStopRecording(timeStop:Number):void
	{
		var eventStopSession:SessionEvent = new SessionEvent(SessionEvent.STOP_RECORDING_SESSION);
		eventStopSession.timeStartStop = timeStop;
		dispatcher.dispatchEvent(eventStopSession);
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
	 * get list obsels "SessionExit", "SessionPause" for updating button "Salon Tutorat"
	 */
	public function onCheckListObselSessionExitSessionPause(listObselVO:Array):void
	{
		var nbrObsel:int = listObselVO.length;
		if(nbrObsel > 0)
		{
			var lastObselVO:ObselVO = listObselVO[nbrObsel-1];
			var lastObsel:Obsel = Obsel.fromRDF(lastObselVO.rdf);
			// last sessionId
			var sessionId:int = lastObsel.props[TraceModel.SESSION_ID];
			var sessionEvent:SessionEvent = new SessionEvent(SessionEvent.GET_SESSION);
			sessionEvent.sessionId = sessionId;
			this.dispatcher.dispatchEvent(sessionEvent);
		}
	}
	/**
	 * get last visited session in the salon tutorat
	 */
	public function onCheckLastSession(sessionVO:SessionVO):void
	{
		if(sessionVO != null)
		{
			var session:Session = new Session(sessionVO);
			var sessionStatus:int = session.statusSession;
			if(sessionStatus != SessionStatusEnum.SESSION_CLOSE)
			{
				// set current session
				Model.getInstance().setCurrentSession(session);
				// set button enabled true;
				Model.getInstance().setEnabledButtonSalonSynchrone(true);
			}
		}
		
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
		var dateSession:Date = sessionVO.date_session;
		var promtDeLeString:String = " de "+dateSession.getHours().toString()+":"+dateSession.getMinutes().toString()+" le "+dateSession.getDate().toString()+"."+(dateSession.getMonth()+1).toString()+"."+dateSession.getFullYear().toString();
		// FIXME : if user hasn't session of the date(user just looking on the list date of session and don't choose any date),
	    // and at this moment responsable will "désinscrit" user from the session => the date will stay on his liste  the date .....
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
					var hasLoggedUserInSession:Boolean = false;
					var nbrUser:uint = ar.length;
					for(var nUser:uint = 0; nUser < nbrUser; nUser++){
						var user:UserVO = ar[nUser];
						var userId:uint = user.id_user;
						if(userId == loggedUserId){
							hasLoggedUserInSession = true;
						}
					}
					if(!hasLoggedUserInSession)
					{
						Model.getInstance().addFluxActivity(loggedUserId,loggedUser.firstname, loggedUser.avatar,fxgt.gettext("A été désinscrit de la séance: ")+sessionVO.theme+promtDeLeString, new Date());		
					}
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
					Model.getInstance().addFluxActivity(userId,user.firstname, user.avatar,fxgt.gettext("A été inscrit à la séance: ")+sessionVO.theme+promtDeLeString, new Date());	
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
	 *  Get list obsel for salon synchrone
	 */
	public function onCheckListActiveObsel(listObselVO:Array):void
	{		
		var listObsel:ArrayCollection = null;
		if(!(listObselVO == null || listObselVO.length == 0))
		{
			listObsel = new ArrayCollection();
			var firstObselVO:ObselVO = listObselVO[0] as ObselVO;
			var typeFirstObselVO:String = firstObselVO.type;
			var firstObsel:Obsel = null;
			if(typeFirstObselVO == TraceModel.SESSION_START || typeFirstObselVO == TraceModel.SESSION_ENTER)
			{
				firstObsel = Obsel.fromRDF(firstObselVO.rdf);
				// add presents users(id, name, avatar, color) from start the session
				this.addPresentUsers(firstObsel);	
				//Model.getInstance().setBeginTimeSalonSynchrone(firstObsel.begin);
			}else
			{
				Alert.show('Probleme avec le trace activities, premier obsel != SessionStart/SessionEnter',"");	
			}

			// exit from session 
			var stopTimeSessionMsec:Number;
			var startTimeSessionMsec:Number;
			var activityStartId:int = 0;
			var nbrObsels:int = listObselVO.length;
			// try start finding obsel exclus first obsel => nObsel = 1; 
			for(var nObsel:int = 1;nObsel < nbrObsels; nObsel++)
			{
				var obselVO:ObselVO = listObselVO[nObsel] as ObselVO;
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				var typeObsel:String = obsel.type;
				switch (typeObsel){
					case TraceModel.SEND_CHAT_MESSAGE:
					case TraceModel.RECEIVE_CHAT_MESSAGE:
					case TraceModel.SET_MARKER:
					case TraceModel.RECEIVE_MARKER:
					case TraceModel.SEND_KEYWORD:
					case TraceModel.RECEIVE_KEYWORD:
					case TraceModel.SEND_INSTRUCTIONS:
					case TraceModel.RECEIVE_INSTRUCTIONS:
					case TraceModel.SEND_DOCUMENT:
					case TraceModel.RECEIVE_DOCUMENT:
					case TraceModel.READ_DOCUMENT:
						listObsel.addItem(obsel);
						break;
					case TraceModel.SESSION_EXIT:
						var uid:int = int(obsel.props[TraceModel.UID]);
						if (uid == Model.getInstance().getLoggedUser().id_user)
						{
							stopTimeSessionMsec = obsel.begin;
						}
						break;
					case TraceModel.SESSION_PAUSE:
						stopTimeSessionMsec = obsel.begin;
						break;
					case TraceModel.SESSION_ENTER:
						// add obsel SessionOut
						var uid:int = int(obsel.props[TraceModel.UID]);
						if(uid == Model.getInstance().getLoggedUser().id_user)
						{
							startTimeSessionMsec = obsel.begin;
							var obselOutSession:Obsel = new Obsel(TraceModel.SESSION_OUT);
							obselOutSession.begin = stopTimeSessionMsec;
							obselOutSession.end = startTimeSessionMsec;
							obselOutSession.uid = uid;	
							listObsel.addItem(obselOutSession);
						}
						// add presents users(id, name, avatar, color)
						this.addPresentUsers(obsel);
						break;
					case TraceModel.ACTIVITY_START:
						activityStartId = int(obsel.props[TraceModel.ACTIVITY_ID]);
						break;
					case TraceModel.ACTIVITY_STOP:
						activityStartId = 0;
						break;
					
				}
				
			}
			
		}
		Model.getInstance().setListObsel(listObsel);
		this.dispatcher.dispatchEvent(new SessionEvent(SessionEvent.LOAD_LIST_OBSEL));
		// update current activity in TutoratModule
		if(activityStartId != 0)
		{
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.UPDATE_ACTIVITY);
			visuActivityEvent.activityId = activityStartId;
			this.dispatcher.dispatchEvent(visuActivityEvent);
		}
	}
	
	/**
	 *  Get list obsel StartSession EnterSession for salon retrospection 
	 */
	public function onCheckListObselStartSession(listObselVO:Array):void
	{
		
	}
	
	/**
	 * Add TraceLines to Model
	 */
	private function addPresentUsers(obsel:Obsel):void
	{
		var listPresents:Array = obsel.props[TraceModel.PRESENT_IDS] as Array;
		var listNames:Array  = obsel.props[TraceModel.PRESENT_NAMES] as Array;
		var listAvatars:Array  = obsel.props[TraceModel.PRESENT_AVATARS] as Array;
		var listColors:Array  = obsel.props[TraceModel.PRESENT_COLORS] as Array;
		var listColorsCode:Array  = obsel.props[TraceModel.PRESENT_COLORS_CODE] as Array;
		var nbrPresents:int = listPresents.length;
		for(var nPresent:int = 0 ; nPresent < nbrPresents ; nPresent++)
		{
			var userId:int = listPresents[nPresent];
			var userName:String = listNames[nPresent];
			var userAvatar:String = listAvatars[nPresent];
			var userColor:String = listColors[nPresent];
			var code:String = listColorsCode[nPresent];
			var userColorCode:String =  ColorEnum.getColorByCode(code);
			Model.getInstance().addTraceLine(userId, userName, userAvatar, userColorCode);
		}
	}
	
	/**
	 * call if user join the session
	 * @param
	 * userVO
	 * userIdClient 
	 */
	public function onJoinSession(userVO:UserVO, userIdClient:String, sessionId:int, status:int):void{
			// update status user 
			Model.getInstance().updateStatusUser(userVO, status, sessionId);
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
	}
	
	/**
	 * set status recording
	 * @param
	 * userVO
	 * userIdClient 
	 */
	public function onSetStatusRecording(userId:int, status:int, sessionId:int, startRecording:Date, obselVO:ObselVO):void{
			// FIXME : have to fine other solution
			var userVO:UserVO = new UserVO();
			userVO.id_user = userId;
			// update status user 
			Model.getInstance().updateStatusUser(userVO, status , sessionId);
			// update status session, "recording"
			var session:Session = Model.getInstance().getCurrentSession();
/*			if(session == null)
			{
				Alert.show("You have a problem with setting the current session !!!","information")
			}*/
			if(sessionId == session.id_session)
			{
				// set time begin in the salon synchrone only if the session start recording
				// session started, have to set time the startRecording, not begin the obsel 
				// FIXME : now we getting start recording time from current session
				Model.getInstance().setBeginTimeSalonSynchrone(startRecording.time);
				session.statusSession = SessionStatusEnum.SESSION_RECORDING; 
				// NOTE : startRecording will be null only if user join session after start recording event, other user ready has date the start session
				if(startRecording != null)
				{
					session.date_start_recording = startRecording; 
				}
				
				if(obselVO != null)
				{
				// have to add new traceLine and update the model, list obsel of this user is empty
					var obsel:Obsel = Obsel.fromRDF(obselVO.rdf); 
					this.addPresentUsers(obsel);
					var eventUpdateviewTraceLine:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_VIEW_TRACELINE);
					eventUpdateviewTraceLine.userId = userId;
					this.dispatcher.dispatchEvent(eventUpdateviewTraceLine);
				}
			}
			// update list user
			var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
			this.dispatcher.dispatchEvent(eventUpdateSessionView);	
	}

	/**
	 * set status stop/pause
	 * @param
	 * userVO
	 * userIdClient 
	 */
	public function onSetStatusStop(userId:int, status:int, sessionId:int, sessionStatus:int):void{
			// FIXME : have to fine other solution
			var userVO:UserVO = new UserVO();
			userVO.id_user = userId;
			// update status user 
			Model.getInstance().updateStatusUser(userVO, status , sessionId);
			// update status session "Pause"
			var session:Session = Model.getInstance().hasSessionById(sessionId);
			if(session != null)
			{
				// status can be close/pause
				session.statusSession = sessionStatus;
				// check if session close
				if(sessionStatus == SessionStatusEnum.SESSION_CLOSE)
				{
					// notification to logged user closing session by other user
					var closeSessionEvent:SessionEvent = new SessionEvent(SessionEvent.CLOSE_SESSION);
					this.dispatcher.dispatchEvent(closeSessionEvent);
				}
			}
			// update list user
			var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
			this.dispatcher.dispatchEvent(eventUpdateSessionView);	
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
		Model.getInstance().updateStatusUser(userVO, status , 0);
		// update list user
		var eventUpdateSessionView:SessionEvent = new SessionEvent(SessionEvent.UPDATE_LIST_USER);
		this.dispatcher.dispatchEvent(eventUpdateSessionView);
		
		var oldUserOutSession:SessionEvent = new SessionEvent(SessionEvent.OLD_USER_OUT_SESSION);	
		oldUserOutSession.userIdClient = Model.getInstance().getIdClient(userVO.id_user);
		oldUserOutSession.userId = userVO.id_user;
		this.dispatcher.dispatchEvent(oldUserOutSession);	
	}
	
	/**
	 *  call when user receive dhared info
	 * @param
	 * 
	 * 
	 */
	public function onCheckSharedInfo(typeInfo:int, info:String, senderUserId:int, urlElement:String, obselVO:ObselVO):void
	{	
		var sessionSharedEvent:SessionSharedEvent = new SessionSharedEvent(SessionSharedEvent.RECEIVE_SHARED_INFO);	
		sessionSharedEvent.typeInfo = typeInfo;
		sessionSharedEvent.info = info;
		sessionSharedEvent.senderUserId = senderUserId;		
		sessionSharedEvent.url = urlElement;	
		// TODO : can make simple
		sessionSharedEvent.obselVO = obselVO;		
		this.dispatcher.dispatchEvent(sessionSharedEvent);	
	}
	
	
	public function onError(event : Object) : void
	{
		var closeConnetionEvent:ApplicationMenuEvent = new ApplicationMenuEvent(ApplicationMenuEvent.CLOSE_CONNECTION);
		this.dispatcher.dispatchEvent(closeConnetionEvent);
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