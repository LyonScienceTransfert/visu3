package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.SessionListViewEvent;
	import com.ithaca.visu.events.SessionUserEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.view.session.controls.SessionDetail;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	public class SessionManagerView extends SkinnableComponent
	{
		[SkinPart("true")]
		public var explorerSession:TabNavigator;
		
		[SkinPart("true")]
		public var sessionDetailView:SessionDetailView;
		
		// only for debug
//		[SkinPart("true")]
//		public var sessionDetail:SessionDetail;
		
		private var sessionListView:SessionListView;
		private var planListView:SessionListView;
		
		private var sessionList:ArrayCollection;
		private var planList:ArrayCollection;
		private var _sessions:Array = [];
		private var _session:Session;
		private var sessionChange:Boolean;
		private var _loggedUser:User;
		
		private var filterChange:Boolean;
		private var selectedIndexListSession:int;
		
		public function SessionManagerView()
		{
			super();
			sessionList = new ArrayCollection();
			planList = new ArrayCollection();
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________	
		public function set session(value:Session):void
		{
			_session = value;
			if(value != null)
			{
				sessionChange = true;
			}
		}
		public function get session():Session
		{
			return _session;
		}
		public function get sessions():Array {return _sessions;}
		public function set sessions(value:Array):void
		{
			if( value != _sessions && value.length > 0)
			{
				_sessions = value;
				
				for each(var session:Session in value)
				{
					if(session.isModel)
					{
						planList.addItem(session);
					}else
					{
						sessionList.addItem(session);	
					}
				}
				filterChange = true;
				this.invalidateProperties();
			}
		} 
		
		
		public function get loggedUser():User
		{
			return this._loggedUser;
		}
		
		public function set loggedUser(value:User):void
		{
			this._loggedUser = value;
		}
		public function get filterSession():int {return 1;}
		public function set filterSession(value:int):void
		{

		};
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == explorerSession)
			{
				var sessionBox:VBox = new VBox();
				sessionBox.label = "Séances";
				sessionListView = new SessionListView();
				sessionListView.id = "sessionListView";
				sessionListView.percentWidth = 100;
				sessionListView.percentHeight = 100;
				// set session skin
				sessionListView.setSessionView();
				// set logged user
				sessionListView.loggedUser = loggedUser;
				sessionListView.addEventListener(SessionListViewEvent.SELECT_SESSION, onSelectSession);
				sessionListView.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletListSession);
				sessionBox.addElement(sessionListView);
				explorerSession.addChild(sessionBox);
							
				var planBox:VBox = new VBox();
				planBox.label = "Plans de séance";
				planListView = new SessionListView();
				planListView.id = "planListView";
				planListView.percentWidth = 100;
				planListView.percentHeight = 100;
				planListView.addEventListener(SessionListViewEvent.SELECT_SESSION, onSelectSession);
				planListView.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletListPlan);
				// set plan skin
				planListView.setPlanView();
				// set logged user
				planListView.loggedUser = loggedUser;
				planBox.addElement(planListView);
				explorerSession.addChild(planBox);	
				
				explorerSession.addEventListener(IndexChangedEvent.CHANGE, onChangeViewExplorer);
				
			}
			if (instance == sessionDetailView)
			{
				sessionDetailView.loggedUser = loggedUser;
				sessionDetailView.addEventListener(SessionEditEvent.PRE_DELETE_SESSION, preDeleteSession);
			}

		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(filterChange)
			{
				filterChange = false;
				
				sessionListView.listSessionCollection = this.sessionList;
				this.sessionList.addEventListener(CollectionEvent.COLLECTION_CHANGE , onChangeSessionCollection);
				
				planListView.listPlanCollection = this.planList;
				this.planList.addEventListener(CollectionEvent.COLLECTION_CHANGE , onChangePlanCollection);
				
				if(sessionChange)
				{
					sessionChange = false;
					selectSession();
				}
			}
		}
		
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________
		
		private function onCreationCompletListSession(event:*):void
		{
			// add listeners on filter
			sessionListView.filterText.addEventListener(TextOperationEvent.CHANGE, onChangeTextFilterSession);
			// add listener 
			sessionListView.newSessionButton.addEventListener(MouseEvent.CLICK, onClickNewSession);
		}
		
		private function onCreationCompletListPlan(event:*):void
		{
			// add listeners on filter
			planListView.filterText.addEventListener(TextOperationEvent.CHANGE, onChangeTextFilterPlan);
//			planListView.newPlanButton.addEventListener(MouseEvent.CLICK, onClickNewPlan);

		}
		private function onChangeTextFilterSession(event:TextOperationEvent):void
		{
			
		}
		private function onChangeTextFilterPlan(event:TextOperationEvent):void
		{
			
		}
		
		private function onClickNewSession(event:*):void
		{
			
		}
		private function onClickNewPlan(event:*):void
		{
			
		}
		private function onSelectSession(event:SessionListViewEvent = null):void
		{
			var session:Session = event.selectedSession;
			updateSeletedSession(session);
		}
		
		private function updateSeletedSession(session:Session):void
		{
			this.session = session;
			sessionDetailView.session = session;
			if(session != null)
			{
				var sessionId:int = session.id_session;
				loadListActivity(sessionId);
			}
		}
		// listener if filter was call in SessionListView
		private function onChangeSessionCollection(event:CollectionEvent):void
		{
			var session:Session = this.getIndexSession(this.sessionListView.listSessionCollection);
			if(this.sessionListView.sessionList != null)
			{
				this.sessionListView.sessionList.selectedItem = null;
				this.sessionListView.sessionList.selectedItem = session;
			}
			if(this.sessionListView.sessionDataGrid != null)
			{
				// update selected session after dataGrid creation complet
				sessionListView.sessionDataGrid.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateDataGridComplet);
			}
			updateSeletedSession(session);
		}
		// listener if filter was call in SessionListView
		private function onChangePlanCollection(event:CollectionEvent):void
		{
			var session:Session = this.getIndexSession(this.planListView.listPlanCollection);
			if(this.planListView.sessionList != null)
			{
				this.planListView.planList.selectedItem = null;
				this.planListView.planList.selectedItem = session;
			}
			if(this.planListView.sessionDataGrid != null)
			{
				this.planListView.planDataGrid.selectedItem = null;
				this.planListView.planDataGrid.selectedItem  = session;
			}

			updateSeletedSession(session);
		}
				
		private function onChangeViewExplorer(event:IndexChangedEvent):void
		{
			// TODO : if list is empty
			var sessionListView:SessionListView = (this.explorerSession.selectedChild as VBox).getChildAt(0) as SessionListView;
			var session:Session = null;
			if(sessionListView.id == "sessionListView" )
			{
				if(sessionListView.sessionList != null)
				{
					session = sessionListView.sessionList.selectedItem as Session;	
				}
				if(sessionListView.sessionDataGrid != null)
				{
					session = sessionListView.sessionDataGrid.selectedItem as Session;	
				}
				
			}else
			{
				if(planListView.planList != null)
				{
					session = planListView.planList.selectedItem as Session;		
				}
				if(planListView.planDataGrid != null)
				{
					session = planListView.planDataGrid.selectedItem as Session;	
				}
			}
			// set session
			sessionDetailView.session = session;
			sessionDetailView.initTabNav();
			if(session != null)
			{
				loadListActivity(session.id_session);
			}
		}
		
		
// DELETE SESSION
		private function preDeleteSession(event:SessionEditEvent):void
		{
			var session:Session = event.session;
			var deleteSession:SessionEvent = new SessionEvent(SessionEvent.DELETE_SESSION);
			deleteSession.sessionId = session.id_session;
			this.dispatchEvent(deleteSession);
		}
		
		private function removeSession(value:int,list:ArrayCollection):Boolean
		{
			var indexSession:int= -1;
			var nbrSession:uint = list.length;
			for(var nSession:uint = 0; nSession < nbrSession ; nSession++)
			{
				var session:Session = list.getItemAt(nSession) as Session;
				if(session.id_session == value)
				{
					indexSession = nSession;
					break;
				}
			}
			if(indexSession > -1)
			{
				list.removeItemAt(indexSession);
				return true;
			}
			return false;
		}
		
		public function removeSessionView(value:int, nameUserDeleteSession:String):void
		{	
			var session:Session = sessionDetailView.session;
			if(removeSession(value, this.sessionList))
			{
				if(session.id_session == value)
				{
					Alert.show('La Séance "'+session.theme+'" a été supprimer par '+ nameUserDeleteSession, "Information");
					sessionDetailView.session = null;
					filterChange = true;
					this.invalidateProperties();
				}
			}
			if(removeSession(value, this.planList))
			{
				if(session.id_session == value)
				{
					Alert.show('Le plan de la séance "'+session.theme+'" a été supprimer par '+ nameUserDeleteSession, "Information");
					sessionDetailView.session = null;
					filterChange = true;
					this.invalidateProperties();
				}
			}
		}		
		
		public function updateSession(value:Session):void
		{
			sessionDetailView.feedBackUpdateSession(value);
		}
// ADD SESSION
		public function addSession(session:Session, clonedSession:Boolean):void
		{
			if(this.explorerSession != null)
			{
				// set new session, with null activities
				if(!clonedSession)
				{
					this.session = session;
				}
				if(session.isModel)
				{
					this.planList.addItem(session);
					// change onglet to "plan"
					this.explorerSession.selectedIndex = 1;
					
					this.planListView.selectAllPlan();
					this.planListView.planDataGrid.selectedItem = session;
					var selectedIndexListPlan:int = this.planListView.planDataGrid.selectedIndex;
					this.planListView.planDataGrid.scrollToIndex(selectedIndexListPlan);
					// update session
					sessionDetailView.session = session;
				}else
				{
					this.sessionList.addItem(session);
					// change onglet to "session"
					this.explorerSession.selectedIndex = 0;
					this.sessionListView.selectAllSession();
					this.sessionListView.sessionDataGrid.selectedItem = session;
					var selectedIndexListSession:int = this.sessionListView.sessionDataGrid.selectedIndex;
					this.sessionListView.sessionDataGrid.scrollToIndex(selectedIndexListSession);
					// update session
					sessionDetailView.session = session;
					// set session after add item and after dispatche(call) for load activity
					this.session = session;
				}
			}
		}
		
		public function showClonedPlan(value:int):void
		{
			loadListActivity(value);
		}

		private function loadListActivity(value:int):void
		{
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.LOAD_LIST_ACTIVITY);
			visuActivityEvent.sessionId = value;					
			dispatchEvent(visuActivityEvent);
			
			// get list user was recording in session
			var presentUserEvent:SessionUserEvent = new SessionUserEvent(SessionUserEvent.GET_LIST_SESSION_USER);
			presentUserEvent.sessionId = value;
			this.dispatchEvent(presentUserEvent);
		}
// SELECT SESSION FROM MODULE EXTERNE
		private function selectSession():void
		{
			var session:Session = getIndexSession(this.sessionList);
			// FIXME : if session exclus from the list session ?
			if(sessionListView.sessionList != null)
			{
				sessionListView.sessionList.selectedItem = session;
			}
			if(sessionListView.sessionDataGrid != null)
			{
				// update selected session after dataGrid creation complet
				sessionListView.sessionDataGrid.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateDataGridComplet);
			}
			updateSeletedSession(session);
		}
		/**
		 * Set session visible in dataGrid that was choose outside the SessionModule
		 */
		private function onUpdateDataGridComplet(event:FlexEvent):void
		{
			sessionListView.sessionDataGrid.removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateDataGridComplet);
			if(this.session != null)
			{
				sessionListView.sessionDataGrid.selectedItem = this.session;
				selectedIndexListSession = this.sessionListView.sessionDataGrid.selectedIndex;
				sessionListView.sessionDataGrid.scrollToIndex(selectedIndexListSession);
			}
		}
		
		private function getIndexSession(list:ArrayCollection):Session
		{
			var nbrSession:int = list.length;
			for(var nSession : int = 0; nSession < nbrSession ; nSession++)
			{
				var session:Session = list.getItemAt(nSession) as Session;
				if(this._session != null && session.id_session == this._session.id_session)
				{
					return session;
				}
			}
			return null;
		}
	}
}