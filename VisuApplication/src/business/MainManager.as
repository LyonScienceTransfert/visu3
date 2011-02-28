package business
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.RetroDocument;
import com.ithaca.traces.Obsel;
import com.ithaca.traces.model.TraceModel;
import com.ithaca.utils.UtilFunction;
import com.ithaca.utils.XMLUtils;
import com.ithaca.visu.controls.globalNavigation.event.ApplicationMenuEvent;
import com.ithaca.visu.events.SessionEvent;
import com.ithaca.visu.events.SessionSharedEvent;
import com.ithaca.visu.events.VisuActivityEvent;
import com.ithaca.visu.events.VisuModuleEvent;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.Session;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.ObselVO;
import com.ithaca.visu.model.vo.RetroDocumentVO;
import com.ithaca.visu.model.vo.SessionUserVO;
import com.ithaca.visu.model.vo.SessionVO;
import com.ithaca.visu.model.vo.UserVO;
import com.ithaca.visu.ui.utils.ColorEnum;
import com.ithaca.visu.ui.utils.RightStatus;
import com.ithaca.visu.ui.utils.SessionStatusEnum;

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
	
	private var MIN_DURATION_OBSEL_SESSION_OUT:Number = 1000;
	
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
		Model.getInstance().addFluxActivity(userVO.id_user,userVO.firstname,userVO.avatar,fxgt.gettext(" a rejoint Visu "),new Date());
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
		Model.getInstance().addFluxActivity(userVO.id_user, userVO.firstname, userVO.avatar, fxgt.gettext(" a quitté Visu "),new Date());
		
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
	 * check list date of the session in format string
	 * it's easy than control UTC time localy. 
	 */
	public function onCheckListDates(listDateString:Array):void
	{
		var eventListDate:SessionEvent = new SessionEvent(SessionEvent.SHOW_LIST_DATE_SESSION);
		eventListDate.listDate = listDateString;
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
		Alert.show(fxgt.gettext("Un utilisateur ayant le même identifiant est déjà connecté sur la plate-forme"),fxgt.gettext("Information"));
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
		var timeServeurString:String = ar['timeNumber'];
		var timeServeur:Number = new Number(timeServeurString);		
		Model.getInstance().setTimeServeur(timeServeur);
	}
	/**
	 * get list RetroDocuments 
	 */
	public function onCheckListRetroDocument(listRetroDocumentOwner:Array, listRetroDocumentShared:Array):void
	{
		var myRetroDocumentNodes:XML = new XML("<myDocument title='Mes bilans'/>");
		for each(var retroDocumentVO:RetroDocumentVO in listRetroDocumentOwner)
		{
			var createur:String = Model.getInstance().getLoggedUser().lastname;
			createur = XMLUtils.toXMLString(createur);
			var titre:String = XMLUtils.toXMLString(retroDocumentVO.title);
			var date:String = UtilFunction.getLabelDate(retroDocumentVO.creationDate,"/");
			var id:String = retroDocumentVO.documentId.toString();
			var nodeString:String = "<retroDocument creator='"+createur+"' title='"+titre+"' date='"+date+"' documentId='"+id+"' editabled='true'/>";
			var retroDocumentNode:XML = new XML(nodeString);
			myRetroDocumentNodes.appendChild(retroDocumentNode);
		}
		var shareRetroDocumentNodes:XML = new XML("<node title='Bilans des autres'/>");
		for each(var shareRetroDocumentVO:RetroDocumentVO in listRetroDocumentShared)
		{
			var createurUser:User = Model.getInstance().getUserPlateformeByUserId(shareRetroDocumentVO.ownerId);
			var createur:String = XMLUtils.toXMLString(createurUser.lastname);
			var titre:String = createur = XMLUtils.toXMLString(shareRetroDocumentVO.title);
			var date:String = UtilFunction.getLabelDate(shareRetroDocumentVO.creationDate,"/");
			var id:String = shareRetroDocumentVO.documentId.toString();
			var nodeString:String = "<node creator='"+createur+"' title='"+titre+"' date='"+date+"' documentId='"+id+"' editabled='false'/>";
			var shareRetroDocumentNode:XML = new XML(nodeString);
			shareRetroDocumentNodes.appendChild(shareRetroDocumentNode);
		}
		var xmlNode:XML = new XML("<node title='Bilans'/>");
		xmlNode.appendChild(myRetroDocumentNodes);
		xmlNode.appendChild(shareRetroDocumentNodes);
		var loadTreeRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOAD_TREE_RETRO_DOCUMENT);
		/*		var str:String = " <node title='Bilans'><node title='Mes bilans'><node creator='Damien' title='Mon bilan perso' date='23/02/2011' documentId='1'/>"+
                    "<node creator='Damien' title='Toto à la montagne' date='24/02/2011' documentId='2'/>"+
                "</node>"+
                "<node title='Bilans des autres'>"+
                   " <node creator='Serguei' title='Toto à la montagne' date='24/02/2011'  documentId='4'/>"+
                    "<node creator='Nicolas' title='Toto à la mer' date='27/02/2011'  documentId='5'/>"+
                "</node></node>";
		var xml:XML = new XML(str);*/
		loadTreeRetroDocumentEvent.xmlTreeRetroDocument = xmlNode;
		this.dispatcher.dispatchEvent(loadTreeRetroDocumentEvent);
	}
	
	public function onCheckRetroDocument(retroDocumentVO:RetroDocumentVO, listInvitees:Array, editabled:Boolean):void
	{
		var retroDocument:RetroDocument = new RetroDocument();
		retroDocument.setRetroDocumentXML(retroDocumentVO.xml);
		retroDocument.sessionId = retroDocumentVO.sessionId;
		retroDocument.id = retroDocumentVO.documentId;
		retroDocument.ownerId = retroDocumentVO.ownerId;		
		var retroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.SHOW_RETRO_DOCUMENT);
		retroDocumentEvent.retroDocument = retroDocument;
		retroDocumentEvent.listUser = listInvitees;
		retroDocumentEvent.editabled = editabled;
		this.dispatcher.dispatchEvent(retroDocumentEvent);
	}
	/**
	 * get notify updated retroDocument by owner, in this case logged user is shared for this document 
	 */
	public function onCheckUpdateRetroDocument(retroDocumentVO:RetroDocumentVO, listInvitees:Array):void
	{
		// TODO check if logged user looking for this document
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
						Model.getInstance().addFluxActivity(loggedUserId,loggedUser.firstname, loggedUser.avatar,fxgt.gettext("A été désinscrit de la séance : ")+sessionVO.theme+promtDeLeString, new Date());		
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
					Model.getInstance().addFluxActivity(userId,user.firstname, user.avatar,fxgt.gettext("A été inscrit à la séance : ")+sessionVO.theme+promtDeLeString, new Date());	
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
	public function onCheckListActiveObsel(listObselVO:Array, dateStartRecording:Date):void
	{		
		var listObsel:ArrayCollection = null;
		if(!(listObselVO == null || listObselVO.length == 0))
		{
			this.onCheckListUserObsel(listObselVO,dateStartRecording,null,false,true)
			var activityStartId:int = 0;
			var nbrObsels:int = listObselVO.length;
			for(var nObsel:int = 0;nObsel < nbrObsels; nObsel++)
			{
				var obselVO:ObselVO = listObselVO[nObsel] as ObselVO;
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				var typeObsel:String = obsel.type;
				switch (typeObsel){
					case TraceModel.ACTIVITY_START:
						activityStartId = int(obsel.props[TraceModel.ACTIVITY_ID]);
						break;
					case TraceModel.ACTIVITY_STOP:
						activityStartId = 0;
						break;
				}	
			}
		}
		// update current activity in TutoratModule
		if(activityStartId != 0)
		{
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.UPDATE_ACTIVITY);
			visuActivityEvent.activityId = activityStartId;
			this.dispatcher.dispatchEvent(visuActivityEvent);
		}
	}
	
	public function onCheckSessionSalonRetro(sessionVO:SessionVO):void
	{
		var sessionEvent:SessionEvent = new SessionEvent(SessionEvent.LOAD_SESSION_SALON_RETROSPECTION);
		var session:Session = new Session(sessionVO);
		sessionEvent.session = session;
		this.dispatcher.dispatchEvent(sessionEvent);
	}
	
	/**
	 *  Get list obsel StartSession EnterSession for salon retrospection 
	 */
	public function onCheckListObselStartSession(listObselVO:Array):void
	{
		var nbrObsel:int = listObselVO.length;
		var listSession:ArrayCollection = new ArrayCollection();
		for(var nObsel:int ; nObsel  < nbrObsel ; nObsel++)
		{
			var obselVO:ObselVO = listObselVO[nObsel];
			var traceId:String = obselVO.trace;
			var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
			var sessionTheme:String = obsel.props[TraceModel.SESSION_THEME];
			var sessionId:String = obsel.props[TraceModel.SESSION_ID];
			listSession.addItem({label:sessionTheme, traceId:traceId, sessionId:sessionId, dateRecording:"waiting....."});
		}
		
		var eventLoadListSessionSalonRetrospection:SessionEvent = new SessionEvent(SessionEvent.LOAD_LIST_SESSION_SALON_RETROSPECTION);
		eventLoadListSessionSalonRetrospection.listSession = listSession;
		this.dispatcher.dispatchEvent(eventLoadListSessionSalonRetrospection);
	}
	 
	
	/**
	 * Get list obsel for salon retro
	 */
	public function onCheckListUserObsel(listObselVO:Array, dateStartRecordingSession:Date, listObselCommentVO:Array = null, sharedSession:Boolean = false , salonTutorat:Boolean = false):void
	{
		if(listObselCommentVO != null && listObselCommentVO.length != 0)
		{
			var firstObselVO:ObselVO = listObselCommentVO[0];
			Model.getInstance().setCurrentCommentTraceId(firstObselVO.trace);
			var arr:ArrayCollection = new ArrayCollection();
			var listObselUM:ArrayCollection = new ArrayCollection();
			var listObselDM:ArrayCollection = new ArrayCollection();
			var nbrObselCommentVO:int = listObselCommentVO.length;
			for(var nObselCommentVO:int = 0 ; nObselCommentVO < nbrObselCommentVO; nObselCommentVO++)
			{
				var obselVO:ObselVO = listObselCommentVO[nObselCommentVO];
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				var typeObsel:String = obsel.type;
				switch (typeObsel){
					case  TraceModel.SET_TEXT_COMMENT :
					arr.addItem(obsel);
						break;
					case  TraceModel.UPDATE_TEXT_COMMENT :
					listObselUM.addItem(obsel);
						break;
					case TraceModel.DELETE_TEXT_COMMENT :
					listObselDM.addItem(obsel);
						break;	
				}
			
			}
			var nbrObselUM:int = listObselUM.length;
			for(var nObselUM:int = 0; nObselUM < nbrObselUM; nObselUM++)
			{
				var obselUm:Obsel = listObselUM.getItemAt(nObselUM) as Obsel;
				// update text obsel marker with the same timestamp
				updateObselComment(arr, obselUm);	
			}
			// remove obsel if user delete it
			for each (var obselDM:Obsel in listObselDM)
			{	
				deleteObselComment(arr, obselDM);		
			}
			
			Model.getInstance().setListObselComment(arr);
		}
		var startRecordingSession:Number = dateStartRecordingSession.time;
		var listObsel:ArrayCollection = null;
		var listObselRFN:ArrayCollection = new ArrayCollection();
		var listObselSI:ArrayCollection = new ArrayCollection();
		// list obsel update marker
		var listObselUM:ArrayCollection = new ArrayCollection();
		// list obsel delete marker
		var listObselDM:ArrayCollection = new ArrayCollection();
		var durationSession :Number = 0;
		var tempSharedSession:Boolean = false;
		if(!(listObselVO == null || listObselVO.length == 0))
		{
			// set current sessionId for setting commentObsel
			var obselVO:ObselVO = listObselVO[0];
			var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
			var sessionId:int = obsel.props[TraceModel.SESSION_ID];
			Model.getInstance().setCurrentSessionId(sessionId);
			Model.getInstance().setCurrentTraceId(obselVO.trace);
			// begin session
			var timeSessionStart:Number = 0;
			var timeSessionEnd:Number = 0;
			listObsel = new ArrayCollection();
			// exit from session 
			var stopTimeSessionMsec:Number;
			var startTimeSessionMsec:Number;
			var tempObselRecordFileName:Obsel = null;
			var tempObselSessionStartSessionEnter:Obsel = null;
			var activityStartId:int = 0;
			var nbrObsels:int = listObselVO.length;
			for(var nObsel:int = 0;nObsel < nbrObsels; nObsel++)
			{
				var obselVO:ObselVO = listObselVO[nObsel] as ObselVO;
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				var ow:String = obsel.props[TraceModel.UID] 
				var typeObsel:String = obsel.type;
				switch (typeObsel){

					case TraceModel.SESSION_START:
					case TraceModel.SESSION_ENTER:
						// close every SI opens
						var nbrObselSI:int = listObselSI.length;
						for(var nObselSI:int = 0 ; nObselSI < nbrObselSI ; nObselSI++)
						{
							var obselSI:Obsel = listObselSI[nObselSI];
							var ownerSI:String = obselSI.props[TraceModel.UID];
							var obselRFN:Obsel = getObselByUserIdByType("RFN",ownerSI);
							// ICI LE BUG
							if(obselRFN != null)
							{
								obselSI.begin = obselRFN.begin;
								obselSI.props[TraceModel.PATH] = obselRFN.props[TraceModel.PATH];
								obselSI.end = obsel.begin;
								listObsel.addItem(obselSI);
							}
						}
						// remove SI, RFN
						listObselSI.removeAll();
						listObselRFN.removeAll();
						
						var listUser:Array = new Array();
						listUser = obsel.props[TraceModel.PRESENT_IDS];
						var nbrUser:int = listUser.length;
						for(var nUser:int = 0; nUser < nbrUser; nUser ++)
						{
							var userId:String = listUser[nUser];
							var obselStartSession:Obsel = Obsel.fromRDF(obselVO.rdf);
							obselStartSession.props[TraceModel.UID] = userId;
							obselStartSession.type = TraceModel.SESSION_IN;
							addTempObsel("SI" , obselStartSession); 
						}
						// add presents users
						this.addPresentUsers(obsel);
						break;
					
					case TraceModel.SESSION_EXIT:	
					case TraceModel.SESSION_PAUSE:
						
						timeSessionEnd = obsel.begin;
						var owner:String = obsel.props[TraceModel.UID];
							var nbrObselSI:int = listObselSI.length;
							for(var nObselSI:int = 0 ; nObselSI < nbrObselSI ; nObselSI++)
							{
								var obselSI:Obsel = listObselSI[nObselSI];
								var ownerSI:String = obselSI.props[TraceModel.UID];
								var obselRFN:Obsel = getObselByUserIdByType("RFN",ownerSI);
// BUG ICI
								if (obselRFN != null)
								{
									obselSI.begin = obselRFN.begin;
									var path:String = obselRFN.props[TraceModel.PATH];
									obselSI.props[TraceModel.PATH] = path;
									obselSI.end = obsel.begin;
									listObsel.addItem(obselSI);
								}
							}
						// remove all path of video	
						listObselRFN.removeAll();	
						//remove only user walk out
						removeTempObsel("SI", owner);
						
						var loggedUserId:String = Model.getInstance().getLoggedUser().id_user.toString();
						if(!sharedSession){
							if(owner == loggedUserId)
							{
								tempSharedSession = false;
							}else{								
							tempSharedSession = true;
							}
						}else
						{
							tempSharedSession = true;
						}
						
						if( !tempSharedSession || typeObsel == TraceModel.SESSION_PAUSE )
						{
							listObselSI.removeAll();
							listObselRFN.removeAll();
						}else
						{
							var listClonedObselSI:ArrayCollection = new ArrayCollection();
							var nbrObselSI:int = listObselSI.length;
							for(var nObselSI:int = 0; nObselSI < nbrObselSI ; nObselSI++)
							{
								var obselSI:Obsel = listObselSI[nObselSI];
								// FIXME, lost some prefix
								var clonedObselRdf:String = obselSI.toRDF();
								var clonedObsel:Obsel = Obsel.fromRDF(clonedObselRdf);
								listClonedObselSI.addItem(clonedObsel);
							//	obselSI.begin = obsel.end;
							}
							// remove old obsels
							listObselSI.removeAll();
							// add new cloned obsels
							listObselSI.addAll(listClonedObselSI);
						}
							
					//	}
						break;
					case TraceModel.RECORD_FILE_NAME:
						addTempObsel("RFN" , obsel); 
						break;
					case TraceModel.ACTIVITY_START:
						activityStartId = int(obsel.props[TraceModel.ACTIVITY_ID]);
						break;
					case TraceModel.ACTIVITY_STOP:
						activityStartId = 0;
						break;
					case TraceModel.SEND_CHAT_MESSAGE:
					case TraceModel.RECEIVE_CHAT_MESSAGE:
				// exclus obsels "SetMarker" => hasn't property "Sender"		
				//	case TraceModel.SET_MARKER:
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
					case TraceModel.UPDATE_MARKER:
						listObselUM.addItem(obsel);
						break;
					case TraceModel.SYSTEM_UPDATE_MARKER:
						listObselUM.addItem(obsel);
						break;
					case TraceModel.DELETE_MARKER:
						listObselDM.addItem(obsel);
						break;
					case TraceModel.SYSTEM_DELETE_MARKER:
						listObselDM.addItem(obsel);
						break;
					case TraceModel.PLAY_VIDEO:
					case TraceModel.PAUSE_VIDEO:
					case TraceModel.END_VIDEO:
					case TraceModel.STOP_VIDEO:
					case TraceModel.PRESS_SLIDER_VIDEO:
					case TraceModel.RELEASE_SLIDER_VIDEO:
						listObsel.addItem(obsel);
						break;
				}
			}
			// duration session 
			durationSession = timeSessionEnd - startRecordingSession;
		}
		// update marker
		var nbrObselUM:int = listObselUM.length;
		for(var nObselUM:int = 0; nObselUM < nbrObselUM; nObselUM++)
		{
			var obselUm:Obsel = listObselUM.getItemAt(nObselUM) as Obsel;
			// update text obsel marker with the same timestamp
			updateObselMarker(listObsel, obselUm);	
		}
		// remove obsel if user delete it
		for each (var obselDM:Obsel in listObselDM)
		{	
			deleteObselMarker(listObsel, obselDM);		
		}
		
		// for salon tutorat on add last obsels "SessionIn" with begin == end
		if(salonTutorat)
		{
			var nbrObselSI:int = listObselSI.length;
			for(var nObselSI:int = 0 ; nObselSI < nbrObselSI ; nObselSI++)
			{
				var obselSI:Obsel = listObselSI[nObselSI];
				listObsel.addItem(obselSI);
			}
		}else
		{
			if(listObsel != null && listObsel.length != 0)
			{
				// add if logged user hasn't timeline
				var loggedUser:User = Model.getInstance().getLoggedUser();
				Model.getInstance().addTraceLine(loggedUser.id_user, loggedUser.firstname, loggedUser.avatar, ColorEnum.getColorByCode("0"));
			}
		}
		// get last obsel "SessionIn"
		var lastObselSessionIn:Obsel;
		if(listObsel != null && listObsel.length != 0)
		{
			lastObselSessionIn = this.addObselSessionOut(listObsel,startRecordingSession);
		}
		Model.getInstance().setListObsel(listObsel);
		
		if(salonTutorat)
		{
			// check if all users in the session
			var session:Session = Model.getInstance().getCurrentSession();
			if(session == null)
			{ 
				Alert.show("The problem with current session ","Bug....");
			}
			else 
			{
				if(session.statusSession == SessionStatusEnum.SESSION_PAUSE)
				{
					Model.getInstance().setObselSessionOutForAllUser(session.id_session);
				}else
				{
					Model.getInstance().setObselSessionOutForUserWalkOutSession(session, lastObselSessionIn);
				}
			}
			this.dispatcher.dispatchEvent(new SessionEvent(SessionEvent.LOAD_LIST_OBSEL));
		}else
		{
			var loadListObselRetro:SessionEvent = new SessionEvent(SessionEvent.LOAD_LIST_OBSEL_RETRO);
			loadListObselRetro.dateStartRecording = dateStartRecordingSession;
			loadListObselRetro.durationSessionRetro = durationSession;		
			this.dispatcher.dispatchEvent(loadListObselRetro);			
		}
			
		function removeTempObsel(type:String, userId:String):void
		{
			var listObselByType:ArrayCollection = getListObselByType(type);
			var nbrObsel:int = listObselByType.length;
			var index:int = 0;
			//var listSameOwnerObsel:ArrayCollection  = new ArrayCollection();
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = listObselByType.getItemAt(nObsel) as Obsel;
				var owner:String = obsel.props[TraceModel.UID]
				if(owner == userId)
				{
					listObselByType.removeItemAt(nObsel);
					return;
					// FIXME : for remove all the same obsels have to add same obsel in array and than remove it
					//listSameOwnerObsel.addItem(nObsel);
				}
			}
			/*var nbrSameObsel:int = listSameOwnerObsel.length;
			for(var nSameObsel:int = nbrSameObsel; nSameObsel > 0 ; nSameObsel--  )
			{
				var orderSameObselInListObselByType:int = listSameOwnerObsel.getItemAt(nSameObsel-1) as int;
				listObselByType.removeItemAt(orderSameObselInListObselByType);
			}	*/		
		}
		
		function getListObselByType(type:String):ArrayCollection
		{
			var listObselByType:ArrayCollection = null;
			switch (type)
			{
				case "RFN" : 
					listObselByType = listObselRFN;
					break;
				case "SI" :
					listObselByType = listObselSI;					
					break;
				default:
					break;
			}
			return listObselByType;
		}
		
		function getObselByUserIdByType(type:String, userId:String):Obsel
		{
			var listObselByType:ArrayCollection = getListObselByType(type);
			var nbrObsel:int = listObselByType.length;
			for(var nObsel :int ;nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = listObselByType.getItemAt(nObsel) as Obsel;
				var owner:String = obsel.props[TraceModel.UID];
				if(userId == owner)
				{
					return obsel;
				}
			}
			return null;
		}
		
		function addTempObsel(type:String, obsel:Obsel):void
		{
			var listObselByType:ArrayCollection = getListObselByType(type);
			listObselByType.addItem(obsel);
		}
		
		function updateObselMarker(listObsel:ArrayCollection, obsel:Obsel):void
		{
			var timeStamp:Number = obsel.props[TraceModel.TIMESTAMP];
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obselTemp:Obsel = listObsel.getItemAt(nObsel) as Obsel;
				var obselTempType:String = obselTemp.type;
				if(obselTempType == TraceModel.SET_MARKER || obselTempType == TraceModel.RECEIVE_MARKER)
				{
					var timeStampMarker:Number = obselTemp.props[TraceModel.TIMESTAMP];
					if(timeStamp == timeStampMarker)
					{
						obselTemp.props[TraceModel.TEXT] = obsel.props[TraceModel.TEXT];
					}
				}
			}
		}
		function updateObselComment(listObsel:ArrayCollection, obsel:Obsel):void
		{
			var timeStamp:Number = obsel.props[TraceModel.TIMESTAMP];
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obselTemp:Obsel = listObsel.getItemAt(nObsel) as Obsel;
				var obselTempType:String = obselTemp.type;
				if(obselTempType == TraceModel.SET_TEXT_COMMENT)
				{
					var timeStampMarker:Number = obselTemp.props[TraceModel.TIMESTAMP];
					if(timeStamp == timeStampMarker)
					{
						obselTemp.props[TraceModel.TEXT] = obsel.props[TraceModel.TEXT];
					}
				}
			}
		}
		
		function deleteObselMarker(listObsel:ArrayCollection, obsel:Obsel):void
		{
			var listIndexDeletingObsel:Array = new Array()
			var timeStamp:Number = obsel.props[TraceModel.TIMESTAMP];
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obselTemp:Obsel = listObsel.getItemAt(nObsel) as Obsel;
				var obselTempType:String = obselTemp.type;
				if(obselTempType == TraceModel.SET_MARKER || obselTempType == TraceModel.RECEIVE_MARKER)
				{
					var timeStampMarker:Number = obselTemp.props[TraceModel.TIMESTAMP];
					if(timeStamp == timeStampMarker)
					{
						listIndexDeletingObsel.push(nObsel);
					}
				}
			}
			if(listIndexDeletingObsel.length > 0)
			{
				listIndexDeletingObsel.reverse();
				for each(var index:int in listIndexDeletingObsel)
				{
					listObsel.removeItemAt(index);
				}
			}
		}
		
		function deleteObselComment(listObsel:ArrayCollection, obsel:Obsel):void
		{
			var listIndexDeletingObsel:Array = new Array()
			var timeStamp:Number = obsel.props[TraceModel.TIMESTAMP];
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obselTemp:Obsel = listObsel.getItemAt(nObsel) as Obsel;
				var obselTempType:String = obselTemp.type;
				if(obselTempType == TraceModel.SET_TEXT_COMMENT)
				{
					var timeStampMarker:Number = obselTemp.props[TraceModel.TIMESTAMP];
					if(timeStamp == timeStampMarker)
					{
						listIndexDeletingObsel.push(nObsel);
					}
				}
			}
			if(listIndexDeletingObsel.length > 0)
			{
				listIndexDeletingObsel.reverse();
				for each(var index:int in listIndexDeletingObsel)
				{
					listObsel.removeItemAt(index);
				}
			}
		}
	}
	
	/**
	 * 
	 */
	private function addObselSessionOut(listObsel:ArrayCollection, startSession:Number):Obsel
	{
		var lastObselSessionIn:Obsel = null;
		var listObselSO:ArrayCollection = new ArrayCollection();
		var listNewObselSO:ArrayCollection = new ArrayCollection();
		var obsel:Obsel= null;
		var obselSessionOut:Obsel = null;
		var nbrObsels:int = listObsel.length;
		// set all users SessionOut
		var listPresentsUsers:ArrayCollection  = Model.getInstance().getListTraceLines();
		var nbrTraceLine:int = listPresentsUsers.length;
		for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine; nTraceLine++ )
		{
			var traceLine:Object = listPresentsUsers.getItemAt(nTraceLine) as Object;
			var userId:String = traceLine.userId;
			var tempObsel:Obsel = listObsel.getItemAt(0) as Obsel;
			var obselSessionOut:Obsel = Obsel.fromRDF(tempObsel.toRDF());
			obselSessionOut.type = TraceModel.SESSION_OUT;
			obselSessionOut.props[TraceModel.UID] = userId;
			obselSessionOut.begin = startSession;
			listObselSO.addItem(obselSessionOut);
		}
		for(var nObsel:int = 0;nObsel < nbrObsels; nObsel++)
		{	
			obsel = listObsel.getItemAt(nObsel) as Obsel;
			var owner:String = obsel.props[TraceModel.UID] 
			var typeObsel:String = obsel.type;
			switch (typeObsel)
			{
				case TraceModel.SESSION_IN:
					obselSessionOut = getObselByUserIdByType("SO",owner);
					if(obselSessionOut != null)
					{
						obselSessionOut.end = obsel.begin;
						var durationObselSO:Number = obselSessionOut.end - obselSessionOut.begin;
						if(	durationObselSO > MIN_DURATION_OBSEL_SESSION_OUT)
						{
							listNewObselSO.addItem(obselSessionOut);
						}
						removeTempObsel("SO",owner);			
					}					
					// create new onsel only if in obsel sessionIn begin != end, it's last obsel in the salon synchrone
					if(obsel.begin != obsel.end)
					{
						obselSessionOut = Obsel.fromRDF(obsel.toRDF());
						obselSessionOut.begin = obsel.end;
						obselSessionOut.type = TraceModel.SESSION_OUT;
						addTempObsel("SO" , obselSessionOut);					
					}else
					{
						lastObselSessionIn = obsel;
					}
					break;
			}	
		}
		// create SessionOut
		var listObselSessionOut:ArrayCollection = getListObselByType("SO");
		var nbrObsel:int = listObselSessionOut.length;
		for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
		{
			var obselOut:Obsel = listObselSessionOut.getItemAt(nObsel) as Obsel;
			obselOut.end = obsel.end;
			listNewObselSO.addItem(obselOut);
		}
		// add new obsels to the basic list
		listObsel.addAll(listNewObselSO);
		return lastObselSessionIn;
	
	
	function removeTempObsel(type:String, userId:String):void
	{
		var listObselByType:ArrayCollection = getListObselByType(type);
		var nbrObsel:int = listObselByType.length;
		var index:int = 0;
		for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
		{
			var obsel:Obsel = listObselByType.getItemAt(nObsel) as Obsel;
			var owner:String = obsel.props[TraceModel.UID]
			if(owner == userId)
			{
				listObselByType.removeItemAt(nObsel);
				return;
			}
		}
	}
	
	function getListObselByType(type:String):ArrayCollection
	{
		var listObselByType:ArrayCollection = null;
		switch (type)
		{
			case "SO" : 
				listObselByType = listObselSO;
				break;
			default:
				break;
		}
		return listObselByType;
	}
	
	function getObselByUserIdByType(type:String, userId:String):Obsel
	{
		var listObselByType:ArrayCollection = getListObselByType(type);
		var nbrObsel:int = listObselByType.length;
		for(var nObsel :int ;nObsel < nbrObsel; nObsel++)
		{
			var obsel:Obsel = listObselByType.getItemAt(nObsel) as Obsel;
			var owner:String = obsel.props[TraceModel.UID];
			if(userId == owner)
			{
				return obsel;
			}
		}
		return null;
	}
	
	function addTempObsel(type:String, obsel:Obsel):void
	{
		var listObselByType:ArrayCollection = getListObselByType(type);
		listObselByType.addItem(obsel);
	}		

}

	
	
	
	/**
	 * get list closed session with logged user 
	 */
	public function onCheckListClosedSession(listSessionVO:Array):void
	{
		var nbrSession:int = listSessionVO.length;
		var listSession:ArrayCollection = new ArrayCollection();
		for(var nSession:int ; nSession  < nbrSession ; nSession++)
		{
			var session:SessionVO = listSessionVO[nSession];
			var sessionTheme:String = session.theme;
			var sessionId:int = session.id_session;
			listSession.addItem({label:sessionTheme, sessionId:sessionId, dateRecording:"waiting....."})
			// get detaile the closed session for salon retro
			// FIXME : can be easy the getting the detail of the session 
			var sessionSalonRetroEvent:SessionEvent = new SessionEvent(SessionEvent.GET_SESSION_SALON_RETRO);
			sessionSalonRetroEvent.sessionId = int(sessionId);
			this.dispatcher.dispatchEvent(sessionSalonRetroEvent);
		}
		
		var eventLoadListClosedSessionSalonRetrospection:SessionEvent = new SessionEvent(SessionEvent.LOAD_LIST_CLOSED_SESSION_SALON_RETROSPECTION);
		eventLoadListClosedSessionSalonRetrospection.listSession = listSession;
		this.dispatcher.dispatchEvent(eventLoadListClosedSessionSalonRetrospection);		
	}
	
	public function onCheckListObselClosedSession(listObselClosedSessionVO:Array, dateStartRecordingSession:Date):void
	{
		// creation trace for logged user
		var listUserObselVO:Array = new Array();
		var listTimeStampedObsel:ArrayCollection = new ArrayCollection();
		var listPathStampedObsel:ArrayCollection = new ArrayCollection();
		var nbrObsel:int = listObselClosedSessionVO.length;
		for(var nObsel:int = 0 ; nObsel < nbrObsel; nObsel++ )
		{
			var obselVO:ObselVO = listObselClosedSessionVO[nObsel];	
			var typeObsel:String = obselVO.type;
			if(typeObsel == TraceModel.RECORD_FILE_NAME)
			{
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				var subject:String = obsel.uid.toString();
				var owner:String = obsel.props[TraceModel.UID];
				if(subject == owner)	
				{
					listUserObselVO.push(obselVO);
				}
				// FIXME : checking if have the obsel with same path
				/*if(!hasObselWithSamePathFile(obselVO))
				{
					listUserObselVO.push(obselVO);
				}*/
			}
			// only chat messages will show
			else if( typeObsel == TraceModel.SESSION_EXIT || typeObsel == TraceModel.SESSION_PAUSE || typeObsel == TraceModel.SESSION_START || typeObsel == TraceModel.SESSION_ENTER)
			{
				if(!hasObselWithTimeStamp(obselVO))
				{		
					listUserObselVO.push(obselVO);
				}
			}
			else if( typeObsel == TraceModel.RECEIVE_CHAT_MESSAGE)
			{
				listUserObselVO.push(obselVO);
			}
		}
		// reverse the elements of the array
		var reversedListUserObselVO:Array = new Array();
		var nbrObselUserVO:int = listUserObselVO.length;
		for(var nObselUserVO:int = 0; nObselUserVO < nbrObselUserVO; nObselUserVO++ )
		{
			var obselVO:ObselVO = listUserObselVO[nObselUserVO];
			reversedListUserObselVO.push(obselVO);
			
		}
		
		// creation timeLine
		this.onCheckListUserObsel(reversedListUserObselVO, dateStartRecordingSession, null, true, false);
		
		
		function hasObselWithTimeStamp(obselVO:ObselVO):Boolean
		{
			var obselChecking:Obsel = Obsel.fromRDF(obselVO.rdf);
			var timeStampChecking:Number = obselChecking.props[TraceModel.TIMESTAMP];
			var nbrObsel:int = listTimeStampedObsel.length;
			for(var nObsel:int = 0 ; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = listTimeStampedObsel.getItemAt(nObsel) as Obsel;
				var timeStamp:Number = obsel.props[TraceModel.TIMESTAMP];
				if(timeStampChecking == timeStamp)
				{
					return true;
				}
			}
			// add obsel checking
			listTimeStampedObsel.addItem(obselChecking);
			return false;
		}
		
		function hasObselWithSamePathFile(obselVO:ObselVO):Boolean
		{
			var obselChecking:Obsel = Obsel.fromRDF(obselVO.rdf);
			var path:String = obselChecking.props[TraceModel.PATH];
			var nbrObsel:int = listPathStampedObsel.length;
			for(var nObsel:int = 0 ; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = listPathStampedObsel.getItemAt(nObsel) as Obsel;
				var pathStamp:String = obsel.props[TraceModel.PATH];
				if(pathStamp == path)
				{
					return true;
				}
			}
			// add obsel path
			listPathStampedObsel.addItem(obselChecking);
			return false;
		}
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
			if(session != null)
			{
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
					closeSessionEvent.sessionId = sessionId;
					this.dispatcher.dispatchEvent(closeSessionEvent);
					// update button "salon synchrone"
					var currentSession:Session = Model.getInstance().getCurrentSession();
					// will be null if logged user close session
					if(currentSession != null)
					{
						var currentSessionId:int = currentSession.id_session;
						if(currentSessionId == sessionId)
						{
							Model.getInstance().setCurrentSession(null);
							Model.getInstance().setEnabledButtonSalonSynchrone(false);
						}
					}
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
	 *  call when user receive shared info
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
	
	public function onCheckUpdatedMarker(text:String ,senderUserId:int , obselVO:ObselVO):void
	{
		var obsel:Obsel =  Obsel.fromRDF(obselVO.rdf);
		var timeStampObsel:Number = obsel.props[TraceModel.TIMESTAMP];
		Model.getInstance().updateTextObselMarker(senderUserId, timeStampObsel, text, obsel.type);
	}
	
	public function onCheckAddObselComment(obselVO:ObselVO, timeBegin:String, timeEnd:String):void
	{
		var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
		var timeStampObsel:Number = obsel.props[TraceModel.TIMESTAMP];
		var text:String = obsel.props[TraceModel.TEXT];
		// TODO correction in the function fromRDF, if in the string has \n => simbol "enter" will give NaN !!!
		Model.getInstance().updateTextObselComment( timeStampObsel, text, obsel.type); 
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