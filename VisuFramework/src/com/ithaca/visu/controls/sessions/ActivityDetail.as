package com.ithaca.visu.controls.sessions
{
	import com.ithaca.utils.ExtendToolTip;
	import com.ithaca.visu.controls.sessions.skins.StatementSkin;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.ActivityElementType;
	import com.ithaca.visu.ui.utils.IconEnum;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.ToolTipEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	

	[SkinState("normal")]
	[SkinState("open")]
	// Bubling event
	[Event(name="startActivity",type="com.ithaca.visu.events.VisuActivityEvent")]
	
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
		
		private var open:Boolean;

		private var _activity:Activity; 
		private var activityChanged : Boolean;
		
		private var statementList:IList;
		private var documentList:IList; 
		private var memo:String=""; 
		private var TOOL_TIPS_IMAGE_WIDTH:int = 160;
		
		
		public function ActivityDetail()
		{
			super();
			statementList = new ArrayCollection();
			documentList = new ArrayCollection();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleDisplay)
			{
				titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			
			if (instance == titleDisplay)
			{
				titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			if (instance == durationDisplay)
			{
				durationDisplay.text = "Durée prévue : " +activity.duration.toString();
			}
			if (instance == startButton)
			{
				startButton.addEventListener(MouseEvent.CLICK,startButton_clickHandler);
			}
			if (instance == statementGroup)
			{
				trace("add statementGroup");
				if (statementList.length > 0) 
					addStatements(statementList);
			}
			
			if (instance == documentGroup)
			{
				trace("add documentGroup");
				if (documentList.length > 0) 
					addDocuments(documentList);
			}

			if (instance == memoDisplay)
			{
				if (_activity != null) memoDisplay.text = memoDisplay.toolTip = memo;
			}
			 
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == titleDisplay)
			{
				titleDisplay.removeEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			if (instance == startButton)
			{
				startButton.removeEventListener(MouseEvent.CLICK,startButton_clickHandler);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activityChanged)
			{
				activityChanged = false;
				
				titleDisplay.toolTip = titleDisplay.text = _activity.title;
				if (durationDisplay) durationDisplay.text = "Durée prévue : " + _activity.duration.toString();
				parseActivityElements();

			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disable" : open? "open" : "normal";
		}
		
		protected function parseActivityElements():void
		{
			for each (var el:ActivityElement in _activity.getListActivityElement())
			{
				switch(el.type_element)
				{
					case ActivityElementType.MEMO:
						memo = el.data;				
						break;
					case ActivityElementType.STATEMENT:					
						statementList.addItem(el);
						break;
					case ActivityElementType.IMAGE:
						documentList.addItem(el);
						break;
					case ActivityElementType.VIDEO:
						documentList.addItem(el);
						break;
				}
			}
		}
		protected function addStatements(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				//var s:com.ithaca.visu.controls.sessions.ActivityElementDetail = new com.ithaca.visu.controls.sessions.ActivityElementDetail();
				var s:ActivityElementDetail = new ActivityElementDetail();
				s.setStyle("skinClass",StatementSkin);
				s.percentWidth = 100;
				s.label = el.data;
				s.activityElement = el;
				s.doubleClickEnabled = true;
				//s.addEventListener(MouseEvent.DOUBLE_CLICK, activityElement_doubleClickHandler);
				statementGroup.addElement(s);
			}
		}
		protected function addDocuments(list:IList):void
		{
			for each( var el:ActivityElement in list)
			{
				var image:ImageActivity = new ImageActivity()
				var source:String = IconEnum.getPathByName("video");
				if(el.type_element == "image")
				{
					source = el.url_element;
				}
				image.source = source;
				image.toolTip = el.data;
				image.activityElement = el;
				image.doubleClickEnabled = true;
				image.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, onToolTipsCreate);
				image.addEventListener(ToolTipEvent.TOOL_TIP_SHOW, onToolTipsShown);
				documentGroup.addElement(image);
			}
		}
		private function onToolTipsCreate(event:ToolTipEvent):void{
			event.toolTip = this.createTip(event.currentTarget.toolTip, event.currentTarget.source);
		} 
		
		private function createTip(tip:String, urlImage:String):ExtendToolTip{
			var imageToolTip:ExtendToolTip = new ExtendToolTip();
			imageToolTip.ImageTip = urlImage;
			imageToolTip.TipText = tip;
			imageToolTip.setSizeImage(TOOL_TIPS_IMAGE_WIDTH);
			return imageToolTip;
		}
		private function onToolTipsShown(event:ToolTipEvent):void{
			var toolTip:ExtendToolTip = event.toolTip as ExtendToolTip;
			toolTip.y = toolTip.y  - TOOL_TIPS_IMAGE_WIDTH;
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
		public function titleDisplay_clickHandler(event:MouseEvent):void
		{
			open = !open;
			invalidateSkinState();
		}
		protected function startButton_clickHandler(event:MouseEvent):void
		{
			var e:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.START_ACTIVITY);
			e.activity = activity;
			dispatchEvent(e);
			if( open == false )
			{
				open = true;
				invalidateSkinState();
			}
		}
	}
}