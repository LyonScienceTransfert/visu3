package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.events.SessionEvent;
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
				sessionListView.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletListSession);
				sessionBox.addElement(sessionListView);
				explorerSession.addChild(sessionBox);
							
				var planBox:VBox = new VBox();
				planBox.label = "Plans de séance";
				planListView = new SessionListView();
				planListView.id = "planListView";
				planListView.percentWidth = 100;
				planListView.percentHeight = 100;
				planListView.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletListPlan);
				// set plan skin
				planListView.setPlanView();
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
				
				sessionListView.sessionList.dataProvider = this.sessionList;
				planListView.planList.dataProvider = this.planList;
				
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
			// add listeners on radioButton
			sessionListView.allButton.addEventListener(MouseEvent.CLICK, onClickAllSession);
			sessionListView.pastButton.addEventListener(MouseEvent.CLICK, onClickPastSession);
			sessionListView.comingButton.addEventListener(MouseEvent.CLICK, onClickComingSession);
			// add listeners on filter
			sessionListView.filterText.addEventListener(TextOperationEvent.CHANGE, onChangeTextFilterSession);
			// add listener 
			sessionListView.newSessionButton.addEventListener(MouseEvent.CLICK, onClickNewSession);
			sessionListView.sessionList.addEventListener(IndexChangeEvent.CHANGE, onChangeSession);
		}
		
		private function onCreationCompletListPlan(event:*):void
		{
			// add listeners on radioButton
			planListView.sharingAllButton.addEventListener(MouseEvent.CLICK, onClickAllPlan);
			planListView.sharingMineButton.addEventListener(MouseEvent.CLICK, onClickMinePlan);
			planListView.sharingOtherButton.addEventListener(MouseEvent.CLICK, onClickOtherPlan);
			// add listeners on filter
			planListView.filterText.addEventListener(TextOperationEvent.CHANGE, onChangeTextFilterPlan);
			// add listener 
			planListView.newPlanButton.addEventListener(MouseEvent.CLICK, onClickNewPlan);
			planListView.planList.addEventListener(IndexChangeEvent.CHANGE, onChangePlan);
		}
		
		private function onClickAllSession(event:*):void
		{
//			filterSession();
		}
		private function onClickPastSession(event:*):void
		{
			
		}
		private function onClickComingSession(event:*):void
		{
			
		}
		private function onClickAllPlan(event:*):void
		{
	
		}
		private function onClickMinePlan(event:*):void
		{
			
		}
		private function onClickOtherPlan(event:*):void
		{
			
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
		private function onChangeSession(event:* = null):void
		{
			var session:Session = sessionListView.sessionList.selectedItem as Session;
			this.session = session;
			sessionDetailView.session = session;
			if(session != null)
			{
				var sessionId:int = session.id_session;
				loadListActivity(sessionId);
			}
		}
		private function onChangePlan(event:IndexChangeEvent):void
		{
			var session:Session = this.planList.getItemAt(event.newIndex) as Session;
			this.session = session;
			sessionDetailView.session = session;
			var sessionId:int = session.id_session;
			loadListActivity(sessionId);
		}
		
		
		private function onChangeViewExplorer(event:IndexChangedEvent):void
		{
			// TODO : if list is empty
			var sessionListView:SessionListView = (this.explorerSession.selectedChild as VBox).getChildAt(0) as SessionListView;
			var session:Session = null;
			if(sessionListView.id == "sessionListView" )
			{
				session = sessionListView.sessionList.selectedItem as Session;	
			}else
			{
				session = planListView.planList.selectedItem as Session;		
			}
			// set session
			sessionDetailView.session = session;
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
				}
			}
			if(indexSession > 1)
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
				}
			}
			if(removeSession(value, this.planList))
			{
				if(session.id_session == value)
				{
					Alert.show('Le plan de la séance "'+session.theme+'" a été supprimer par '+ nameUserDeleteSession, "Information");
					sessionDetailView.session = null;
				}
			}
		}		
		
		public function updateSession(value:Session):void
		{
		}
// ADD SESSION
		public function addSession(session:Session):void
		{
			if(this.explorerSession != null)
			{
				var typeSession:String = "Votre nouvelle séance a été créée et ajoutée à la liste des séances.";
				if(session.isModel)
				{
					typeSession = "Le nouveau plan de séance a été créé et ajouté à la liste des séances.";
					this.planList.addItem(session);
					// change onglet to "plan"
					this.explorerSession.selectedIndex = 1;
					var lastAddedItem:int = this.planList.length-1;
					this.planListView.planList.selectedIndex = lastAddedItem;
					// update session
					sessionDetailView.session = session;
					this.planListView.planList.ensureIndexIsVisible(lastAddedItem);			
				}else
				{
					this.sessionList.addItem(session);
					// change onglet to "session"
					this.explorerSession.selectedIndex = 0;
					var lastAddedItemSession:int = this.sessionList.length-1;
					this.sessionListView.sessionList.selectedIndex = lastAddedItemSession;
					// update session
					sessionDetailView.session = session;
					this.sessionListView.sessionList.ensureIndexIsVisible(lastAddedItemSession);
				}

				Alert.show(typeSession,
					"Information"); 
				dispatchEvent( new Event("update") );
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
			sessionListView.sessionList.selectedItem = session;
			onChangeSession();
		}
		
		private function getIndexSession(list:ArrayCollection):Session
		{
			var nbrSession:int = list.length;
			for(var nSession : int = 0; nSession < nbrSession ; nSession++)
			{
				var session:Session = list.getItemAt(nSession) as Session;
				if(session.id_session == this._session.id_session)
				{
					return session;
				}
			}
			return null;
		}
	}
}