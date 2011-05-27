package com.ithaca.visu.view.video
{
	import com.ithaca.visu.events.VideoPanelEvent;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.events.SliderEvent;
	
	import spark.components.HSlider;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TrackBaseEvent;
	
	public class ImageVolume extends SkinnableComponent
	{
		[SkinPart("true")]
		public var volumeSlider:HSlider;
		
		private var mouseOver:Boolean = false;
		private var muteVolume:Boolean = false;
		private var muteVolumeChange:Boolean = false;
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
		public function set mute(value:Boolean):void
		{
			//unMute only if volume > 0
			if(volume == 0 && value == false)
			{
				return;
			}

			muteVolume = value;
			invalidateSkinState();
			
			muteVolumeChange = true;
			invalidateProperties();
		}
		public function get mute():Boolean
		{
			return muteVolume ;
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
			
			if(mute)
			{
				mute = false;
			}
		}
		private function onPressThumb(event:TrackBaseEvent):void
		{
			if(!volumeSlider.hasEventListener(FlexEvent.VALUE_COMMIT))
			{
				volumeSlider.addEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
			}
		}
		private function onReleaseThumb(event:TrackBaseEvent):void
		{
			if(volume == 0)
			{
				this.mute = true;	
			}
		}
		private function onChangeEnd(event:FlexEvent):void
		{
			var hSlider:HSlider = event.currentTarget as HSlider;
			volume = hSlider.value;
			var volumeChange:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.CHANGE_VOLUME);
			volumeChange.volume = volume;
			dispatchEvent(volumeChange);
			
			if(volume == 0)
			{
				this.mute = true;	
			}else
			{
				this.mute = false;	
			}
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
				var tempVolume:Number = volume;
				if(mute)
				{
					tempVolume = 0;	
				}
				volumeSlider.value = tempVolume;
				volumeSlider.addEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
				volumeSlider.addEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
				volumeSlider.addEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
				volumeSlider.addEventListener(FlexEvent.CHANGE_END, onChangeEnd);
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
			if(muteVolumeChange)
			{
				muteVolumeChange = false;
				var tempVolume:Number = volume;
				if(mute)
				{
					if(volumeSlider != null)
					{
						volumeSlider.removeEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
					}
					tempVolume = 0;	
				}else
				{
					tempVolume = volume;
				}
				if(volumeSlider != null)
				{
					volumeSlider.value = tempVolume;
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