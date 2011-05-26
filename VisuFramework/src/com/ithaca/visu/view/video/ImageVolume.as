package com.ithaca.visu.view.video
{
	import com.ithaca.visu.events.VideoPanelEvent;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.events.SliderEvent;
	
	import spark.components.HSlider;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ImageVolume extends SkinnableComponent
	{
		[SkinPart("true")]
		public var volumeSlider:HSlider;
		
		private var mouseOver:Boolean = false;
		private var muteVolume:Boolean = false;
		private var _volume:Number;
		private var volumeChange:Boolean;
		
		
		public function ImageVolume()
		{
			super();
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		public function set volume(value:Number):void
		{
			_volume = value;
			volumeChange = true;
			invalidateProperties();
		}
		public function get volume():Number
		{
			return _volume;
		}
		
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________

		private function onMouseOver(event:MouseEvent):void
		{
			mouseOver = true;
			invalidateSkinState();
		}

		private function onMouseOut(event:MouseEvent):void
		{
			mouseOver = false;
			invalidateSkinState();
		}
		private function onChangeVolume(event:FlexEvent):void
		{
			var hSlider:HSlider = event.currentTarget as HSlider;
			volume = hSlider.value;
			var volumeChange:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.CHANGE_VOLUME);
			volumeChange.volume = volume;
			dispatchEvent(volumeChange);
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == volumeSlider)
			{
				volumeSlider.value = volume;
				volumeSlider.addEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(volumeChange)
			{
				volumeChange = false;
				if(volumeSlider != null)
				{
					volumeSlider.value = volume;	
				}
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			var skinName:String;
			if(muteVolume)
			{
				skinName = "mute";
			}else
			{
				if(mouseOver)
				{
					skinName = "over"
				}else
				{
					skinName = "up"
				}
			}
			return skinName;
		}
	}
}