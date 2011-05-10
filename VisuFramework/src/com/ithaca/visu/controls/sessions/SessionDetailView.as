package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	import com.ithaca.visu.view.session.controls.SessionPlanEdit;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TabNavigator;
	import mx.controls.Alert;
	import mx.controls.LinkButton;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import spark.components.Button;
	import spark.components.NavigatorContent;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("empty")]
	[SkinState("planMine")]
	[SkinState("planOther")]
	[SkinState("sessionPast")]
	[SkinState("sessionComing")]
	
	public class SessionDetailView extends SkinnableComponent
	{
		[SkinPart("true")]
		public var deleteButtonSession:Button;
		[SkinPart("true")]
		public var deleteButtonPlan:Button;

		
		[SkinPart("true")]
		public var tabNav:TabNavigator;
		
		[SkinPart("true")]
		public var planTab:NavigatorContent;
		[SkinPart("true")]
		public var dateTab:NavigatorContent;
		[SkinPart("true")]
		public var recordTab:NavigatorContent;
		
		
		[SkinPart("true")]
		public var sharePlanButton:Button;
		[SkinPart("true")]
		public var createSessionButton:Button;
		
		[SkinPart("true")]
		public var goRetroButton:LinkButton;
		
		
		[SkinPart("true")]
		public var sessionFormView:SessionEditFormView;
		
		[SkinPart("true")]
		public var sessionSummaryView:SessionSummaryView;
		
		[SkinPart("true")]
		public var sessionPlanEdit:SessionPlanEdit;
		
		[SkinPart("true")]
		public var sessionBilanFormView:SessionBilanFormView;
		
		[SkinPart("true")]
		public var saveButton:Button;

		
		private var _listUser:ArrayCollection;
		private var _listPresentUser:ArrayCollection;
		
		private var _activities:ArrayCollection;
		
		private var _profiles:Array;
		
		private var _session:Session;
		private var _loggedUser:User;
		private var sessionChanged:Boolean;
		private var planedUsersChanged:Boolean;
		private var presentUsersChanged:Boolean;
		private var activitiesChanged:Boolean;
		private var _durationRecorded:Number;
		private var durationRecordedChange:Boolean;
		private var _nbrRetroDocumentOwner:int = 0;
		private var _nbrRetroDocumentShare:int = 0;
		private var nbrRetrodocumentChange:Boolean;
		
		private var planSkin:Boolean;
		private var planMineSkin:Boolean;
		private var sessionPastSkin:Boolean;
		private var emptySkin:Boolean;
		
		private var planSessionEditabled:Boolean;
		private var flagNeedUpdateSession:Boolean = false;
		private var TIME_UPDATE_SESSION:Number = 10000;
		private var timer:Timer;
		
		public function SessionDetailView()
		{
			super();
			_listUser = new ArrayCollection();
			_activities = new ArrayCollection();
			_listPresentUser = new ArrayCollection();
			this.addEventListener(Event.REMOVED_FROM_STAGE, stopTimer);
			startTimer();
		}
		
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________

		public function get session():Session
		{
			return _session;
		}
		
		public function set session(value:Session):void
		{
			if(value != _session)
			{
				stopTimer();
			}
			_session = value;
			emptySkin = false;
			
			if( value == null)
			{
				emptySkin = true;
				this.invalidateSkinState();
			} else
			{
				// set users of the session
				this.users = value.participants;
				
				planSkin = false;	
				planMineSkin  = false;
				sessionPastSkin = false;
				// set plan session editabled
				planSessionEditabled = false;
				if(session.isModel)
				{
					planSkin = true;
					if(session.id_user == loggedUser.id_user)
					{ 
						planMineSkin = true;
						planSessionEditabled = true;
					}
				}else{
					if(session.statusSession == SessionStatusEnum.SESSION_CLOSE && !session.isModel)
					{
						sessionPastSkin = true;
					}else
					{
						planSessionEditabled = true;
					}
				}
				invalidateSkinState();
				
				sessionChanged = true;
				invalidateProperties();
			}
		}

		public function get users():ArrayCollection
		{
			return _listUser;
		}
		
		public function set users(value:ArrayCollection):void
		{
			if (_listUser == value) return;
			
			_listUser = value;
			planedUsersChanged = true;
			invalidateProperties();
			
			if (_listUser)
			{
				_listUser.addEventListener(CollectionEvent.COLLECTION_CHANGE, users_ChangeHandler);
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
		
		public function get activities():ArrayCollection
		{
			return _activities;
		}
		public function set activities(value:ArrayCollection):void
		{
			if (_activities == value) return;
			
			if (_activities != null)
			{
				_activities.removeEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
			}
			
			_activities = value;
			activitiesChanged = true;
			invalidateProperties();
			
			if (_activities)
			{
				_activities.addEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
			}

		}
		public function set allUsers(value:Array):void
		{
			if(sessionFormView != null)
			{
				sessionFormView.allUsers = value;
			}
		}
		public function get listPresentUser():ArrayCollection
		{
			return _listPresentUser;
		}
		
		public function set listPresentUser(value:ArrayCollection):void
		{	
			_listPresentUser = value;
			presentUsersChanged = true;
			invalidateProperties();
		}
		// set duration recorded in miliseconds 
		public function set durationRecorded(value:Number):void
		{
			this._durationRecorded = value;
			this.durationRecordedChange = true;
			this.invalidateProperties();
		}
		
		// set nbrRetroDocumentOwner 
		public function set nbrRetroDocumentOwner(value:int):void
		{
			this._nbrRetroDocumentOwner = value;
			this.nbrRetrodocumentChange = true;
			invalidateProperties();
		}
		
		// set nbrRetroDocumentOwner 
		public function set nbrRetroDocumentShare(value:int):void
		{
			this._nbrRetroDocumentShare = value;
			this.nbrRetrodocumentChange = true;
			invalidateProperties();
		}

		public function set profiles(value:Array):void
		{
			this._profiles = value;
			this.sessionFormView.profiles = value;
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == tabNav)
			{	
				// add plan the session
				sessionPlanEdit = new SessionPlanEdit();
				sessionPlanEdit.activities = null;
				sessionPlanEdit.percentHeight = 100;
				sessionPlanEdit.percentWidth = 100;
				sessionPlanEdit.addEventListener(SessionEditEvent.PRE_ADD_SESSION, onPreAddSession);
				sessionPlanEdit.addEventListener(SessionEditEvent.UPDATE_ACTIVITY, onUpdateDurationPlaned,true);
				sessionPlanEdit.addEventListener(SessionEditEvent.UPDATE_THEME, onUpdateTheme);
				planTab = new NavigatorContent();
				planTab.label = "Plan de séance";
				planTab.addElement(sessionPlanEdit);
				tabNav.addChild(planTab);
				// add date and users
				sessionFormView = new SessionEditFormView();
				sessionFormView.percentHeight = 100;
				sessionFormView.percentWidth = 100;
				sessionFormView.addEventListener(SessionEditEvent.UPDATE_DATE_TIME, onUpdateDateTime);
				sessionFormView.addEventListener(SessionEditEvent.UPDATE_LIST_PLANED_USER, onUpdateListPlanedUser);
				dateTab = new NavigatorContent();
				dateTab.label = "Dates et participants";
				dateTab.addElement(sessionFormView);
				tabNav.addChild(dateTab);
				// add bilan
				sessionBilanFormView = new SessionBilanFormView();
				sessionBilanFormView.percentHeight = 100;
				sessionBilanFormView.percentWidth = 100;
				recordTab = new NavigatorContent();
				recordTab.label = "Compte-rendu de séance";
				recordTab.addElement(sessionBilanFormView);
				tabNav.addChild(recordTab);
			}
			if (instance == deleteButtonSession)
			{
				deleteButtonSession.addEventListener(MouseEvent.CLICK, onDeleteSession);
			}
			if (instance == deleteButtonPlan)
			{
				deleteButtonPlan.addEventListener(MouseEvent.CLICK, onDeletePlan);
			}
			if (instance == sessionSummaryView)
			{
				sessionSummaryView.loggedUser = this.loggedUser;
			}
			if (instance == saveButton)
			{
				saveButton.enabled = false;
				saveButton.addEventListener(MouseEvent.CLICK, onSaveSession);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(sessionChanged)
			{
				sessionChanged = false;
				sessionSummaryView.session = this.session;
				sessionFormView.session = this.session;	
				sessionBilanFormView.session = this.session;
				sessionPlanEdit.theme = this.session.theme;
				startTimer();
			}
			
			if(activitiesChanged)
			{
				activitiesChanged = false;
				
				sessionPlanEdit.setEditabled(planSessionEditabled);
				sessionPlanEdit.activities = activities;
				checkDurationPlaned()
			}
			
			if(presentUsersChanged)
			{
				presentUsersChanged = false;
				sessionSummaryView.listPresentUser = listPresentUser;
				sessionBilanFormView.listPresentUser = listPresentUser;
			}

			if(durationRecordedChange)
			{
				durationRecordedChange = false;
				sessionSummaryView.durationRecorded = this._durationRecorded;
				sessionBilanFormView.durationRecorded = this._durationRecorded;
			}
			
			if(nbrRetrodocumentChange)
			{
				nbrRetrodocumentChange = false;
				this.sessionSummaryView.nbrRetrodocument = this._nbrRetroDocumentOwner + this._nbrRetroDocumentShare;
				sessionBilanFormView.nbrRetroDocumentOwner = this._nbrRetroDocumentOwner;
				sessionBilanFormView.nbrRetroDocumentShare = this._nbrRetroDocumentShare;
			}
		}
		//_____________________________________________________________________
		//
		// Handlers
		//
		//_____________________________________________________________________
		
		protected function users_ChangeHandler(event:CollectionEvent):void
		{
			planedUsersChanged = true;
			invalidateProperties();
		}
		protected function activities_ChangeHandler(event:CollectionEvent):void
		{
			activitiesChanged = true;
			invalidateProperties();
		}
		
		private function checkDurationPlaned():void
		{
			var duration:int = 0;
			for each(var activity:Activity in this.activities)
			{
				duration += activity.duration;
			}
			sessionSummaryView.durationPlaned = duration;
			sessionFormView.durationPlaned = duration;
			
		}
		
		override protected function getCurrentSkinState():String
		{
			var skinName:String;
			if(!enabled)
			{
				skinName = "disable";
			}else if(emptySkin){skinName = "empty"}
			else if(planSkin)
			{
				  if(planMineSkin){skinName = "planMine"}else{skinName = "planOther"}
			}else if(sessionPastSkin){skinName = "sessionPast"} else{skinName = "sessionComing"};

			return skinName;
		}
		
		
		public function updateSkin(value:String):void
		{
			var planEditabled:Boolean = false;
			switch (value)
			{
				case "planMine" :
				case "planOther" :
					tabNav.removeAllChildren();
					tabNav.addChild(planTab);
					initTabNav();
					break;
				case "sessionComing" :
					tabNav.removeAllChildren();
					tabNav.addChild(planTab);
					tabNav.addChild(dateTab);
					planEditabled = true;      
					break;
				case "sessionPast" :
					tabNav.removeAllChildren();
					tabNav.addChild(planTab);
					tabNav.addChild(recordTab);
					break;
			// FIXME : when in "sessionComing" view dateTab is selected, 
			//	than replace the view to "sessionPast" => index tabNav=0, but label of index = 1 is active. 
			}
			sessionPlanEdit.setEditabled(planEditabled);
		}
		
		public function initTabNav():void
		{
			tabNav.selectedIndex = 0;
		}
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________
		
// ADD SESSION
		private function onPreAddSession(event:SessionEditEvent):void
		{
			var addSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_SESSION);
			//_session.date_session = event.date;
			addSession.session = session;
			addSession.date = event.date;
			addSession.theme = event.theme;
			addSession.isModel = event.isModel;
			this.dispatchEvent(addSession);
		}
// DELETE SESSION
		private function onDeleteSession(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous supprimer cet séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, deleteSessionConformed);
		}
// DELETE PLAN
		private function onDeletePlan(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous supprimer cet plan de séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, deleteSessionConformed);
		}
		
		private function deleteSessionConformed(event:CloseEvent):void{
			if( event.detail == Alert.YES)
			{
				var sessionDeleteEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_DELETE_SESSION);
				sessionDeleteEvent.session = this.session;
				this.dispatchEvent(sessionDeleteEvent);
			}
		}
// UPDATE DATE TIME
		private function onUpdateDateTime(event:SessionEditEvent):void
		{
			var date:Date = event.date;
			// FIXME : for update the date on renderer have to change object(not just time in the objet)
			session.date_session = null;
			session.date_session = date;
			sessionSummaryView.dateSession = date;
			needUpdateSession();
		}
// UPDATE LIST PLANED USER 
		private function onUpdateListPlanedUser(event:SessionEditEvent):void
		{
			var listPlanedUser:ArrayCollection = event.listPlanedUser;
			sessionSummaryView.listPresentUser = listPlanedUser;
		}
// UPDATE DURATION PLANED 
		private function onUpdateDurationPlaned(event:SessionEditEvent):void
		{
			checkDurationPlaned();
		}
// UPDATE THEME
		private function onUpdateTheme(event:SessionEditEvent):void
		{
			if(session != null && session.theme != null)
			{
				this.session.theme = "";
				this.session.theme = event.theme;
			}
			needUpdateSession();
			sessionSummaryView.theme = event.theme;
		}
// UPDATE SESSION
		private function updateSession():void
		{
			var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
			updateSession.session = this.session;
			this.dispatchEvent(updateSession);
		}
// SAVE SESSION 
		private function onSaveSession(event:MouseEvent):void
		{
			updateSession();
		}
		public function feedBackUpdateSession(value:Session):void
		{
			if(saveButton != null)
			{
				saveButton.enabled = false;
			}
		}
		
		private function startTimer():void
		{
			if(!timer)
			{
				timer = new Timer(TIME_UPDATE_SESSION,0);
				timer.addEventListener(TimerEvent.TIMER, checkUpdateSegment);
			}
			timer.start();
		}
		private function checkUpdateSegment(event:TimerEvent):void
		{
			if(flagNeedUpdateSession)
			{
				flagNeedUpdateSession = false;
				updateSession();
			}
		}
		
		private function needUpdateSession():void
		{
			flagNeedUpdateSession = true;
			if(saveButton != null)
			{
				saveButton.enabled = true;
			}
		}
		
		private function stopTimer(event:*=null):void
		{
			saveButton.enabled = false;
			flagNeedUpdateSession = false;
			if(timer != null)
			{
				this.timer.stop();
				this.timer = null;
			}
		}
	}
}