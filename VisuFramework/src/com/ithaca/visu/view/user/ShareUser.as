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
package com.ithaca.visu.view.user
{
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.utils.VisuUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.CheckBox;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ShareUser extends SkinnableComponent
	{
		[SkinPart("true")]
		public var firstLastNameUser:Label;
		
		[SkinPart("true")]
		public var checkBoxUser:CheckBox;
		
		private var _firstLastName:String;
		private var _user:User;
		private var _share:Boolean;
		
		public function get user():User {return _user;}
		public function set user(value:User):void
		{
			this._user = value;
			this._firstLastName = value.firstname + " "+value.lastname;
		}
		public function get share():Boolean {return _share;}
		public function set share(value:Boolean):void
		{
			this._share = value;
		}
			
		public function ShareUser()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == checkBoxUser)
			{
				checkBoxUser.selected = _share;
				checkBoxUser.addEventListener(Event.CHANGE, onChangeShare);
			}
			if (instance == firstLastNameUser)
			{
				firstLastNameUser.text = _firstLastName + " (" + VisuUtils.getRoleLabel(user.role) + ")";
				// set color red for admins
				if(user.role > RoleEnum.RESPONSABLE-1)
				{
					firstLastNameUser.setStyle("color","0xe34545");
				}
                
                firstLastNameUser.buttonMode = true;
                // listener click on label 
                firstLastNameUser.addEventListener(MouseEvent.CLICK, onClickFirstLastNameUser);
			}
		}
		
        private function onClickFirstLastNameUser(event:MouseEvent):void
        {
            if(checkBoxUser.selected)
            {
                checkBoxUser.selected = false;
            }else
            {
                checkBoxUser.selected = true;
            }
            
            _share = checkBoxUser.selected;
            dispatcherChangeShare();
        }
        
		private function onChangeShare(event:Event):void
		{
			_share = checkBoxUser.selected;
            dispatcherChangeShare();
		}
        
        private function dispatcherChangeShare():void
        {
            var changeCheckBox:Event = new Event("selectedSharedUser");
            this.dispatchEvent(changeCheckBox);
        }
	}
}