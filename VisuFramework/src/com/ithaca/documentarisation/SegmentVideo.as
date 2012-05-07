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
package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.lyon2.controls.utils.TimeUtils;
	
	import flash.events.Event;
	
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Spinner;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SegmentVideo extends SkinnableComponent
	{
		[SkinState("empty")]
		[SkinState("normal")]
		[SkinState("read")]
		
		private static var logger:ILogger = Log.getLogger("com.ithaca.documentarisation.SegmentVideo");
	
		[SkinPart("true")]
		public var startSpinner:Spinner;
		
		[SkinPart("true")]
		public var endSpinner:Spinner;
		
		[SkinPart("true")]
		public var labelStartSpinner:Label;
		[SkinPart("true")]
		public var labelEndSpinner:Label;
		
		private var empty:Boolean = true;
		public var editable:Boolean = true;
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
		
		private var timeSegmentChange:Boolean;
				
		public function SegmentVideo()
		{
			super();
		}
		
		public function setNewBeginEnd(begin:Number, end:Number):void
		{
			_timeBegin = begin;
			_timeEnd = end;
			timeSegmentChange = true;
			invalidateProperties();
		};
		public function get timeBegin():Number {return _timeBegin;};
		public function get timeEnd():Number {return _timeEnd;};

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == startSpinner)
			{
				startSpinner.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletStartSpinner);
				startSpinner.addEventListener(Event.CHANGE, onChange);
			}
			if(instance == endSpinner)
			{
				endSpinner.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletEndSpinner);
				endSpinner.addEventListener(Event.CHANGE, onChange);
			}
			if(instance == labelStartSpinner)
			{
				labelStartSpinner.text = TimeUtils.formatTimeString(Math.floor(_timeBegin / 1000)); 
			}
			if(instance == labelEndSpinner)
			{
				labelEndSpinner.text = TimeUtils.formatTimeString(Math.floor(_timeEnd / 1000)); 
			}
		}
		
		private function onCreationCompletStartSpinner(event:FlexEvent):void
		{
			startSpinner.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletStartSpinner);
			startSpinner.value = Math.floor(_timeBegin / 1000);
			startSpinner.maximum = Math.floor(_timeEnd / 1000);
		}
		private function onCreationCompletEndSpinner(event:FlexEvent):void
		{
			endSpinner.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletEndSpinner);
			endSpinner.value = Math.floor(_timeEnd / 1000);
			endSpinner.minimum = Math.floor(_timeBegin / 1000);
		}
		
		override protected function getCurrentSkinState():String
		{
			var state:String = empty ? "empty" : editable ? "normal":"read";
			logger.debug("Current skin state of the segment video is {0}", state)
			return state;
		}
		
		/*
		 * Set the state to empty
		 */
		public function showDetail(value:Boolean):void
		{
			empty = value;
			this.invalidateSkinState();
		}
		 public function isEmpty():Boolean
		 {
			 return empty;
		 }
		 
		 public function setEditable(value:Boolean):void
		 {
			editable = value;
			this.invalidateSkinState();
		 }
		
		 override protected function commitProperties():void
		 {
			super.commitProperties();
			if(timeSegmentChange)
			{
				timeSegmentChange = false;
				
				var newBegin:Number = Math.floor(_timeBegin / 1000);
				var newEnd:Number = Math.floor(_timeEnd / 1000);

				if(startSpinner != null)
				{
					startSpinner.value = newBegin;
					startSpinner.maximum = newEnd;
					
				}
				if(endSpinner != null)
				{
					endSpinner.value = newEnd;
					endSpinner.minimum = newBegin;
				}
				if(labelStartSpinner != null)
				{
					labelStartSpinner.text  = TimeUtils.formatTimeString(newBegin); 
				}
				if(labelEndSpinner != null)
				{
					labelEndSpinner.text  = TimeUtils.formatTimeString(newEnd); 
				}
			}
		 }
		 
		 private function onChange(event:Event):void
		 {
		 	
			logger.debug("Video segment boundns changed from ({0},{1}) to ({2},{3})", 
							this._timeBegin,
							this._timeEnd,
							startSpinner.value * 1000,
							endSpinner.value * 1000
							);
			this._timeBegin = startSpinner.value * 1000; 
			this._timeEnd = endSpinner.value * 1000; 
			timeSegmentChange = true;
			invalidateProperties();
			
			updateTimeBeginTimeEnd();	
			 
		 }
		 
		 private function updateTimeBeginTimeEnd():void
		 {
			 var updateTimeBeginTimeEndEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_TIME_BEGIN_TIME_END);
			 updateTimeBeginTimeEndEvent.beginTime = this._timeBegin;
			 updateTimeBeginTimeEndEvent.endTime = this._timeEnd;
			 this.dispatchEvent(updateTimeBeginTimeEndEvent);			 
		 }
	}
}