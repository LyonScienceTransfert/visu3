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

package com.ithaca.visu.view.session
{
	import com.ithaca.visu.controls.AdvancedTextInput;
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.events.SessionUserEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.ui.utils.SessionFilterEnum;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	import com.ithaca.visu.view.session.controls.SessionDetail;
	import com.ithaca.visu.view.session.controls.SessionFilters;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	import com.ithaca.visu.view.session.controls.event.SessionFilterEvent;
	import com.lyon2.controls.utils.LemmeFormatter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	public class SessionManagement extends SkinnableComponent
	{
		protected static var log:ILogger = Log.getLogger("views.SessionManagement");

		[SkinPart("true")]
		public var filter:SessionFilters;
		
		[SkinPart("true")]
		public var sessionsList:Group;
/*		public var sessionsList:List;*/
		
		[SkinPart("true")]
		public var addSessionButton:Button;
		
		[SkinPart("false")]
		public var searchDisplay:AdvancedTextInput;
		
		[SkinPart("true")]
		public var sessionDetail:SessionDetail;
		
		private var _filterSession:int = -1;
		
		private var filterChange:Boolean;
		private var _loggedUser:User;

        [Bindable]
        private var fxgt: _FxGettext = FxGettext;
		
		public function SessionManagement()
		{
			super();
		}
		
		public var sessionCollection:ArrayCollection;
		private var _sessions:Array = [];
		
		[Bindable("update")]
		public function get filterSession():int {return this._filterSession;}
		public function set filterSession(value:int):void
		{
			this._filterSession = value; 
			// init selected filter
			this.filter.setSelectedFilter(this._filterSession);
			this.filterChange = true;
			this.invalidateProperties();
		};
				
		public function get sessions():Array {return _sessions;}
		public function set sessions(value:Array):void
		{
			log.debug("set users " + value);
			if( value != _sessions )
			{
				_sessions = value;
				sessionCollection = new ArrayCollection( _sessions);
				
				this.filterChange = true;
				this.invalidateProperties();
				
				// init filter show my session
				
/*				this._filterSession = SessionFilterEnum.SESSION_MY;
				this.filterChange = true;
				this.invalidateProperties();*/
				//sessionCollection.filterFunction = userFilterFunction;
				/*var nbrSession:int = sessionCollection.length;
				for(var nSession:int = 0 ; nSession < nbrSession ; nSession++)
				{
					var session:Session = sessionCollection.getItemAt(nSession) as Session;
					var sessionView:SessionViewSalonSession = createSessionView(session);
					sessionsList.addElement(sessionView);
				}*/
			//	sessionsList.dataProvider = sessionCollection;
			//	dispatchEvent( new Event("update") );
				
/*				var showFirstSession:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CHANGE);
				showFirstSession.newIndex = 0;
				sessionList_indexChangeHandler(showFirstSession);*/
				//onSessionViewClick();
			}
		} 
		
		public function get loggedUser():User
		{
			return this._loggedUser;
		}
		
		public function set loggedUser(value:User):void
		{
			this._loggedUser = value;
		}
		
		private function createSessionView(session:Session):SessionViewSalonSession
		{
			var sessionView:SessionViewSalonSession = new SessionViewSalonSession();
			sessionView.session = session;
			sessionView.theme = session.theme;
			if(session.isModel){
				sessionView.setStatusSession(SessionFilterEnum.SESSION_PLAN);
				sessionView.dateRecorded = session.date_session;
			}else
			{
				var statusSession:int= -1;
				switch (session.statusSession)
				{
					case 0:
						statusSession = SessionFilterEnum.SESSION_WILL;
						sessionView.dateRecorded = session.date_session;
						break;
					case 1:
						statusSession = SessionFilterEnum.SESSION_WAS;
						sessionView.dateRecorded = session.date_start_recording;
						break;
				}
				sessionView.setStatusSession(statusSession);	
			}	
			sessionView.ownerSession = Model.getInstance().getUserPlateformeByUserId(session.id_user);
			sessionView.percentWidth = 100;
			sessionView.addEventListener(MouseEvent.CLICK, onSessionViewClick);
			sessionView.listUserSession = session.participants;
			return sessionView;
		}
		
		[Bindable("update")]
		public function addSession(session:Session):void{
			if(sessionCollection  != null)
			{
				sessionCollection.addItem(session);
				var sessionView:SessionViewSalonSession = createSessionView(session);
				sessionsList.addElement(sessionView);
				var typeSession:String = fxgt.gettext("Votre nouvelle séance a été créée et ajoutée à la liste des séances.");
				if(session.isModel)
				{
					typeSession = fxgt.gettext("Le nouveau plan de séance a été créé et ajouté à la liste des séances.");
				}
				Alert.show(typeSession, fxgt.gettext("Information"));
				dispatchEvent( new Event("update") );
			}
		}
		// TODO update session item
		/*public function updateSession(value:Session):void
		{
			var nbrSession:int = sessionsList.dataProvider.length;
			for(var nSession:int = 0 ; nSession < nbrSession; nSession++)
			{
				var session:Session = sessionsList.dataProvider.getItemAt(nSession) as Session;
				if(session.id_session == value.id_session)
				{
					session.date_session = value.date_session;
					session.theme = value.theme;
					session.description = value.description;
					return;
				}
			}
		}*/
		public function updateSession(value:Session):void
		{
			var sessionIndexUpdate:int = -1;
			// update session
			var nbrSession:int = sessionCollection.length;
			for(var nSession:int = 0 ; nSession < nbrSession; nSession++)
			{
				var session:Session = sessionCollection.getItemAt(nSession) as Session;
				if(session.id_session == value.id_session)
				{
					sessionIndexUpdate = nSession;	
				}
			}
			sessionCollection.removeItemAt(sessionIndexUpdate);		
			sessionCollection.addItemAt(value,sessionIndexUpdate);
			// update view session
			var nbrElm:int = sessionsList.numElements;
			for(var nElm:int = 0; nElm < nbrElm ; nElm++ )
			{
				var viewSession:SessionViewSalonSession = sessionsList.getElementAt(nElm) as SessionViewSalonSession;
				var session:Session = viewSession.session;
				if(session.id_session == value.id_session)
				{
					viewSession.listUserSession = value.participants;
					viewSession.theme = value.theme;
					// update date only for session "will"
					viewSession.dateRecorded = value.date_session;	
					return;
				}
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
			if (instance == sessionsList)
			{
		//		sessionsList.addEventListener(IndexChangeEvent.CHANGE, sessionList_indexChangeHandler);
			}
			if (instance == filter)
			{
				filter.addEventListener(SessionFilterEvent.VIEW_SESSION, onFilterViewHandler);
			}
			if (instance == searchDisplay)
			{
				searchDisplay.addEventListener(TextOperationEvent.CHANGE,searchDisplay_changeHandler);
				searchDisplay.addEventListener(FlexEvent.VALUE_COMMIT,searchDisplay_mxchangeHandler);
			}
			if (instance == addSessionButton)
			{
				addSessionButton.addEventListener(MouseEvent.CLICK, addButton_clickHandler);
			}
			if (instance == sessionDetail)
			{
				sessionDetail.addEventListener(SessionEditEvent.PRE_DELETE_SESSION, preDeleteSession);
				sessionDetail.loggedUser = this.loggedUser;
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == sessionsList)
			{
	//			sessionsList.removeEventListener(IndexChangeEvent.CHANGE, sessionList_indexChangeHandler);
			}
			if (instance == filter)
			{
				filter.removeEventListener(SessionFilterEvent.VIEW_SESSION, onFilterViewHandler);
			}
			if (instance == searchDisplay)
			{
				searchDisplay.removeEventListener(TextOperationEvent.CHANGE,searchDisplay_changeHandler);
			}
			if (instance == addSessionButton)
			{
				addSessionButton.removeEventListener(MouseEvent.CLICK, addButton_clickHandler);
			}	
			if (instance == sessionDetail)
			{
				sessionDetail.removeEventListener(SessionEditEvent.PRE_DELETE_SESSION, preDeleteSession);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (filterChange)
			{
				filterChange = false;
				
				doFilterSession();
				
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
		
		/**
		 * @private
		 */
		protected function addButton_clickHandler(event:MouseEvent):void
		{
			/*usersList.selectedIndex = -1;
			userDetail.editing = true;
			userDetail.user = new User( new UserVO());*/
		}
		
		/**
		 * @private
		 */
		protected function sessionList_indexChangeHandler(event:IndexChangeEvent):void
		{
			/*var session:Session = Session(sessionsList.dataProvider.getItemAt(event.newIndex));
			sessionDetail.session = session;
			var editable:Boolean = false;
			if(session.statusSession == SessionStatusEnum.SESSION_OPEN){
				editable = true;
			}
			sessionDetail.setEditabled(editable);
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.LOAD_LIST_ACTIVITY);
			visuActivityEvent.sessionId = session.id_session;					
			dispatchEvent(visuActivityEvent);*/
		}
		
		protected function onSessionViewClick(event:MouseEvent=null):void
		{
			var sessionView:SessionViewSalonSession;
			if(event == null)
			{
				if(this.sessionsList.numElements > 0)
				{
					sessionView = this.sessionsList.getElementAt(0) as SessionViewSalonSession;
				}else
				{
					sessionDetail.setViewEmpty(); // set empty = false
					return;					
				}
			}else
			{
				sessionView = event.currentTarget as SessionViewSalonSession;
			}
			// update selected session
			updateSelectedSession(sessionView);
			var session:Session = sessionView.session;	
			sessionDetail.session = session;
			var editable:Boolean = false;
			if(session.statusSession == SessionStatusEnum.SESSION_OPEN){
				editable = true;
			}
			sessionDetail.setEditabled(editable);
			// posibility add user to the closed session only fot "visuvciel"
			var canAddUserToClosedSession:Boolean = false;
			var isVisuvciel:Boolean = Model.getInstance().checkServeurVisuVciel();
			if(isVisuvciel)
			{
				if( !session.isModel)
				{
					canAddUserToClosedSession = true;			
				}
				sessionDetail.setCanAddUserToClosedSession(canAddUserToClosedSession);
			}
			
			// get list user was recording in session
			var presentUserEvent:SessionUserEvent = new SessionUserEvent(SessionUserEvent.GET_LIST_SESSION_USER);
			presentUserEvent.sessionId = sessionDetail.session.id_session;
			this.dispatchEvent(presentUserEvent);
			
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.LOAD_LIST_ACTIVITY);
			visuActivityEvent.sessionId = session.id_session;					
			dispatchEvent(visuActivityEvent);
		}
		private function updateSelectedSession(value:SessionViewSalonSession):void
		{
			var nbrElm:int = sessionsList.numElements;
			for(var nElm:int = 0; nElm < nbrElm ; nElm++ )
			{
				var viewSession:SessionViewSalonSession = sessionsList.getElementAt(nElm) as SessionViewSalonSession;
				viewSession.setSelected(false); 
				var session:Session = viewSession.session;
				if(session.id_session == value.session.id_session)
				{
					viewSession.setSelected(true); 
				}
			}
		}
		
		protected function onFilterViewHandler(event:SessionFilterEvent):void
		{
			log.debug("filter session is :  " + event.filterSession );
			this._filterSession = event.filterSession;
			// set new filter to model
			var filterChangeEvent:SessionFilterEvent = new SessionFilterEvent(SessionFilterEvent.CHANGE_FILTER);
			filterChangeEvent.filterSession = this._filterSession;
			this.dispatchEvent(filterChangeEvent);
			
			filterChange = true;
			this.invalidateProperties();
		}

		protected function searchDisplay_changeHandler(event:TextOperationEvent):void
		{
			log.debug("searchDisplay change"); 
			sessionCollection.refresh();
		}
		protected function searchDisplay_mxchangeHandler(event:FlexEvent):void
		{
			log.debug("searchDisplay clear"); 
			sessionCollection.refresh();
		}

		private function doFilterSession():void
		{
			if(sessionsList != null)
			{
				sessionsList.removeAllElements();
			}
			var addSession:Boolean;
			var sortFieldFunction:Function = compareDateSession;
			var listFilteredSession:ArrayCollection = new ArrayCollection();
			var nbrSession:int = sessionCollection.length;
			for(var nSession:int = 0 ; nSession < nbrSession ; nSession++)
			{
				var session:Session = sessionCollection.getItemAt(nSession) as Session;
				addSession = false;
				switch (this._filterSession)
				{
					case SessionFilterEnum.SESSION_MY :
						if(session.id_user == Model.getInstance().getLoggedUser().id_user && !session.isModel)
						{addSession = true;	};
						break;
					case SessionFilterEnum.SESSION_ALL :
						addSession = true;
						break;
					case SessionFilterEnum.SESSION_WILL :
						if(session.statusSession == SessionStatusEnum.SESSION_OPEN && !session.isModel){ addSession = true;};
						break;						
					case SessionFilterEnum.SESSION_WAS :
						if(session.statusSession == SessionStatusEnum.SESSION_CLOSE && !session.isModel){ addSession = true;};
						sortFieldFunction = compareDateSessionRecording;
						break;
					case SessionFilterEnum.SESSION_PLAN :
						if(session.isModel){ addSession = true; };
						break;
				}
				if(addSession)
				{
					listFilteredSession.addItem(session);
				}
			}
			// sort by date 
			var sort:Sort = new Sort();
			sort.compareFunction = sortFieldFunction;
			listFilteredSession.sort = sort;
			listFilteredSession.refresh();
			
			var nbrFilteredSession:uint = listFilteredSession.length;
			for(var nFilteredSession:int = 0 ; nFilteredSession < nbrFilteredSession ; nFilteredSession++)
			{
				var filteredSession:Session = listFilteredSession.getItemAt(nFilteredSession) as Session;
				var sessionView:SessionViewSalonSession = createSessionView(filteredSession);
				sessionsList.addElement(sessionView);
			}
			
			onSessionViewClick();
		}
		// sort by date session planed
		private function compareDateSession(ObjA:Object,ObjB:Object,fields:Array = null):int
		{
			var dateA:Date=ObjA.date_session;
			var dateB:Date=ObjB.date_session;
			return ObjectUtil.dateCompare(dateA, dateB);
		}
		// sort by date session recording
		private function compareDateSessionRecording(ObjA:Object,ObjB:Object,fields:Array = null):int
		{
			var dateA:Date=ObjA.date_start_recording;
			var dateB:Date=ObjB.date_start_recording;
			return ObjectUtil.dateCompare(dateA, dateB);
		}
		
		
		
		protected function userFilterFunction(item:Object):Boolean
		{
			// FIXME : ? will be with session en recording
			var result:Boolean = false;
			var session :Session = item as Session;
			return true;
		//	this.filterSession = session.statusSession;
				switch (this._filterSession)
				{
					case SessionFilterEnum.SESSION_PLAN:
						if(session.isModel){
							result = true;
						}
						break;
					case SessionFilterEnum.SESSION_ALL:
						//this.filterSession = -1;
						result = true;
						break;
					case SessionFilterEnum.SESSION_WAS:
						if(session.statusSession == SessionStatusEnum.SESSION_CLOSE && !session.isModel)
						{
							result = true;
						}				
						break;
					case SessionFilterEnum.SESSION_WILL:
						if(session.statusSession == SessionStatusEnum.SESSION_OPEN)
						{
							result = true;
						}
						break;
					case SessionFilterEnum.SESSION_MY:
						if( session.id_user == Model.getInstance().getLoggedUser().id_user)
						{
							result = true;
						}
						break;
					default:
						break;	
				}

				return result;
						
			var dict :String = LemmeFormatter.format( session.theme );
			
			if (dict.indexOf( searchDisplay.text ) == -1  )
			{
				return false
			}
			else
			{
				return true;
			}	
		}
// DELETE SESSION
		private function preDeleteSession(event:SessionEditEvent):void
		{
			var deletingSession:Session = event.session;
			removeSession(deletingSession.id_session);
			this.filterChange = true;
			this.invalidateProperties();
			var deleteSession:SessionEvent = new SessionEvent(SessionEvent.DELETE_SESSION);
			deleteSession.sessionId = deletingSession.id_session;
			this.dispatchEvent(deleteSession);
		}
		
		private function removeSession(value:int):Boolean
		{
			var indexSession:int= -1;
			var nbrSession:uint = this.sessionCollection.length;
			for(var nSession:uint = 0; nSession < nbrSession ; nSession++)
			{
				var session:Session = this.sessionCollection.getItemAt(nSession) as Session;
				if(session.id_session == value)
				{
					indexSession = nSession;
				}
			}
			if(indexSession > 1)
			{
				this.sessionCollection.removeItemAt(indexSession);
				return true;
			}
			return false;
		}
		
		public function removeSessionView(value:int, nameUserDeleteSession:String):void
		{
			if(removeSession(value))
			{
				var session:Session = sessionDetail.session;
				if(session.id_session == value)
				{
					Alert.show(fxgt.gettext('La Séance "') + session.theme + fxgt.gettext('" a été supprimée par ') + nameUserDeleteSession, fxgt.gettext("Information"));
					this.filterChange = true;
					this.invalidateProperties();
				}else
				{
					if(removeSessionViewFromGroup(value))
					{
						// TODO : massage that user remove session
					}
				}

			}
		}
		
		private function removeSessionViewFromGroup(value:int):Boolean
		{
			var indexSessionView:int = -1;
			var nbrSessionView:int = sessionsList.numElements;
			for(var nSessinView:int = 0; nSessinView < nbrSessionView; nSessinView++)
			{
				var iVisualElement:IVisualElement = sessionsList.getElementAt(nSessinView) as IVisualElement;
				var sessionView:SessionViewSalonSession = iVisualElement as SessionViewSalonSession;
				if(sessionView.session.id_session == value)
				{
					indexSessionView = nSessinView;
				}
			}
			if(indexSessionView > -1)
			{
				sessionsList.removeElementAt(indexSessionView);
				return true;
			}
			return false;
		}
	}
}
