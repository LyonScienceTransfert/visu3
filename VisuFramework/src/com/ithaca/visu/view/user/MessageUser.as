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

package com.ithaca.visu.view.user
{
	import mx.utils.StringUtil;
	import mx.controls.Alert;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.utils.StringUtils;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.view.session.controls.UserEdit;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.controls.Image;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class MessageUser extends SkinnableComponent
	{
		[SkinPart("true")]
		public var avatarUser:Image;
		
		[SkinPart("true")]
		public var nomUser:Label;

		[SkinPart("true")]
		public var prenomUser:Label;
		
		[SkinPart("true")]
		public var roleUser:Label;
		
		[SkinPart("true")]
		public var messageUser:RichEditableText;

		[SkinPart("true")]
		public var statusIcon:Image;
		
		private var selected:Boolean = false;
		
		private var currentMouseCursor:String;
		public var _user:User;
		private var _numberUser:int;
		private var numberUserChange:Boolean;
		
		public function MessageUser()
		{
			super();
			currentMouseCursor  = Mouse.cursor; 
			addEventListener(MouseEvent.CLICK,onMouseClickListener);
		}
		
		private function onMouseClickListener(event:MouseEvent):void {
			selected = !selected;
			invalidateSkinState();
		}
		
		
		public function get user():User {return _user; }
		public function set user(value:User):void
		{
			_user = value;
		}
		
		public function get numberUser():int {return _numberUser; }
		public function set numberUser(value:int):void
		{
			_numberUser = value;
			numberUserChange = true;
			this.invalidateProperties();
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == roleUser)
			{
				if(_user.role < RoleEnum.STUDENT)
				{
					roleUser.text = "Etudiant";
				}else
					if(_user.role < RoleEnum.TUTEUR)
					{
						roleUser.text = "Tuteur";
					}else 
						if(_user.role < RoleEnum.RESPONSABLE)
						{
							roleUser.text = "Responsable";
						}else
						{
							roleUser.text = "Administrateur";							
						}
				
			}
			
			if(instance == avatarUser)
			{
				avatarUser.source = _user.avatar;
			}
			
			if(instance == prenomUser)
			{
				prenomUser.text = StringUtils.cap(_user.firstname);
			}
			
			if(instance == nomUser)
			{
				nomUser.text = StringUtils.cap(_user.lastname);
			}
			
			
			if(instance == messageUser)
			{
				messageUser.text = this.user.message;
				messageUser.toolTip = this.user.message;
			}
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (numberUserChange && roleUser)
			{
				numberUserChange = false;
				
				var firstChar:String = roleUser.text.charAt(0);
				var newText:String = firstChar.toLocaleUpperCase() + this._numberUser.toString() + " : " + roleUser.text;
				roleUser.text = newText;
				
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return selected? "selected" : "normal";
		}
		
			
		private function setUserVO(value:User):UserVO
		{
			var userVO:UserVO = new UserVO();
			userVO.firstname = value.firstname;
			userVO.lastname = value.lastname;
			userVO.mail = value.mail;
			userVO.password = value.password;
			userVO.profil = value.profil;
			userVO.id_user = value.id_user;
			userVO.avatar = value.avatar;
			userVO.message = value.message;
			userVO.recovery_key = value.recovery_key;
			userVO.activation_key = value.activation_key;
			return userVO;
		}

	}
}