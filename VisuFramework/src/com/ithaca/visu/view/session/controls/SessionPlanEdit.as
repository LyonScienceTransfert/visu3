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

package com.ithaca.visu.view.session.controls
{
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	public class SessionPlanEdit extends SkinnableContainer
	{
			
		[SkinPart("true")] 
		public var activityGroup:Group;
		
/*		[SkinPart("true")] 
		public var keywordGroup:Group;*/
		
		[SkinPart("true")] 
		public var sharePlanButton:Button;

		[SkinPart("true")] 
		public var createSessionButton:Button;
		
		private var editabled:Boolean;
		private var _activities:ArrayCollection;
		protected var activitiesChanged:Boolean;
		
		public function SessionPlanEdit()
		{
			super();
		}
		
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == createSessionButton)
			{
				createSessionButton.addEventListener(MouseEvent.CLICK, onMouseClickButtonCreateSessionByTemplate);
			}

			if (instance == sharePlanButton)
			{
				sharePlanButton.addEventListener(MouseEvent.CLICK, onMouseClickButtonExportSession);
			}

		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == createSessionButton)
			{
				createSessionButton.removeEventListener(MouseEvent.CLICK, onMouseClickButtonCreateSessionByTemplate);
			}
			
			if (instance == sharePlanButton)
			{
				sharePlanButton.removeEventListener(MouseEvent.CLICK, onMouseClickButtonExportSession);
			}

		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (activitiesChanged)
			{
				activitiesChanged = false;
				
				// remove all elements from activityGroup 
				if(activityGroup != null)
				{
					activityGroup.removeAllElements();
				}
				
				if(_activities == null)
				{
					// TODO : message "hasn't acitivties fro this session
				}else
				{
					// remove listener for sort the order activity
					_activities.removeEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
					sortByOrder(activities);
					_activities.addEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
					
					var nbrActivity:int =  _activities.length;
					for (var nActivity:int = 0; nActivity < nbrActivity; nActivity++  )
					{
						var activity:Activity= _activities.getItemAt(nActivity) as Activity;
						activity.ind = activityGroup.numElements;
						
						var activityDetailEdit:ActivityDetailEdit =  new ActivityDetailEdit();
						activityDetailEdit.activity = activity;
						activityDetailEdit.setEditabled(this.editabled);
						activityDetailEdit.percentWidth = 100;
						activityDetailEdit.addEventListener(SessionEditEvent.DELETE_ACTIVITY, onDeleteActivity);
						activityDetailEdit.addEventListener(SessionEditEvent.MOVE_UP_ACTIVITY, onMoveUpActivity);
						activityDetailEdit.addEventListener(SessionEditEvent.MOVE_DOWN_ACTIVITY, onMoveDownActivity);
						activityGroup.addElement( activityDetailEdit );
					}
				}
					
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : editabled? "normalEditable" : "normal";
		}
		
		public function setEditabled(value:Boolean):void
		{
			editabled = value;
			this.enabled = true;
			this.invalidateSkinState();
		}
		
		public function setViewEmpty():void
		{
			this.enabled = false;
			this.invalidateSkinState();
			this._activities = null;
			activitiesChanged = true;
			this.invalidateProperties();
		}
		
		[Bindable("updateActivities")] 
		public function get activities():ArrayCollection { return _activities; }
		public function set activities(value:ArrayCollection):void 
		{
			if (_activities == value) return;
			
			if (_activities != null)
			{
				_activities.removeEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
			}
			
			_activities = value;
			activitiesChanged = true;
			invalidateProperties();
			
			if (_activities)
			{
				_activities.addEventListener(CollectionEvent.COLLECTION_CHANGE, activities_ChangeHandler);
			}
			
			dispatchEvent(new Event("updateActivities"));
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET);
			_activities.dispatchEvent(event);
			
		}
		
		protected function activities_ChangeHandler(event:CollectionEvent):void
		{
			activitiesChanged = true;
			invalidateProperties();
		}

		private function onDeleteActivity(event:SessionEditEvent):void
		{
			var activityDeleting:Activity = event.activity;
			var index:int= -1;
			var nbrActivity:int = _activities.length;
			for(var nActivity:int = 0; nActivity < nbrActivity ; nActivity++)
			{
				var activity:Activity = _activities.getItemAt(nActivity) as Activity;
				if(activityDeleting.id_activity == activity.id_activity)
				{
					index = nActivity;
				}
			}
			if(index == -1)
			{
				Alert.show("You havn't activity with title = "+activityDeleting.title,"message error");
			}else{
				_activities.removeItemAt(index);
				activitiesChanged = true;
				invalidateProperties();
			}
		}
// ACTIVITY		
		public function addActivity():void
		{
			var obj:Object = new Object();
			obj.duration = 12;
			obj.title = "New activity";
			var activity:Activity = new Activity(obj);
			var index:int = 0;
			if(activityGroup != null)
			{
				index = activityGroup.numElements;
			}
			activity.ind = index;
			_activities.addItem(activity);
			activitiesChanged = true;
			invalidateProperties();
			
			var addActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY);
			addActivityEvent.activity = activity;
			this.dispatchEvent(addActivityEvent);
		}
		
		public function onMouseClickButtonCreateSessionByTemplate(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous créer une nouvelle séance à partir de ce plan de séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, createSessionByTemplateConformed); 
		}
		private function createSessionByTemplateConformed(event:CloseEvent):void{
			if( event.detail == Alert.YES)
			{
				var sessionAddEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_ADD_SESSION);
				this.dispatchEvent(sessionAddEvent);
			}
		}

		public function onMouseClickButtonExportSession(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous rendre public ce plan de séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, exportSessionConformed); 
		}
		
		private function exportSessionConformed(event:CloseEvent):void{
			if( event.detail == Alert.YES)
			{
				var sessionAddEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_ADD_SESSION);
				sessionAddEvent.isModel = true;
				this.dispatchEvent(sessionAddEvent);
			}
		}
		

// DELETE ACTIVITY ELEMENT FROM ACTIVITY
		private function deleteActivityElement(deletingActivityElemen:ActivityElement):void
		{
			var indexAr:int = -1;
			for each(var activity:Activity in this._activities)
			{
				var arrActivityElement:ArrayCollection = activity.getListActivityElement();
				var nbrActivityElement:int = arrActivityElement.length;
				for(var nActivityElement:int = 0; nActivityElement < nbrActivityElement ; nActivityElement++)
				{
					var activityElement:ActivityElement = arrActivityElement.getItemAt(nActivityElement) as ActivityElement;
					if(deletingActivityElemen.id_element == activityElement.id_element)
					{
						indexAr = nActivityElement;
						arrActivityElement.removeItemAt(nActivityElement);
						return;
					}
				}
			}
			if(indexAr == -1)
			{
				Alert.show("You havn't activityElement in activity = "+activity.title,"message error");
			}	
		}
// MOVE UP/DOWN ACTIVITY
		private function onMoveUpActivity(event:SessionEditEvent):void
		{
			var activityMoveUp:Activity = event.activity;
			var order:int = activityMoveUp.ind;
			if(order == 0) { return; } // do nothing
			// TODO : hide arrow "up" when consigne on the top
			
			var movedDownActivity:Activity = updateOrder(_activities, order-1,order);
			// update moved down activity
			var changeOrderMovedDownActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY);
			changeOrderMovedDownActivityEvent.activity = movedDownActivity;
			this.dispatchEvent(changeOrderMovedDownActivityEvent);	
			
			var movedUpActivity:Activity = setOrder(_activities, activityMoveUp, order-1);
			// update moved down activity
			var changeOrderMovedUpActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY);
			changeOrderMovedUpActivityEvent.activity = movedUpActivity;
			this.dispatchEvent(changeOrderMovedUpActivityEvent);	
			
			activitiesChanged = true;
			this.invalidateProperties();	
			
		}
		private function onMoveDownActivity(event:SessionEditEvent):void
		{
			var activityMoveDown:Activity = event.activity;
			var order:int = activityMoveDown.ind;
			
			if(order == activityGroup.numElements - 1) return; // do nothing
			// TODO : hide arrow "down" when consigne on the bottom
			
			var movedUpActivity:Activity = updateOrder(_activities, order+1,order);
			// update moved down activity
			var changeOrderMovedUpActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY);
			changeOrderMovedUpActivityEvent.activity = movedUpActivity;
			this.dispatchEvent(changeOrderMovedUpActivityEvent);	
			
			var movedDownActivity:Activity = setOrder(_activities, activityMoveDown, order+1);
			// update moved down activity
			var changeOrderMovedDownActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY);
			changeOrderMovedDownActivityEvent.activity = movedDownActivity;
			this.dispatchEvent(changeOrderMovedDownActivityEvent);	
			
			activitiesChanged = true;
			this.invalidateProperties();
		}
		
		private function updateOrder(list:ArrayCollection, orderOld:int,orderNew:int):Activity
		{
			var nbrActivity:int = list.length;
			for( var nActivity:int = 0; nActivity < nbrActivity; nActivity++ )
			{	
				var activity:Activity = list.getItemAt(nActivity) as Activity;
				var order:int = activity.ind;
				if(order == orderOld)
				{
					activity.ind = orderNew;
					return activity;
				}
			}
			return null;
		}
		
		private function setOrder(list:ArrayCollection,value:Activity, orderNew:int):Activity
		{
			var nbrActivity:int = list.length;
			for( var nActivity:int = 0; nActivity < nbrActivity; nActivity++ )
			{	
				var activity:Activity = list.getItemAt(nActivity) as Activity;
				
				if(activity.id_activity == value.id_activity)
				{
					activity.ind = orderNew;
					return activity;
				}
			}
			return null;
		}
		
		private function sortByOrder(list:ArrayCollection):void
		{
			var sort:Sort = new Sort();
			// There is only one sort field, so use a null first parameter.
			sort.fields = [new SortField("ind", true)];
			list.sort = sort;
			list.refresh();
		}
	
	}
}