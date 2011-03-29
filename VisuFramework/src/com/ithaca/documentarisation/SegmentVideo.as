package com.ithaca.documentarisation
{
	import spark.components.Spinner;
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.view.ObselImage;
	import mx.logging.Log;
    import mx.logging.ILogger;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Label;
	import spark.components.NumericStepper;
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
		
		private var empty:Boolean = true;
		public var editable:Boolean = true;
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
				
		public function SegmentVideo()
		{
			super();
		}
		
		public function setNewBeginEnd(begin:Number, end:Number):void
		{
			_timeBegin = begin;
			_timeEnd = end;
			invalidateProperties();
		};
		public function get timeBegin():Number {return _timeBegin;};
		public function get timeEnd():Number {return _timeEnd;};

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == startSpinner)
				startSpinner.addEventListener(Event.CHANGE, onChange);
			else if(instance == endSpinner)
				endSpinner.addEventListener(Event.CHANGE, onChange);
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
			if(startSpinner != null && endSpinner != null) {
				// A hack to ensure that the spinner will not refrain
				// a new value to be set because of the other spinner's value 
				var newBegin:Number = Math.floor(_timeBegin / 1000);
				var newEnd:Number = Math.floor(_timeEnd / 1000);
				
				var setBeginValueFirst:Boolean = newBegin<=_timeEnd;
				
				logger.debug("Setting video segment (start,end) values from ({0},{1}) to ({2},{3}) - {4} first", 
					startSpinner.value,
					endSpinner.value,
					newBegin,
					newEnd,
					(setBeginValueFirst?"BEGIN":"END")
				);
				
				if(setBeginValueFirst) {
					startSpinner.value = newBegin;
					endSpinner.value = newEnd;
				} else {
					endSpinner.value = newEnd;
					startSpinner.value = newBegin;
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