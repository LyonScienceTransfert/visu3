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
	import com.ithaca.visu.model.ActivityElementType;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	public class SessionPlanEdit extends SkinnableContainer
	{
			
		[SkinPart("true")] 
		public var activityGroup:Group;
		
		[SkinPart("true")] 
		public var keywordGroup:Group;
		
		[SkinPart("true")] 
		public var buttonCreateSessionByTemplate:Button;
		
	/*	[SkinPart("true")] 
		public var comboBoxActivity:ComboBox;*/
		
		private var editabled:Boolean;
		private var _activities:IList;
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
			if (instance == buttonCreateSessionByTemplate)
			{
				buttonCreateSessionByTemplate.addEventListener(MouseEvent.CLICK, onMouseClickButtonCreateSessionByTemplate);
			}
			/*if (instance == comboBoxActivity)
			{
				comboBoxActivity.labelFunction = setLabelComboboxActivity;
			}*/
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == buttonCreateSessionByTemplate)
			{
				buttonCreateSessionByTemplate.removeEventListener(MouseEvent.CLICK, onMouseClickButtonCreateSessionByTemplate);
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
				keywordGroup.removeAllElements();
				
				for each (var activity:Activity in _activities)
				{
					var activityDetailEdit:ActivityDetailEdit =  new ActivityDetailEdit();
					activityDetailEdit.activity = activity;
					activityDetailEdit.setEditabled(this.editabled);
					activityDetailEdit.percentWidth = 100;
					activityDetailEdit.addEventListener(SessionEditEvent.DELETE_ACTIVITY, onDeleteActivity);
					activityGroup.addElement( activityDetailEdit );
					
					for each( var el:ActivityElement in activity.getListActivityElement())
					{
						if (el.type_element == ActivityElementType.KEYWORD)
						{
							var keywordEdit:KeywordEdit = new KeywordEdit();
							keywordEdit.activityElement = el;
							keywordEdit.textKeyword = el.data;
							keywordEdit.setEditabled(this.editabled);
							keywordEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteKeywordActivElement);
							keywordEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateKeywordActivElement);
							keywordGroup.addElement(keywordEdit);
						}
					}
				}
				// set dataprovider for combobox
				/*if(_activities.length > 0)
				{
					comboBoxActivity.dataProvider = _activities;
					comboBoxActivity.selectedIndex = 0;
				}*/
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : editabled? "normalEditable" : "normal";
		}
		
		public function setEditabled(value:Boolean):void
		{
			editabled = value;
			this.invalidateSkinState();
		}
		
		[Bindable("updateActivities")] 
		public function get activities():IList { return _activities; }
		public function set activities(value:IList):void 
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
// KEYWORD	
		public function addKeyword(value:String):void
		{
			var keyObj:Object = new Object();
			keyObj.id_element = 0;
			keyObj.data = "SOS => koko";
			keyObj.type_element =  ActivityElementType.KEYWORD;
			var activityElement:ActivityElement = new ActivityElement(keyObj);
			var activity:Activity= this._activities.getItemAt(0) as Activity;
			if(activity == null)
			{
				Alert.show("You havn't activity","message error");
			}else
			{
				activity.getListActivityElement().addItem(activityElement);
			}
			var addActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY_ELEMENT);
			// keyword hasn't activity
			addActivityElement.activity = null;
			addActivityElement.activityElement = activityElement;
			this.dispatchEvent(addActivityElement);
			
			var keywordEdit:KeywordEdit = new KeywordEdit();
			keywordEdit.textKeyword = value;
			keywordEdit.activityElement = activityElement;
			keywordEdit.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteKeywordActivElement);
			keywordEdit.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateKeywordActivElement);
			keywordGroup.addElement(keywordEdit);
		}
		// delete keyword 
		private function onDeleteKeywordActivElement(event:SessionEditEvent):void
		{
			var deletingKeyword:ActivityElement = event.activityElement;				
			// delet activityElement from activity
			this.deleteActivityElement(deletingKeyword);
			// delete activityElement from keywordGroup
			var nbrElement:int = keywordGroup.numElements;
			
			for(var nElement:int =0; nElement < nbrElement; nElement++)
			{
				var documentEdit:KeywordEdit = keywordGroup.getElementAt(nElement) as KeywordEdit;
				if(documentEdit.activityElement.id_element == deletingKeyword.id_element)
				{
					keywordGroup.removeElementAt(nElement);
					var deletedActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.DELETE_ACTIVITY_ELEMENT);
					// keyword hasn't activity
					deletedActivityElement.activity = null;
					deletedActivityElement.activityElement = deletingKeyword;
					this.dispatchEvent(deletedActivityElement);
					return;
				}
			}
		}
		// update keyword
		private function onUpdateKeywordActivElement(event:SessionEditEvent):void
		{
			var updatedActivityElement:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_ACTIVITY_ELEMENT);
			// keyword hasn't activity
			updatedActivityElement.activity = null;
			updatedActivityElement.activityElement = event.activityElement;
			this.dispatchEvent(updatedActivityElement);
			
		}
// COMBOBOX ACTIVITY
/*		private function setLabelComboboxActivity(item:Object):String
		{
			var activity:Activity = item as Activity;
			if(activity != null)
			{
				return activity.title;
			}
			return "";
		}*/
		
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
			activity.ind = 0;
			_activities.addItemAt(activity,0);
			activitiesChanged = true;
			invalidateProperties();
			
			var addActivityEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_ACTIVITY);
			addActivityEvent.activity = activity;
			this.dispatchEvent(addActivityEvent);
		}
		
		public function onMouseClickButtonCreateSessionByTemplate(event:MouseEvent):void
		{
			var sessionAddEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.PRE_ADD_SESSION);
			this.dispatchEvent(sessionAddEvent);
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
					}
				}
				if(indexAr == -1)
				{
					Alert.show("You havn't activityElement in activity = "+activity.title,"message error");
				}else{
					arrActivityElement.removeItemAt(indexAr);
				}	
				
			}
		}		
	}
}