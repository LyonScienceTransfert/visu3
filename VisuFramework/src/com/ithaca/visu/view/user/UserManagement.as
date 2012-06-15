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
	import com.ithaca.visu.controls.AdvancedTextInput;
	import com.ithaca.visu.controls.users.UserDetail;
	import com.ithaca.visu.controls.users.UserFilters;
	import com.ithaca.visu.controls.users.event.UserFilterEvent;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	import com.lyon2.controls.utils.LemmeFormatter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.Panel;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
    
    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;
	
	
	public class UserManagement extends SkinnableComponent
	{
		protected static var log:ILogger = Log.getLogger("views.UserManagement");
		
		[SkinPart("true")]
		public var filter:UserFilters;
		
		[SkinPart("true")]
		public var addUserButton:Button;
		
		[SkinPart("true")]
		public var usersList:List;
		
		[SkinPart("false")]
		public var searchDisplay:AdvancedTextInput;
		
		[SkinPart("true")]
		public var userDetail:UserDetail;

        [SkinPart("true")]
        
        [Bindable]
        private var fxgt: _FxGettext = FxGettext;
		
		[Bindable] public var selectedUser:User;
		[Bindable] public var filterProfileMax:int = -1;
		[Bindable] public var filterProfileMin:int = -1;
		[Bindable] public var sessions:Session;
		
		public function UserManagement()
		{
			super();
            
            // init internalisation
            fxgt = FxGettext;
		}
		
		public var userCollection:ArrayCollection;
		private var _users:Array = [];
		
		[Bindable("update")]
		public function get users():Array {return _users;}
		public function set users(value:Array):void
		{
			log.debug("set users " + value);
			if( value != _users )
			{
				_users = value;
				userCollection = new ArrayCollection( _users);
				userCollection.filterFunction = userFilterFunction;
				
				usersList.dataProvider = userCollection;
				dispatchEvent( new Event("update") );
			}
		} 
		
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == usersList)
			{
				usersList.addEventListener(IndexChangeEvent.CHANGE, userList_indexChangeHandler);
			}
			if (instance == filter)
			{
				filter.addEventListener(UserFilterEvent.VIEW_ALL,filter_viewAllHandler);
				filter.addEventListener(UserFilterEvent.VIEW_PROFILE,filter_viewProfileHandler);
				filter.addEventListener(UserFilterEvent.VIEW_UNGROUP,filter_viewUngroupHandler);
			}
			if (instance == searchDisplay)
			{
				searchDisplay.addEventListener(TextOperationEvent.CHANGE,searchDisplay_changeHandler);
				searchDisplay.addEventListener(FlexEvent.VALUE_COMMIT,searchDisplay_mxchangeHandler);
			}
			if (instance == addUserButton)
			{
				addUserButton.addEventListener(MouseEvent.CLICK, addButton_clickHandler);
			}
			if (instance == userDetail)
			{
                userDetail.user = null;
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == usersList)
			{
				usersList.removeEventListener(IndexChangeEvent.CHANGE, userList_indexChangeHandler);
			}
			if (instance == filter)
			{
				filter.removeEventListener(UserFilterEvent.VIEW_ALL,filter_viewAllHandler);
				filter.removeEventListener(UserFilterEvent.VIEW_PROFILE,filter_viewProfileHandler);
				filter.removeEventListener(UserFilterEvent.VIEW_UNGROUP,filter_viewUngroupHandler);
			}
			if (instance == searchDisplay)
			{
				searchDisplay.removeEventListener(TextOperationEvent.CHANGE,searchDisplay_changeHandler);
			}
			if (instance == addUserButton)
			{
				addUserButton.removeEventListener(MouseEvent.CLICK, addButton_clickHandler);
			}

			 
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			 
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled ? "disabled" : "normal"; 
		}
		
		//_____________________________________________________________________
		//
		// Event Handlers
		//
		//_____________________________________________________________________
		
		/**
		 * @private
		 */
		protected function addButton_clickHandler(event:MouseEvent):void
		{
			usersList.selectedIndex = -1;
			
			userDetail.editing = true;
			userDetail.user = new User( new UserVO());
            
		}
		
		/**
		 * @private
		 */
		protected function userList_indexChangeHandler(event:IndexChangeEvent):void
		{
			userDetail.user = User(usersList.dataProvider.getItemAt(event.newIndex));
		}
		
		protected function filter_viewAllHandler(event:UserFilterEvent):void
		{
			log.debug("filter change : view all users");
			filterProfileMax = -1;
			
			userCollection.refresh();
			
		}
		protected function filter_viewProfileHandler(event:UserFilterEvent):void
		{
			log.debug("filter users with profile " + event.profile_max.toString(2) +" - "+ event.profile_min.toString(2) );
			
			filterProfileMax = event.profile_max;
			filterProfileMin = event.profile_min;
			userCollection.refresh();
		}
		protected function filter_viewUngroupHandler(event:UserFilterEvent):void
		{
			log.debug("filter change view ungroup users");
			filterProfileMax = -1;
			
			userCollection.refresh();
		}
		protected function searchDisplay_changeHandler(event:TextOperationEvent):void
		{
			log.debug("searchDisplay change"); 

			userCollection.refresh();
		}
		protected function searchDisplay_mxchangeHandler(event:FlexEvent):void
		{
			log.debug("searchDisplay clear"); 
			
			userCollection.refresh();
		}
		
		
	 
		protected function userFilterFunction(item:Object):Boolean
		{
			var u :User = item as User;
			if (filterProfileMax != -1)
			{
				if (u.role > filterProfileMax || u.role < filterProfileMin) return false;
			}
			
			var dict :String = LemmeFormatter.format( u.lastname + "|" + u.firstname+"|"+u.mail);
				
			if (dict.indexOf( searchDisplay.text ) == -1  )
			{
				return false
			}
			else
			{
				return true;
			}	
		}
		
        public function setStateEmpty():void{
            userDetail.setStateEmpty();
            // set title the panel
        }
	}
}