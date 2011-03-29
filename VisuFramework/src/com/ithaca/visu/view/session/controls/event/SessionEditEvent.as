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
package com.ithaca.visu.view.session.controls.event
{
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	
	import flash.events.Event;
	
	public class SessionEditEvent extends Event
	{
		public static const DELETE_ACTIVITY:String="deleteActivitySessionEdit";
		public static const UPDATE_ACTIVITY:String="updateActivitySessionEdit";
		public static const ADD_ACTIVITY:String="addActivitySessionEdit";
		
		public static const DELETE_ACTIVITY_ELEMENT:String="deleteActivityElement";
		public static const PRE_DELETE_ACTIVITY_ELEMENT:String="preDeleteActivityElement";
		public static const UPDATE_ACTIVITY_ELEMENT:String="updateActivityElement";
		public static const PRE_UPDATE_ACTIVITY_ELEMENT:String="preUpdateActivityElement";
		public static const ADD_ACTIVITY_ELEMENT:String="addActivityElement";
		
		public static const UPDATE_DATE_TIME:String="updateDateTime";
		public static const UPDATE_SESSION:String="updateSession";
		public static const PRE_ADD_SESSION:String="preAddSession";
		public static const ADD_SESSION:String="addSession";
		public static const PRE_DELETE_SESSION:String="preDeleteSession";
		
		public static const PRE_DELETE_SESSION_USER:String="preDeleteSessionUser";
		public static const PRE_LOAD_USERS:String="preLoadUsers";
		public static const LOAD_LIST_USERS:String="loadListUsers";
		
		public static const MOVE_UP_ACTIVITY_ELEMENT:String="moveUpActivityElement";
		public static const MOVE_DOWN_ACTIVITY_ELEMENT:String="moveDownActivityElement";
		public static const MOVE_UP_ACTIVITY:String="moveUpActivity";
		public static const MOVE_DOWN_ACTIVITY:String="moveDownActivity";
		
		public var activity:Activity;
		public var activityElement:ActivityElement;
		public var session:Session;
		public var user:User;
		public var isModel:Boolean = false;
		public var listUser:Array;
		
		public function SessionEditEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}