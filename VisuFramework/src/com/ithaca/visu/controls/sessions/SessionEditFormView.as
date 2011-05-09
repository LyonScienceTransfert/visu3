package com.ithaca.visu.controls.sessions
{
	import com.ithaca.utils.AddUserTitleWindow;
	import com.ithaca.visu.events.SessionUserEvent;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.SessionUserVO;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	public class SessionEditFormView extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var dateField:DateField;
		[SkinPart("true")]
		public var startDDL:DropDownList;
		[SkinPart("true")]
		public var participantList:spark.components.List;
		[SkinPart("true")]
		public var addUser:Button;
		[SkinPart("true")]
		public var deleteUser:Button;
		
		private var sessionChange:Boolean;
		
		private var _session:Session;
		private var _listUser:ArrayCollection;
		private var _profiles:Array;
		
		private var timeCodes:ArrayCollection = new ArrayCollection();
		private static var INTERVAL_MINUTE:int = 10;
		public function SessionEditFormView()
		{
			super();
			initTimeCode();
		}

		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		public function get session():Session {return _session}
		public function set session(value:Session):void
		{
			if( value != _session )
			{
				_session = value;
				if(value == null)
				{
					_listUser = null;
				}else
				{
					_listUser = value.participants;
				}
				
				sessionChange = true;
				this.invalidateProperties();
			}
		} 
		public function set allUsers(value:Array):void
		{
			var listUserShow:Array = this.getListUserShow(value);
			// message if list users for adding empty
			if(listUserShow.length == 0)
			{
				Alert.show("Hasn't utilisateur for adding to session.","Message");
			}else
			{
				var addUser:AddUserTitleWindow = AddUserTitleWindow(PopUpManager.createPopUp( 
					this, AddUserTitleWindow , true) as spark.components.TitleWindow);
				addUser.addEventListener(UserEvent.SELECTED_USER, onSelectAddedUser);
				addUser.x = (this.parentApplication.width - addUser.width)/2;
				addUser.y = (this.parentApplication.height - addUser.height)/2;
				addUser.addUserManagement.users = listUserShow;
				addUser.addUserManagement.profiles = _profiles;
			}	
		}
		public function set profiles(value:Array):void
		{
			this._profiles = value;
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == dateField)
			{
				dateField.addEventListener(CalendarLayoutChangeEvent.CHANGE , onDateChange);
			}
			if (instance == startDDL)
			{
				startDDL.dataProvider = timeCodes;
				startDDL.addEventListener(IndexChangeEvent.CHANGE, onStartTimeSessionChange);
			}
			if (instance == addUser)
			{
				addUser.addEventListener(MouseEvent.CLICK, onAddUser);
			}
			if (instance == deleteUser)
			{
				deleteUser.addEventListener(MouseEvent.CLICK, onDeleteUser);
				deleteUser.enabled = false;
			}
			if(instance == participantList)
			{
				participantList.addEventListener(IndexChangeEvent.CHANGE, onSelectUser);
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(sessionChange)
			{
				sessionChange = false;
				
				participantList.dataProvider = _listUser;
				dateField.selectedDate = session.date_session;
				startDDL.selectedIndex = getIndexStartDDLByDate(session.date_session);
				deleteUser.enabled = false;
			}
		}
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________
		
		private function onDateChange(event:CalendarLayoutChangeEvent):void
		{
			var date:Date = event.newDate;
			dispatcherDateTime(date, startDDL.selectedIndex);
		}
		private function onStartTimeSessionChange(event:IndexChangeEvent):void
		{
			var selectedIndex:int = event.newIndex;
			dispatcherDateTime(dateField.selectedDate, selectedIndex);
		}
		
		private function dispatcherDateTime(date:Date, selectedIndex:int):void
		{
			var dataProvider:ArrayCollection = startDDL.dataProvider as ArrayCollection;
			var obj:Object = dataProvider.getItemAt(selectedIndex) as Object;
			var hour:int = obj.hour;
			var minute:int = obj.minute;
			// set date and time
			date.setHours(hour);
			date.setMinutes(minute);
						
			var changeDateTimeSessionEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_DATE_TIME);
			changeDateTimeSessionEvent.date = date;
			this.dispatchEvent(changeDateTimeSessionEvent);
		}
		// get index for startDDL:DropDownList 
		private function getIndexStartDDLByDate(date:Date):int
		{
			if( date == null) return 0 ;
			var hour:int = date.getHours();
			var minute:int = date.getMinutes();
			var divMinute:int = Math.round((minute/INTERVAL_MINUTE));
			var result:int = hour*(60/INTERVAL_MINUTE)+divMinute;
			return result;
		}
	
		
		private function onSelectUser(event:IndexChangeEvent):void
		{
			this.deleteUser.enabled = true;
		}
		
		private function onAddUser(event:MouseEvent):void
		{
			var userEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_LOAD_USERS);
			this.dispatchEvent(userEvent);
		}
		private function onSelectAddedUser(event:UserEvent):void
		{
			var user:User = event.user;
			
			this._listUser.addItemAt(user,0);
			// update list planed user
			var updateListPlanedUser:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_LIST_PLANED_USER);
			updateListPlanedUser.listPlanedUser = this._listUser;
			this.dispatchEvent(updateListPlanedUser);
			
			var sessionUserVO:SessionUserVO = new SessionUserVO();
			sessionUserVO.id_session = _session.id_session;
			sessionUserVO.id_user = user.id_user;
			sessionUserVO.mask = 0;
			var sessionUserEvent:SessionUserEvent = new SessionUserEvent(SessionUserEvent.ADD_SESSION_USER);
			sessionUserEvent.newSessionUser = sessionUserVO;
			this.dispatchEvent(sessionUserEvent);			
		}
		
		private function getListUserShow(value:Array):Array
		{
			var result:Array = new Array();
			var nbrUser:int = value.length;
			for(var nUser:int= 0; nUser < nbrUser ; nUser++)
			{
				var user:User = value[nUser]
				var hasUser:Boolean = hasUserInSession(user.id_user, this._listUser)
				if(!hasUser)
				{
					result.push(user);
				}
			}
			return result;
			
			function hasUserInSession(id:int, list:ArrayCollection):Boolean
			{
				var nbrUser:int = list.length;
				for(var nUser:int = 0 ; nUser < nbrUser; nUser++)
				{
					var user:User = list.getItemAt(nUser) as User;
					if (id == user.id_user)
					{
						return true;
					}
				}
				return false;
			}
		}
		
		protected function onDeleteUser(event:MouseEvent):void
		{
			var user:User = participantList.selectedItem as User;
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous supprimer "+ user.lastname +" "+user.firstname + "?",
				"Confirmation", Alert.YES|Alert.NO, null, deleteUserConformed); 
		}
		
		private function deleteUserConformed(event:CloseEvent):void 
		{
			var deletingUser:User = participantList.selectedItem as User;
			
			// delete user from the list
			var index:int = -1;
			var nbrUser:int = this._listUser.length;
			for(var nUser:int = 0; nUser < nbrUser; nUser++)
			{
				var user:User = this._listUser.getItemAt(nUser) as User;
				if(user.id_user == deletingUser.id_user)
				{
					index = nUser;
				}
			}
			if(index == -1)
			{
				Alert.show("You havn't user with name = "+deletingUser.firstname,"message error");
			}else{
				this._listUser.removeItemAt(index);
				
				var deleteUser:SessionUserEvent = new SessionUserEvent(SessionUserEvent.REMOVE_SESSION_USER);
				var sessionUserVO:SessionUserVO = new SessionUserVO();
				sessionUserVO.id_session = _session.id_session;
				sessionUserVO.id_user = deletingUser.id_user;
				sessionUserVO.mask = 0;
				deleteUser.newSessionUser = sessionUserVO;
				this.dispatchEvent(deleteUser);
			}
			this.deleteUser.enabled = false;
		}
		
		private function initTimeCode():void
		{	
			var i:int; 
			for (i = 0; i < 24; i++) { 
				var j:int; 
				for (j = 0; j < 60; j+=INTERVAL_MINUTE) {
					var prefix:String = j<10?"0":"";						
					timeCodes.addItem({hour:i, minute:j, string:(i+":"+ prefix + j)});
				}
			}
		}
	}
}