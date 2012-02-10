package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.controls.sessions.skins.KeywordSkin;
	import com.ithaca.visu.events.ActivityElementEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.ActivityElementType;
	import com.lyon2.controls.VisuVisio;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Image;
	import mx.core.FlexLoader;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	[Event(name="shareElement",type="com.ithaca.visu.events.ActivityElementEvent")]
	[Event(name="startActivity",type="com.ithaca.visu.events.VisuActivityEvent")]
	
	public class SessionPlanB extends SkinnableContainer
	{
		
		[SkinPart("true")] 
		public var activityGroup:Group;
		
		private var _activities:IList;
		protected var activitiesChanged:Boolean;
		
		public var session_id:int;
		
		private var _sessionStatus:int = VisuVisio.STATUS_NONE;
		protected var sessionStatusChanged:Boolean;
		
		private var _currentActivityId:int = 0;
		protected var currentActivityChanged:Boolean;
		
		[Bindable]
		private var fxgt: _FxGettext = FxGettext;
		
		public function SessionPlanB()
		{
			super();
			_activities = new ArrayList();	
			fxgt = FxGettext;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(sessionStatusChanged)
			{
				sessionStatusChanged = false; 
				var enabledStartButton:Boolean = false;
				if (this._sessionStatus == 1)
				{
					enabledStartButton = true;
				}
				var nbrElements:int = this.numElements;
				for(var nElement:int = 0 ; nElement < nbrElements ; nElement++)
				{
					var element = this.getElementAt(nElement);
					if(element is ActivityDetailB)
					{
						var a:ActivityDetailB = this.getElementAt(nElement) as ActivityDetailB;
						a.startButton.visible = enabledStartButton;
						checkCurrentActivity(a);
					}
				}
			}
			if(currentActivityChanged)
			{
				currentActivityChanged = false;
				
				var nbrElements:int = this.numElements;
				for(var nElement:int = 0 ; nElement < nbrElements ; nElement++)
				{
					var element = this.getElementAt(nElement);
					if(element is ActivityDetailB)
					{
						var activityDetail:ActivityDetailB = this.getElementAt(nElement) as ActivityDetailB;
						checkCurrentActivity(activityDetail);
					}
				}
			}
			if (activitiesChanged)
			{
				activitiesChanged = false;
				
				removeAllElements();
				
				for each (var activity:Activity in _activities)
				{
					var a:ActivityDetailB =  new ActivityDetailB();
					a.activity = activity;
					a.percentWidth = 100;
					a.addEventListener(MouseEvent.DOUBLE_CLICK, shareActivityElement);
					a.addEventListener(FlexEvent.CREATION_COMPLETE, onAddedActivityDetailOnStage);
					addElement( a );
				}
			}
		}
		
		private function onAddedActivityDetailOnStage(event:FlexEvent):void
		{		
			var activityDetail:ActivityDetailB = event.currentTarget as ActivityDetailB;
			activityDetail.removeEventListener(FlexEvent.CREATION_COMPLETE, onAddedActivityDetailOnStage);
			if (this._sessionStatus == VisuVisio.STATUS_NONE)
			{
				activityDetail.startButton.visible = false;
			}else
			{
				checkCurrentActivity(activityDetail);
			}
		}
		
		private function checkCurrentActivity(activityDetail:ActivityDetailB):void
		{
			if(activityDetail.activity.id_activity == _currentActivityId)
			{
				activityDetail.startButton.enabled = false;
				activityDetail.startButton.label = fxgt.gettext("en cours");
			}else
			{
				activityDetail.startButton.enabled = true;	
				activityDetail.startButton.label = fxgt.gettext("start");
			}	
		}
		
		public function getActivityDetailById(value:int):ActivityDetailB
		{
			var nbrElements:int = this.numElements;
			for(var nElement:int = 0 ; nElement < nbrElements ; nElement++)
			{
				var element = this.getElementAt(nElement);
				if(element is ActivityDetailB)
				{
					var activityDetail:ActivityDetailB = this.getElementAt(nElement) as ActivityDetailB;
					var activityId:int = activityDetail.activity.id_activity;
					if(value == activityId)
					{
						return activityDetail;
					}
				}
			} 
			return null;
		}
		
		public function getCurrentActivityId():int{return this._currentActivityId;}
		public function setCurrentActivityId(value:int):void
		{
			if(value != 0)
			{
				_currentActivityId = value;			
			}
			currentActivityChanged = true;
			invalidateProperties();
		}
		
		public function setSessionStatus(value:int):void
		{
			_sessionStatus = value;
			// if stop recording(value == 0) than update currentActivity to 0
			if(value == VisuVisio.STATUS_NONE)
			{
				_currentActivityId = 0;	
				currentActivityChanged = true;
			}
			sessionStatusChanged = true;
			invalidateProperties();
		}		
		
		[Bindable("updateActivities")] 
		public function get activities():IList { return _activities; }
		public function set activities(value:IList):void 
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
			
			dispatchEvent( new Event("updateActivities")); 
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET);
			_activities.dispatchEvent(event);
			
		}
		
		
		protected function activities_ChangeHandler(event:CollectionEvent):void
		{
			activitiesChanged = true;
			invalidateProperties();
		}	
		
		protected function shareActivityElement(event:MouseEvent):void
		{
			trace("shareActivityElement");
			if( !(event.target is ActivityElementDetail  || event.target is FlexLoader )) return;
			var e:ActivityElementEvent = new ActivityElementEvent(ActivityElementEvent.SHARE_ELEMENT);
			if (event.target is ActivityElementDetail)
			{
				e.element = ActivityElementDetail(event.target).activityElement;
			}else
			{
				var flLoader:FlexLoader = event.target as FlexLoader;
				var imageActivity:ImageActivity=  flLoader.parent as ImageActivity;
				e.element = imageActivity.activityElement;
			}
			dispatchEvent(e);
		}
		
	}
}