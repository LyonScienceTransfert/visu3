/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
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

package com.ithaca.visu.view.session.controls
{
	import com.ithaca.utils.AddUserTitleWindow;
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.SessionUserEvent;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.SessionUserVO;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	import com.visualempathy.display.controls.datetime.DateTimePickerFR;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SessionDetail  extends SkinnableComponent
	{
		[SkinPart("true")]
		public var sessionPlanEdit:SessionPlanEdit;
		
		[SkinPart("true")]
		public var themeSession:RichEditableText;
		
		[SkinPart("true")]
		public var picker:DateTimePickerFR;
		
		[SkinPart("true")] 
		public var themeSessionLabel:RichText;
		
		[SkinPart("true")] 
		public var descriptionSessionLabel:RichText;
		
		[SkinPart("true")] 
		public var dateLabel:Label;
		
		[SkinPart("true")] 
		public var heurLabel:Label;
		
		[SkinPart("true")] 
		public var minLabel:Label;
		
		[SkinPart("true")] 
		public var groupUser:Group;
			
		[SkinPart("true")] 
		public var buttonAddUser:Button;
		
		[SkinPart("true")] 
		public var buttonGoRetrospection:Button;

		[SkinPart("true")] 
		public var groupRecordedUser:Group;
		
		[SkinPart("true")] 
		public var buttonSaveSession:Button;
		
		[SkinPart("true")] 
		public var buttonDeleteSession:Button;
		
		public var theme:String="";
		public var description:String="";
		public var dateSession:Date= null;
		private var _session:Session;
		private var _activities:ArrayCollection;
		private var _listUser:IList;
		private var _listPresentUser:ArrayCollection;
		private var _profiles:Array;
		
		private var sessionChanged:Boolean;
		private var activitiesChanged:Boolean;
		private var usersChanged:Boolean;
		private var listPresentUserChange:Boolean;
		private var editabled:Boolean;
		private var accessRetrospection:Boolean;
		private var canAddUserToClosedSession:Boolean = false;
		private var canAddUserChange:Boolean;
		private var _loggedUser:User;
		
		[SkinPart("true")]
		public var descriptionSession:RichEditableText;
		
		public function SessionDetail()
		{
			super();
			_activities = new ArrayCollection();
			_listPresentUser = new ArrayCollection();
			_listUser = new ArrayList();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == groupUser)
			{
				/*var uvo:UserVO = new UserVO();
				uvo.lastname = "koko";
				uvo.firstname = "azaz";
				uvo.avatar = "https://lh3.googleusercontent.com/_r4tG6k7JBcg/S0H_ok3HOSI/AAAAAAAACH8/U3Un09ysGqw/s104-c/avatar-2.jpg";
				var user:User = new User(uvo);
				var userEdit:UserEdit = new UserEdit();
				userEdit.user = user;
				userEdit.percentWidth = 100;
				groupUser.addElement(userEdit);
*/			}
			
			if (instance == themeSession)
			{
				
			}
			
			if (instance == descriptionSession)
			{
				
			}
			
			if (instance == descriptionSessionLabel)
			{
			

			}
			
			if (instance == buttonDeleteSession)
			{
				buttonDeleteSession.addEventListener(MouseEvent.CLICK, onButtonDeleteSession);
			}

			if (instance == buttonGoRetrospection)
			{
				buttonGoRetrospection.addEventListener(MouseEvent.CLICK, onButtonClickGoRetrospection);
			}
			
			if (instance == sessionPlanEdit)
			{
				sessionPlanEdit.addEventListener(SessionEditEvent.PRE_ADD_SESSION, onPreAddSession);
			}

			if (instance == buttonAddUser)
			{
				buttonAddUser.addEventListener(MouseEvent.CLICK , onClickButtonAddUser);
				
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == sessionPlanEdit)
			{
				sessionPlanEdit.removeEventListener(SessionEditEvent.PRE_ADD_SESSION, onPreAddSession);
			}
			
			if (instance == buttonAddUser)
			{
				buttonAddUser.removeEventListener(MouseEvent.CLICK , onClickButtonAddUser);
			}
			if (instance == buttonGoRetrospection)
			{
				buttonGoRetrospection.removeEventListener(MouseEvent.CLICK, onButtonClickGoRetrospection);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (sessionChanged)
			{
				sessionChanged = false;
				
				theme = _session.theme;
				description = _session.description;
				dateSession = _session.date_session;
				
				if(themeSession)
				{
					if(theme != "")
					{
						themeSession.text = themeSession.toolTip = theme;
					}else
					{
						setMessageTheme();
					}	
				}
				
				if(themeSessionLabel) themeSessionLabel.text = themeSessionLabel.toolTip = theme;
				if(dateLabel)
				{
					dateLabel.text =  UtilFunction.getLabelDate(dateSession,"/");
				}
				if(heurLabel)
				{ 
					var heureString:String = dateSession.getHours().toString();
					var  heure:Number = dateSession.getHours(); if(heure < 10 ){heureString = "0"+heureString;}
					heurLabel.text = heureString;
				}
				if(minLabel)
				{
					var minuteString:String = dateSession.getMinutes().toString();
					var  minute:Number = dateSession.getMinutes(); if(minute < 10 ){minuteString = "0"+minuteString;}
					minLabel.text = minuteString;
				}
				
				if(descriptionSession)
				{
					if(description != "")
					{
						descriptionSession.text = descriptionSession.toolTip = description;
						
					}else
					{
						setMessageDescription();
					}
				}
				
				if(descriptionSessionLabel) descriptionSessionLabel.text = descriptionSessionLabel.toolTip = description;
				
				if(picker){
					if(dateSession != null)
					{
						picker.selectedDate = dateSession;
					}
					
				}
				
				if(session.statusSession == SessionStatusEnum.SESSION_CLOSE && !session.isModel)
				{
					accessRetrospection = true;
					this.invalidateSkinState();
				}
				
				if(session.isModel)
				{
					if(session.id_user == this.loggedUser.id_user  || this.loggedUser.role >= RoleEnum.TUTEUR - 1  ) 
					{
						this.buttonDeleteSession.visible = true;
					}else
					{
						this.buttonDeleteSession.visible = false;	
					}
				}
			}
			
			if(activitiesChanged)
			{
				activitiesChanged = false;
				
				sessionPlanEdit.setEditabled(this.editabled);
				sessionPlanEdit.activities = _activities;
				
			}
			
			if(usersChanged)
			{
				usersChanged = false;
				
				groupUser.removeAllElements();
				if(this._listUser != null)
				{
					var nbrUser:int = this._listUser.length;
					for(var nUser:int = 0; nUser < nbrUser; nUser++)
					{
						var user:User = this._listUser.getItemAt(nUser) as User;
						var userEdit:UserEdit = new UserEdit();
						userEdit.addEventListener(SessionEditEvent.PRE_DELETE_SESSION_USER, onPreDeleteUser);
						userEdit.user = user;
						var editabled:Boolean = this.editabled;
						// only for instance "Visuvciel" when session closed
						if(canAddUserToClosedSession && session.statusSession == SessionStatusEnum.SESSION_CLOSE)
						{
							editabled = canRemoveUser(user);
						}
						userEdit.setEditabled(editabled);
						userEdit.percentWidth = 100;
						groupUser.addElement(userEdit);			
					}
				}
				
				if (groupRecordedUser != null)
				{
					groupRecordedUser.removeAllElements();
					if(this._listPresentUser != null)
					{
						var nbrPresentUser:uint = this._listPresentUser.length;
						for(var nPresentUser:uint = 0; nPresentUser < nbrPresentUser; nPresentUser++)
						{
							var userPresent:User = this._listPresentUser.getItemAt(nPresentUser) as User;
							var userPresentView:UserEdit = new UserEdit();
							userPresentView.user = userPresent;
							userPresentView.setEditabled(this.editabled);
							userPresentView.percentWidth = 100;
							groupRecordedUser.addElement(userPresentView);
						}
					}
				}
			}
			if(canAddUserChange)
			{
				canAddUserChange = false;
				
				buttonAddUser.enabled = canAddUserToClosedSession;
			}

		}
		
		// check if can remove user from recorded session
		private function canRemoveUser(value:User):Boolean
		{
			if(this._listPresentUser.length != 0)
			{
				var nbrUser:uint = this._listPresentUser.length;
				for(var nUser:uint = 0 ; nUser < nbrUser ; nUser++)
				{
					var user:User = this._listPresentUser.getItemAt(nUser) as User;
					if(user.id_user == value.id_user)
					{
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
// SETTER/GETTER
		public function get session():Session
		{
			return _session;
		}
		
		public function set session(value:Session):void
		{
			if( _session == value) return;
			_session = value;
			// set users of the session
			this.users = value.participants;
			sessionChanged = true;
			invalidateProperties();
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
				addUser.addEventListener(UserEvent.SELECTED_USER, onSelectUser);
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
		
		public function get users():IList
		{
			return _listUser;
		}
		
		public function set users(value:IList):void
		{
			if (_listUser == value) return;
			
/*			if (_listUser != null)
			{
				_listUser.removeEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
			}*/
			
			_listUser = value;
			usersChanged = true;
			invalidateProperties();
			
			if (_listUser)
			{
				_listUser.addEventListener(CollectionEvent.COLLECTION_CHANGE, users_ChangeHandler);
			}
			
/*			dispatchEvent( new Event("updateActivities"));
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET);
			_activities.dispatchEvent(event);*/
		}
		
		
		public function get listPresentUser():ArrayCollection
		{
			return _listPresentUser;
		}

		public function set listPresentUser(value:ArrayCollection):void
		{	
			_listPresentUser = value;
			usersChanged = true;
			invalidateProperties();
		}
		
		public function get activities():ArrayCollection
		{
			return _activities;
		}

		public function set activities(value:ArrayCollection):void
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
		
		
		public function get loggedUser():User
		{
			return this._loggedUser;
		}
		
		public function set loggedUser(value:User):void
		{
			this._loggedUser = value;
		}
		
		protected function activities_ChangeHandler(event:CollectionEvent):void
		{
			activitiesChanged = true;
			invalidateProperties();
		}

		protected function users_ChangeHandler(event:CollectionEvent):void
		{
			usersChanged = true;
			invalidateProperties();
		}

		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : editabled? "normalEditable" : accessRetrospection?  "accessRetrospection" : "normal";
		}
		
		public function setEditabled(value:Boolean):void
		{
			editabled = value;
			enabled = true;
			accessRetrospection = false;
			this.invalidateSkinState();
		}
		
		public function setCanAddUserToClosedSession(value:Boolean):void
		{
			canAddUserToClosedSession = value;
			canAddUserChange = true;
			invalidateProperties();
		}
// THEME 		
		public function updateTheme(value:String):void
		{
			_session.theme = value;
			var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
			updateSession.session = _session;
			this.dispatchEvent(updateSession);
			
		}
		public function setMessageTheme():void
		{
			themeSession.text = "Entrez un nouveau thème de séance ici";
			themeSession.setStyle("fontStyle","italic");
			themeSession.setStyle("color","#CCCCCC");
		}	
// DESCRIPTION		
		public function updateDescription(value:String):void
		{
			_session.description = value;
			var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
			updateSession.session = _session;
			this.dispatchEvent(updateSession);
			
		}
		
		public function setMessageDescription():void
		{
			descriptionSession.text = "Entrez une nouvelle description de séance ici";
			descriptionSession.setStyle("fontStyle","italic");
			descriptionSession.setStyle("color","#CCCCCC");
		}
// DATE
		public function updateDateSession(value:Date):void
		{
			if( _session.date_session.time != value.time)
			{
				_session.date_session = value;
				var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
				updateSession.session = _session;
				this.dispatchEvent(updateSession);
			}
		}
// ADD SESSION
		private function onPreAddSession(event:SessionEditEvent):void
		{
			var addSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_SESSION);
			_session.date_session = new Date();
			addSession.session = _session;
			addSession.isModel = event.isModel;
			this.dispatchEvent(addSession);
		}
// DELETE SESSION
		private function onButtonDeleteSession(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous supprimer cet séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, deleteSessionConformed);
		}
		
		private function deleteSessionConformed(event:CloseEvent):void{
			if( event.detail == Alert.YES)
			{
				var sessionDeleteEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_DELETE_SESSION);
				sessionDeleteEvent.session = this.session;
				this.dispatchEvent(sessionDeleteEvent);
				// remove all info, set message "have to use session";
				this.listPresentUser = null;
				this._listUser = null;
				this.usersChanged = true;
				this.invalidateProperties();
				// TODO set state "empty"
			}
		}	
// USER
		private function onClickButtonAddUser(event:MouseEvent):void
		{
			var userEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_LOAD_USERS);
			this.dispatchEvent(userEvent);
		}
		private function onSelectUser(event:UserEvent):void
		{
			var user:User = event.user;
			
			this._listUser.addItemAt(user,0);
			this.usersChanged = true;
			this.invalidateProperties();
			// add user in to session
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
		
		private function onPreDeleteUser(event:SessionEditEvent):void
		{
			var deletingUser:User = event.user;
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
				usersChanged = true;
				
				this.invalidateProperties();
				var deleteUser:SessionUserEvent = new SessionUserEvent(SessionUserEvent.REMOVE_SESSION_USER);
				var sessionUserVO:SessionUserVO = new SessionUserVO();
				sessionUserVO.id_session = _session.id_session;
				sessionUserVO.id_user = deletingUser.id_user;
				sessionUserVO.mask = 0;
				deleteUser.newSessionUser = sessionUserVO;
				this.dispatchEvent(deleteUser);
			}
			
	
		}
		
		private function onButtonClickGoRetrospection(event:MouseEvent):void
		{
			var goRetrospectionEvent:SessionEvent = new SessionEvent(SessionEvent.GO_RETROSPECTION_MODULE);
			goRetrospectionEvent.session = this.session;
			this.dispatchEvent(goRetrospectionEvent);
		}
		
		public function setViewEmpty():void
		{
			this.enabled = false;
			this.invalidateSkinState();
			sessionPlanEdit.setViewEmpty();
		}

	}
}