package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.view.ObselImage;
	import com.lyon2.controls.utils.TimeUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.managers.DragManager;
	
	import spark.components.NumericStepper;
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