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
package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.controls.sessions.skins.KeywordSkin;
	import com.ithaca.visu.events.ActivityElementEvent;
	import com.ithaca.visu.events.VisuActivityEvent;
	import com.ithaca.visu.model.Activity;
	import com.ithaca.visu.model.ActivityElement;
	import com.ithaca.visu.model.ActivityElementType;
	import com.lyon2.controls.VisuVisio;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Image;
	import mx.core.FlexLoader;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	[Event(name="shareElement",type="com.ithaca.visu.events.ActivityElementEvent")]
	[Event(name="startActivity",type="com.ithaca.visu.events.VisuActivityEvent")]
	
	public class SessionPlanB extends SkinnableContainer
	{
		
		[SkinPart("true")] 
		public var activityGroup:Group;
		
		private var _activities:IList;
		protected var activitiesChanged:Boolean;
		
		public var session_id:int;
		
		private var _sessionStatus:int = VisuVisio.STATUS_NONE;
		protected var sessionStatusChanged:Boolean;
		
		private var _currentActivityId:int = 0;
		protected var currentActivityChanged:Boolean;
		
		[Bindable]
		private var fxgt: _FxGettext = FxGettext;
		
		public function SessionPlanB()
		{
			super();
			_activities = new ArrayList();	
			fxgt = FxGettext;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(sessionStatusChanged)
			{
				sessionStatusChanged = false; 
				var enabledStartButton:Boolean = false;
				if (this._sessionStatus == 1)
				{
					enabledStartButton = true;
				}
				var nbrElements:int = this.numElements;
				for(var nElement:int = 0 ; nElement < nbrElements ; nElement++)
				{
					var element = this.getElementAt(nElement);
					if(element is ActivityDetailB)
					{
						var a:ActivityDetailB = this.getElementAt(nElement) as ActivityDetailB;
						a.startButton.visible = enabledStartButton;
						checkCurrentActivity(a);
					}
				}
			}
			if(currentActivityChanged)
			{
				currentActivityChanged = false;
				
				var nbrElements:int = this.numElements;
				for(var nElement:int = 0 ; nElement < nbrElements ; nElement++)
				{
					var element = this.getElementAt(nElement);
					if(element is ActivityDetailB)
					{
						var activityDetail:ActivityDetailB = this.getElementAt(nElement) as ActivityDetailB;
						checkCurrentActivity(activityDetail);
					}
				}
			}
			if (activitiesChanged)
			{
				activitiesChanged = false;
				
				removeAllElements();
				
				for each (var activity:Activity in _activities)
				{
					var a:ActivityDetailB =  new ActivityDetailB();
					a.activity = activity;
					a.percentWidth = 100;
					a.addEventListener(MouseEvent.DOUBLE_CLICK, shareActivityElement);
					a.addEventListener(FlexEvent.CREATION_COMPLETE, onAddedActivityDetailOnStage);
					addElement( a );
				}
			}
		}
		
		private function onAddedActivityDetailOnStage(event:FlexEvent):void
		{		
			var activityDetail:ActivityDetailB = event.currentTarget as ActivityDetailB;
			activityDetail.removeEventListener(FlexEvent.CREATION_COMPLETE, onAddedActivityDetailOnStage);
			if (this._sessionStatus == VisuVisio.STATUS_NONE)
			{
				activityDetail.startButton.visible = false;
			}else
			{
				checkCurrentActivity(activityDetail);
			}
		}
		
		private function checkCurrentActivity(activityDetail:ActivityDetailB):void
		{
			if(activityDetail.activity.id_activity == _currentActivityId)
			{
				activityDetail.startButton.enabled = false;
				activityDetail.startButton.label = fxgt.gettext("En cours");
			}else
			{
				activityDetail.startButton.enabled = true;	
				activityDetail.startButton.label = fxgt.gettext("Démarrer");
			}	
		}
		
		public function getActivityDetailById(value:int):ActivityDetailB
		{
			var nbrElements:int = this.numElements;
			for(var nElement:int = 0 ; nElement < nbrElements ; nElement++)
			{
				var element = this.getElementAt(nElement);
				if(element is ActivityDetailB)
				{
					var activityDetail:ActivityDetailB = this.getElementAt(nElement) as ActivityDetailB;
					var activityId:int = activityDetail.activity.id_activity;
					if(value == activityId)
					{
						return activityDetail;
					}
				}
			} 
			return null;
		}
		
		public function getCurrentActivityId():int{return this._currentActivityId;}
		public function setCurrentActivityId(value:int):void
		{
			if(value != 0)
			{
				_currentActivityId = value;			
			}
			currentActivityChanged = true;
			invalidateProperties();
		}
		
		public function setSessionStatus(value:int):void
		{
			_sessionStatus = value;
			// if stop recording(value == 0) than update currentActivity to 0
			if(value == VisuVisio.STATUS_NONE)
			{
				_currentActivityId = 0;	
				currentActivityChanged = true;
			}
			sessionStatusChanged = true;
			invalidateProperties();
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
			
			dispatchEvent( new Event("updateActivities")); 
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET);
			_activities.dispatchEvent(event);
			
		}
		
		
		protected function activities_ChangeHandler(event:CollectionEvent):void
		{
			activitiesChanged = true;
			invalidateProperties();
		}	
		
		protected function shareActivityElement(event:MouseEvent):void
		{
			trace("shareActivityElement");
			if( !(event.target is ActivityElementDetail  || event.target is FlexLoader )) return;
			var e:ActivityElementEvent = new ActivityElementEvent(ActivityElementEvent.SHARE_ELEMENT);
			if (event.target is ActivityElementDetail)
			{
				e.element = ActivityElementDetail(event.target).activityElement;
			}else
			{
				var flLoader:FlexLoader = event.target as FlexLoader;
				var imageActivity:ImageActivity=  flLoader.parent as ImageActivity;
				e.element = imageActivity.activityElement;
			}
			dispatchEvent(e);
		}
		
	}
}