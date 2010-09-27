package  com.lyon2.visu.model
{
	import com.ithaca.visu.modules.VisuModuleBase;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.visu.model.Session;
	import com.lyon2.visu.vo.SessionVO;
	import com.lyon2.visu.vo.UserVO;
	
	import flash.net.NetConnection;
	
	import mx.collections.ArrayCollection;
	import mx.modules.ModuleBase;


	public final class Model
	{

		/**
		 * Defines the Singleton instance of the Application Model
		 */
		private static var instance:Model;
		/* Serveur */
		public var server : String = "localhost";
		public var port   : uint = 5080; 
		public var appName: String = "visu2";
		
		private var listConnectedUsers:ArrayCollection = new ArrayCollection();
		private var listSwapUsers:ArrayCollection = new ArrayCollection();
		private var listSessions:ArrayCollection = new ArrayCollection();
		private var listFluxActivity:ArrayCollection = new ArrayCollection();
		private var listDateSession:ArrayCollection = new ArrayCollection();
		
		public var profiles:Array = [];
		
		private var _loggedUser:User;
		private var _netConnection:NetConnection;
		private var _userIdClient:String;
		private var _currentSession:Session;
		private var _tutoratModule:VisuModuleBase;
		private var _userModule:VisuModuleBase;
		private var _homeModule:VisuModuleBase;
		
		private var _selectedDateLoggedUser:Object = null;
		
		public function Model(access:Private)
		{
			if (access == null)
			{
				// TODO MESSAGE
			}
			instance = this;
		}
		
		/**
		 * Returns the Singleton instance of the Application Model
		 */
		public static function getInstance() : Model
		{
			if (instance == null)
			{
				instance = new Model( new Private() );
			}
			
			return instance;
		}
		
		public function get AMFServer(): String
		{
			return "http://" + this.server + ":" + this.port + "/" + this.appName + "/gateway";
		}
		
		public function get rtmpServer(): String
		{
			return "rtmp://" + this.server + "/" + this.appName + "/" + "monSalon";
		}
		
		public function setLoggedUser(value:UserVO):void
		{ 	
			_loggedUser = new User(value); 
			_loggedUser.setStatus(ConnectionStatus.PENDING);
		}
		
		public function getLoggedUser():User
		{
			return _loggedUser;
		}
		
		/**
		 * Update status of logged User 
		 */
		public function updateStatusLoggedUser(value:int):void
		{
			_loggedUser.status = value;
		}
		
		public function setNetConnection(value:NetConnection):void
		{
			_netConnection = value;
		}
		
		public function getNetConnection():NetConnection
		{
			return _netConnection;
		}
		
		/**
		 * set client id 
		 */
		public function setUserIdClient(value:String):void
		{
			_userIdClient = value;
		}
		
		/**
		 *  get client id
		 */
		public function getUserIdClient():String
		{
			return _userIdClient;
		}
		
		/**
		 * current session for tutorat module, only for debugging
		 */ 
		public function setCurrentSession(value:Session):void
		{
			_currentSession = value;
		}
		
		public function getCurrentSession():Session
		{
			return _currentSession;
		}
		
		/**
		 * current tutorat module, only for debugging
		 */
		public function setCurrentTutoratModule(value:VisuModuleBase):void
		{
			_tutoratModule = value;
		}
		
		public function getCurrentTutoratModule():VisuModuleBase
		{
			return _tutoratModule;
		}
		
		/**
		 * current user module, only for debugging
		 */
		public function setCurrentUserModule(value:VisuModuleBase):void
		{
			_userModule = value;
		}
		
		public function getCurrentUserModule():VisuModuleBase
		{
			return _userModule;
		}
		
		/**
		 * current user module, only for debugging
		 */
		public function setCurrentHomeModule(value:VisuModuleBase):void
		{
			_homeModule = value;
		}
		
		public function getCurrentHomeModule():VisuModuleBase
		{
			return _homeModule;
		}
		
		public function setSelectedItemNavigateurDayByLoggedUser(value:Object):void{
			_selectedDateLoggedUser = value;
		}
		
		public function getSelectedItemNavigateurDayByLoggedUser():Object
		{
			return _selectedDateLoggedUser;
		}
		public function setListSessions(arSession:Array):void
		{
			var nbrSession:uint = arSession.length;
			for (var nSession:uint = 0; nSession < nbrSession; nSession++)
			{
				var sessionVO:SessionVO = arSession[nSession];
				var session:Session = new Session(sessionVO);
				this.listSessions.addItem(session);
			}
		}
		
		public function setListSessionsByDate(arSession:Array, sessionDate:String):void
		{
			var listSessionByDate:ArrayCollection = new ArrayCollection();
			var nbrSession:uint = arSession.length;
			for (var nSession:uint = 0; nSession < nbrSession; nSession++)
			{
				var sessionVO:SessionVO = arSession[nSession];
				var session:Session = new Session(sessionVO);
				listSessionByDate.addItem(session);
			}
			var dateSessionsObject:Object =  getObjectDateSessions(sessionDate);
			// TODO check if null
			dateSessionsObject.listSessionDate = listSessionByDate;
		}
		
		public function getListSessionByDate(sessionDate:String):ArrayCollection
		{
			var dateSessionObject:Object = getObjectDateSessions(sessionDate);
			if (dateSessionObject != null){
				return dateSessionObject.listSessionDate;
			}else
				return null;
		}
		
		public function getObjectDateSessions(dateSession:String):Object
		{
			var nbrObjects:int = this.listDateSession.length;
			for(var nObject:int = 0; nObject < nbrObjects; nObject++){
				var obj:Object = this.listDateSession[nObject];
				var labelDate:String = obj.labelDate as String;
				if(labelDate == dateSession)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**
		 * remove session when user sing out from this session by responsable
		 */
		public function removeSession(sessionVO:SessionVO):String
		{
			var labelDate:String = getDateFormatYYY_MM_DD(sessionVO.date_session);	
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var dateSession:String = obj.labelDate;				
				if (dateSession == labelDate){
					var listSessionDate:ArrayCollection = obj.listSessionDate;
					var session:Session = this.getSessionById(sessionVO.id_session, listSessionDate);
					if(session != null)
					{
						var indexRemoveSession:int = listSessionDate.getItemIndex(session);
						listSessionDate.removeItemAt(indexRemoveSession);
						//checking if no more session by this date
						var nbrSession:uint = listSessionDate.length;
						if(nbrSession == 0)
						{
							var indexRemovedSessionDate:int = this.listDateSession.getItemIndex(obj);
							this.listDateSession.removeItemAt(indexRemovedSessionDate);
						}
						return labelDate;
					}				
				}					
			}
			return "";	
		}
		
		/**
		 * add session for user when responsable add him to this session 
		 */
		public function addSession(sessionVO:SessionVO, listUsers:Array):String{
			var labelDate:String = getDateFormatYYY_MM_DD(sessionVO.date_session);			
			var session:Session = new Session(sessionVO);
			session.setUsers(listUsers);
			// add swap users
			this.setSwapUsers(session.participants);
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var dateSession:String = obj.labelDate;				
				if (dateSession == labelDate){
						var listSessionDateTemp:ArrayCollection = obj.listSessionDate;
						listSessionDateTemp.addItem(session);
						return labelDate;
				}					
			}
			// add new date and session
			var listSessionDate:ArrayCollection = new ArrayCollection();
			listSessionDate.addItem(session);
			var index:int = this.getIndexDateSession(sessionVO.date_session);		
			this.listDateSession.addItemAt({labelDate:labelDate, fullDate:sessionVO.date_session, listSessionDate:listSessionDate},index);			
			return labelDate;
		}
		
		/**
		 * Get index of element date where will be add new date of the sesion
		 */
		private function getIndexDateSession(date:Date):int
		{
			var nbrDate:uint = this.listDateSession.length;
			if(nbrDate == 0){
				return 0;
			}else
			{
				for(var nDate:int = 0; nDate < nbrDate; nDate++){
					var obj:Object = this.listDateSession[nDate] as Object;
					var dateObject:Date = obj.fullDate as Date;
					var diff:Number = dateObject.getTime() - date.getTime();
					if(diff > 0)
					{
						return nDate
					}
				}
				return nDate;
			}	
		}
		
		/**
		 * set list participants of this session 
		 */
		public function setListUsersSession(arUser:Array, sessionId:int):void
		{
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var listSessionDate:ArrayCollection = obj.listSessionDate;
				var session:Session = this.getSessionById(sessionId,listSessionDate);
				if (session != null){
					session.setUsers(arUser);
					this.setSwapUsers(session.participants);
					return;
				}					
			}
		}

		private function getSessionById(sessionId:int, listSession:ArrayCollection):Session
		{
			if(listSession == null){ return null};
			var nbrSession:uint = listSession.length;
			if (nbrSession == 0) return null;
			for(var nSession:uint = 0; nSession < nbrSession; nSession++ )
			{
				var session:Session = listSession[nSession];
				var id:int = session.getSessionId();
				if(sessionId == id)
				{
					return session; 
				}
			}
			return null;
		}
		/**
		 * check if user has this session
		 */
		public function hasSessionById(sessionId:int):Session
		{
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var listSessionDate:ArrayCollection = obj.listSessionDate;
				var session:Session = this.getSessionById(sessionId,listSessionDate);
				if(session != null){					
					return session;
				}					
			}
			return null;
		}

		/**
		 * get dates of the sessions
		 */
		public function getSessionDates():ArrayCollection
		{
			var nbrSession:uint = this.listSessions.length;
			if (nbrSession == 0) return null;
			var listDate:ArrayCollection = new ArrayCollection();			
			for(var nSession:uint = 0; nSession < nbrSession; nSession++ )
			{
				var session:Session = this.listSessions[nSession];
				var date:Date = session.getSessionDate();
				if (!this.hasSameDate(listDate, date))
				{
					listDate.addItem(date);
				}
			}
			return listDate;
		}
		
		/**
		 * get list session 
		 */ 
		public function getSessionByDay(date:Date):ArrayCollection
		{
			var nbrSession:uint = this.listSessions.length;
			if (nbrSession == 0) return null;
			var listSession:ArrayCollection = new ArrayCollection();			
			for(var nSession:uint = 0; nSession < nbrSession; nSession++ )
			{
				var session:Session = this.listSessions[nSession];
				var dateSession:Date = session.getSessionDate();
				if ((dateSession.date == date.date) && (dateSession.month == date.month) && (dateSession.fullYearUTC == date.fullYearUTC))
				{
					listSession.addItem(session);
				}
			}
			return listSession;
		}
		
		/**
		 * checking if we have the same date 
		 */
		private function hasSameDate(ar:ArrayCollection , date:Date ):Boolean
		{
			var nbrDay:uint = ar.length;
			if(nbrDay == 0) { return false};
			var day:Number = date.date;
			var mont:Number = date.month;
			var year:Number = date.fullYearUTC;
			for(var nDay:uint = 0; nDay < nbrDay ; nDay++)
			{
				var elm:Date = ar[nDay];
				if ((elm.date == day) && (elm.month == mont) && (elm.fullYearUTC == year) )
				{
					return true;
				}
			}
			return false;
		}	
		
		public function hasSession(sessionId:uint):Boolean{
			var nbrSession:uint = this.listSessions.length;
			for(var nSession:uint = 0; nSession < nbrSession ; nSession++){
				var session:Session = this.listSessions[nSession];
				var id:uint = session.getSessionId();
				if(id == sessionId){
					return true;
				}
			}
			return false;
		}

		
		public function getListSessions():ArrayCollection
		{
			return this.listSessions;
		}
		
		/**
		 * set list date 
		 */
		public function setSessionDate(ar:Array):void
		{
			var nbrDates:uint = ar.length;
			for(var nDate:uint = 0; nDate < nbrDates ; nDate++){
				var date:Date = ar[nDate] as Date;
				var labelDate:String = getDateFormatYYY_MM_DD(date);
				this.listDateSession.addItem({labelDate:labelDate, fullDate:date, listSessionDate:null});
			}
		}
		
		public function addSessionDateToday(index:int):Object
		{
			var date:Date = new Date();
			var labelDate:String = getDateFormatYYY_MM_DD(date);
			this.listDateSession.addItemAt({labelDate:labelDate, fullDate:date, listSessionDate:null},index);
			return this.listDateSession.getItemAt(index);
		}
		public function hasDateSession():Boolean
		{
			if(this.listDateSession.length > 0)
			{
				return true;
			}else return false;
		}
		
		public function getSessionDate():ArrayCollection
		{
			return this.listDateSession;
		}
		
		/**
		 * set connected users 
		 */
		public function setConnectedUsers(ar:Array):void
		{
			var nbrUser:uint = ar.length;
			if(nbrUser == 0) { return };
			for(var nUser:uint = 0; nUser < nbrUser; nUser++)
			{
				var infoUser:Array = ar[nUser];
				var status:int = infoUser[0];
				var userVO:UserVO = infoUser[1];
				var user:User = new User(userVO);
				user.setStatus(status);
				user.id_client=infoUser[2];
				user.currentSessionId = infoUser[3];
				this.listConnectedUsers.addItem(user);
				// add set swapUsers
				this.listSwapUsers.addItem(user);
			}
		}
		
		public function getConnectedUsers():ArrayCollection
		{
			return this.listConnectedUsers;
		}
		
		public function getConnectedUserExcludeLoggedUser():ArrayCollection
		{
			var listConnectedUserExcludeLoggedUser:ArrayCollection = new ArrayCollection();
			var nbrConnectedUser:uint = this.listConnectedUsers.length;
			for(var nConnectedUser:uint = 0; nConnectedUser < nbrConnectedUser ; nConnectedUser++)
			{
				var user:User = this.listConnectedUsers[nConnectedUser];
				if(user != _loggedUser)
				{
					listConnectedUserExcludeLoggedUser.addItem(user);
				}
			}
			return listConnectedUserExcludeLoggedUser;
		}
		
		public function getSwapUsers():ArrayCollection
		{
			return this.listSwapUsers;
		}
		
		public function getFluxActivity():ArrayCollection
		{
			return this.listFluxActivity;
		}
		
		public function addFluxActivity(userId:int, firstname:String, path:String, message:String , date:Date):void
		{
			var h:String = date.getHours().toString();
			var m:String = date.getMinutes().toString();
			var time:String = h+":"+m;
			var fluxActivity:FluxActivity = new FluxActivity(userId,firstname,path,message,time);
			this.listFluxActivity.addItemAt(fluxActivity,0);		
		}
		
		public function removeConnectedUser(userId:int):void
		{
			var nbrUser:uint = this.listConnectedUsers.length;
			if(nbrUser == 0) { return };
			for(var nUser:uint = 0; nUser < nbrUser; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				var id:int = user.getId();
				if(id == userId)
				{
					this.listConnectedUsers.removeItemAt(nUser);
					//set swap user disconnected
					this.addSwapUser(user, ConnectionStatus.DISCONNECTED);
					return;
				}			
			}			
		}
		
		public function addConnectedUsers(userVO:UserVO):void
		{
			var user:User = new User(userVO);
			user.setStatus(ConnectionStatus.PENDING);
			this.listConnectedUsers.addItem(user);
			// add swap user
			this.addSwapUser(user, ConnectionStatus.PENDING);
		}
		
		
		public function setSwapUsers(listSessionUsers:ArrayCollection):void{
			var nbrSessionUsers:uint = listSessionUsers.length;
			for(var nSessionUser:uint = 0; nSessionUser < nbrSessionUsers; nSessionUser++){
				var sessionUser:User = listSessionUsers[nSessionUser] as User;
				addSwapUser(sessionUser);				
			}
		}
		
		private function addSwapUser(user:User, status:int = -1):void{
			var nbrSwapUsers:uint = this.listSwapUsers.length;
			for(var nSwapUser:uint = 0; nSwapUser < nbrSwapUsers; nSwapUser++){
				var swapUser:User = this.listSwapUsers[nSwapUser] as User;
				var swapUserId:uint = swapUser.getId();
				var userId:uint = user.getId();
				if(swapUserId == userId){
					if(status != -1){
						swapUser.setStatus(status);
					}
					return;
				}
			}
			this.listSwapUsers.addItem(user);		
		}	
		
		/**
		 * update status connected user, when user walk out fro salon tutorat 
		 */
		public function updateStatusUser(userVO:UserVO, status:int, sessionId:int):void
		{
			this.updateStatusUserFromList(userVO, this.listConnectedUsers, status, sessionId);
			this.updateStatusUserFromList(userVO, this.listSwapUsers, status, sessionId);
		}
		
		/**
		 * update status user  
		 */
		private function updateStatusUserFromList(userVO:UserVO, listUsers:ArrayCollection, status:int, sessionId:int):void{
			var nbrUsers:uint = listUsers.length;
			for(var nUser:uint =0; nUser < nbrUsers; nUser++)
			{ 
				var user:User = listUsers[nUser] as User;
				var userId:int = user.id_user;
				if(userId == userVO.id_user)
				{
					user.status = status;
					user.currentSessionId = sessionId;
				}
			}
		}
		
		/**
		 * get list client id of the connected users
		 */
		public function getListIdClient(sessionId:int):Array
		{
			var result:Array = new Array();
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				var idClient:String = this.getIdClient(user.id_user);
				var status:int = user.status;
				var currentSessionUser:int = user.currentSessionId;
				if((idClient != "") && (status == ConnectionStatus.CONNECTED || status == ConnectionStatus.RECORDING) && (currentSessionUser == sessionId))
				{
					//add idClient only if status Connected or Recording
					result.push(idClient);				
				}
			}
			return result;
		}
		
		
		/**
		 * get list users id of the session 
		 */
		public function getListUsersId(listUserSession:ArrayCollection):Array
		{
			var result:Array = new Array();
			var nbrUsers:uint = listUserSession.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = listUserSession[nUser];
				if(user.status == ConnectionStatus.RECORDING)
				{
					//add userId only if status Recording
					result.push(user.getId());				
				}
			}
			return result;
		}
		
		/**
		 * get list users id with status "RECORDING" of the recording session 
		 */
		public function getListUsersIdByRecordingSession(sessionId:int):Array
		{
			var result:Array = new Array();
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if((user.status == ConnectionStatus.RECORDING) && (user.currentSessionId == sessionId))
				{
					//add userId only if status Recording of this sessionId
					result.push(user.getId());				
				}
			}
			return result;
		}
		
		public function getIdClient(userId:int):String
		{
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.id_user == userId)
				{
					return user.id_client;
				}
			}
			return "";
		}
		
		public function getUserByUserId(userId:int):User
		{
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.id_user == userId)
				{
					return user;
				}
			}
			return null;
		}
		
		/**
		 * update client id of the user
		 */
		public function updateUserIdClient(userVO:UserVO, idClient:String):void
		{
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.id_user == userVO.id_user)
				{
					user.id_client = idClient;
					return;
				}
			}
		}
		
		/**
		 * 
		 */
		private function getDateFormatYYY_MM_DD(date:Date):String{
			var month:uint = date.getMonth()+1;
			var monthString:String = month.toString();
			if(month < 10){
				monthString = '0'+monthString;
			}
			var day:uint = date.date;
			var dayString:String = day.toString();
			if(day < 10){
				dayString = '0'+dayString;
			}
			return date.getFullYear().toString()+"-"+monthString+"-"+dayString;
		}	
	}
}

/**
 * Inner class which restricts constructor access to Private
 */
class Private {}