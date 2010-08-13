package business
{

	import com.ithaca.visu.events.VisuActivityElementEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.visu.model.Activity;
	import com.lyon2.visu.vo.ActivityVO;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class TutoratManager
	{
		// properties
		[Bindable]
		public var listActivities:ArrayCollection = new ArrayCollection();
		
		private var logger : ILogger = Log.getLogger('TutoratManager');
		
		private var dispatcher:IEventDispatcher;
		
		// constructor
		public function TutoratManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		/**
		 * Set activity list 
		 */
		public function onLoadListActivity(arrActivities:Array):void
		{
			if(this.listActivities.length == 0){
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
			// DEBAG MODE without load list activity
			/*var activity:Activity = this.getActivityById(activityId);
			if(activity != null)
			{
				var nbrActivity:int = activity.getListActivityElement().length;
				if((activity != null) && ( nbrActivity == 0))
				{
					activity.setListActivityElement(listActivityElement);
					var ev:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.SHOW_LIST_ACTIVITY);
					ev.listActivity = this.listActivities;
					this.dispatcher.dispatchEvent(ev);
					
				}
			}*/
		}
		
		public function error(event:Object):void
		{
			
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