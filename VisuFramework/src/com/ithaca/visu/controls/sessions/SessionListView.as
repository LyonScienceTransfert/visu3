package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.events.SessionListViewEvent;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	import com.lyon2.controls.utils.TimeUtils;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.graphics.SolidColor;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButton;
	import spark.components.TextInput;
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.primitives.Rect;
	import mx.collections.Sort;
	
	
	[Event(name="selectSession",type="com.ithaca.visu.events.SessionListViewEvent")]
	[Event(name="changeTextFilter",type="com.ithaca.visu.events.SessionListViewEvent")]
	
	[SkinState("plan")]
	[SkinState("session")]
	
	public class SessionListView extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var allButton:RadioButton;
		[SkinPart("true")]
		public var pastButton:RadioButton;
		[SkinPart("true")]
		public var comingButton:RadioButton;
		
		[SkinPart("true")]
		public var sharingAllButton:RadioButton;
		[SkinPart("true")]
		public var sharingMineButton:RadioButton;
		[SkinPart("true")]
		public var sharingOtherButton:RadioButton;
		
		[SkinPart("true")]
		public var filterText:TextInput;
		
		[SkinPart("true")]
		public var newPlanButton:Button;
		[SkinPart("true")]
		public var newSessionButton:Button;
		
		[SkinPart("true")]
		public var solidColorFilter:SolidColor;
		[SkinPart("true")]
		public var filterAreaBorder:Rect;
		[SkinPart("true")]
		public var filterLabel:Label;
		[SkinPart("true")]
		public var filterGroup:HGroup;
		[SkinPart("true")]
		public var filterPlanButtonsGroup:VGroup;
		[SkinPart("true")]
		public var filterSessionButtonsGroup:VGroup;
		[SkinPart("true")]
		public var newPlanSessionButtonsGroup:Group;

		[SkinPart("true")]
		public var planList:List;
		[SkinPart("true")]
		public var sessionList:List;
		
		private var plan:Boolean;
		
		private var _filterAlpha:Number = 0.2 ;
		private var filterAlphaChange:Boolean;
		
		private var _showFilterAreaBorder:Boolean = true;
		private var showFilterAreaBorderChange:Boolean;
		
		private var _showFilterLabels:Boolean = true;
		private var showFilterLabelsChange:Boolean;

		private var _showFilterButtons:Boolean = true;
		private var showFilterButtonsChange:Boolean;
		
		private var _showFilterText:Boolean = true;
		private var showFilterTextChange:Boolean

		private var _showNewButton:Boolean = true;
		private var showNewButtonChange:Boolean
		
		public function SessionListView()
		{
			super();
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________		
		public function setPlanView():void
		{
			plan = true;
			this.invalidateSkinState();
		}
		
		public function setSessionView():void
		{
			plan = false;
			this.invalidateSkinState();
		}
		
		public function get filterAlpha():Number
		{
			return _filterAlpha;
		}
		
		public function set filterAlpha(value:Number):void
		{
			_filterAlpha = value;
			filterAlphaChange = true;
			this.invalidateSkinState();
		}
		
		public function get showFilterAreaBorder():Boolean
		{
			return _showFilterAreaBorder;
		}
		
		public function set showFilterAreaBorder(value:Boolean):void
		{
			_showFilterAreaBorder = value;
			showFilterAreaBorderChange = true;
			this.invalidateSkinState();
		}
		public function get showFilterLabels():Boolean
		{
			return _showFilterLabels;
		}
		
		public function set showFilterLabels(value:Boolean):void
		{
			_showFilterLabels = value;
			showFilterLabelsChange = true;
			this.invalidateSkinState();
		}
		public function get showFilterButtons():Boolean
		{
			return _showFilterButtons;
		}
		
		public function set showFilterButtons(value:Boolean):void
		{
			_showFilterButtons = value;
			showFilterButtonsChange = true;
			this.invalidateSkinState();
		}
		
		public function get showFilterText():Boolean
		{
			return _showFilterText;
		}
		
		public function set showFilterText(value:Boolean):void
		{
			_showFilterText = value;
			showFilterTextChange = true;
			this.invalidateSkinState();
		}
		
		public function get showNewButton():Boolean
		{
			return _showNewButton;
		}
		
		public function set showNewButton(value:Boolean):void
		{
			_showNewButton = value;
			showNewButtonChange = true;
			this.invalidateSkinState();
		}

		
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(filterAlphaChange)
			{
				filterAlphaChange = false;
				solidColorFilter.alpha = _filterAlpha;
			}
			
			if(showFilterAreaBorderChange)
			{
				showFilterAreaBorderChange = false;
				filterAreaBorder.visible = _showFilterAreaBorder;
			}
			
			if(showFilterLabelsChange)
			{
				showFilterLabelsChange = false;
				filterLabel.visible = _showFilterLabels;
				filterLabel.includeInLayout = _showFilterLabels;
				filterGroup.visible = _showFilterLabels;
				filterGroup.includeInLayout = _showFilterLabels;
			}
			
			if(showFilterButtonsChange)
			{
				showFilterButtonsChange = false;
				if(filterPlanButtonsGroup != null)
				{
					filterPlanButtonsGroup.visible = _showFilterButtons;
					filterPlanButtonsGroup.includeInLayout = _showFilterButtons;
				}
				if(filterSessionButtonsGroup != null)
				{
					filterSessionButtonsGroup.visible = _showFilterButtons;
					filterSessionButtonsGroup.includeInLayout = _showFilterButtons;
				}
			}
			
			if(showFilterTextChange)
			{
				showFilterTextChange = false;
				if(filterGroup != null)
				{
					filterGroup.visible = _showFilterText;
					filterGroup.includeInLayout = _showFilterText;
				}
			}

			if(showNewButtonChange)
			{
				showNewButtonChange = false;
				if(newPlanSessionButtonsGroup != null)
				{
					newPlanSessionButtonsGroup.visible = _showNewButton;
					newPlanSessionButtonsGroup.includeInLayout = _showNewButton;
				}
			}
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == newSessionButton)
			{
				newSessionButton.addEventListener(MouseEvent.CLICK, onAddNewSession);
			}
			
			if (instance == newPlanButton)
			{
				newPlanButton.enabled = false;
			}
			
			if (instance == filterPlanButtonsGroup)
			{
				filterPlanButtonsGroup.visible = _showFilterButtons;
				filterPlanButtonsGroup.includeInLayout = _showFilterButtons;
			}
			
			if (instance == filterSessionButtonsGroup)
			{
				filterSessionButtonsGroup.visible = _showFilterButtons;
				filterSessionButtonsGroup.includeInLayout = _showFilterButtons;
			}
			
			if (instance == filterGroup)
			{
				filterGroup.visible = _showFilterButtons;
				filterGroup.includeInLayout = _showFilterButtons;
			}
			
			if (instance == newPlanSessionButtonsGroup)
			{
				newPlanSessionButtonsGroup.visible = _showFilterButtons;
				newPlanSessionButtonsGroup.includeInLayout = _showFilterButtons;
			}
			
			if (instance == newPlanSessionButtonsGroup)
			{
				newPlanSessionButtonsGroup.visible = _showFilterButtons;
				newPlanSessionButtonsGroup.includeInLayout = _showFilterButtons;
			}

			if(instance == filterLabel)
			{
				filterLabel.visible = _showFilterLabels;
				filterLabel.includeInLayout = _showFilterLabels;
			}
			
			if(instance == filterGroup)
			{
				filterGroup.visible = _showFilterLabels;
				filterGroup.includeInLayout = _showFilterLabels;
			}

			if(instance == filterAreaBorder)
			{
				filterAreaBorder.visible = _showFilterLabels;
			}

			if(instance == solidColorFilter)
			{
				solidColorFilter.alpha = _filterAlpha;
			}
			
			if(instance == planList)
			{
				planList.addEventListener(IndexChangeEvent.CHANGE, onChangeSession);
			}
			
			if(instance == sessionList)
			{
				sessionList.addEventListener(IndexChangeEvent.CHANGE, onChangeSession);
				//var sort:Sort = new Sort(); 	
				//sort.compareFunction = TimeUtils.compareDates;
				//sessionList.dataProvider.sort = sort;
	            
			}
			if(instance == filterText)
			{
				filterText.addEventListener(TextOperationEvent.CHANGE, onChangeTextFilter);
			}
			
		}
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disable" : plan? "plan" : "session";
		}
		
		
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________

		private function onChangeSession(event:IndexChangeEvent):void
		{
			var list:List = event.currentTarget as List;
			var session:Session = list.selectedItem as Session;
			var selectSessionEvent:SessionListViewEvent = new SessionListViewEvent(SessionListViewEvent.SELECT_SESSION);
			selectSessionEvent.selectedSession = session;
			dispatchEvent(selectSessionEvent);	
		}
		
		private function onChangeTextFilter(event:TextOperationEvent):void
		{
			var textInput:TextInput = event.currentTarget as TextInput;
			var changeTextFilter:SessionListViewEvent = new SessionListViewEvent(SessionListViewEvent.CHANGE_TEXT_FILTER);
			changeTextFilter.textFilter = textInput.text;
			dispatchEvent(changeTextFilter);
		}
		public function onAddNewSession(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous créer une nouvelle séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, createEmptySessionConformed); 
		}
		
		private function createEmptySessionConformed(event:CloseEvent):void
		{
			if( event.detail == Alert.YES)
			{
				var sessionAddEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_EMPTY_SESSION);
				sessionAddEvent.isModel = false;
				this.dispatchEvent(sessionAddEvent);
			}
		}
	}
}