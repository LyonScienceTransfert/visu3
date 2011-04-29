package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.events.SessionListViewEvent;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	import com.lyon2.controls.utils.TimeUtils;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.graphics.SolidColor;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;
	
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
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
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
		
		[SkinPart("true")]
		public var clearIcon:Group;
		
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
		
		private var _listPlanCollection:ArrayCollection;
		private var listPlanCollectionChange:Boolean; 
		private var _listSessionCollection:ArrayCollection;
		private var listSessionCollectionChange:Boolean;
		
		private var _loggedUser:User;
		
		private var logger : ILogger = Log.getLogger('com.ithaca.visu.controls.sessions.SessionListView');

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

		public function set listPlanCollection(value:ArrayCollection):void
		{
			_listPlanCollection = value;
			listPlanCollectionChange = true;
			this.invalidateSkinState();
		}
		public function get listPlanCollection():ArrayCollection
		{
			return _listPlanCollection;
		}
		
		public function set listSessionCollection(value:ArrayCollection):void
		{
			_listSessionCollection = value;
			listSessionCollectionChange = true;
			this.invalidateSkinState();
		}
		
		public function get listSessionCollection():ArrayCollection
		{
			return _listSessionCollection;
		}

		public function get loggedUser():User
		{
			return this._loggedUser;
		}
		
		public function set loggedUser(value:User):void
		{
			this._loggedUser = value;
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
			
			if(listPlanCollectionChange)
			{
				listPlanCollectionChange = false;
				planList.dataProvider = listPlanCollection;
				listPlanCollection.filterFunction = filterPlan;
			}
			
			if(listSessionCollectionChange)
			{
				listSessionCollectionChange = false;
				sessionList.dataProvider = listSessionCollection;
				listSessionCollection.filterFunction = filterSession;
				// update list session by filter and sort by date
				onRadioSessionFilter();
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
			
			if(instance == allButton)
			{
				allButton.addEventListener(MouseEvent.CLICK , onRadioSessionFilter);
			}
			if(instance == pastButton)
			{
				pastButton.addEventListener(MouseEvent.CLICK , onRadioSessionFilter);
			}
			if(instance == comingButton)
			{
				comingButton.addEventListener(MouseEvent.CLICK , onRadioSessionFilter);
			}
			
			if(instance == sharingAllButton)
			{
				sharingAllButton.addEventListener(MouseEvent.CLICK , onRadioPlanFilter);
			}
			if(instance == sharingMineButton)
			{
				sharingMineButton.addEventListener(MouseEvent.CLICK , onRadioPlanFilter);
			}
			if(instance == sharingOtherButton)
			{
				sharingOtherButton.addEventListener(MouseEvent.CLICK , onRadioPlanFilter);
			}
			
			if(instance == clearIcon)
			{
				clearIcon.addEventListener(MouseEvent.CLICK , onClearIcon);
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
			// refresh collection for calling filterFunction 
			refreshCollection();
		}
		
		private function onRadioSessionFilter(event:MouseEvent = null):void
		{		
			var sortDateFunction:Function = compareDateSession;
			// set function "compareDateSessionRecording" for past session
			if(pastButton.selected)
			{
				sortDateFunction = compareDateSessionRecording;
			}
			// sort by date 
			var sort:Sort = new Sort();
			sort.compareFunction = sortDateFunction;
			listSessionCollection.sort = sort;
			// refresh collection for calling filterFunction 
			listSessionCollection.refresh();
			// TODO : move verticalScroller for show selected item
			
		}
		
		private function onRadioPlanFilter(event:MouseEvent):void
		{		
			// refresh collection for calling filterFunction 
			this.listPlanCollection.refresh();
		}
		private function onClearIcon(event:MouseEvent):void
		{
			// set empty text
			filterText.text = "";
			refreshCollection();
		}
		
		// refreshe "active" collection 
		private function refreshCollection():void
		{
			if(plan)
			{
				this.listPlanCollection.refresh();
			}else
			{
				this.listSessionCollection.refresh();
			}
		}
		
		private function filterPlan(item:Object):Boolean
		{
			var session:Session = item as Session;
			var result:Boolean = false;
			if(sharingMineButton.selected)
			{
				if(session.isModel && session.id_user == loggedUser.id_user)
				{
					result = true;
				}
			}else if(sharingOtherButton.selected)
			{
				if(session.isModel && session.id_user != loggedUser.id_user)
				{
					result = true;
				}
			}else
			{
				result = true;
			}
			return result && checkFilterText(session);
		}
		private function filterSession(item:Object):Boolean
		{
			var session:Session = item as Session;
			var result:Boolean = false;
			if (pastButton.selected)
			{
				if(session.statusSession == SessionStatusEnum.SESSION_CLOSE)
				{
					result = true;
				}	
			}else if (comingButton.selected)
				{	
					if(session.statusSession == SessionStatusEnum.SESSION_OPEN)
					{
						result = true;
					}
				}
			else
			{
				result = true;
			}
			return result && checkFilterText(session);
		}
		
		private function checkFilterText(session:Session):Boolean
		{
			var passTextFilter:Boolean = false;
			passTextFilter = session.theme.match(filterText.text) || session.description.match(filterText.text);
			return passTextFilter;
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
		//_____________________________________________________________________
		//
		// Utils
		//
		//_____________________________________________________________________
		
		// sort by date session planed
		private function compareDateSession(ObjA:Object,ObjB:Object,fields:Array = null):int
		{
			if(ObjA==null && ObjB==null)
				return 0;
			if(ObjA==null)
				return 1;
			if(ObjB == null)
				return -1;
			
			var dateA:Date=ObjA.date_session;
			var dateB:Date=ObjB.date_session;
			return ObjectUtil.dateCompare(dateA, dateB);
		}
		// sort by date session recording
		private function compareDateSessionRecording(ObjA:Object,ObjB:Object,fields:Array = null):int
		{
			if(ObjA==null && ObjB==null)
		        return 0;
	    	if(ObjA==null)
				return 1;
			if(ObjB == null)
				return -1;
			
			var dateA:Date=ObjA.date_start_recording;
			var dateB:Date=ObjB.date_start_recording;
			return ObjectUtil.dateCompare(dateA, dateB);
		}
		
	}
}