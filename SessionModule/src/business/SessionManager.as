package business
{
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.SessionUserEvent;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.events.VisuActivityElementEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.ActivityElementVO;
	import com.ithaca.visu.model.vo.ActivityVO;
	import com.ithaca.visu.model.vo.SessionUserVO;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;

	public class SessionManager
	{

		private var dispatcher:IEventDispatcher;
		
		protected static var log:ILogger = Log.getLogger("managers.SessionManager");

		public var model:Model; 

		[Bindable] 
		public var sessions:Array=[];
		[Bindable]
		public var listActivities:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var listUser:ArrayCollection = new ArrayCollection();
		
		public function SessionManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function setCurrentSessionId(value:int):void
		{
			Model.getInstance().getTimeServeur();
			Model.getInstance().setCurrentSessionId(value);
		}
		public function getCurrentSessioId():int
		{
			return Model.getInstance().getCurrentSessionId();
		}
		
		public function setSessionAndPlan(value:Array):void 
		{ 
			log.debug( ObjectUtil.toString(value));
			var ar:Array = []
			for each (var sessionVO:SessionVO in value)
			{
				var session:Session = new Session(sessionVO);
				ar.push(session);   
			}
			sessions = ar;
			log.debug("setSessionAndPlan "+ sessions);
		}
		
		/**
		 * Set activity list 
		 */
		public function onLoadListActivity(arrActivities:Array):void
		{
			if(true){
				this.listActivities.removeAll();
				var nbrActivities:uint = arrActivities.length;
				for(var nActivity:uint = 0; nActivity < nbrActivities; nActivity++){
					var obj:Object = arrActivities[nActivity];
					var activity:Activity = new Activity(obj);
					this.listActivities.addItem(activity);
					var activityId:int = obj.id_activity;
					var visuActivtyElementEvent:VisuActivityElementEvent = new VisuActivityElementEvent(VisuActivityElementEvent.LOAD_LIST_ACTIVITY_ELEMENTS);
					visuActivtyElementEvent.activityId = activityId;
					this.dispatcher.dispatchEvent(visuActivtyElementEvent);
				}	
			}
		}
		
		public function onLoadListActivityElement(listActivityElement:Array, activityId:int):void
		{
			var activity:Activity = this.getActivityById(activityId);
			if(activity != null)
			{
				var nbrActivity:int = activity.getListActivityElement().length;
				if((activity != null) && ( nbrActivity == 0))
				{
					activity.setListActivityElement(listActivityElement);
					listActivities.itemUpdated( activity, activity.activityElements);
				}
			}
		}
		
		public function onLoadListUsersSession(listUserVO:Array, sessionId:int):void
		{
			this.listUser.removeAll();
			var nbrUserVO:int = listUserVO.length;
			for(var nUserVO:int = 0; nUserVO < nbrUserVO; nUserVO++)
			{
				var userVO:UserVO = listUserVO[nUserVO];
				var user:User = new User(userVO);
				this.listUser.addItem(user);
			}
		}
		
		public function onUpdateSession(sessionVO:SessionVO):void
		{
			model.clearDateSession();
		}
		public function onUpdateActivity(activityVO:ActivityVO):void
		{
			
		}
		public function onDeleteActivity(activityId:int):void
		{
			
		}
		public function onAddActivity(activityVO:ActivityVO):void
		{
			this.getActivityById(0).id_activity = activityVO.id_activity;
		}
		public function onUpdateActivityElement(activityElement:ActivityElementVO):void
		{
			
		}
//		public function onDeleteActivityElement(activityElementId:int, activityId:int):void
		public function onDeleteActivityElement(value:*):void
		{	

		}
		
		public function onAddActivityElement(value:ActivityElementVO):void
		{
			var idElement:int = value.id_element;
			if(idElement != 0)
			{
				var arrActivityElement:ArrayCollection = this.getActivityById(value.id_activity).activityElements;
				setIdElement(idElement, arrActivityElement);
			}else
			{
				var nbrActivity:int = this.listActivities.length;
				for(var nActivity:int=0; nActivity < nbrActivity; nActivity++)
				{
					var activity:Activity = this.listActivities.getItemAt(nActivity) as Activity;
					var arrActivityElement:ArrayCollection = activity.activityElements;
					var isSet:Boolean = setIdElement(idElement, arrActivityElement);
					if(isSet){ return;}
				}
			}
			
			function setIdElement(id:int , list:ArrayCollection):Boolean
			{
				var nbrElement:int = list.length;
				for(var nElement:int = 0; nElement < nbrElement; nElement++)
				{
					var activityElement:ActivityElement = list.getItemAt(nElement) as ActivityElement;
					if(activityElement.id_element == 0)
					{
						activityElement.id_element = id;
						return true;
					}
				}
				return false;
			}
		}
/// ADD SESSION
		public function onAddSession(sessionVO:SessionVO):void
		{
			var session:Session = new Session(sessionVO);
			var addSession:SessionEvent = new SessionEvent(SessionEvent.ADD_CLONED_SESSION);
			addSession.session = session;
			this.dispatcher.dispatchEvent(addSession);
			if(!session.isModel){
				// add logged user to the new session
				var sessionUserVO:SessionUserVO = new SessionUserVO();
				sessionUserVO.id_session = sessionVO.id_session;
				sessionUserVO.id_user = model.getLoggedUser().id_user;
				sessionUserVO.mask = 0;
				var sessionUserEvent:SessionUserEvent = new SessionUserEvent(SessionUserEvent.ADD_SESSION_USER);
				sessionUserEvent.newSessionUser = sessionUserVO;
				this.dispatcher.dispatchEvent(sessionUserEvent);
				// clear liste date the session
				model.clearDateSession();
			}
			// ADD ACTIVITY
			var nbrActivity:int = this.listActivities.length;
			for(var nActivity:int = 0 ; nActivity < nbrActivity; nActivity++)
			{
				var activity:Activity = this.listActivities.getItemAt(nActivity) as Activity;
				var activityVO:ActivityVO = setActivityVO(activity,sessionVO.id_session);
				var addActivity:SessionEvent = new SessionEvent(SessionEvent.ADD_CLONED_ACTIVITY);
				addActivity.activityVO = activityVO;
				addActivity.activityId = activity.id_activity;
				this.dispatcher.dispatchEvent(addActivity);
			}
		}		
// ADD ACTIVITY		
		public function onAddClonedActivity(activityVO:ActivityVO, activityId:int):void
		{
			
			var activity:Activity = this.getActivityById(activityId);
				var arrActivityElement:ArrayCollection = activity.activityElements;
				var nbrActivityElement:int = arrActivityElement.length;
				for(var nActivityElement:int = 0; nActivityElement < nbrActivityElement; nActivityElement++ )
				{
					var activityElement:ActivityElement = arrActivityElement.getItemAt(nActivityElement) as ActivityElement;
					var activityElementVO: ActivityElementVO = setActivityElementVO(activityElement, activityVO.id_activity);
					var addActivityElement:SessionEvent = new SessionEvent(SessionEvent.ADD_CLONED_ACTIVITY_ELEMENT);
					addActivityElement.activityElementVO = activityElementVO;
					this.dispatcher.dispatchEvent(addActivityElement);
				}
		}
		
		
		public function onAddClonedActivityElement(value:ActivityElementVO):void
		{
			
		}
// USER
		public function onAddSessionUser(sessionUserVO:SessionUserVO):void
		{
			model.clearDateSession();	
		}

		public function onRemoveSessionUser(value:int):void
		{
			model.clearDateSession();	
		}
		public function onLoadListUsers(value:Array):void
		{
			var ar:Array = []
			for each (var vo:UserVO in value)
			{
				ar.push(new User(vo)) ; 
			}
			
			var onLoadedAllUsers:UserEvent = new UserEvent(UserEvent.LOADED_ALL_USERS,true);
			onLoadedAllUsers.listUser = ar;
			this.dispatcher.dispatchEvent(onLoadedAllUsers);
		}
		/**
		 * Default error Handler for rtmp method call
		 */
		public function error(event:Event):void
		{
			log.error(event.toString());
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
		
		private function setActivityVO(activity:Activity,sessionId:int):ActivityVO
		{
			var activityVO:ActivityVO = new ActivityVO();
			activityVO.id_activity = activity.id_activity; 
			activityVO.id_session = sessionId;
			activityVO.title = activity.title;
			activityVO.duration = activity.duration;
			activityVO.ind = activity.ind;
			return activityVO;
		}
		private function setActivityElementVO(activityElement:ActivityElement, idActivity:int):ActivityElementVO
		{
			var alm:ActivityElementVO = new ActivityElementVO();
			var idActivity:int;
			alm.id_activity = idActivity;
			alm.data = activityElement.data;
			alm.url_element = activityElement.url_element;
			alm.type_element = activityElement.type_element;
			alm.type_mime = activityElement.type_mime;
			return alm;
		}
		
		
		private function getActivityById(value:int):Activity
		{
			var nbrActivity:uint = this.listActivities.length;
			for(var nActivity:uint = 0; nActivity < nbrActivity;nActivity++)
			{
				var activity:Activity = this.listActivities[nActivity];
				var activityId:int = activity.id_activity;
				if(activityId == value)
				{
					return activity;
				}
			}
			return null;
		}
		
	}
}