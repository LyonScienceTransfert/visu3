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
package managers
{
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	
	import flash.events.Event;
	
	import modules.UserModule;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;

	public class UserManager
	{
		import flash.events.IEventDispatcher;
		
		protected static var log:ILogger = Log.getLogger("managers.UserManager");
		
		private var dispatcher:IEventDispatcher;
		
		public function UserManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
			
		}
		/*
		* this variable contains the list of profileDescription 
		*/	
		/*
		[Bindable] public var profiles:Array=[];	
		public function setProfiles(value:Array):void { log.debug(value.toString());profiles = value; }
		*/
		[Bindable] public var users:Array=[];	
		public function setUsers(value:Array):void 
		{ 
			log.debug( ObjectUtil.toString(value));
			var ar:Array = []
			for each (var vo:UserVO in value)
			{
				ar.push(new User(vo)) ; 
			}
			users = ar;
			log.debug("setUsers "+ users);
		}
			
		/**
		 * get the list of users 
		 */
		public function getUsers():void
		{
			var e:UserEvent = new UserEvent(UserEvent.LOAD_USERS);
			dispatcher.dispatchEvent( e );
		}
		
		/**
		 * Default error Handler for rtmp method call
		 */
		public function onError(event:Event):void
		{
			log.error(event.toString());
		}
		
		/**
		 * return updated user
		 */
		public function onUpdateUser(userVO:UserVO):void{
			//var userEvent:UserEvent = new UserEvent(UserEvent.UPDATE_VIEW_USER);
			//userEvent.userVO = userVO;
			var userModule:UserModule = Model.getInstance().getCurrentUserModule() as UserModule;
			userModule.setModeEditUpdatedUser(userVO);
			// FIXME : If using dispatcher => Error : many instances the UserModule
			//TypeError: Error #1034: Echec de la contrainte de type 
			//dispatcher.dispatchEvent(userEvent);
		}
		
		/**
		 * return added user
		 */
		public function onAddUser(userVO:UserVO):void{
			var userModule:UserModule = Model.getInstance().getCurrentUserModule() as UserModule;
			userModule.setModeEditAddedUser(userVO);
		}
		
		/**
		 * return id of the deleted user
		 */
		public function onDeleteUser(userId:int):void{
			var userModule:UserModule = Model.getInstance().getCurrentUserModule() as UserModule;
			userModule.setModeEditDeletedUser(userId);
		}
	}
}