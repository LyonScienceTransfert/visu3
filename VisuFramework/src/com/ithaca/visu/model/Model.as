/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package  com.ithaca.visu.model
{
	import com.ithaca.timelineskins.ObselSessionOut;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.visu.events.VisuModuleEvent;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.modules.VisuModuleBase;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.ui.utils.SessionFilterEnum;
	import com.ithaca.visu.view.video.model.StreamObsel;
	
	import flash.net.NetConnection;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.events.PropertyChangeEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.ToggleButton;


	public final class Model
	{

		private static var logger:ILogger = Log.getLogger("com.ithaca.visu.model.Model");
	
		/**
		 * Defines the Singleton instance of the Application Model
		 */
		private static var instance:Model;
		/* Serveur */
		public var server : String = "localhost";
		public var port   : uint = 5080; 
		public var appName: String = "visu2";
		public var roomName: String = "monSalon";
		
		private var NAME_VISU2: String = "VISU";
		private var NAME_VISU_VCIEL: String = "VISUVCIEL";
        
        private var LAYOUT_SALON_RETRO_ETUDIANT:String = "layoutSalonRetrospectionEtudiant.xml";
        private var LAYOUT_SALON_RETRO_TUTEUR:String = "layoutSalonRetrospectionTuteur.xml";
        private var LAYOUT_SALON_SYNCHRONE_ETUDIANT:String = "layoutSalonSynchroneEtudiant.xml";
        private var LAYOUT_SALON_SYNCHRONE_TUTEUR:String = "layoutSalonSynchroneTuteur.xml";
        private var LAYOUT_ADMIN:String = "layoutVisu2.xml";	
        private var FOLDER_NAME_LAYOUT_FILES:String = "xml";     
		
		private var listSessions:ArrayCollection = new ArrayCollection();
		private var listFluxActivity:ArrayCollection = new ArrayCollection();
		private var listDateSession:ArrayCollection = new ArrayCollection();
		private var _listUsersPlateforme:ArrayCollection;
		
		public var profiles:Array = [];
		
		private var _loggedUser:User;
		private var _netConnection:NetConnection;
		private var _userIdClient:String;
		private var _currentSession:Session = null;
		private var _currentSessionRetroModule:Session = null;
		private var _currentSessionTutoratModule:Session = null;
		
		private var _tutoratModule:VisuModuleBase;
		private var _sessionModule:VisuModuleBase;
		private var _retroModule:VisuModuleBase;
		private var _userModule:VisuModuleBase;
		private var _bilanModule:VisuModuleBase;
		private var _homeModule:VisuModuleBase = null;
		
		private var _selectedDateLoggedUser:Object = null;
		
		private var listObsels:ArrayCollection;
//		private var _listObselsComment:ArrayCollection;
		private var _beginTimeSalonSynchrone:Number;
	
		private var listTraceGroup:ArrayCollection;
		private var traceComment:Trace;

		private var _buttonSalonTutorat:ToggleButton; 
		private var _buttonSalonRetro:ToggleButton; 
		
		private var _listViewObselSessionOut:ArrayCollection = new ArrayCollection();
		private var _listViewObselComment:ArrayCollection = new ArrayCollection();
		private var _listFrameSplit:ArrayCollection = new ArrayCollection();
		
		// time of the serveur red5
		private var _timeServeur:Number;
		private var _timeJoinDECK:Number;
		
		private var _currentSessionId:int;
		private var _currentCommentTraceId:String="void";
		private var _currentTraceId:String="void";
		private var _selectedRadioButtonHomeModule:String = "";
		private var _localeVersionGit:String;
		private var _remoteVersionGit:String;  
		private var _dateCompiled:String;
		private var _currentFilterSession:int = SessionFilterEnum.SESSION_MY;
		private var _modeDebug:Boolean = false;
		private var _frameRateSplit:Number = 2000;
		private var _currentSessionSalonSession:Session;
        
		private var _traceIdRetroRoom:String;
		private var _parentTraceId:String;
   
        // init module
        private var _initModule:String;
        // init session id
        private var _initSessionId:Number;
        // init bilan id
        private var _initBilanId:Number;        
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
			var portString:String = ":" + this.port;
			// check if port don't using in adress
			if (this.port == 0){
				portString = "";
			}
			return "http://" + this.server + portString + "/" + this.appName + "/gateway";
		}
		
		public function get rtmpServer(): String
		{
		//	return "rtmpt://" + this.server + ":80/" + this.appName + "/" + this.roomName;
			return "rtmp://" + this.server + "/" + this.appName + "/" + this.roomName;
		}
		
		public function get urlServeur(): String
		{
			var portString:String = ":" + this.port;
			// check if port don't using in adress
			if (this.port == 0){
				portString = "";
			}
			return "http://" + this.server + portString + "/" + this.appName;
		}
		
		public function checkServeurVisuVciel():Boolean
		{
			if (this.appName == "visuvciel")
			{
				return true;
			}
			return false;
		}
		
		public function checkServeurVisu():Boolean
		{
			if (this.appName == "visu2"  || this.appName == "visudev")
			{
				return true;
			}
			return false;
		}
		
		public function checkServeurVisuDev():Boolean
		{
			if (this.appName == "visudev")
			{
				return true;
			}
			return false;
		}
		
		public function getNamePlateforme():String
		{
			var name:String = "Visu";
			switch (this.appName)
			{
				case "visu2" : 
					name = NAME_VISU2;
					break;
				
				case "visuvciel" : 
					name = this.NAME_VISU_VCIEL;
					break;
				default:
					break;
			}
				
				return name;
		}
        // init module 
        public function setInitModule(value:String):void{_initModule = value;}
        public function getInitModule():String{return _initModule;}
        // init session id
        public function setInitSessionId(value:Number):void{_initSessionId = value;}
        public function getInitSessionId():Number{return _initSessionId;}
        // init bilan id
        public function setInitBilanId(value:Number):void{_initBilanId = value;}
        public function getInitBilanId():Number{return _initBilanId;}
        
		public function setRemoteVersionGit(value:String):void{_remoteVersionGit = value;}
		public function getRemoteVersionGit():String{return _remoteVersionGit;}
		
		public function setLocalVersionGit(value:String):void{_localeVersionGit = value;}
		public function getLocalVersionGit():String{return _localeVersionGit;}
		
		public function setDateCompiled(value:String):void{_dateCompiled = value;}
		public function getDateCompiled():String{return _dateCompiled;}
		
		public function setCurrentFilterSession(value:int):void{_currentFilterSession = value;}
		public function getCurrentFilterSession():int{return _currentFilterSession;}

		public function setModeDebug(value:Boolean):void{_modeDebug = value;}
		public function getModeDebug():Boolean{return _modeDebug;}
		
		public function setFrameRateSplit(value:Number):void{_frameRateSplit = value;}
		public function getFrameRateSplit():Number{return _frameRateSplit;}
			
		public function setCurrentSessionId(value:int):void
		{
			_currentSessionId = value;
		}
		public function getCurrentSessionId():int
		{
			return _currentSessionId;
		}
		public function setCurrentSessionSalonSession(value:Session):void
		{
			_currentSessionSalonSession = value;
		}
		public function getCurrentSessionSalonSession():Session
		{
			return _currentSessionSalonSession;
		}
        
        /**
         * Set current comment trace id
         */
        public function setCurrentCommentTraceId(value:String):void
        {
            // check if has comment trace id 
            if(_currentCommentTraceId == "void" )
            {
                _currentCommentTraceId = value;
            }
        }
        
        /**
         * Get current comment trace id
         */
        public function getCurrentCommentTraceId():String
        {
            return _currentCommentTraceId;
        }
		
		public function setSelectedRadioButton(value:String):void
		{
			this._selectedRadioButtonHomeModule = value;
		}
		public function getSelectedRadioButton():String
		{
			return this._selectedRadioButtonHomeModule;
		}
		
		
		public function setCurrentTraceId(value:String):void
		{
			_currentTraceId = value;
		}
		public function getCurrentTraceId():String
		{
			return _currentTraceId;
		}

		public function setListUsersPlateforme(value:ArrayCollection):void
		{
			_listUsersPlateforme = value;
		}
		public function getListUserPlateforme():ArrayCollection
		{
			return _listUsersPlateforme;
		}		
		
		/**
		 *  set time of the serveur red5
		 */
		public function setTimeServeur(value:Number):void
		{
			this._timeServeur = value;
			// start synchronisation the time with serveur red5
			this._timeJoinDECK = new Date().time;
		}
		
		/**
		 * get calculated time of the serveur red5  
		 */
		public function getTimeServeur():Number
		{
			var timePresentsOnTheDeck:Number = new Date().time - this._timeJoinDECK;
			return this._timeServeur + timePresentsOnTheDeck;
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
        * check layout logged user by salon
        */
        public function getPathLayoutXml(value:String):String
        {
            var result:String = "";
            if(value == VisuModuleEvent.RETROSPECTION_MODULE)
            {
                if(VisuUtils.isAdmin(_loggedUser) || VisuUtils.isResponsable(_loggedUser))
                {
                    result =  LAYOUT_ADMIN;
                }else if(VisuUtils.isTuteur(_loggedUser))
                    {
                    result = LAYOUT_SALON_RETRO_TUTEUR;
                    }else result = LAYOUT_SALON_RETRO_ETUDIANT;
            }else if(value == VisuModuleEvent.TUTORAT_MODULE)
            {
                if(VisuUtils.isAdmin(_loggedUser) || VisuUtils.isResponsable(_loggedUser))
                {
                    result = LAYOUT_ADMIN;
                }else if(VisuUtils.isTuteur(_loggedUser))
                    {
                    result = LAYOUT_SALON_SYNCHRONE_TUTEUR;
                    }else result = LAYOUT_SALON_SYNCHRONE_ETUDIANT;
            }
            return FOLDER_NAME_LAYOUT_FILES + "/" + result;
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
		 * current session 
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
		 * current session salon retro
		 */ 
		public function setCurrentSessionRetroModule(value:Session):void
		{
			_currentSessionRetroModule = value;
		}
		
		public function getCurrentSessionRetroModule():Session
		{
			return _currentSessionRetroModule;
		}
		/**
		 * current session salon tutorat
		 */ 
		public function setCurrentSessionTutoratModule(value:Session):void
		{
			_currentSessionTutoratModule = value;
		}
		
		public function getCurrentSessionTutoratModule():Session
		{
			return _currentSessionTutoratModule;
		}
		
		/**
		 * set the button salon Tutorat
		 */
		public function setButtonSalonTutorat(value:ToggleButton):void
		{
			this._buttonSalonTutorat = value;
		}
		/**
		 * set enabled button salon Tutorat
		 */
		public function setEnabledButtonSalonTutorat(value:Boolean):void
		{
			// FIXME : enale = false, have to set correct the current session
			this._buttonSalonTutorat.enabled = value;
		}
		
		/**
		 * set the button salon Retro
		 */
		public function setButtonSalonRetro(value:ToggleButton):void
		{
			this._buttonSalonRetro = value;
		}
		/**
		 * set enabled button salon Retro
		 */
		public function setEnabledButtonSalonRetro(value:Boolean):void
		{
			this._buttonSalonRetro.enabled = value;
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
		 * current session module, only for debugging
		 */
		public function setCurrentSessionModule(value:VisuModuleBase):void
		{
			_sessionModule = value;
		}
		
		public function getCurrentSessionModule():VisuModuleBase
		{
			return _sessionModule;
		}
		
		/**
		 * current tutorat module, only for debugging
		 */
		public function setCurrentRetroModule(value:VisuModuleBase):void
		{
			_retroModule = value;
		}
		
		public function getCurrentRetroModule():VisuModuleBase
		{
			return _retroModule;
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
	
		/**
		 * current user module, only for debugging
		 */
		public function setCurrentBilanModule(value:VisuModuleBase):void
		{
			this._bilanModule = value;
		}
		
		public function getCurrentBilanModule():VisuModuleBase
		{
			return _bilanModule;
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
		
		/**
		 * Set list obsels 
		 */
		public function setListObsel(listObsels:ArrayCollection):void
		{
			this.listObsels = listObsels;
		}
		
		/**
		 * Get list obsels
		 */
		public function getListObsels():ArrayCollection
		{
			return this.listObsels;
		}
		
        /**
        * Set trace id Retro room
        */
        public function setTraceIdRetroRoom(value:String):void
        {
            this._traceIdRetroRoom = value;
        }
        /**
        * Get trace id Retro room
        */
        public function getTraceIdRetroRoom():String
        {
            return this._traceIdRetroRoom;
        }

        /**
        * Set trace id Synchro room
        */
        public function setParentTraceId(value:String):void
        {
            this._parentTraceId = value;
        }
        /**
        * Get trace id Synchro room
        */
        public function getParentTraceId():String
        {
            return this._parentTraceId;
        }
        
		public function hasObsels():Boolean
		{
			var result:Boolean = false;
			if(listObsels && listObsels.length > 0)
			{
				result = true;
			}
			return result;
		}
		/**
		 * add all comment obsel in Trace obsel
		 */
		public function setTraceCommentObsel(value:ArrayCollection):void
		{
			var nbrObsel:int = value.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = value.getItemAt(nObsel) as Obsel;
				// check if has traceComment, have traceComment only in retrospectionModule, but call this function in BilanModule
				if(traceComment)
				{
					traceComment.addObsel(obsel);
				}
			}
		}
		
		/**
		 * Get list obsels comment
		 */
		/*public function getListObselComment():ArrayCollection
		{
			return this._listObselsComment;
		}*/
		
		/**
		 * check if user enter in the session second time
		 */
		public function isFirstEnterSession(userId:int):Boolean
		{
			var result:Boolean = true;
			var arr:Array = new Array();
		//	var userId:int = this._loggedUser.id_user;
			if(this.listObsels != null)
			{
				var nbrObsel:int = this.listObsels.length;
				for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
				{
					var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
					var typeObsel:String = obsel.type;
					if(typeObsel == TraceModel.SESSION_OUT && obsel.props[TraceModel.UID] == userId)
					{
						arr.push(obsel);
					}
				}			
			}
			var nbrObselSessionOut:int = arr.length;
			// for first enter in the session only one obsel "sessionOut"
			if(nbrObselSessionOut > 1)
			{
				result = false;
			}
			return result;	
		}
		/**
		 * Creation data collection for VisuVisioAdvanced, with classes StreamObsel
		 */
		public function getListStreamObsel():ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			if(this.listObsels != null)
			{
				var nbrObsel:int = this.listObsels.length;
				for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
				{
					var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
					var typeObsel:String = obsel.type;
					if(typeObsel == TraceModel.SESSION_IN)
					{
						if(!hasStreamObsel(result, obsel))
						{
							addStreamObsel(result, obsel);
						}
					}
				}
			}
			return result;
			
			function addStreamObsel(array:ArrayCollection, obsel:Obsel):ArrayCollection
			{
				var streamObsel:StreamObsel = new StreamObsel();
				streamObsel.begin = obsel.begin;
				streamObsel.end = obsel.end;
				// owner the stream
				streamObsel.userId = obsel.props[TraceModel.UID];
				streamObsel.pathStream = obsel.props[TraceModel.PATH];
				array.addItem(streamObsel);
				return array;
			}
			function hasStreamObsel(array:ArrayCollection, obsel:Obsel):Boolean
			{
				var nbrStreamObsel:int = array.length;
				for(var nStreamObsel:int = 0 ; nStreamObsel < nbrStreamObsel; nStreamObsel++)
				{
					var streamObsel:StreamObsel = array.getItemAt(nStreamObsel) as StreamObsel;
					if(streamObsel.pathStream == obsel.props[TraceModel.PATH])
					{
						return true;
					}
				}
				return false;
			}
		}
		/**
		 * get list obsel "SessionIn" for this moment the time
		 */
		public function getObselSessionInByTimestamp(value:Number):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			if(this.listObsels != null)
			{
				var nbrObsel:int = this.listObsels.length;
				for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
				{
					var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
					var typeObsel:String = obsel.type;
					if(typeObsel == TraceModel.SESSION_IN)
					{
						var begin:Number = obsel.begin;
						var end:Number = obsel.end;
						if(begin < value && value < end)
						{
							result.addItem(obsel);	
						}
					}
				}
			}
			return result;
		}
		
		public function getObselSessionInByPathStream(value:String):Obsel
		{
			var nbrObsel:int = this.listObsels.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
				var typeObsel:String = obsel.type;
				if(typeObsel == TraceModel.SESSION_IN)
				{
					var pathStream:String = obsel.props[TraceModel.PATH];
					if(pathStream == value)
					{
						return obsel;
					}
				}
			}
			return null;
		}
			
		public function setBeginTimeSalonSynchrone(value:Number):void
		{
			_beginTimeSalonSynchrone=value;
		}
		
		public function getBeginTimeSalonSynchrone():Number
		{
			return this._beginTimeSalonSynchrone;
		}
		
		public function getListTraceLines():ArrayCollection
		{
            // FIXME : refactoring show obsels "SessionOut", "SessionIn"
			return null;
		}
	
		public function getListTraceGroup():ArrayCollection
		{
			return this.listTraceGroup;
		}
		
		public function initListTraceLine():void
		{
		    this._listViewObselComment = new ArrayCollection();
			
			listTraceGroup = new ArrayCollection();
			// init trace comment
			var loggedUserId:int = _loggedUser.id_user;
			traceComment = new Trace(loggedUserId, "" );
		}
		
		public function getTraceComment():Trace
		{
			return traceComment;
		}
		
		public function getListViewObselComment():ArrayCollection
		{
			return this._listViewObselComment;
		}
			
		public function addTraceLine(userId:int, userName:String, userAvatar:String, userColor:String):void
		{
			// check if this user include in listTraceLines
			if(!hasTraceLineByUserId(userId))
			{
				var userTrace:Trace = new Trace(userId, "" );
				this.listTraceGroup.addItem({userId: userId, userColor: userColor, userAvatar : userAvatar, userName : userName, userTrace : userTrace});
			}
		}
		
		public function getListUserIdPresentOnTimeLine():Array
		{
			var result:Array = new Array();
			var nbrTraceGroup:int = this.listTraceGroup.length;
			for(var nTraceGroup:int = 0; nTraceGroup < nbrTraceGroup ; nTraceGroup++)
			{
				var traceLine:Object = this.listTraceGroup.getItemAt(nTraceGroup) as Object;
				var userId:int = traceLine.userId;
				result.push(userId);
			}
			return result;
		}
		public function getListUserPresentOnTimeLine():ArrayCollection
		{
            var result:ArrayCollection = new ArrayCollection();
			var nbrTraceGroup:int = this.listTraceGroup.length;
			for(var nTraceGroup:int = 0; nTraceGroup < nbrTraceGroup ; nTraceGroup++)
			{
				var traceGroup:Object = this.listTraceGroup.getItemAt(nTraceGroup) as Object;
				var userId:int = traceGroup.userId;
				var user:User = Model.instance.getUserPlateformeByUserId(userId);
				result.addItem(user);
			}
			return result;
		}
		
		public function setObselComment(value:Obsel):void
		{		
			var indexDeletedObsel : Number = -1;
			var timeStampUpdatedObsel:Number = value.props[TraceModel.TIMESTAMP];
			var typeObsel:String = value.type;
			// add new obsel
			
			if(typeObsel == TraceModel.SET_TEXT_COMMENT)
			{
				traceComment.addObsel(value);
				return;
			}	
			// traceLineGroupe 
			var listObsel:ArrayCollection = traceComment.obsels;
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = listObsel.getItemAt(nObsel) as Obsel;
				var timeStamp:Number = new Number(obsel.props[TraceModel.TIMESTAMP]);
				// same timeStamp
				if(timeStamp == timeStampUpdatedObsel)
				{
					switch (typeObsel)
					{
					case TraceModel.UPDATE_TEXT_COMMENT : 
						obsel.props[TraceModel.TEXT] == value.props[TraceModel.TEXT];
						var propChange :PropertyChangeEvent= new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
						propChange.property = "props";
						obsel.dispatchEvent( propChange );
						break;
					case TraceModel.DELETE_TEXT_COMMENT : 
						indexDeletedObsel = nObsel;
						break;
					}				
				}
			}
			// delete obsel
			if(indexDeletedObsel > -1)
			{
				listObsel.removeItemAt(indexDeletedObsel);
			}
		}
		
		/**
		 * update new text and tooltips the obsel marker
		 */
		public function updateTextObselMarker(userId:int , timeStampUpdatedObsel:Number , text:String, typeObsel:String):void
		{
			var indexDeletedObsel : Number = -1;
			// traceLineGroupe 
			var traceLineGroup:Object = getTraceGroupByUserId(userId);
			var traceUser:Trace= traceLineGroup.userTrace as Trace;
			var listObsel:ArrayCollection  = traceUser.obsels;
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = listObsel.getItemAt(nObsel) as Obsel;
				var timeStamp:Number = new Number(obsel.props[TraceModel.TIMESTAMP]);
				// same timeStamp
				if(timeStamp == timeStampUpdatedObsel)
				{
					switch (typeObsel)
					{
						case TraceModel.UPDATE_MARKER : 
							obsel.props[TraceModel.TEXT] == text;
							var propChange :PropertyChangeEvent= new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
							propChange.property = "props";
							obsel.dispatchEvent( propChange );
							break;
						case TraceModel.DELETE_MARKER : 
							indexDeletedObsel = nObsel;
							break;
					}				
				}
			}
			// deleting obsel
			if(indexDeletedObsel > -1)
			{
				listObsel.removeItemAt(indexDeletedObsel);
			}
		}
		
		/**
		 * add list obsel to title trace line
		 */
		public function addListObselTitleTraceLine(userId:int , listObsel:ArrayCollection):void
		{
			var traceLine:Object = this.getTraceLineByUserId(userId);
			var listTitleObsel:ArrayCollection = traceLine.listTitleObsels as ArrayCollection;
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0 ; nObsel < nbrObsel ; nObsel++)
			{
				var obsel = listObsel.getItemAt(nObsel);	
				// clone obsel, can't have same(one) obsel on too traceLine
				var newObsel = obsel.cloneMe();
				listTitleObsel.addItem(newObsel);
			}
		}
		
		/**
		 * remove list obsel to title trace line
		 */
		public function removeListObselTitleTraceLine(userId:int , listObsel:ArrayCollection):void
		{
			var traceLine:Object = this.getTraceLineByUserId(userId);
			var listTitleObsel:ArrayCollection = traceLine.listTitleObsels as ArrayCollection;
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0 ; nObsel < nbrObsel ; nObsel++)
			{
				var obsel = listObsel.getItemAt(nObsel);	
				// remove cloned obsel
				removeClonedObsel(listTitleObsel, obsel);
			}
		}
		
		/**
		 * remove obsel by property "begin" 
		 */
		private function removeClonedObsel(listObsel:ArrayCollection , obselOrigin:*):void
		{
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel = listObsel.getItemAt(nObsel);
				if(obsel.getBegin() == obselOrigin.getBegin())
				{
					listObsel.removeItemAt(nObsel);
					return;
				}
			}
			return;
		}
		/**
		 * checking if has users trace line
		 */
		private function hasTraceLineByUserId(userId:int):Boolean
		{
			if(this.listTraceGroup != null)
			{
				var nbrTraceGroup:int = this.listTraceGroup.length;
				for(var nTraceGroup:int = 0; nTraceGroup < nbrTraceGroup; nTraceGroup++)
				{
					var traceGroup:Object = this.listTraceGroup[nTraceGroup] as Object;
					var id:int = traceGroup.userId;
					if(id == userId)
					{
						return true;
					}
				}
				return false;
			}
			// FIXME : it's hapen when user in Accuiel , and other user start recording
			this.initListTraceLine();
			return false;
		}
		
		/**
		 * 
		 */
		public function getTraceGroupByUserId(userId:int):Object
		{
			var nbrTraceGroup:int = this.listTraceGroup.length;
			for(var nTraceGroup:int = 0; nTraceGroup < nbrTraceGroup; nTraceGroup++)
			{
				var traceGroup:Object = this.listTraceGroup[nTraceGroup] as Object;
				var id:int = traceGroup.userId;
				if(id == userId)
				{
					return traceGroup;
				}
			}
			return null;
		}
		/**
		 * 
		 */
		public function getTraceLineByUserId(userId:int):Object
		{
			if(!listTraceGroup)
			{
				return null;
			}
			var nbrTraceGroup:int = this.listTraceGroup.length;
			for(var nTraceGroup:int = 0; nTraceGroup < nbrTraceGroup; nTraceGroup++)
			{
				var traceGroup:Object = this.listTraceGroup[nTraceGroup] as Object;
				var id:int = traceGroup.userId;
				if(id == userId)
				{
					return traceGroup;
				}
			}
			return null;
		}
		
        /**
        ** create view obsel and add on the traceLine
        */
        public function addObsel(obsel:Obsel):Array
        {
            // return the liste the objets for init the chat panel
            var result:Array = new Array();
            // property of the obsel
            var ownerObsel:int;
            var textObsel:String;
            // source of the icon the obsel class/string
            var source:Object;
            var senderObsel:int;
            // type of the obsel
            var typeObsel:String = obsel.type;
            switch (typeObsel)
            {
                case TraceModel.STOP_VIDEO:
                case TraceModel.PRESS_SLIDER_VIDEO:
                case TraceModel.RELEASE_SLIDER_VIDEO:
                case TraceModel.PLAY_VIDEO:
                case TraceModel.PAUSE_VIDEO:
                case TraceModel.END_VIDEO:
                case TraceModel.RECEIVE_MARKER :
                case TraceModel.READ_DOCUMENT :
                    ownerObsel = obsel.props[TraceModel.SENDER];
                    break;
                
                case TraceModel.SET_MARKER :
                case TraceModel.SEND_CHAT_MESSAGE :
                case TraceModel.SEND_KEYWORD :
                case TraceModel.SEND_INSTRUCTIONS :
                case TraceModel.SEND_DOCUMENT :
                    ownerObsel = obsel.uid;
                    break;
                
                case TraceModel.RECEIVE_CHAT_MESSAGE :
                    ownerObsel = obsel.uid;
                    source =  IconEnum.getIconByTypeObsel(typeObsel);
                    textObsel = obsel.props[TraceModel.CONTENT];
                    senderObsel = obsel.props[TraceModel.SENDER];
                    result.push({senderId:senderObsel, textObsel:textObsel, source:source});
                    break;
                
                case TraceModel.RECEIVE_KEYWORD :
                    ownerObsel = obsel.uid;
                    source =  IconEnum.getIconByTypeObsel(typeObsel);
                    textObsel = obsel.props[TraceModel.KEYWORD];
                    senderObsel = obsel.props[TraceModel.SENDER];
                    result.push({senderId:senderObsel, textObsel:textObsel, source:source});
                    break;
                
                case TraceModel.RECEIVE_INSTRUCTIONS :
                    ownerObsel = obsel.uid;
                    source =  IconEnum.getIconByTypeObsel(typeObsel);
                    textObsel = obsel.props[TraceModel.INSTRUCTIONS];
                    senderObsel = obsel.props[TraceModel.SENDER];
                    result.push({senderId:senderObsel, textObsel:textObsel, source:source});
                    break;
                
                case TraceModel.RECEIVE_DOCUMENT :
                    ownerObsel = obsel.uid;
                    var typeDocument:String = obsel.props[TraceModel.TYPE_DOCUMENT]; 
                    if(typeDocument == ActivityElementType.IMAGE)
                    {
                        source =  obsel.props[TraceModel.URL];  
                    }else
                    {
                        source = IconEnum.getIconByTypeObsel(typeObsel);
                    }
                    textObsel = obsel.props[TraceModel.TEXT];
                    senderObsel = obsel.props[TraceModel.SENDER];
                    result.push({senderId:senderObsel, textObsel:textObsel, source:source});
                    break;
                //  case TraceModel.SESSION_IN :
                //	case TraceModel.SESSION_OUT :	
                    // FIXME : don't add obsel SessionOut, 
                    // TODO : have to find the BUG
                    //	return result;
					
                    /*viewObsel = new ObselSessionOut()
                    viewObsel.setBegin(obsel.begin);
                    viewObsel.setEnd(obsel.end);*/
                    //	ownerObsel = obsel.props[TraceModel.UID];
                    //	break;
               //	case TraceModel.SESSION_OUT_VOID_DURATION :
                // FIXME : don't add obsel SessionOut, 
                // TODO : have to find the BUG
                //		return result;
					
                //		ownerObsel = obsel.props[TraceModel.UID];
                    /*viewObsel = new ObselSessionOut()
                    viewObsel.setBegin(obsel.begin);
                    viewObsel.setEnd(obsel.end);
                    viewObsel.setOwner(ownerObsel);
                    // add viewObsel for updating his duration
                    this._listViewObselSessionOut.addItem(viewObsel);
                    // add viewObsel like "SessionOut"
                    typeObsel = TraceModel.SESSION_OUT;*/
             //		break;
            }
			
            Model.getInstance().setObsel(null,ownerObsel,typeObsel,obsel)
            return result;
        }
        
		/**
        * add obsel to the Trace 
        */
		public function setObsel(obsel:*, userId:int, typeObsel:String, obselOrigin:Obsel = null):void
		{
			var traceGroup:Object = getTraceGroupByUserId(userId);
			if(traceGroup == null)
			{
				// TODO message
				return;
			}
			var trace:Trace = traceGroup.userTrace;
			if(obselOrigin)
			{
				trace.addObsel(obselOrigin);
			}
		}
		
		public function getListElementsTraceLineByUserId(userId:int):ArrayList
		{
			var traceLine:Object = getTraceLineByUserId(userId);
			if(traceLine == null)
			{
				// TODO message
				return null;
			}
			var listElementsTraceLine:ArrayList = traceLine.listElementTraceLine as ArrayList;
			var nbrElements:int = listElementsTraceLine.length;
			for(var nElement:int=0; nElement < nbrElements; nElement++)
			{
				var objTraceLineElement:Object = listElementsTraceLine.getItemAt(nElement);
				var visible:Boolean = objTraceLineElement.visible;
				if(!visible)
				{
					objTraceLineElement.visible = true;
					return listElementsTraceLine;
				}
			}
			return listElementsTraceLine;
		}
		
		public function setUnvisibleElementTraceLineByUser(idElement:int, userId:int):void
		{
			var traceLine:Object = getTraceLineByUserId(userId);
			if(traceLine == null)
			{
				// TODO message
			}
			var listElementsTraceLine:ArrayList = traceLine.listElementTraceLine as ArrayList;
			var nbrElements:int = listElementsTraceLine.length;
			for(var nElement:int =0; nElement < nbrElements; nElement++)
			{
				var objTraceLineElement:Object = listElementsTraceLine.getItemAt(nElement);
				if(objTraceLineElement.id == idElement)
				{
					objTraceLineElement.visible = false;
					return;
				}
			}	
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
		 * Delete session by owner the session or responsable
		 */
		public function deleteSession(value:int):Session
		{	
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var dateSession:String = obj.labelDate;				
				var listSessionDate:ArrayCollection = obj.listSessionDate;
				var session:Session = this.getSessionById(value, listSessionDate);
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
					return session;
				}			
			}
			return null;	
		}
		
		/**
		 * add session for user when responsable add him to this session 
		 */
		public function addSession(sessionVO:SessionVO, listUsers:Array):String{
			var labelDate:String = getDateFormatYYY_MM_DD(sessionVO.date_session);			
			var session:Session = new Session(sessionVO);
			session.setUsers(listUsers);
			// add swap users
//			this.setSwapUsers(session.participants);
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var dateSession:String = obj.labelDate;				
				if (dateSession == labelDate){
						var listSessionDateTemp:ArrayCollection = obj.listSessionDate;
						if(listSessionDateTemp == null)
						{
							listSessionDateTemp = new ArrayCollection();	
						}
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
//					this.setSwapUsers(session.participants);
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
				var dateString:String = ar[nDate] as String;
				var arrDate:Array = dateString.split("-");
				// create new date similaire like on the serveur
				var date:Date = new Date(new Number(arrDate[0]), new Number(arrDate[1]),new Number(arrDate[2]));
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
		public function clearDateSession():void
		{
			this.listDateSession.removeAll();
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
			var userPlateforme:User;
			var nbrUser:uint = ar.length;
			if(nbrUser == 0) { return };
			for(var nUser:uint = 0; nUser < nbrUser; nUser++)
			{
				var infoUser:Array = ar[nUser];
				var userVO:UserVO = infoUser[1];
				var userStatus:int = infoUser[4];
				
				userPlateforme = this.getUserPlateformeByUserId(userVO.id_user);
				userPlateforme.setStatus(userStatus);
				userPlateforme.id_client=infoUser[2];
				userPlateforme.currentSessionId = infoUser[3];
			}
		}
		
		public function isUserConnected(id_user:int):Boolean {
			//logger.debug("Verifying if the user {0} is connected ", id_user);
			for each (var user:User in this._listUsersPlateforme) {
				if(user.status != ConnectionStatus.DISCONNECTED)
					return true;
			}
			return false;
		}
		
		public function getConnectedUsers():ArrayCollection
		{
			var list:ArrayCollection = new ArrayCollection();
			var nbrUser:int = this._listUsersPlateforme.length;
			for(var nUser:int = 0 ; nUser < nbrUser ; nUser++)
			{
				var user:User = this._listUsersPlateforme.getItemAt(nUser) as User;
				if(user.status != ConnectionStatus.DISCONNECTED)
				{
					list.addItem(user);
				}
			}
			return list;
		}
		
		public function getConnectedUserExcludeLoggedUser():ArrayCollection
		{
			var listConnectedUserExcludeLoggedUser:ArrayCollection = new ArrayCollection();
//			var nbrConnectedUser:uint = this.listConnectedUsers.length;
			var nbrConnectedUser:uint = this._listUsersPlateforme.length;
			for(var nConnectedUser:uint = 0; nConnectedUser < nbrConnectedUser ; nConnectedUser++)
			{
//				var user:User = this.listConnectedUsers[nConnectedUser];
				var user:User = this._listUsersPlateforme[nConnectedUser];
				if(user != _loggedUser)
				{
					listConnectedUserExcludeLoggedUser.addItem(user);
				}
			}
			return listConnectedUserExcludeLoggedUser;
		}

		public function getFluxActivity():ArrayCollection
		{
			return this.listFluxActivity;
		}
		
		public function addFluxActivity(userId:int, firstname:String, lastname:String, path:String, message:String , date:Date):void
		{
			var h:String = date.getHours().toString();
			var zeroMin:String = "";
			if (date.getMinutes() < 10)
			{
				zeroMin = "0";
			}
			var m:String = zeroMin+date.getMinutes().toString();
			var time:String = h+":"+m;
			var fluxActivity:FluxActivity = new FluxActivity(userId,firstname,lastname,path,message,time);
			this.listFluxActivity.addItem(fluxActivity);		
		}

		
		public function removeConnectedUser(userId:int):void
		{
//			var nbrUser:uint = this.listConnectedUsers.length;
			var nbrUser:uint = this._listUsersPlateforme.length;
			
			this.updateUserStatus(userId, ConnectionStatus.DISCONNECTED);	
		}
		
		public function addConnectedUsers(userVO:UserVO):void
		{
			var user:User = new User(userVO);
			user.setStatus(ConnectionStatus.PENDING);
//			this.listConnectedUsers.addItem(user);
			
			this.updateUserStatus(user.id_user, ConnectionStatus.CONNECTED);
			
			// add swap user
//			this.addSwapUser(user, ConnectionStatus.PENDING);
		}
		
		
		public function updateUserStatus(userId:int, userStatus:int) : void {
			var user:User = this.getUserPlateformeByUserId(userId);
			if(user)
			{
				updateUserStatusByUser(user,userStatus);
			}
		}

		
		public function updateSessionStatus(userId:int, sessionId:int):void
		{
			var user:User = this.getUserPlateformeByUserId(userId);
			// FIXME : sometime hasn't user => bug
			if(user)
			{
				updateSessionIdByUser(user,sessionId);		
			}
		}
		
		
		private function updateSessionIdByUser(user:User, sessionId:int):void
		{
			user.currentSessionId = sessionId;
		}
		private function updateUserStatusByUser(user:User , status:int):void
		{
			user.status = status;
		}

		
		/**
		 * get list client id of the connected users
		 */
		public function getListIdClient(sessionId:int):Array
		{
			var result:Array = new Array();
			var nbrUsers:uint = this._listUsersPlateforme.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = this._listUsersPlateforme[nUser];
				var idClient:String = this.getIdClient(user.id_user);
				var status:int = user.status;
				var currentSessionUser:int = user.currentSessionId;
				if((idClient != "") && (status == ConnectionStatus.PENDING || status == ConnectionStatus.RECORDING) && (currentSessionUser == sessionId))
				{
					//add idClient and user only if status Connected or Recording
					result.push({idClient:idClient, user:user});				
				}
			}
			return result;
		}
		
		/**
		 * update duration viewObsels "SessionOut" 
		 */
		public function setTimeViewObselSessionOut(value:Number):void
		{
			var viewObsel:ObselSessionOut;
			for each(viewObsel in this._listViewObselSessionOut)
			{
				viewObsel.setEnd(value);	
			}
		}
		
		/**
		 * add viewObsel "SessionOut" 
		 */
		public function addViewObselSessionOut(timeBegin:Number, userId:int):void
		{
			var viewObsel:ObselSessionOut = new ObselSessionOut();
			viewObsel.setOwner(userId);
			viewObsel.setBegin(timeBegin);
			viewObsel.setEnd(timeBegin+100);
			this.setObsel(viewObsel,userId,TraceModel.SESSION_OUT);
			this._listViewObselSessionOut.addItem(viewObsel);
			
		}
		/**
		 * remove viewObsel "SessionOut"
		 */
		public function removeViewObselSessionOut(userId:int):Boolean
		{
			var result:Boolean = false;
			var listSameOwnerObsel:ArrayCollection  = new ArrayCollection();
			var nbrViewObsel:int = this._listViewObselSessionOut.length;
			for(var nViewObsel:int ; nViewObsel < nbrViewObsel ; nViewObsel++)
			{
				var viewObsel:ObselSessionOut = this._listViewObselSessionOut.getItemAt(nViewObsel) as ObselSessionOut;
				var owner:int = viewObsel.getOwner();
				if(owner == userId)
				{
					//this._listViewObselSessionOut.removeItemAt(nViewObsel);
					listSameOwnerObsel.addItem(nViewObsel);
				//	return true;
				}
			}		
			var nbrSameObsel:int = listSameOwnerObsel.length;
			for(var nSameObsel:int = nbrSameObsel; nSameObsel > 0 ; nSameObsel--  )
			{
				var orderSameObselInList:int = listSameOwnerObsel.getItemAt(nSameObsel-1) as int;
				this._listViewObselSessionOut.removeItemAt(orderSameObselInList);
			}	
			if(nbrSameObsel > 0)
			{
				result =  true
			}
			return result;
		}
		
		public function removeObselSessionOutCurrentUser(sessionId:int):void
		{
			if(listTraceLine)
			{
				var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
				var listTraceLine:ArrayCollection = this.getListTraceLines();
				var nbrTraceLine:int = listTraceLine.length;
				for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
				{
					var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
					// id of the user having traceLine
					var userId:int = traceLine.userId;
					if(hasUserInSession(listUserId,userId))
					{
						// stop MAJ duration of the obsel "SessionOut"
						this.removeViewObselSessionOut(userId);
					}
				}
			}
		}
		/**
		 * paused session  => add obsel "SessionOut" for all users
		 */
		public function setObselSessionOutForAllUser(sessionId:int):void
		{
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
            if(listTraceLine)
            {
    			var nbrTraceLine:int = listTraceLine.length;
    			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
    			{
    				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
    				// id of the user having traceLine
    				var userId:int = traceLine.userId;
    				var viewObsel:ObselSessionOut = new ObselSessionOut();
    				viewObsel.setOwner(userId);
    				viewObsel.setBegin(new Date().time);
    				// TODO gestion currentTime
    				viewObsel.setEnd(new Date().time + 100);
    				this.addViewObselSessionOut(viewObsel.getBegin(), userId);
    			}			
            }
		}
		/**
		 * add obsel "SessionOut for user presents in the session, after click on boutton "stop recording"
		 */
		public function setObselSessionOutForCurrentUser(sessionId:int):void
		{
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
            if(listTraceLine)
            {
    			var nbrTraceLine:int = listTraceLine.length;
    			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
    			{
    				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
    				// id of the user having traceLine
    				var userId:int = traceLine.userId;
    				if(hasUserInSession(listUserId,userId))
    				{
    					var viewObsel:ObselSessionOut = new ObselSessionOut();
    					viewObsel.setOwner(userId);
    					viewObsel.setBegin(new Date().time);
    					// TODO gestion currentTime
    					viewObsel.setEnd(new Date().time + 100);
    					// show obsel on traceLine
    	//				this.setObsel(viewObsel,userId,TraceModel.SESSION_OUT);
    					// add obsel in the list for update duration
    					this.addViewObselSessionOut(viewObsel.getBegin(), userId);
    				}
    			}		
            }
		}
		/**
		 * set obsels "SessionOut" for users had walk out from TutoratModule 
		 * before creation "TimeLine" for logged user
		 */
		public function setObselSessionOutForUserWalkOutSession(session:Session, obsel:Obsel):void
		{
			var sessionId:int = session.id_session;
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
            if(listTraceLine)
            {
    			var nbrTraceLine:int = listTraceLine.length;
    			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
    			{
    				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
    				// id of the user having traceLine
    				var userId:int = traceLine.userId;
    				if(!hasUserInSession(listUserId,userId) && obsel != null)
    				{
    					// user walk out from session
    					var obselSessionOut:Obsel = Obsel.fromRDF((obsel.toRDF()));
    					obselSessionOut.type = TraceModel.SESSION_OUT_VOID_DURATION;
    					obselSessionOut.props[TraceModel.UID] = userId.toString();
    					obselSessionOut.end = obselSessionOut.begin + 100;
    					// add obsel to collection the obsel for show in TimeLine
    					
    					
    					
    			//		this.listObsels.addItem(obselSessionOut);
    					
    					
    					
    				}
    			}		
            }
		}
		
		private function hasUserInSession(listUserId:Array, value:int):Boolean
		{
			var nbrUser:int = listUserId.length;
			for(var nUser:int = 0; nUser < nbrUser; nUser++)
			{
				var id:int = listUserId[nUser];
				if(id == value)
				{
					return true;	
				}
			}
			return false;
		}
		
		/**
		 * get list users id of the session 
		 */
		public function getListUsersIdByConnectedSession(sessionId:int):Array
		{
			var result:Array = new Array();
//			var nbrUsers:uint = this.listConnectedUsers.length;
			var nbrUsers:uint = this._listUsersPlateforme.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
//				var user:User = this.listConnectedUsers[nUser];
				var user:User = this._listUsersPlateforme[nUser];
				if(user.currentSessionId == sessionId)
				{
					//add userId only if user in this session(really, not planning)
					result.push(user.getId());				
				}
			}
			return result;
		}
		/**
		 * get list users id with status "RECORDING" of the recording session whitout logged user
		 */
		public function getListUsersIdByRecordingSessionWithoutLoggedUser(sessionId:int):Array
		{
			var result:Array = new Array();
			var loggedUserId:int = this._loggedUser.getId();
			var listUsersIdByRecordingSession:Array = this.getListUsersIdByRecordingSession(sessionId);
			var nbrIds:int = listUsersIdByRecordingSession.length;
			for(var nId:int = 0 ; nId < nbrIds ; nId++)
			{
				var id:int = listUsersIdByRecordingSession[nId]	as int;
				if(id != loggedUserId)
				{
					result.push(id);
				}
			}
			return result;
		}
		
		/**
		 * get list users id with status "RECORDING" of the recording session 
		 */
		public function getListUsersIdByRecordingSession(sessionId:int, role:int=0, filter:Boolean = false):Array
		{
			var status:int = ConnectionStatus.RECORDING;
			if(filter)
			{
				// have to add users with status recording and paused
				status = ConnectionStatus.CONNECTED;
			}
			var result:Array = new Array();
//			var nbrUsers:uint = this.listConnectedUsers.length;
			var nbrUsers:uint = this._listUsersPlateforme.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
//				var user:User = this.listConnectedUsers[nUser];
				var user:User = this._listUsersPlateforme[nUser];
				if((user.status == ConnectionStatus.RECORDING || user.status == status) && (user.currentSessionId == sessionId))
				{
					//add userId only if status Recording of this sessionId
					if(role == 0 )
					{
						result.push(user.getId());				
					}
					else if( role < RoleEnum.TUTEUR)
						// will shared only with Tutor.....and with myself
						{
							if (user.role > RoleEnum.STUDENT || user.id_user == this._loggedUser.id_user)
							{
								result.push(user.getId());	
							}
						}
					else 
						// will shared only with himself
					{
						if(user.id_user == this._loggedUser.id_user)
						{
							result.push(user.getId());	
						}
					}
					
				}
			}
			return result;
		}
		
		public function getIdClient(userId:int):String
		{
//			var nbrUsers:uint = this.listConnectedUsers.length;
			var nbrUsers:uint = this._listUsersPlateforme.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
//				var user:User = this.listConnectedUsers[nUser];
				var user:User = this._listUsersPlateforme[nUser];
				if(user.id_user == userId)
				{
					return user.id_client;
				}
			}
			return "";
		}
		
/*		public function getUserByUserId(userId:int):User
		{
//			var nbrUsers:uint = this.listConnectedUsers.length;
			var nbrUsers:uint = this._listUsersPlateforme.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
//				var user:User = this.listConnectedUsers[nUser];
				var user:User = this._listUsersPlateforme[nUser];
				if(user.id_user == userId)
				{
					return user;
				}
			}
			return null;
		}*/
		
		public function getUserPlateformeByUserId(userId:int):User
		{
			var nbrUsers:uint = this._listUsersPlateforme.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this._listUsersPlateforme[nUser];
				if(user.id_user == userId)
				{
					return user;
				}
			}
			return null;
		}
		/**
		 * check if can edit obsel
		 */
		public function canEditObsel(value:Obsel):Boolean
		{
			var result:Boolean = false;
			if(getCurrentTutoratModule())
			{
				// can edit obsel only in Tutorat Module
				var senderUserId:int = int(value.props[TraceModel.SENDER]);
				if( senderUserId == this._loggedUser.id_user)
				{
					result = true;
				}
			}
			return result;
		}

		/**
		 * update client id of the user
		 */
		public function updateUserIdClient(userVO:UserVO, idClient:String):void
		{
			var nbrUsers:uint = this._listUsersPlateforme.length;
//			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
//				var user:User = this.listConnectedUsers[nUser];
				var user:User = this._listUsersPlateforme[nUser];
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
		
		public function clearListFrameSplit():void
		{
			this._listFrameSplit = new ArrayCollection();
		}
		public function addFrameSplit(value:Object):void
		{
			this._listFrameSplit.addItem(value);
		}
		public function getFrameSplit():ArrayCollection
		{
			return this._listFrameSplit;
		}
	}
}

/**
 * Inner class which restricts constructor access to Private
 */
class Private {}