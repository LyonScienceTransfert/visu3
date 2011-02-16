package com.ithaca.documentarisation
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.view.ObselImage;
	
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
		
		private var empty:Boolean = true;
		private var _timeBegin:String="";
		private var _sourceIcon:Object;
		
		public function SegmentVideo()
		{
			super();
		/*	this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);*/
		}
		
		public function get timeBigin():String {return _timeBegin;};
		public function set timeBigin(value:String):void{_timeBegin = value;};
		
		public function get sourceIcon():Object {return _sourceIcon;};
		public function set sourceIcon(value:Object):void
		{
			_sourceIcon = value; 
		};

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == timeWindowLabel)
			{
				timeWindowLabel.text = _timeBegin;
				timeWindowLabel.toolTip = _timeBegin;
			}	
			
			if(instance == screenShotImage)
			{
				screenShotImage.source = _sourceIcon
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