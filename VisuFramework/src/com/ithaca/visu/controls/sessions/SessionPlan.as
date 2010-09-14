package com.ithaca.visu.controls.sessions
{
	import com.lyon2.visu.model.Activity;
	import com.lyon2.visu.model.ActivityElement;
	import com.lyon2.visu.model.ActivityElementType;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
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
					for each( var el:ActivityElement in activity.getListActivityElement())
					{
						if (el.type_element == ActivityElementType.KEYWORD)
						{
							var s:Label = new Label();
							s.text = el.data;
							keywordGroup.addElement(s);
						}
					}
					addElement( a );
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
	}
}