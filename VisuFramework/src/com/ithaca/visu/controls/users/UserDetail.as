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
package com.ithaca.visu.controls.users
{
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.ProfileDescriptionVO;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.ui.utils.RightStatus;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Image;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinSate("normal")]
	[SkinSate("edit")]
	[SkinSate("pending")]
	[SkinSate("empty")]
	
	public class UserDetail extends SkinnableComponent
	{
		[SkinPart("true")]
		public var firstnameInput : TextInput;
		
		[SkinPart("true")]
		public var firstnameDisplay : Label;
		
		[SkinPart("true")]
		public var lastnameInput : TextInput;
		
		[SkinPart("true")]
		public var lastnameDisplay : Label;
		
		[SkinPart("true")]
		public var emailInput : TextInput;
		[SkinPart("true")]
		public var emailDisplay : Label;

		[SkinPart("true")]
		public var avatarUser : Image;
		
		[SkinPart("true")]
		public var profileList : DropDownList;
		
		[SkinPart("true")]
		public var profileDisplay : Label;
		
		[SkinPart("true")]
		public var cancelButton : Button;
		
		[SkinPart("true")]
		public var saveButton : Button;
		
		[SkinPart("true")]
		public var editButton : Button;
		
		[SkinPart("true")]
		public var deleteButton : Button;
		
		 
        private var _profiles:Array = [];
        private var profilesChanged : Boolean;
		
        
        private var _user : User; 
        private var userChanged : Boolean;
        
		private var pending : Boolean; 
        private var _editing : Boolean; 
        
        private var empty : Boolean;
		
		
		public function UserDetail()
		{
			super();
		}
        
        //_____________________________________________________________________
        //
        // Setter/getter
        //
        //_____________________________________________________________________		
        [Bindable("update")]
        public function get profiles():Array {return _profiles;}
        public function set profiles(value:Array):void
        {
            if( value && value != _profiles )
            {
                _profiles = value;
                profilesChanged = true;
                invalidateProperties();
                dispatchEvent( new Event("update") );
            }
        } 
        
        [Bindable("update")]
        public function get user():User { return _user; }
        public function set user(value:User):void 
        {
            if(value == null)
            {
                pending = _editing = false;
                empty = true;
                this.invalidateSkinState();
                return;                
            }
            _user = value;
            userChanged = true;
            
            pending = _editing = false;
            empty = false;
            
            dispatchEvent( new Event("update") );    
                
            if( _user.id_user == 0)
            {
                pending = empty = false;
                _editing  = true;
            }
            
            this.invalidateSkinState();
        }
        
        
        public function set editing(value:Boolean):void
        {
            _editing = true;
            empty = false;
            invalidateSkinState();
        }
        
        public function setStateNormal():void{
            pending = false;
            _editing = false;
            empty = false;
            invalidateSkinState();
        }
        public function setStateEmpty():void{
            pending = false;
            _editing = false;
            empty = true;
            invalidateSkinState();
        }
		
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == editButton)
			{
				editButton.addEventListener(MouseEvent.CLICK, editButton_clickHandler);
			}
			if (instance == saveButton)
			{
				saveButton.addEventListener(MouseEvent.CLICK, saveButton_clickHandler);
			}
			if (instance ==  cancelButton)
			{
				cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
			}
			if (instance == profileList)
			{
				profileList.dataProvider = new ArrayList(_profiles);
			}
			if (instance == deleteButton )
			{
				deleteButton.addEventListener(MouseEvent.CLICK, deleteButton_clickHandler);
				deleteButton.enabled = false;
			}
			if (instance == firstnameInput)
			{
				if( _user.id_user == 0)
				{
					firstnameInput.setFocus();
				}
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == editButton)
			{
				editButton.removeEventListener(MouseEvent.CLICK, editButton_clickHandler);
			}
			if (instance == saveButton)
			{
				saveButton.removeEventListener(MouseEvent.CLICK, saveButton_clickHandler);
			}
			if (instance ==  cancelButton)
			{
				cancelButton.removeEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
			}
			if (instance == deleteButton )
			{
				deleteButton.removeEventListener(MouseEvent.CLICK, deleteButton_clickHandler);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (profileList && profilesChanged)
			{
				profileList.dataProvider = new ArrayList(_profiles);
				profilesChanged = false;
			}
			if (userChanged)
			{
				userChanged = true;
                if ( getCurrentSkinState() == "normal" || getCurrentSkinState() == "empty")
					setDisplay();
				else
					setInput();
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled ? "disabled" : pending ? "pending" : _editing ?  "edit" :  empty ? "empty" : "normal"; 
		}
		//_____________________________________________________________________
		//
		// Event Handlers
		//
		//_____________________________________________________________________
				
		/**
		 * @private
		 */
		public function editButton_clickHandler(event:*=null):void
		{
			_editing = true;
            empty = false;
			invalidateSkinState();
		}
		
		/**
		 * @private
		 */
		protected function saveButton_clickHandler(event:MouseEvent):void
		{
			pending = true;   empty = false;
			var u:UserVO = new UserVO();
			u.firstname = firstnameInput.text;
			u.lastname = lastnameInput.text;
			u.mail = emailInput.text;
			u.profil = RightStatus.numberToBinary(profileList.selectedItem.profile);
			u.id_user = _user.id_user;
			u.avatar = _user.avatar;
			
			if(u.id_user == 0)
			{
				var userEventAdd:UserEvent = new UserEvent(UserEvent.ADD_USER);
				u.avatar = "/images/unknown.png";
				userEventAdd.userVO = u;
				
				dispatchEvent( userEventAdd );
			}else
			{
				var userEventUpdate:UserEvent = new UserEvent(UserEvent.UPDATE_USER);
				userEventUpdate.userVO = u;
				dispatchEvent( userEventUpdate );
			}
			invalidateSkinState();
		}
		
		/**
		 * @private
		 */
		protected function deleteButton_clickHandler(event:MouseEvent):void
		{
			var u:UserVO = new UserVO();
			u.id_user = _user.id_user;
			var userEventDelete:UserEvent = new UserEvent(UserEvent.DELETE_USER);
			userEventDelete.userVO = u;
			dispatchEvent( userEventDelete );
		}
		
		
		/**
		 * @private
		 */
		protected function cancelButton_clickHandler(event:MouseEvent):void
		{
			pending = false; _editing=false;  empty = false;
			
			//Reset textInput value
			lastnameInput.text = user.lastname;
			lastnameDisplay.text = user.lastname;
			
			firstnameInput.text = user.firstname;
			firstnameDisplay.text = user.firstname;
			
			emailInput.text = user.mail;
			emailDisplay.text = user.mail;
			
			avatarUser.source = user.avatar;
			
			updateProfileList();
			profileDisplay.text = getProfile(user.role).short_description;
			
			invalidateSkinState();
		}
		/*
		 *
		 * Methods
		 * 
		 */
		/**
		 * @private 
		 */
		protected function setInput():void
		{
			lastnameInput.text = user.lastname;			
			firstnameInput.text = user.firstname;			
			emailInput.text = user.mail;
			avatarUser.source = user.avatar;
			updateProfileList();
            
            firstnameInput.setFocus();
		}
		protected function setDisplay():void
		{
			lastnameDisplay.text = user.lastname;
			firstnameDisplay.text = user.firstname;
			emailDisplay.text = user.mail;
			avatarUser.source = user.avatar;
			profileDisplay.text = getProfile(user.role).short_description;
		}
		
		/**
		 * @private
		 */
		protected function updateProfileList():void
		{
			var profile:ProfileDescriptionVO = getProfile(user.role);
			
			if (profileList.selectedItem != profile) 
			{
				profileList.selectedItem = profile;
			}
		}
		
		/**
		 * @private
		 */
		protected function getProfile(userProfil:int):ProfileDescriptionVO
		{
			var lastProfile:ProfileDescriptionVO = profiles[0];
			for each (var p:ProfileDescriptionVO in profiles)
			{
				if(userProfil < p.profile || userProfil == p.profile ) 
				{
					return p; 
				}
				else
				{
					 
					lastProfile = p;
				}
			} 
			return lastProfile;
		}
	}
}