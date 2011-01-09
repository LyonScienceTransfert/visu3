package business
{
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.VisuActivityElementEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.ActivityElementVO;
	import com.ithaca.visu.model.vo.ActivityVO;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
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
				session.statusSession
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
		
		public function onUpdateSession(sessionVO:SessionVO):void
		{
			
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
		public function onDeleteActivityElement(activityElementId:int):void
		{
			
		}
		
		public function onAddActivityElement(value:ActivityElementVO):void
		{
			var idElement:int = value.id_activity;
			if(idElement != 0)
			{
				var arrActivityElement:ArrayCollection = this.getActivityById(value.id_activity).activityElements;
				setIdElement(idElement, arrActivityElement);
			}else
			{
				var nbrActivity:int = this.listActivities.length;
				for(var nActivity:int=0; nActivity < nbrActivity; nActivity++)
				{
					var activity:Activity = this.listActivities.getItemIndex(nActivity) as Activity;
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
						return true
					}
				}
				return false;
			}
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