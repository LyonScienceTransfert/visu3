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
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	import com.visualempathy.display.controls.datetime.DateTimePickerFR;
	
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
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
			
		public var theme:String="";
		public var description:String="";
		public var dateSession:Date= null;
		private var _session:Session;
		private var _activities:IList;
		private var _listUser:IList;
		private var sessionChanged:Boolean;
		private var activitiesChanged:Boolean;
		private var usersChanged:Boolean;
		private var editabled:Boolean;
		
		[SkinPart("true")]
		public var descriptionSession:RichEditableText;
		
		public function SessionDetail()
		{
			super();
			_activities = new ArrayList();
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
			
			if (instance == themeSessionLabel)
			{
				
			}

			if (instance == picker)
			{
				
			}
			
			if (instance == sessionPlanEdit)
			{
				sessionPlanEdit.addEventListener(SessionEditEvent.PRE_ADD_SESSION, onPreAddSession);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == sessionPlanEdit)
			{
				sessionPlanEdit.removeEventListener(SessionEditEvent.PRE_ADD_SESSION, onPreAddSession);
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
					dateLabel.text =  UtilFunction.getLabelDate(dateSession);
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
				var nbrUser:int = this._listUser.length;
				for(var nUser:int = 0; nUser < nbrUser; nUser++)
				{
					var user:User = this._listUser.getItemAt(nUser) as User;
					var userEdit:UserEdit = new UserEdit();
					userEdit.user = user;
					userEdit.setEditabled(this.editabled);
					userEdit.percentWidth = 100;
					groupUser.addElement(userEdit);			
				}
			}
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
			sessionChanged = true;
			invalidateProperties();
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
		
		public function get activities():IList
		{
			return _activities;
		}

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

		protected function users_ChangeHandler(event:CollectionEvent):void
		{
			usersChanged = true;
			invalidateProperties();
		}

		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : editabled? "normalEditable" : "normal";
		}
		
		public function setEditabled(value:Boolean):void
		{
			editabled = value;
			this.invalidateSkinState();
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
			themeSession.text = "entrer un nouveau themè de la séance ici";
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
			descriptionSession.text = "entrer un nouveau description de la séance ici";
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
/*			_session.id_user = Model.getInstance().getLoggedUser().id_user;
			_session.setModel(false);
			_session.statusSession = 0;*/
			addSession.session = _session;
			this.dispatchEvent(addSession);
		}
	}
}