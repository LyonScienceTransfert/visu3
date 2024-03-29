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
package  com.ithaca.visu.events
{
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.UserVO;
	
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		// constants
		static public const LOAD_LIST_USERS_SESSION : String = 'loadListUsersSession';
		static public const LOAD_USERS : String = 'loadUsers';
		static public const LOADED_ALL_USERS : String = 'loadedAllUsers';
		static public const LOADED_ALL_USERS_SALON_HOME : String = 'loadedAllUsersSalonHome';
		static public const UPDATE_USER : String = 'updateUser';
		static public const ADD_USER : String = 'addViewUser';
		static public const DELETE_USER : String = 'deleteViewUser';
		static public const SELECTED_USER : String = 'selectedUser';
		static public const NOTIFICTION_ADD_UPDATE_USER : String = 'notificationAddUpdateUser';
		static public const CHECK_UPDATED_USER : String = 'checkUpdatedUser';
		static public const CHECK_ADDED_USER : String = 'checkAddedUser';
		static public const CHECK_DELETED_USER : String = 'checkDeletedUser';
		static public const SEND_MAIL : String = 'sendMail';
		static public const SET_PASSWORD : String = 'setPassword';
		
		// properties
		public var sessionId : int;
		public var sessionDate : String;
		public var user : User;
		public var userVO: UserVO;
		public var listUser:Array;
		public var userId:int;
		public var sendTo:String;
		public var subject:String;
		public var bodyMail:String;
		public var password:String;
		
		// constructor
		public function UserEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
		public override function toString() : String
		{ return "events.UserEvent"; }
	}
}