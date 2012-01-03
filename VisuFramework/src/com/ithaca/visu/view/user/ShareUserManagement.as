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
	import com.ithaca.visu.controls.AdvancedTextInput;
	import com.ithaca.visu.controls.users.event.UserFilterEvent;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.lyon2.controls.utils.LemmeFormatter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.TextArea;
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	
	public class ShareUserManagement extends SkinnableComponent
	{
		protected static var log:ILogger = Log.getLogger("views.user.ShareUserManagement");
		
		
		[SkinPart("true")]
		public var usersList:Group;

		[SkinPart("true")]
		public var mailList:TextArea;
        
		[SkinPart("true")]
		public var urlBilanTextArea:TextArea;
        
		private var _profiles:Array;
		private var _listShareUser:Array;
		private var _urlBilan:String;
		
        private var profilesChange:Boolean;
		private var listUsersChange:Boolean;
		private var urlBilanChange:Boolean;
        
		
		public function ShareUserManagement()
		{
			super();
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
				listUsersChange = true;
				this.invalidateProperties();
			}
		} 
		public function set profiles(value:Array):void
		{
			this._profiles = value;
			profilesChange = true;
			this.invalidateProperties();
		}
		public function set listShareUser(value:Array):void
		{
			this._listShareUser = value;
		}
		public function get listShareUser():Array
		{
			var result:Array = new Array();
			var nbrShareUser:int = this.usersList.numElements;
			for(var nShareUser:int = 0; nShareUser < nbrShareUser ; nShareUser++ )
			{
				var shareUser:ShareUser = this.usersList.getElementAt(nShareUser) as ShareUser;
				var shared:Boolean = shareUser.share;
				if(shared)
				{
					var userId:int = shareUser.user.id_user;
					result.push(userId);
				}
			}
			return result;
		}
        public function set urlBilan(value:String):void
        {
            _urlBilan = value; 
            urlBilanChange = true;
            invalidateProperties();
        }
        public function get urlBilan():String
        {
            return _urlBilan;
        }
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == urlBilanTextArea)
			{
                urlBilanTextArea.text = urlBilan;
			}

		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(profilesChange)
			{
				profilesChange = false;
			}
			
			if(listUsersChange)
			{
				listUsersChange = false;
				addShareUsers();
                onCheckListSharedUser();
			}
            
			if(urlBilanChange)
			{
                urlBilanChange = false;
                if(urlBilanTextArea)
                {
                    urlBilanTextArea.text = urlBilan;
                }
			}
			
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
	
		private function addShareUsers():void
		{
			var nbrUser:int = userCollection.length;
			for(var nUser:int = 0; nUser < nbrUser; nUser++)
			{	
				var user:User = userCollection.getItemAt(nUser) as User;
				var shareUser:ShareUser = new ShareUser();
                // add listener the checkbox
                shareUser.addEventListener("selectedSharedUser", onCheckListSharedUser);
				shareUser.user = user;
				shareUser.percentWidth = 100;
				var share:Boolean = isUserShare(user.id_user, _listShareUser);
				if(share)
				{
					shareUser.share = true;
				}
				usersList.addElement(shareUser);
			}			
			function isUserShare(id:int, list:Array):Boolean
			{
				var nbrUser:int = list.length;
				for(var nUser:int = 0 ; nUser < nbrUser; nUser++)
				{
					var userId:int = list[nUser];
					if (id == userId)
					{
						return true;
					}
				}
				return false;
			}
		}
		
        private function onCheckListSharedUser(event:Event = null):void
        {
            var result:String="";
            mailList.text = "";
            var nbrShareUser:int = this.usersList.numElements;
            for(var nShareUser:int = 0; nShareUser < nbrShareUser ; nShareUser++ )
            {
                var shareUser:ShareUser = this.usersList.getElementAt(nShareUser) as ShareUser;
                var shared:Boolean = shareUser.share;
                if(shared)
                {
                    if(mailList.text.length > 0)
                    {
                        mailList.text = mailList.text + ", ";
                    }
                    mailList.text =  mailList.text + shareUser.user.mail;
                }
            }
        }
	}
}