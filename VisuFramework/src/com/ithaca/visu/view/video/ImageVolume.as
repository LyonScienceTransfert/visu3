package com.ithaca.visu.view.video
{
	import com.ithaca.visu.events.ImageVolumeEvent;
	import com.ithaca.visu.events.VideoPanelEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	import mx.events.SliderEvent;
	
	import spark.components.HSlider;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TrackBaseEvent;
	
	public class ImageVolume extends SkinnableComponent
	{
		[SkinPart("true")]
		public var volumeSlider:HSlider;
		[SkinPart("true")]
		public var volumeImage:Image;
		[SkinPart("true")]
		public var muteImage:Image;
		
		
		private var mouseOver:Boolean = false;
		private var muteVolume:Boolean = false;
		private var muteVolumeChange:Boolean = false;
		private var _volume:Number;
		private var volumeChange:Boolean;
		// set volume slider enabled
		private var _volumeSliderEnabled:Boolean = true;
		private var volumeSliderEnabledChange:Boolean = false;
		
		
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
		public function set volumeSliderEnabled(value:Boolean):void
		{
			_volumeSliderEnabled = value;
			volumeSliderEnabledChange = true;
			invalidateProperties();
		}
		public function get volumeSliderEnabled():Boolean
		{
			return _volumeSliderEnabled ;
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
			
			if(volumeSlider.hasEventListener(FlexEvent.VALUE_COMMIT))
			{
				volumeSlider.removeEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
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
		private function onClickVolumeImage(event:MouseEvent):void
		{
			mute = true;
			var clickImageVolumeEvent:ImageVolumeEvent = new ImageVolumeEvent(ImageVolumeEvent.CLICK_IMAGE_VOLUME);
			clickImageVolumeEvent.mute = mute;
			dispatchEvent(clickImageVolumeEvent);
		}
		private function onClickMuteImage(event:MouseEvent):void
		{
			mute = false;
			var clickImageVolumeEvent:ImageVolumeEvent = new ImageVolumeEvent(ImageVolumeEvent.CLICK_IMAGE_VOLUME);
			clickImageVolumeEvent.mute = mute;
			dispatchEvent(clickImageVolumeEvent);
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == volumeImage)
			{
				if(!_volumeSliderEnabled)
				{
					volumeImage.addEventListener(MouseEvent.CLICK, onClickVolumeImage);
				}
			}
			if (instance == muteImage)
			{
				if(!_volumeSliderEnabled)
				{
					muteImage.addEventListener(MouseEvent.CLICK, onClickMuteImage);
				}
			}
			
			if (instance == volumeSlider)
			{
				var tempVolume:Number = volume;
				if(mute)
				{
					tempVolume = 0;	
				}
				
				if(_volumeSliderEnabled)
				{
					volumeSlider.includeInLayout = true;
					volumeSlider.visible = true;
					volumeSlider.value = volume;
					//volumeSlider.addEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
					volumeSlider.addEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
					volumeSlider.addEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
					volumeSlider.addEventListener(FlexEvent.CHANGE_END, onChangeEnd);
				}else
				{
					volumeSlider.includeInLayout = false;
					volumeSlider.visible = false;
					//volumeSlider.removeEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
					volumeSlider.removeEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
					volumeSlider.removeEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
					volumeSlider.removeEventListener(FlexEvent.CHANGE_END, onChangeEnd);
				}	
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(volumeChange)
			{
				volumeChange = false;
				if(volumeSlider != null && _volumeSliderEnabled)
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
/*					if(volumeSlider != null && _volumeSliderEnabled)
					{
						volumeSlider.removeEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
					}*/
					tempVolume = 0;	
				}else
				{
					tempVolume = volume;
				}
				if(volumeSlider != null && _volumeSliderEnabled)
				{
					volumeSlider.value = tempVolume;
				}
			}
			if(volumeSliderEnabledChange)
			{
				volumeSliderEnabledChange = false;
				if(volumeSlider != null)
				{
					if(_volumeSliderEnabled)
					{
						volumeSlider.includeInLayout = true;
						volumeSlider.visible = true;
						volumeSlider.value = volume;
						//volumeSlider.addEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
						volumeSlider.addEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
						volumeSlider.addEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
						volumeSlider.addEventListener(FlexEvent.CHANGE_END, onChangeEnd);
					}else
					{
						volumeSlider.includeInLayout = false;
						volumeSlider.visible = false;
					//	volumeSlider.removeEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
						volumeSlider.removeEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
						volumeSlider.removeEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
						volumeSlider.removeEventListener(FlexEvent.CHANGE_END, onChangeEnd);
					}	
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