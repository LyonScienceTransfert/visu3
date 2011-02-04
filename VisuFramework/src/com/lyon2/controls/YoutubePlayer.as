/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
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
package com.lyon2.controls
{
	
	import com.ithaca.visu.interfaces.IDocument;
	import com.youtube.player.YoutubeVideo;
	import com.youtube.player.constants.PlayerStateCode;
	import com.youtube.player.events.PlaybackQualityEvent;
	import com.youtube.player.events.PlayerEvent;
	import com.youtube.player.events.PlayerSharedEvent;
	import com.youtube.player.events.PlayerStateEvent;
	import com.youtube.player.events.SimpleVideoEvent;
	import com.youtube.player.events.VideoErrorEvent;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.container.ScrollPolicy;
	
	import mx.core.UIComponent;
	import mx.events.SliderEvent;
	import mx.utils.URLUtil;

	[Event(name="onReady",type="com.youtube.player.events.PlayerEvent")]

	[Event(name="playerStateChangeEvent",type="com.youtube.player.events.PlayerStateEvent")]
	// shared events
	[Event(name="shared",type="com.youtube.player.events.PlayerSharedEvent")]
	
	public class YoutubePlayer extends UIComponent  implements IDocument
	{
		public static const playerURL:String = "http://www.youtube.com/apiplayer?version=3";
		
		private var _ready:Boolean;
		private var _playing:Boolean = false;
		private var _url:String;
		private var urlChanged:Boolean;
		private var videoID:String;
		private var durationInitialized:Boolean;
	
		private var senderId:int;	
		private var _idDocument:Number;	
		
		protected var video:YoutubeVideo
		protected var controlBar:VideoControlBar;
		
		protected var default_width:Number = 200;
		protected var default_height:Number = 150;
		
		public function YoutubePlayer()
		{

 		}
		
		public function setSenderId(value:int):void
		{
			this.senderId = value;
		}
		
		public function getSenderId():int
		{
			return this.senderId;
		}
		
		public function setIdDocument(value:Number):void
		{
			this._idDocument = value;
		}
		
		public function getIdDocument():Number
		{
			return this._idDocument;
		}
		
		public function isPlaying():Boolean
		{
			return this._playing;
		}
		 
		public function getCurrentTime():Number
		{
			return controlBar.playHeadSlider.value;
		}
		/**
		 * 
		 * UIComponents Overriden Methods
		 * 
		 */		
		override protected function createChildren():void
		{
			if( video==null )
			{
				video = new YoutubeVideo();	
				video.addEventListener(PlayerStateEvent.PLAYER_STATE_CHANGE, onPlayerStateChange);
				video.addEventListener(VideoErrorEvent.VIDEO_ERROR, onVideoError);
				video.addEventListener(PlaybackQualityEvent.PLAYBACK_QUALITY_CHANGE, onPlaybackQualityChange);
			}
			addChild( video );
			if( controlBar==null)
			{
				controlBar = new VideoControlBar();
				controlBar.enabled = false;
				controlBar.horizontalScrollPolicy =  ScrollPolicy.OFF;
			}
			addChild( controlBar );
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if( urlChanged && _ready)
			{
				urlChanged = false;
				video.cueVideoById(videoID);
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			var w:Number = getExplicitOrMeasuredWidth() || default_width;
			var h:Number = getExplicitOrMeasuredHeight() || default_height;
			if( _ready )
			{				
				if( w > h )
				{
					//Paysage
					measuredWidth = w;
					measuredHeight = w*3/4;
				}
				else
				{
					//Portrait - carré
					measuredHeight = h;			
					measuredWidth = h*4/3;
				}
			}
			measuredHeight += controlBar.height;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0x000000);
			g.drawRect(0,0,unscaledWidth,unscaledHeight);
			g.endFill();
			if( _ready )
			{
				var w:Number = unscaledWidth;
				var h:Number = unscaledHeight - controlBar.getExplicitOrMeasuredHeight();
				var ph:Number;
				var pw:Number;
				
				if( w/h > 4/3 )
				{
					ph = h;			
					pw = ph*4/3;
				}
				else
				{
					pw = w;
					ph = w*3/4;
				}
				video.setSize(pw,ph);
				video.x = (w - pw)/2 
				video.y = (h - ph)/2 
				
				
			}
			controlBar.setActualSize(unscaledWidth,controlBar.getExplicitOrMeasuredHeight());
			controlBar.move(0,unscaledHeight-controlBar.getExplicitOrMeasuredHeight());
		}
		
		

		protected function initControlBarEvent():void
		{
			controlBar.playButton.addEventListener(MouseEvent.CLICK, playClickHandler);
			controlBar.soundButton.addEventListener(MouseEvent.CLICK, soundClickHandler);
			
			controlBar.playHeadSlider.addEventListener(SliderEvent.CHANGE, playHeadSliderChange);
			controlBar.playHeadSlider.addEventListener(SliderEvent.THUMB_DRAG, playHeadSliderThumbDrag);
			controlBar.playHeadSlider.addEventListener(SliderEvent.THUMB_PRESS, playHeadSliderThumbPress);
			controlBar.playHeadSlider.addEventListener(SliderEvent.THUMB_RELEASE, playHeadSliderThumbRelease);
			
			/*controlBar.soundSlider.addEventListener(SliderEvent.CHANGE, soundSliderChange);
			controlBar.soundSlider.addEventListener(SliderEvent.THUMB_DRAG, soundSliderChange);*/
		}
		protected function initControlBarData():void
		{
			controlBar.enabled = true;
		}
					
		/**
		 * 
		 * Youtube apiplayer event handlers
		 * 
		 */
		 
		 

		protected function onVideoError(event:VideoErrorEvent):void
		{
		    trace("player error:", event.errorCode," - ",event.error );
		}
			
		protected function onPlayerStateChange(event:PlayerStateEvent):void 
		{
		    trace("player state change : " , event.stateCode,"-",event.state);
			//     
		    switch(event.stateCode)
		    {
		    	case PlayerStateCode.READY:
		    		setReady(true);
		    		initControlBarEvent();
		    		dispatchEvent( new PlayerEvent( PlayerEvent.READY) );
					invalidateSize();
					invalidateDisplayList();
					// add listener for the first click on the player, 
					// FIXME : didn't find more easy way for dispatch event the first action play
					video.getLoader().content.addEventListener(MouseEvent.CLICK, onLoaderFirstClick);
		    		break;
		    	case PlayerStateCode.PLAYING:
		    		video.addEventListener(SimpleVideoEvent.PLAYHEAD_UPDATE, onPlayHeadUpdate);
					if( !durationInitialized )
					{
						durationInitialized = true;
						controlBar.duration = video.duration;
						controlBar.playButton.selected = true;
					}
		    		break;
		    	case PlayerStateCode.PAUSED:			    	
					break;
				case PlayerStateCode.ENDED:
					var playerSharedEvent:PlayerSharedEvent = new PlayerSharedEvent(PlayerSharedEvent.SHARED);
					playerSharedEvent.currentTime = controlBar.playHeadSlider.value;	
					playerSharedEvent.action = PlayerSharedEvent.END;
					dispatchEvent(playerSharedEvent);
					controlBar.playButton.selected = false;
					_playing = false;
					break;
				case PlayerStateCode.VIDEO_CUED:
					invalidateSize();
					invalidateDisplayList();
					initControlBarData();
					break;
				case PlayerStateCode.UNSTARTED:
					break;
				case PlayerStateCode.BUFFERING:
					break;
		    }
		    dispatchEvent( event.clone() );
		}
		
		protected function onPlaybackQualityChange(event:PlaybackQualityEvent):void 
		{
		    // Event.data contains the event parameter, which is the new video quality
		    trace("video quality:", event.quality);
		}
		
		
		
		protected function onPlayHeadUpdate(event:SimpleVideoEvent):void
		{
			controlBar.playHeadTime = video.currentTime;
		}
		
		/**
		 * 
		 * ControlBar Event Handler
		 * 
		 */
		protected function playClickHandler(event:MouseEvent):void
		{
			//Play			
			trace("click handler " , controlBar.playButton.selected  );	
			var playerSharedEvent:PlayerSharedEvent = new PlayerSharedEvent(PlayerSharedEvent.SHARED);
			playerSharedEvent.currentTime = controlBar.playHeadSlider.value;
			if( controlBar.playButton.selected )
			{
				video.playVideo();
				playerSharedEvent.action = PlayerSharedEvent.PLAY;
				// remove listener MouseEvent.CLICK if don't remove yet
				if(video.getLoader().content.hasEventListener(MouseEvent.CLICK))
				{
					video.getLoader().content.removeEventListener(MouseEvent.CLICK, onLoaderFirstClick); 
				}	
				_playing = true;
			}
			else
			{
				video.pauseVideo();
				playerSharedEvent.action = PlayerSharedEvent.PAUSE;
				_playing = false;
			}
			this.dispatchEvent(playerSharedEvent);
		}
		
		/**
		 * listener the first click, play video 
		 */
		private function onLoaderFirstClick(event:MouseEvent):void
		{
			if(video.getLoader().content.hasEventListener(MouseEvent.CLICK))
			{
				// dispatch event 
				var playerSharedEvent:PlayerSharedEvent = new PlayerSharedEvent(PlayerSharedEvent.SHARED);
				playerSharedEvent.currentTime = controlBar.playHeadSlider.value;
				playerSharedEvent.action = PlayerSharedEvent.PLAY;
				this.dispatchEvent(playerSharedEvent);
				// remove listener 
				video.getLoader().content.removeEventListener(MouseEvent.CLICK, onLoaderFirstClick); 
			}
			_playing = true;
		}
		
		protected function soundClickHandler(event:MouseEvent):void
		{
			//toggleSound 
			controlBar.soundButton.selected = video.isMuted();
			if( controlBar.soundButton.selected )
			{
				video.unMute();
				video.volume = controlBar.soundSlider.value;
			}
			else
			{
				video.mute();
			}
		}
		protected function playHeadSliderThumbPress(event:SliderEvent):void
		{
			trace("Slider thumb Press");
/*			video.removeEventListener(SimpleVideoEvent.PLAYHEAD_UPDATE, onPlayHeadUpdate);
			var playerSharedEvent:PlayerSharedEvent = new PlayerSharedEvent(PlayerSharedEvent.SHARED);
			playerSharedEvent.currentTime = event.value;
			playerSharedEvent.action = PlayerSharedEvent.SLIDER_PRESS;
			this.dispatchEvent(playerSharedEvent);*/		
		}
		protected function playHeadSliderThumbRelease(event:SliderEvent):void
		{
			trace("Slider thumb Release");
			var playerSharedEvent:PlayerSharedEvent = new PlayerSharedEvent(PlayerSharedEvent.SHARED);
			playerSharedEvent.currentTime = event.value;
			playerSharedEvent.action = PlayerSharedEvent.SLIDER_RELEASE;
			this.dispatchEvent(playerSharedEvent);
			video.seekTo(event.value);
			controlBar.playHeadTime = event.value;
			this.pauseVideo()
			// simulation the first click on play button 
			onLoaderFirstClick(new MouseEvent(MouseEvent.CLICK));
		}
		protected function playHeadSliderThumbDrag(event:SliderEvent):void
		{
			trace("Slider thumb Drag");
			controlBar.playHeadTime = event.value;
			
		}
		protected function playHeadSliderChange(event:SliderEvent):void
		{
			trace("SliderChange");
		}

		protected function soundSliderChange(event:SliderEvent):void
		{
			video.volume = event.value;
		}

	 	/**
	 	 * 
	 	 * Getter / setter
	 	 * 
	 	 */
	 	[Bindable(event="readyChanged")]
	 	public function get ready():Boolean{return _ready;}
	 	private function setReady(value:Boolean):void
	 	{
	 		if( _ready != value)
	 		{
	 			_ready = value;
	 			invalidateProperties();
	 			invalidateDisplayList();	
	 			dispatchEvent( new Event("readyChanged"));
	 		}
	 	}
	 	[Bindable(event="urlChanged")]
	 	public function get url():String{return _url;}
	 	public function set url(value:String):void
	 	{
	 		if( _url != value)
	 		{		
	 			videoID = getVideoId( value);
				if(videoID == null)
				{
					var errorPropertyAdresseEvent:PlayerEvent = new PlayerEvent(PlayerEvent.ERROR_PROPERTY_ADRESSE);
		 			dispatchEvent(errorPropertyAdresseEvent);					
				}else
				{
					_url = value;
					urlChanged = true;
		 			invalidateProperties();
		 			dispatchEvent( new Event("urlChanged"));
				}
	 		}
	 	}
	 	
	 	public function destroy():void
	 	{
	 		video.removeEventListener(PlayerStateEvent.PLAYER_STATE_CHANGE, onPlayerStateChange);
			video.removeEventListener(VideoErrorEvent.VIDEO_ERROR, onVideoError);
			video.removeEventListener(PlaybackQualityEvent.PLAYBACK_QUALITY_CHANGE, onPlaybackQualityChange);
	 		video.destroy();
	 	}
	 	public function stopVideo():void
	 	{
	 		video.stopVideo();
	 		controlBar.playHeadSlider.value = 0;
			_playing = false;
	 	}
		
		/**
		 *  pause video 
		 */
	 	public function pauseVideo():void
	 	{
	 		video.pauseVideo();
			controlBar.playButton.selected = false;
			_playing = false;
	 	}
		
		/**
		 *  play video 
		 */
	 	public function playVideo():void
	 	{
	 		video.playVideo();
			controlBar.playButton.selected = true;
			_playing = true;
	 	}
	 	
	 	/**
	 	 * 
	 	 * Youtube utils
	 	 * 
	 	 */
	 	protected function getVideoId(value:String):String
	 	{
	 		var ar:Array=value.split('?');
	 		if(ar.length==2)
	 		{
		 		var params:Object = URLUtil.stringToObject(ar[1],"&");		 		
		 		if( params.hasOwnProperty("v"))
	 			{
	 				return params.v;
	 			}
	 		}
 			return null;
	 	}
	}
}
