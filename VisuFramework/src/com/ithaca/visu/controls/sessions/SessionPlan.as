package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.controls.sessions.skins.KeywordSkin;
	import com.ithaca.visu.events.ActivityElementEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.lyon2.visu.model.Activity;
	import com.lyon2.visu.model.ActivityElement;
	import com.lyon2.visu.model.ActivityElementType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Image;
	import mx.core.FlexLoader;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	[Event(name="shareElement",type="com.ithaca.visu.events.ActivityElementEvent")]
	[Event(name="startActivity",type="com.ithaca.visu.events.VisuActivityEvent")]
	
	public class SessionPlan extends SkinnableContainer
	{

		[SkinPart("true")] 
		public var activityGroup:Group;
		
		[SkinPart("false")] 
		public var keywordGroup:Group;
		
		private var _keywords:IList;
		protected var keywordsChanged:Boolean;
		
		private var _activities:IList;
		protected var activitiesChanged:Boolean;
		
		public var session_id:int;
		
		
		public function SessionPlan()
		{
			super();
			_activities = new ArrayList();	
		
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activitiesChanged)
			{
				activitiesChanged = false;
				
				removeAllElements();
				keywordGroup.removeAllElements();
				
				for each (var activity:Activity in _activities)
				{
					var a:ActivityDetail =  new ActivityDetail();
					
					a.activity = activity;
					a.percentWidth = 100;
					a.addEventListener(MouseEvent.DOUBLE_CLICK, shareActivityElement);
					addElement( a );
					
					for each( var el:ActivityElement in activity.getListActivityElement())
					{
						if (el.type_element == ActivityElementType.KEYWORD)
						{
							var s:ActivityElementDetail = new ActivityElementDetail();
							s.setStyle("skinClass",KeywordSkin);
							s.label = el.data;
							s.activityElement = el;
							s.doubleClickEnabled = true;
							s.addEventListener(MouseEvent.DOUBLE_CLICK,shareActivityElement);
							keywordGroup.addElement(s);
						}
					}
					
				}
			}
		}
		
		
		[Bindable("updateKeywords")]
		public function get keywords():IList { return _keywords; }
		public function setKeywords(value:Array):void
		{
			_keywords = new ArrayList(value);
			dispatchEvent( new Event("updateKeywords"));
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