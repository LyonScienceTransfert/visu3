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
	import com.ithaca.controls.AdvancedTextInput;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.ui.utils.SessionFilterEnum;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	import com.ithaca.visu.view.session.controls.SessionDetail;
	import com.ithaca.visu.view.session.controls.SessionFilters;
	import com.ithaca.visu.view.session.controls.event.SessionFilterEvent;
	import com.lyon2.utils.LemmeFormatter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Button;
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
		public var sessionsList:List;
		
		[SkinPart("true")]
		public var addSessionButton:Button;
		
		[SkinPart("false")]
		public var searchDisplay:AdvancedTextInput;
		
		[SkinPart("true")]
		public var sessionDetail:SessionDetail;
		
		[Bindable] 
		public var filterSession:int = -1;
		
		public function SessionManagement()
		{
			super();
		}
		
		public var sessionCollection:ArrayCollection;
		private var _sessions:Array = [];
		
		[Bindable("update")]
		public function get sessions():Array {return _sessions;}
		public function set sessions(value:Array):void
		{
			log.debug("set users " + value);
			if( value != _sessions )
			{
				_sessions = value;
				sessionCollection = new ArrayCollection( _sessions);
				//sessionCollection.filterFunction = userFilterFunction;
				
				sessionsList.dataProvider = sessionCollection;
				dispatchEvent( new Event("update") );
				
				var showFirstSession:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CHANGE);
				showFirstSession.newIndex = 0;
				sessionList_indexChangeHandler(showFirstSession);
			}
		} 
		
		[Bindable("update")]
		public function addSession(session:Session):void{
			if(sessionCollection  != null)
			{
				sessionCollection.addItem(session);
				sessionCollection.refresh();
				dispatchEvent( new Event("update") );
			}
		}
		// TODO update session item
		public function updateSession(value:Session):void
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
				sessionsList.addEventListener(IndexChangeEvent.CHANGE, sessionList_indexChangeHandler);
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
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == sessionsList)
			{
				sessionsList.removeEventListener(IndexChangeEvent.CHANGE, sessionList_indexChangeHandler);
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
			/*usersList.selectedIndex = -1;
			userDetail.editing = true;
			userDetail.user = new User( new UserVO());*/
		}
		
		/**
		 * @private
		 */
		protected function sessionList_indexChangeHandler(event:IndexChangeEvent):void
		{
			var session:Session = Session(sessionsList.dataProvider.getItemAt(event.newIndex));
			sessionDetail.session = session;
			var editable:Boolean = false;
			if(session.statusSession == SessionStatusEnum.SESSION_OPEN){
				editable = true;
			}
			sessionDetail.setEditabled(editable);
			var visuActivityEvent:VisuActivityEvent = new VisuActivityEvent(VisuActivityEvent.LOAD_LIST_ACTIVITY);
			visuActivityEvent.sessionId = session.id_session;					
			dispatchEvent(visuActivityEvent);
		}
		
		protected function onFilterViewHandler(event:SessionFilterEvent):void
		{
			log.debug("filter session is :  " + event.filterSession );
			this.filterSession = event.filterSession;
			sessionCollection.refresh();
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

		protected function userFilterFunction(item:Object):Boolean
		{
			// FIXME : ? will be with session en recording
			var result:Boolean = false;
			var session :Session = item as Session;
			return true;
		//	this.filterSession = session.statusSession;
				switch (this.filterSession)
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
	}
}