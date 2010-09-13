package com.ithaca.visu.controls.sessions
{
	import com.lyon2.visu.model.Activity;
	import com.lyon2.visu.model.ActivityElement;
	import com.lyon2.visu.model.ActivityElementType;
	
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import spark.components.Button;
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RichText;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	

	[SkinState("normal")]
	[SkinState("open")]
	
	public class ActivityDetail extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var titleDisplay : TextBase;
		
		[SkinPart("true")]
		public var durationDisplay : TextBase;
		
		[SkinPart("true")]
		public var startButton : Button;
		
		[SkinPart("true")]
		public var statementGroup : Group;
				
		[SkinPart("true")]
		public var documentGroup : Group;
		
		[SkinPart("false")]
		public var memoDisplay : Label;
		

		private var _activity:Activity; 
		private var activityChanged : Boolean;
		
		public function ActivityDetail()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == statementGroup)
			{
			}
			 
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activityChanged)
			{
				activityChanged = false;
				
				titleDisplay.text = _activity.title;
				durationDisplay.text = _activity.duration.toString();
				
				for each (var el:ActivityElement in _activity.getListActivityElement())
				{
					trace("+++++ "+el.data+" - " +el.type_element)
					switch(el.type_element)
					{
					case ActivityElementType.MEMO:
						if (memoDisplay) memoDisplay.text = el.data;
						break;
					case ActivityElementType.STATEMENT:						
						var s:ActivityElementDetail = new ActivityElementDetail();
						//s.setStyle("skinClass","com.ithaca.visu.controls.sessions.skins.StatementSkin");
						s.percentWidth = 100
						s.text = el.data;
						statementGroup.addElement(s);
						break;
					case ActivityElementType.DOCUMENT:						
						var d:Label = new Label();
						d.text = el.data;
						//s.setStyle("skinClass","com.ithaca.visu.controls.sessions.StatementSkin");
						documentGroup.addElement(d);
						break;
					}
				}
			}
		}
		
		
		
		
		[Bindable("activityChanged")]
		public function get activity():Activity
		{
			return _activity;
		}
		
		public function set activity(value:Activity):void
		{
			if( _activity == value) return;
			_activity = value;
			activityChanged = true;
			dispatchEvent( new Event("activityChanged"));
			invalidateProperties();
		}
	 	
	}
}