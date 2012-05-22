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
import com.ithaca.visu.model.Session;
import com.ithaca.visu.model.vo.ActivityElementVO;
import com.ithaca.visu.model.vo.ActivityVO;
import com.ithaca.visu.model.vo.SessionVO;
import com.ithaca.visu.model.vo.SessionWithoutListUserVO;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SessionEvent extends Event
{
	// constants
	static public const LOAD_LIST_SESSION : String = 'loadListSession';
	static public const LOAD_LIST_DATE_SESSION : String = 'loadListDateSession';
	static public const LOAD_SESSION : String = 'loadSession';
	static public const LOAD_SESSION_SALON_RETROSPECTION : String = 'loadSessionSalonRetrospection';
	static public const LOAD_DURATION_SESSION: String = 'loadDurationSession';
	static public const SHOW_LIST_DATE_SESSION : String = 'showListDateSession';
	static public const SHOW_CLONED_PLAN : String = 'showClonedPlan';
	static public const SHOW_LIST_SESSION : String = 'showListSession';
	static public const SHOW_UPDATED_SESSION : String = 'showUpdatedSession';
	static public const ADDED_SESSION : String = 'addedSession';
	static public const ADD_SESSION : String = 'addSession';
	static public const ADD_EMPTY_SESSION : String = 'addEmptySession';
	static public const ADD_CLONED_SESSION : String = 'addClonedSession';
	static public const ADD_ACTIVITY : String = 'addActivity';
	static public const ADD_CLONED_ACTIVITY : String = 'addClonedActivity';
	static public const ADD_ACTIVITY_ELEMENT : String = 'addActivityElement';
	static public const ADD_CLONED_ACTIVITY_ELEMENT : String = 'addClonedActivityElement';
	static public const DELETE_SESSION : String = 'deleteSession';
	static public const DELETE_ACTIVITY : String = 'deleteActivity';
	static public const DELETE_ACTIVITY_ELEMENT : String = 'deleteActivityElement';
	static public const UPDATE_LIST_SESSION : String = 'updateListSession';
	static public const UPDATE_LIST_USER : String = 'updateListUser';
	static public const UPDATE_LIST_VIEW_TRACELINE : String = 'updateListViewTraceline';
	static public const UPDATE_DELETED_SESSION : String = 'updateDeletedSession';
	static public const UPDATE_SESSION : String = 'updateSession';
	static public const UPDATE_ACTIVITY_SESSION : String = 'updateActivitySession';
	static public const UPDATE_ACTIVITY_ELEMENT_SESSION : String = 'updateActivityElementSession';
	static public const EDIT_SESSION : String = 'editSession';
	static public const CANCEL_SESSION : String = 'cancelSession';
	static public const JOIN_SESSION : String = 'joinSession';
	static public const OUT_SESSION : String = 'outSession';
	static public const NEW_USER_JOIN_SESSION : String = 'newUserJoinSession';
	static public const OLD_USER_OUT_SESSION : String = 'oldUserOutSession';
	static public const START_RECORDING_SESSION : String = 'startRecordingSession';
	static public const STOP_RECORDING_SESSION : String = 'stopRecordingSession';
	static public const CLOSE_SESSION : String = 'closeSession';
	static public const LOAD_LIST_OBSEL : String = 'loadListObsel';
	static public const LOAD_LIST_SESSION_SALON_RETROSPECTION : String = 'loadListSessionSalonRetrospection';
	static public const GET_SESSION : String = 'getSession';
	static public const GET_SESSION_SALON_RETRO : String = 'getSessionSalonRetro';
	static public const LOAD_LIST_OBSEL_RETRO : String = 'loadListObselRetro';
	static public const LOAD_LIST_OBSEL_BILAN : String = 'loadListObselBilan';
	static public const LOAD_LIST_RETRODOCUMENT_SESSION : String = 'loadListRetrodocumentSession';
	static public const LOAD_LIST_CLOSED_SESSION_SALON_RETROSPECTION : String = 'loadListClosedSessionSalonRetrospection';
	static public const GET_LIST_OBSEL : String = 'getListObsel';
	static public const GET_LIST_SESSION : String = 'getListSession';
	static public const GET_LIST_CLOSED_SESSION : String = 'getListClosedSession';
	static public const GET_LIST_CLOSED_SESSION_ALL : String = 'getListClosedSessionAll';
	static public const GET_LIST_OBSEL_CLOSED_SESSION : String = 'getListObselClosedSession';
	static public const LOAD_LIST_USERS_PLATEFORME : String = 'loadListUsersPlateforme';
	static public const GO_RETROSPECTION_MODULE : String = 'goRetrospectionModule';
	static public const GO_BILAN_MODULE : String = 'goBilanModule';
	static public const GO_HOME_MODULE : String = 'goHomeModule';

	// properties
	public var userId : int;
	public var userIdClient : String;
	public var sessionId : int;
	public var sessionDate : String;
	public var session : Session;
	public var sessionVO :SessionVO;
	public var sessionWitOutListUserVO :SessionWithoutListUserVO;
	public var activityVO :ActivityVO;
	public var activityId :int;
	public var activityElementVO :ActivityElementVO;
	public var listSession : ArrayCollection;
	public var listDate : Array;
	public var status : int;
	public var timeStartStop : Number;
	public var durationSessionRetro : Number;
	public var traceId : String;
	public var dateStartRecording : Date;
	public var nbrRetroDocumentOwner:int;
	public var nbrRetroDocumentShare:int;
	public var listRetroDocument:ArrayCollection;
	public var clonedSession:Boolean;
	public var typeRecording:String;

	// constructor
	public function SessionEvent(type : String,
								 bubbles : Boolean = true,
								 cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

	// methods
}
}
