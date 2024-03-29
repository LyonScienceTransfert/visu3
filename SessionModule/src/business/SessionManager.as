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
package business
{
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.SessionUserEvent;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.events.VisuActivityElementEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.ActivityElementVO;
	import com.ithaca.visu.model.vo.ActivityVO;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;

	public class SessionManager
	{

		private var dispatcher:IEventDispatcher;
		
		protected static var log:ILogger = Log.getLogger("managers.SessionManager");

		public var model:Model; 

		[Bindable] 
		public var sessions:Array=[];
		[Bindable]
		public var listActivities:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var listUser:ArrayCollection = new ArrayCollection();
		
		public function SessionManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function setCurrentSessionId(value:int):void
		{
			Model.getInstance().getTimeServeur();
			Model.getInstance().setCurrentSessionId(value);
		}
		public function getCurrentSessioId():int
		{
			return Model.getInstance().getCurrentSessionId();
		}
		
		public function setSessionAndPlan(value:Array):void 
		{ 
			log.debug( ObjectUtil.toString(value));
			var ar:Array = []
			for each (var sessionVO:SessionVO in value)
			{
				if(sessionVO.listUser != null)
				{
					var t:int = 1;
				}
				var session:Session = new Session(sessionVO);
				var listUserVO:Array = sessionVO.listUser;
				var listUser:ArrayCollection = new ArrayCollection();
				for each(var userVO:UserVO in listUserVO)
				{
					var user:User = new User(userVO);
					listUser.addItem(user);
				}
				session.participants = listUser;
				ar.push(session);   
			}
			sessions = ar;
			log.debug("setSessionAndPlan "+ sessions);
		}
		
		public function loadListPresentUserInSession(value:Array, sessionId:int):void
		{
			if(value != null && value.length > 0)
			{
				// list recording users
				var listUser:ArrayCollection = new ArrayCollection();
				for each (var userVO:UserVO in value)
				{
					var user:User = new User(userVO);
					listUser.addItem(user);
				}
				var loadListRecordingUser:SessionUserEvent = new SessionUserEvent(SessionUserEvent.LOAD_LIST_SESSION_USER);
				loadListRecordingUser.listUser = listUser;
				this.dispatcher.dispatchEvent(loadListRecordingUser);	
			}
			// load activities
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.LOAD_LIST_ACTIVITY);
			visuActivityEvent.sessionId = sessionId;			   		
			this.dispatcher.dispatchEvent(visuActivityEvent);
		}
		
		public function onLoadListUsersSession(listUserVO:Array, sessionId:int):void
		{
			this.listUser.removeAll();
			var nbrUserVO:int = listUserVO.length;
			for(var nUserVO:int = 0; nUserVO < nbrUserVO; nUserVO++)
			{
				var userVO:UserVO = listUserVO[nUserVO];
				var user:User = new User(userVO);
				this.listUser.addItem(user);
			}
		}


// USER
		public function onUpdateSession(sessionVO:SessionVO):void
		{
			// TODO : 1) Notification for all users connected on the plateforme
			//        2) Update open session in SessionModule
			
			/*model.clearDateSession();	
			// update user fo the session 
			var updateSession:SessionEvent = new SessionEvent(SessionEvent.SHOW_UPDATED_SESSION);
			var session:Session = new Session(sessionVO);
			updateSession.session = session;
			this.dispatcher.dispatchEvent(updateSession);*/
		}

		/**
		 * Default error Handler for rtmp method call
		 */
		public function error(event:Event):void
		{
			log.error(event.toString());
		}
		
		public function notifyOutSession():void
		{
			var loggedUser:User =  model.getLoggedUser();
			var statusLoggedUser:int = loggedUser.status; 
			
			if(statusLoggedUser == ConnectionStatus.CONNECTED)
			{
				model.updateStatusLoggedUser(ConnectionStatus.PENDING);
				var outSession:SessionEvent = new SessionEvent(SessionEvent.OUT_SESSION);
				outSession.userId = loggedUser.id_user;
				dispatcher.dispatchEvent(outSession);
			}
		}
		
		private function getActivityById(value:int):Activity
		{
			var nbrActivity:uint = this.listActivities.length;
			for(var nActivity:uint = 0; nActivity < nbrActivity;nActivity++)
			{
				var activity:Activity = this.listActivities[nActivity];
				var activityId:int = activity.id_activity;
				if(activityId == value)
				{
					return activity;
				}
			}
			return null;
		}
	}
}