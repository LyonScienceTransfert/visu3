package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.view.ObselImage;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SegmentVideo extends SkinnableComponent
	{
		[SkinState("empty")]
		[SkinState("normal")]
		
		[SkinPart("true")]
		public var dropInfoLabel:Label;
		
		[SkinPart("true")]
		public var timeWindowLabel:Label;

		[SkinPart("true")]
		public var screenShotImage:Image;
		
		[SkinPart("true")]
		public var playButton:Button;
		
		private var empty:Boolean = true;
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
		private var _sourceIcon:Object;
		private var timeWindowLabelChange:Boolean;
		private var screenShotImageChange:Boolean;
		private var _startDateSession:Number;
		private var _deltaTime:Number = 5000;
		
		public function SegmentVideo()
		{
			super();
		/*	this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);*/
		}
		
		public function get deltaTime():Number {return _deltaTime;};
		public function set deltaTime(value:Number):void{_deltaTime = value;};
		public function get timeBegin():Number {return _timeBegin;};
		public function set timeBegin(value:Number):void
		{
/*			if(value - _startDateSession > _deltaTime)
			{
				_timeBegin = value - _deltaTime ;
			}else
			{
				_timeBegin = _startDateSession;
			}
			// TODO timeEnd  by duration of the session 
			_timeEnd = value + _deltaTime;*/
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
		
		
		
		public function get sourceIcon():Object {return _sourceIcon;};
		public function set sourceIcon(value:Object):void
		{
			_sourceIcon = value;
			screenShotImageChange = true;
			invalidateProperties();
		};
		public function set startDateSession(value:Number):void{_startDateSession = value;};
		public function get startDateSession():Number{return _startDateSession;};

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == timeWindowLabel)
			{
				timeWindowLabel.text = timeToString();
				timeWindowLabel.toolTip = timeToString();
				playButton.enabled = true;
				playButton.toolTip = "Joue la vidéo correspondant à ce segment";		
			}	
			
			if(instance == screenShotImage)
			{
				screenShotImage.source = _sourceIcon;
			}	
			
			if(instance == playButton)
			{
				if(this._timeBegin == 0 )
				{
					playButton.enabled = false;
					playButton.toolTip = "Aucun segment vidéo associé actuellement";
				}
				else
				{
					playButton.toolTip = "Joue la vidéo correspondant à ce segment";					
				}
				playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClick);
				
			}	
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : empty? "empty" : "normal";
		}
		
		public function showDetail(value:Boolean):void
		{
			empty = value;
			this.invalidateSkinState();
		}
		 public function isEmpty():Boolean
		 {
			 return empty;
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
			 if(screenShotImageChange)
			 {
				 screenShotImageChange = false;
				 if(screenShotImage != null)
				 {
					 screenShotImage.source = _sourceIcon
				 }
			 }
			 
		 }
		 
		 private function onPlayButtonClick(event:MouseEvent):void
		 {
			 var playRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PLAY_RETRO_SEGMENT);
			 playRetroDocumentEvent.beginTime = this._timeBegin;
			 // TODO END TIME
			 this.dispatchEvent(playRetroDocumentEvent);
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
/*		private function onDragDrop(event:DragEvent):void
		{
			var viewObsel:ObselImage = event.dragInitiator as ObselImage;
			var obsel:Obsel = viewObsel.parentObsel;
			var timeBegin:String = obsel.begin.toString();
			_timeBegin = timeBegin;
			_sourceIcon = event.dragSource.dataForFormat("sourceIcon");
			_text = event.dragSource.dataForFormat("textObsel") as String;
			empty = false;
			this.invalidateSkinState();
			
		}
		private function onDragEnter(event:DragEvent):void
		{
			if(event.dragSource.hasFormat("obsel"))
			{	
				var vsl:SegmentVideo = event.currentTarget as SegmentVideo;
				DragManager.acceptDragDrop(vsl);
			}	
		}*/
	}
}