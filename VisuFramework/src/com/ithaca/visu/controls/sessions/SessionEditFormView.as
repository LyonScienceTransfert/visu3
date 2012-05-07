/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.ithaca.visu.controls.sessions
{
	import com.ithaca.utils.AddUserTitleWindow;
	import com.ithaca.utils.UtilFunction;
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
	import mx.utils.StringUtil;

    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;

	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	public class SessionEditFormView extends SkinnableComponent
	{
		[Bindable]
	    private var fxgt: _FxGettext = FxGettext;
		
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
		[SkinPart("true")]
		public var labelDuration:Label;
		[SkinPart("true")]
		public var labelEndSession:Label;
		
		private var sessionChange:Boolean;
		private var durationPlanedChange:Boolean;
		
		private var _session:Session;
		private var _listUser:ArrayCollection;
		private var _profiles:Array;
		// planed duration in minutes
		private var _durationPlaned:int;
		
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
				Alert.show(fxgt.gettext("Pas d'utilisateur sélectionné."), fxgt.gettext("Message"));
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
		
		public function set durationPlaned(value:int):void
		{
			_durationPlaned = value;
			durationPlanedChange = true;
			invalidateProperties();
		}
		public function get durationPlaned():int
		{
			return _durationPlaned;
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
				setEndSession();
			}
			
			if(durationPlanedChange)
			{
				durationPlanedChange = false;
				this.labelDuration.text = UtilFunction.getHourMin(durationPlaned);
				if(session != null)
				{
					setEndSession();
				}
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
			Alert.yesLabel = fxgt.gettext("Oui");
			Alert.noLabel = fxgt.gettext("Non");
			Alert.show(StringUtil.substitute(fxgt.gettext("Voulez-vous supprimer {0} {1} ?"), user.lastname, user.firstname),
				       fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, deleteUserConformed);
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
				Alert.show(fxgt.gettext("Aucun utilisateur avec le nom ") + deletingUser.firstname, fxgt.gettext("Message"));
			}else{
				this._listUser.removeItemAt(index);
				
				// update list planed user
				var updateListPlanedUser:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_LIST_PLANED_USER);
				updateListPlanedUser.listPlanedUser = this._listUser;
				this.dispatchEvent(updateListPlanedUser);
				
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
		 
		private function setEndSession():void
		{
			if(session.date_session != null)
			{
				var hours:int = session.date_session.hours;
				var minuts:int = session.date_session.minutes;
				var endSessionPlaned:int = hours*60 + minuts + durationPlaned;
				this.labelEndSession.text = UtilFunction.getHourMin(endSessionPlaned);
			}
		}
			
			
	}
}