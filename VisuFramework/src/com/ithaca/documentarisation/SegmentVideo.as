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
		public var labelMinutBegin:Label;

		[SkinPart("true")]
		public var numStepplerSecondBegin:NumericStepper;
		
		[SkinPart("true")]
		public var labelMinutEnd:Label;

		[SkinPart("true")]
		public var numStepplerSecondEnd:NumericStepper;
		
		private var empty:Boolean = true;
		private var editable:Boolean = true;
		private var valueStepplersChange:Boolean;
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
		private var timeWindowLabelChange:Boolean;
		private var _startDateSession:Number;
		private var _durationSession:Number;
		private var _deltaTime:Number = 5000;
				
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
		public function set durationSession(value:Number):void{_durationSession = value;};
		public function get durationSession():Number{return _durationSession;};

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
			if(instance == labelMinutBegin)
			{
				labelMinutBegin.text = this.timeToMinutes(this._timeBegin).toString();
			}		

			if(instance == numStepplerSecondBegin)
			{
				numStepplerSecondBegin.value = this.timeToSeconds(this._timeBegin);
				setMinMaxStepplers();
				numStepplerSecondBegin.addEventListener(Event.CHANGE, onChangeStepplerSeconBegin);
			}		
			
			if(instance == labelMinutEnd)
			{
				labelMinutEnd.text = this.timeToMinutes(this._timeEnd).toString();
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

			 if(valueStepplersChange)
			 {
				 valueStepplersChange = false;
				
				 labelMinutBegin.text = this.timeToMinutes(this._timeBegin).toString();

				 numStepplerSecondBegin.value = this.timeToSeconds(this._timeBegin);
				 setMinMaxStepplers();
				 
				 labelMinutEnd.text = this.timeToMinutes(this._timeEnd).toString();

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

		 private function onChangeStepplerSeconBegin(event:Event):void
		 {
			 var steppler:NumericStepper = event.currentTarget as NumericStepper;
			 var value:Number = steppler.value;
			 
			 switch (value)
			 {
				 case 60:
				 	steppler.value = 0; 
					this._timeBegin = this._timeBegin + 60000;
					break;
				 
				 case -1:
					if(int(this.labelMinutBegin.text) != 0 )
					{
					 	steppler.value = 59; 
						this._timeBegin = this._timeBegin - 60000;
					}else
					{
						steppler.value = 0; 
						return;
					}
					break;
			 }	
			 	 
			 var oldValueSeconds:Number = this.timeToSeconds(this._timeBegin)*1000;
			 var newValueSecond:Number = steppler.value*1000;
			 var diff:Number =  newValueSecond - oldValueSeconds;
			 
			 this._timeBegin =  this._timeBegin + diff;
			 labelMinutBegin.text = this.timeToMinutes(this._timeBegin).toString();
			 
			 // update border the seconds
			 updateBorderSeconds();
			 updateTimeBeginTimeEnd();	 
			 
		 }
		 
		 private function onChangeStepplerSecondEnd(event:Event):void
		 {
			 var steppler:NumericStepper = event.currentTarget as NumericStepper;
			 var value:Number = steppler.value;
			 var timeEndSession:Number = this._durationSession + this._startDateSession;

			 
			 switch (value)
			 {
				 case 60:
					 steppler.value = 0; 
					 this._timeEnd = this._timeEnd + 60000;
					 break;
				 
				 case -1:
					 steppler.value = 59; 
					 if(int(this.labelMinutEnd.text) != 0 )
					 {
						 this._timeEnd = this._timeEnd - 60000;
					 }
					 break;
			 }
					 
			 var oldValueSeconds:Number = this.timeToSeconds(this._timeEnd)*1000;
			 var newValueSecond:Number = steppler.value*1000;
			 var diff:Number =  newValueSecond - oldValueSeconds;
			 this._timeEnd =  this._timeEnd + diff;
			 labelMinutEnd.text = this.timeToMinutes(this._timeEnd).toString();
			 
			 var dif:Number = timeEndSession  - this._timeEnd;
			 if (dif < 0  ||  this._timeEnd == timeEndSession )
			 {
				 this._timeEnd = timeEndSession;
				 steppler.value = steppler.value - 1; 
				 return;
			 }
			 
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
			 if(this.numStepplerSecondBegin != null && this.numStepplerSecondEnd != null && this.labelMinutBegin != null && this.labelMinutEnd != null)
			 {
				 // update border the seconds
				 updateBorderSeconds();
			 }
		 }
		 private function updateBorderSeconds():void
		 {
			 if(this.labelMinutBegin.text == this.labelMinutEnd.text)
			 {
				 this.numStepplerSecondBegin.maximum = this.numStepplerSecondEnd.value;
				 this.numStepplerSecondEnd.minimum = this.numStepplerSecondBegin.value;
			 }else{
				 this.numStepplerSecondBegin.maximum = 60;
				 this.numStepplerSecondEnd.minimum = -1;
			 }
		 }
	}
}