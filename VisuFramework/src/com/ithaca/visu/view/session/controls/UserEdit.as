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
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.CloseEvent;
	
	import spark.components.Label;
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("editable")]
	
	public class UserEdit extends SkinnableComponent
	{
		[SkinPart("true")]
		public var textContent:Label;

		[SkinPart("true")]
		public var avatarUser:Image;
		
		[SkinPart("true")]
		public var buttonEdit:Image;

		[SkinPart("true")]
		public var buttonDelete:Image;

		private var _user:User;
		public var currentMouseCursor:String;
		private var normal:Boolean = true;
		
		public function UserEdit() 
		{
			super();
			currentMouseCursor  = Mouse.cursor; 
		}
		public function get user():User {return _user; }
		public function set user(value:User):void
		{
			_user = value;
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == buttonDelete)
			{
				buttonDelete.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverButton);
				buttonDelete.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutButton);
				buttonDelete.addEventListener(MouseEvent.CLICK, onButtonDeleteClick);
				buttonDelete.toolTip = "effacer";
			}
			if(instance == buttonEdit)
			{
				/*buttonEdit.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverButton);				
				buttonEdit.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutButton);*/
				buttonEdit.toolTip = "editer";
			}
			
			if(instance == avatarUser)
			{
				avatarUser.source = _user.avatar;
				
				if(_user.role < RoleEnum.STUDENT)
				{
					avatarUser.toolTip = "Etudiant";
				}else
					if(_user.role < RoleEnum.TUTEUR)
					{
						avatarUser.toolTip = "Tuteur";
					}else 
						if(_user.role < RoleEnum.RESPONSABLE)
						{
							avatarUser.toolTip = "Responsable";
						}else
						{
							avatarUser.toolTip = "Administrateur";							
						}
			}

			if(instance == textContent)
			{
				textContent.text = _user.lastname + " "+_user.firstname;
				
				if(_user.role < RoleEnum.STUDENT)
				{
					textContent.setStyle("fontWeight","normal");
				}
				textContent.toolTip = _user.lastname + " "+_user.firstname;
			}
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == buttonDelete)
			{
				buttonDelete.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverButton);
				buttonDelete.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutButton);
				buttonDelete.removeEventListener(MouseEvent.CLICK, onButtonDeleteClick);
			}
			if(instance == buttonEdit)
			{
				/*buttonEdit.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverButton);				
				buttonEdit.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutButton);*/
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : normal? "normal" : "editable";
		}
		
		public function setEditabled(value:Boolean):void
		{
			normal = value;
			this.invalidateSkinState();
		}
		
		protected function onMouseOverButton(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.BUTTON;	
		}
		
		// set cursor mouse AROOW  
		protected function onMouseOutButton(event:MouseEvent):void
		{
			Mouse.cursor = this.currentMouseCursor;
		}
		
		protected function onButtonDeleteClick(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous supprimer "+ _user.lastname +" "+_user.firstname + "?",
				"Confirmation", Alert.YES|Alert.NO, null, deleteUserConformed); 
		}
		
		private function deleteUserConformed(event:CloseEvent):void{
			if( event.detail == Alert.YES)
			{
				var preDeleteUser:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_DELETE_SESSION_USER);
				preDeleteUser.user = _user;
				this.dispatchEvent(preDeleteUser);
			}
		}
	}
}