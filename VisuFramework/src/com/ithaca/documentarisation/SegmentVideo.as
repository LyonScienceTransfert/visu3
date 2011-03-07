package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.view.ObselImage;
	
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
		[SkinState("editable")]
		
		[SkinPart("true")]
		public var dropInfoLabel:Label;
		
		[SkinPart("true")]
		public var timeWindowLabel:Label;

		[SkinPart("true")]
		public var numStepplerMinutBegin:NumericStepper;

		[SkinPart("true")]
		public var numStepplerSecondBegin:NumericStepper;
		
		[SkinPart("true")]
		public var numStepplerMinutEnd:NumericStepper;

		[SkinPart("true")]
		public var numStepplerSecondEnd:NumericStepper;
		
		private var empty:Boolean = true;
		private var editable:Boolean = true;
		private var currentTimeChange:Boolean;
		private var valueStepplersChange:Boolean;
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
		private var timeWindowLabelChange:Boolean;
		private var _startDateSession:Number;
		private var _deltaTime:Number = 5000;
		private var _currentTime:String = "";
		
		
		public function SegmentVideo()
		{
			super();
		}
		
		public function get deltaTime():Number {return _deltaTime;};
		public function set deltaTime(value:Number):void{_deltaTime = value;};
		public function get timeBegin():Number {return _timeBegin;};
		public function set timeBegin(value:Number):void
		{
			_timeBegin = value;
			timeWindowLabelChange = true;
			invalidateProperties();
		};
		public function get timeEnd():Number {return _timeEnd;};
		public function set timeEnd(value:Number):void
		{
			_timeEnd = value;
			timeWindowLabelChange = true;
			invalidateProperties();
		};
		public function set startDateSession(value:Number):void{_startDateSession = value;};
		public function get startDateSession():Number{return _startDateSession;};
		public function set currentTime(value:String):void{
			_currentTime = value;
			currentTimeChange = true;
			this.invalidateProperties();
		};
		public function get currentTime():String{return _currentTime;};
		public function setBeginEndTime():void
		{
			timeWindowLabelChange = true;
			invalidateProperties();	
		}
		public function updateNumStepplers():void
		{
			valueStepplersChange = true;
			invalidateProperties();				
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == timeWindowLabel)
			{
				timeWindowLabel.text = timeToString();
				timeWindowLabel.toolTip = timeToString();	
			}		
			if(instance == numStepplerMinutBegin)
			{
				numStepplerMinutBegin.value = this.timeToMinutes(this._timeBegin);
				setMinMaxStepplers();
				numStepplerMinutBegin.addEventListener(Event.CHANGE, onChangeStepplerMinuteBegin);
			}		
			if(instance == numStepplerSecondBegin)
			{
				numStepplerSecondBegin.value = this.timeToSeconds(this._timeBegin);
				setMinMaxStepplers();
				numStepplerSecondBegin.addEventListener(Event.CHANGE, onChangeStepplerSeconBegin);
			}		
			if(instance == numStepplerMinutEnd)
			{
				numStepplerMinutEnd.value = this.timeToMinutes(this._timeEnd);
				setMinMaxStepplers();
				numStepplerMinutEnd.addEventListener(Event.CHANGE, onChangeStepplerMinuteEnd);
			}		
			if(instance == numStepplerSecondEnd)
			{
				numStepplerSecondEnd.value = this.timeToSeconds(this._timeEnd);
				setMinMaxStepplers();
				numStepplerSecondEnd.addEventListener(Event.CHANGE, onChangeStepplerSecondEnd);
			}		
		}
		
		override protected function getCurrentSkinState():String
		{
			//return !enabled? "disabled" : empty? "empty" : "normal";
			if (!enabled)
			{
				return "disable";
			}else
				if(empty)
				{
					return "empty";
				}else
					if(editable)
					{
						return "editable";
					}else
					{
						return "normal";
					}
		}
		
		public function showDetail(value:Boolean):void
		{
			empty = value;
			this.invalidateSkinState();
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
			 if (timeWindowLabelChange)
			 {
				 timeWindowLabelChange = false;
				 if(timeWindowLabel != null)
				 {
					 timeWindowLabel.text = timeToString();
					 timeWindowLabel.toolTip = timeToString();
				 }
			 }
			 if(currentTimeChange)
			 {
				 currentTimeChange = false;
				
				 timeWindowLabel.text = this._currentTime; 
				 timeWindowLabel.toolTip = this._currentTime; 
			 }
			 if(valueStepplersChange)
			 {
				 valueStepplersChange = false;
				
				 numStepplerMinutBegin.value = this.timeToMinutes(this._timeBegin);
				 setMinMaxStepplers();
				 numStepplerSecondBegin.value = this.timeToSeconds(this._timeBegin);
				 setMinMaxStepplers();
				 numStepplerMinutEnd.value = this.timeToMinutes(this._timeEnd);
				 setMinMaxStepplers();
				 numStepplerSecondEnd.value = this.timeToSeconds(this._timeEnd);
				 setMinMaxStepplers();			 
			 }
			 
		 }
		 
		 private function onPlayButtonClick(event:MouseEvent):void
		 {
			 var playRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PLAY_RETRO_SEGMENT);
			 playRetroDocumentEvent.beginTime = this._timeBegin;
			 // TODO END TIME
			 this.dispatchEvent(playRetroDocumentEvent);
		 }
		 
		 private function timeToMinutes(value:Number):int
		 {
			 value = value - _startDateSession;
			 var result:int = value/60000;
			 return result;
		 }
		 
		 private function timeToSeconds(value:Number):int
		 {
			 value = value - _startDateSession;
			 var minutes:int = value/60000;
			 var result:int = (value - minutes*60000)/1000;
			 return result;
		 }
		 
		 private function timeToString():String
		 {
			 var timeStart:Number = this._timeBegin - _startDateSession;
			 var timeMin:int = timeStart/60000;
			 var timeMinString:String = timeMin.toString();
			 if(timeMin < 10){timeMinString = "0"+timeMinString;};
			 
			 var timeSec:int = (timeStart - timeMin*60000)/1000;
			 var timeSecString:String = timeSec.toString();
			 if(timeSec < 10){timeSecString= "0"+timeSecString;}
			 
			 var timeFrom:String = timeMinString+":"+timeSecString;
			 
			 var timeEnd:Number = this._timeEnd - _startDateSession;
			 var timeMinEnd:int = timeEnd/60000;
			 var timeMinEndString:String = timeMinEnd.toString();
			 if(timeMinEnd < 10){timeMinEndString = "0"+timeMinEndString;};
			 
			 var timeSecEnd:int = (timeEnd - timeMinEnd*60000)/1000;
			 var timeSecStringEnd:String = timeSecEnd.toString();
			 if(timeSecEnd < 10){timeSecStringEnd= "0"+timeSecStringEnd;}
			 
			 var timeTo:String = timeMinEndString+":"+timeSecStringEnd;

			 return "["+timeFrom+"-"+timeTo+"]";
		 }
		 
		 private function onChangeStepplerMinuteBegin(event:Event):void
		 {
			 var steppler:NumericStepper = event.currentTarget as NumericStepper;
			 var value:Number = steppler.value;
			 var oldValueMinutes:Number = timeToMinutes(this._timeBegin)*60000;
			 var newValueMinutes:Number = value*60000;
			 var diff:Number =  newValueMinutes - oldValueMinutes;
			 
			 this.numStepplerMinutEnd.minimum =  value;
			 
			 this._timeBegin =  this._timeBegin + diff;
			 // update border the seconds
			 updateBorderSeconds();
			 updateTimeBeginTimeEnd();
		 }
		 private function onChangeStepplerSeconBegin(event:Event):void
		 {
			 var steppler:NumericStepper = event.currentTarget as NumericStepper;
			 var value:Number = steppler.value;
			 var oldValueSeconds:Number = this.timeToSeconds(this._timeBegin)*1000;
			 var newValueSecond:Number = value*1000;
			 var diff:Number =  newValueSecond - oldValueSeconds;
			 this.numStepplerSecondEnd.minimum = value;
			 
			 this._timeBegin =  this._timeBegin + diff;
			 // update border the seconds
			 updateBorderSeconds();
			 updateTimeBeginTimeEnd();	 
		 }
		 
		 private function onChangeStepplerMinuteEnd(event:Event):void
		 {
			 var steppler:NumericStepper = event.currentTarget as NumericStepper;
			 var value:Number = steppler.value;
			 var oldValueMinutes:Number = timeToMinutes(this._timeEnd)*60000;
			 var newValueMinutes:Number = value*60000;
			 var diff:Number =  newValueMinutes - oldValueMinutes;

			 this.numStepplerMinutBegin.maximum =  value;

			 this._timeEnd =  this._timeEnd + diff;
			 // update border the seconds
			 updateBorderSeconds();
			 updateTimeBeginTimeEnd();
		 }
		 
		 private function onChangeStepplerSecondEnd(event:Event):void
		 {
			 var steppler:NumericStepper = event.currentTarget as NumericStepper;
			 var value:Number = steppler.value;
			 var oldValueSeconds:Number = this.timeToSeconds(this._timeEnd)*1000;
			 var newValueSecond:Number = value*1000;
			 var diff:Number =  newValueSecond - oldValueSeconds;
			 this.numStepplerSecondEnd.minimum = value;
			 
			 this._timeEnd =  this._timeEnd + diff;
			 // update border the seconds
			 updateBorderSeconds();
			 updateTimeBeginTimeEnd();		 
		 }
		 
		 private function updateTimeBeginTimeEnd():void
		 {
			 var updateTimeBeginTimeEndEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_TIME_BEGIN_TIME_END);
			 updateTimeBeginTimeEndEvent.beginTime = this._timeBegin;
			 updateTimeBeginTimeEndEvent.endTime = this._timeEnd;
			 this.dispatchEvent(updateTimeBeginTimeEndEvent);			 
		 }
		 // init minMaxStepplers
		 private function setMinMaxStepplers():void
		 {
			 if(this.numStepplerMinutBegin != null && this.numStepplerMinutEnd != null && this.numStepplerSecondBegin != null && this.numStepplerSecondEnd != null)
			 {
				 this.numStepplerMinutBegin.maximum = this.numStepplerMinutEnd.value;
				 this.numStepplerMinutEnd.minimum = this.numStepplerMinutBegin.value;
				 // update border the seconds
				 updateBorderSeconds();
			 }
		 }
		 private function updateBorderSeconds():void
		 {
			 if(this.numStepplerMinutBegin.value == this.numStepplerMinutEnd.value)
			 {
				 this.numStepplerSecondBegin.maximum = this.numStepplerSecondEnd.value;
				 this.numStepplerSecondEnd.minimum = this.numStepplerSecondBegin.value;
			 }else{
				 this.numStepplerSecondBegin.maximum = 60;
				 this.numStepplerSecondEnd.minimum = 0;
			 }
		 }
	}
}