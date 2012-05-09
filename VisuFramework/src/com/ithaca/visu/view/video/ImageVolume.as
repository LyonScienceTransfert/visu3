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
package com.ithaca.visu.view.video
{
	import com.ithaca.visu.events.ImageVolumeEvent;
	import com.ithaca.visu.events.VideoPanelEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.HSlider;
	import spark.components.VSlider;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TrackBaseEvent;
	
	public class ImageVolume extends SkinnableComponent
	{
		[SkinPart("true")]
		public var volumeSlider:VSlider
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
			if(_volumeSliderEnabled)
			{
				volumeSlider.includeInLayout = true;
				volumeSlider.visible = true;
				volumeSlider.value = volume;
				//volumeSlider.addEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
				volumeSlider.addEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
				volumeSlider.addEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
				volumeSlider.addEventListener(FlexEvent.CHANGE_END, onChangeEnd);
			}		
		}

		private function onMouseOut(event:MouseEvent):void
		{
			if(volumeSlider)
			{
				volumeSlider.includeInLayout = false;
				volumeSlider.visible = false;
				//volumeSlider.removeEventListener(FlexEvent.VALUE_COMMIT, onChangeVolume);
				volumeSlider.removeEventListener(TrackBaseEvent.THUMB_PRESS , onPressThumb);
				volumeSlider.removeEventListener(TrackBaseEvent.THUMB_RELEASE , onReleaseThumb);
				volumeSlider.removeEventListener(FlexEvent.CHANGE_END, onChangeEnd);
			}	
		}
		
		private function onChangeVolume(event:FlexEvent):void
		{
			var vSlider:VSlider = event.currentTarget as VSlider;
			volume = vSlider.value;
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
			var vSlider:VSlider = event.currentTarget as VSlider;
			volume = vSlider.value;
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