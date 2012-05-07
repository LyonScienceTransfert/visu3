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
	import com.ithaca.visu.traces.TracageEventDispatcherFactory;
	import com.ithaca.visu.traces.events.TracageEvent;
	import com.ithaca.traces.model.RetroTraceModel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.utils.components.IconButton;
	import com.ithaca.visu.events.VideoPanelEvent;
	import com.ithaca.visu.model.User;
	import com.lyon2.controls.VideoComponent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import gnu.as3.gettext._FxGettext;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.Panel;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class VideoPanel extends SkinnableComponent
	{
		[SkinPart("true")]
		public var videoUser:VideoComponent;
		[SkinPart("true")]
		public var groupButtonTop:HGroup;

		[SkinPart("true")]
		public var buttonChat:Button;
		[SkinPart("true")]
		public var buttonMarker:Button;
		[SkinPart("true")]
		public var buttonZoom:Button;
		[SkinPart("true")]
		public var buttonComment:Button;

		[SkinPart("true")]
		public var buttonVolumeUserZoomOut:ImageVolume;
		[SkinPart("true")]
		public var labelUserZoomOut:NameUser;
		
		private var _zoom:Boolean;
		private var mouseOver:Boolean;
		private var _streamId:String;
		private var _stream:NetStream;
		private var streamChange:Boolean;
		private var _camera:Camera;
		private var cameraChange:Boolean;
		private var _ownerFluxVideo:User;
		private var ownerFluxVideoChange:Boolean;
		// volume of the stream
		private var _volume:Number;
		private var volumeChange:Boolean;
		// volume mute
		private var _volumeMute:Boolean;
		private var volumeMuteChange:Boolean
		// properties :
		// status of the stream video
		private var _status:int;
		private var statusChange:Boolean;
		// enabled chat buttons
		private var _buttonChatEnabled:Boolean = false;
		private var buttonChatEnabledChange:Boolean = false;
		// enabled marker buttons
		private var _buttonMarkerEnabled:Boolean = false
		private var buttonMarkerEnabledChange:Boolean = false;
		// enabled comment buttons
		private var _buttonCommentEnabled:Boolean = false
		private var buttonCommentEnabledChange:Boolean = false;
		// logged user
		private var _loggedUser:User;
		private var loggedUserChange:Boolean = false;

		
		
		public function VideoPanel()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________

		public function set zoomIn(value:Boolean):void
		{
			_zoom = value;
			mouseOver = false;
			invalidateSkinState();
		}
		public function get zoomIn():Boolean
		{
			return this._zoom;
		}
		
		public function set txt(value:String):void
		{
			_streamId = value;
		}
		public function set status(value:int):void
		{
			_status = value;
			statusChange = true;
			invalidateProperties();
		}
		public function get status():int
		{
			return _status;
		}
		public function set attachNetStream(value:NetStream):void
		{
			_stream = value;
			streamChange = true;
			invalidateProperties();
		}
		public function get attachNetStream():NetStream
		{
			return _stream;
		}
		public function set attachCamera(value:Camera):void
		{
			_camera = value;
			cameraChange = true;
			invalidateProperties();
		}
		public function get attachCamera():Camera
		{
			return _camera;
		}
		public function set ownerFluxVideo(value:User):void
		{
			_ownerFluxVideo = value;
			ownerFluxVideoChange = true;
			invalidateProperties();
		}
		public function get ownerFluxVideo():User
		{
			return _ownerFluxVideo;
		}
		public function set buttonChatEnabled(value:Boolean):void
		{
			_buttonChatEnabled = value;
			buttonChatEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonChatEnabled():Boolean
		{
			return _buttonChatEnabled;
		}
		public function set buttonMarkerEnabled(value:Boolean):void
		{
			_buttonMarkerEnabled = value;
			buttonMarkerEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonCommentEnabled():Boolean
		{
			return _buttonCommentEnabled;
		}
		public function set buttonCommentEnabled(value:Boolean):void
		{
			_buttonCommentEnabled = value;
			buttonCommentEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonMarkerEnabled():Boolean
		{
			return _buttonMarkerEnabled;
		}
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
			_volumeMute = value;
			volumeMuteChange = true;
			invalidateProperties();
		}
		public function get mute():Boolean
		{
			return _volumeMute;
		}
		public function set loggedUser(value:User):void
		{
			_loggedUser = value;
			loggedUserChange = true;
			this.invalidateProperties();
		}
		public function get loggedUser():User
		{
			return _loggedUser;
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == buttonZoom)
			{
				buttonZoom.addEventListener(MouseEvent.CLICK, onClickButtonZoom);	
			}
			if (instance == videoUser)
			{	
				videoUser.status = _status;
				videoUser.attachNetStream(_stream, "void");
				videoUser.attachCamera(_camera);
				videoUser.useHandCursor = true;
				videoUser.buttonMode = true;
				videoUser.addEventListener(MouseEvent.CLICK, onMouseClickVideoComposant);
			}
			if (instance == labelUserZoomOut)
			{	
				labelUserZoomOut.lastFirstNameUser = VisuUtils.getUserLabelLastName(_ownerFluxVideo, true);
			}
			if (instance == buttonMarker)
			{	
				if(_buttonMarkerEnabled)
				{
					buttonMarker.addEventListener(MouseEvent.CLICK, onClickButtonMarker);
				}else
				{
					buttonMarker.includeInLayout = false;
					buttonMarker.visible = false;
				}
			}
			if (instance == buttonChat)
			{	
				if(_buttonChatEnabled)
				{
					buttonChat.addEventListener(MouseEvent.CLICK, onClickButtonChat);
				}else
				{
					buttonChat.includeInLayout = false;
					buttonChat.visible = false;
				}
			}
			if (instance == buttonComment)
			{	
				if(_buttonCommentEnabled)
				{
					buttonComment.addEventListener(MouseEvent.CLICK, onClickButtonComment);
				}else
				{
					buttonComment.includeInLayout = false;
					buttonComment.visible = false;
				}
			}
			if (instance == buttonVolumeUserZoomOut)
			{
				buttonVolumeUserZoomOut.addEventListener(VideoPanelEvent.CHANGE_VOLUME, onChangeVolume);
				buttonVolumeUserZoomOut.volume = _volume;
				buttonVolumeUserZoomOut.mute = _volumeMute;
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == buttonZoom)
			{
				buttonZoom.removeEventListener(MouseEvent.CLICK, onClickButtonZoom);
			}
			if (instance == buttonMarker)
			{	
				buttonMarker.removeEventListener(MouseEvent.CLICK, onClickButtonMarker);
			}
			if (instance == buttonChat)
			{	
				buttonChat.removeEventListener(MouseEvent.CLICK, onClickButtonChat);
			}
			if (instance == buttonComment)
			{	
				buttonComment.removeEventListener(MouseEvent.CLICK, onClickButtonComment);
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(statusChange)
			{
				statusChange = false;
				videoUser.status = _status;
			}
			if(streamChange)
			{
				streamChange = false;
				videoUser.attachNetStream(_stream, "void");
				updateStreamVolume();
			}
			if(cameraChange)
			{
				cameraChange = false;
				videoUser.attachCamera(_camera);
			}
			if(ownerFluxVideoChange)
			{
				ownerFluxVideoChange = false;
				if(labelUserZoomOut != null)
				{
					labelUserZoomOut.lastFirstNameUser = VisuUtils.getUserLabelLastName(_ownerFluxVideo, true);
				}
			}
			if(buttonChatEnabledChange)
			{
				buttonChatEnabledChange = false;
				if(buttonChat != null)
				{
					if(_buttonChatEnabled)
					{
						buttonChat.includeInLayout = true;
						buttonChat.visible = true;
						buttonChat.addEventListener(MouseEvent.CLICK, onClickButtonChat);
					}else
					{
						buttonChat.includeInLayout = false;
						buttonChat.visible = false;
						buttonChat.removeEventListener(MouseEvent.CLICK, onClickButtonChat);
					}	
				}
			}

			if(buttonCommentEnabledChange)
			{
				buttonCommentEnabledChange = false;
				if(buttonComment != null)
				{
					if(_buttonCommentEnabled)
					{
						buttonComment.includeInLayout = true;
						buttonComment.visible = true;
						buttonComment.addEventListener(MouseEvent.CLICK, onClickButtonComment);
					}else
					{
						buttonComment.includeInLayout = false;
						buttonComment.visible = false;
						buttonComment.removeEventListener(MouseEvent.CLICK, onClickButtonComment);
					}	
				}
			}
			
			if(buttonMarkerEnabledChange)
			{
				buttonMarkerEnabledChange = false;
				if(buttonMarker != null)
				{
					if(_buttonMarkerEnabled)
					{
						buttonMarker.includeInLayout = true;
						buttonMarker.visible = true;
						buttonMarker.addEventListener(MouseEvent.CLICK, onClickButtonMarker);
					}else
					{
						buttonMarker.includeInLayout = false;
						buttonMarker.visible = false;
						buttonMarker.removeEventListener(MouseEvent.CLICK, onClickButtonMarker);
					}	
				}
			}
			
			if(volumeChange)
			{
				volumeChange = false;
				if(buttonVolumeUserZoomOut != null)
				{
					buttonVolumeUserZoomOut.volume = _volume;
				}
				if(attachNetStream != null)
				{
					updateStreamVolume();
				}
			}
			
			if(volumeMuteChange)
			{
				volumeMuteChange = false;
				if(attachNetStream != null)
				{
					updateStreamVolumeMute();
				}
			}
			if(loggedUserChange)
			{
				loggedUserChange = false;
				// disabled button send chat message prived to himself
				if(loggedUser.id_user == ownerFluxVideo.id_user)
				{
					_buttonChatEnabled = false;
					buttonChatEnabledChange = true;
					invalidateProperties();
				}
			}
			
		}
		override protected function getCurrentSkinState():String
		{
			var skinName:String;
			if(!enabled)
			{
				skinName = "disable";
			}else if(zoomIn)
			{
				if(mouseOver)
				{
					skinName = "zoomInMouseIn"
				}else
				{
					skinName = "zoomInMouseOut"
				}
			}
			else 
			{
				if(mouseOver)
				{
					skinName = "zoomOutMouseIn"
				}else
				{
					skinName = "zoomOutMouseOut"
				}	
			}
				
			return skinName;
		}
		
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________
		private function onClickButtonMarker(event:MouseEvent):void
		{
			var clickButtonMarkerEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.CLICK_BUTTON_MARKER_VIDEO_PANEL);
			clickButtonMarkerEvent.user = ownerFluxVideo;
			dispatchEvent(clickButtonMarkerEvent);
		}
		private function onClickButtonChat(event:MouseEvent):void
		{
			var clickButtonChatEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.CLICK_BUTTON_CHAT_VIDEO_PANEL);
			clickButtonChatEvent.user = ownerFluxVideo;
			dispatchEvent(clickButtonChatEvent);
		}
		private function onClickButtonComment(event:MouseEvent):void
		{
			var clickButtonChatEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.CLICK_BUTTON_COMMENT_VIDEO_PANEL);
			clickButtonChatEvent.user = ownerFluxVideo;
			dispatchEvent(clickButtonChatEvent);
		}
		private function onClickButtonZoom(even:MouseEvent):void
		{
			var zoomEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.VIDEO_PANEL_ZOOM);
			dispatchEvent(zoomEvent);
            
            // tracage button zoom
            var videoPanelTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_USER_VIDEO);
            videoPanelTracageEvent.typeActivity = RetroTraceModel.USER_VIDEO_ZOOM_MAX;
            videoPanelTracageEvent.userId = ownerFluxVideo.id_user;
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(videoPanelTracageEvent);
		}
		private function onCreationComplete(event:FlexEvent):void
		{
			addEventListener(MouseEvent.ROLL_OVER, onMouseOverVideoPanel);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOutVideoPanel);
		}
		private function onMouseOverVideoPanel(event:MouseEvent):void
		{
			mouseOver = true;
			invalidateSkinState();
		}
		private function onMouseOutVideoPanel(event:MouseEvent):void
		{
			mouseOver = false;
			invalidateSkinState();
		}
		private function onMouseClickVideoComposant(event:MouseEvent):void
		{
			var clickOnPanelEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.CLICK_VIDEO_PANEL);
			this.dispatchEvent(clickOnPanelEvent);
		}
		public function clear():void
		{
			if(videoUser != null)
			{
				videoUser.clear();
			}
		}
		private function updateStreamVolumeMute():void
		{
			var tempVolume:Number;
			// set icon mute
			if(buttonVolumeUserZoomOut != null)
			{
				buttonVolumeUserZoomOut.mute = _volumeMute;
			}
			
			if(_volumeMute)
			{
				tempVolume = 0;	
			}else
			{
				tempVolume = volume;
			}
			var tempSoundTransforme:SoundTransform = attachNetStream.soundTransform;
			tempSoundTransforme.volume = tempVolume;
			attachNetStream.soundTransform = tempSoundTransforme;	
		}
		
		private function updateStreamVolume():void
		{
			var tempSoundTransforme:SoundTransform = attachNetStream.soundTransform;
			tempSoundTransforme.volume = volume;
			attachNetStream.soundTransform = tempSoundTransforme;
		}
		private function onChangeVolume(event:VideoPanelEvent):void
		{
			if (event.volume == 0)
			{
				mute = true;
			}else
			{
				mute = false;
			}
				
			volume = event.volume;
			var volumeUpdateEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.UPDATE_VOLUME);
			volumeUpdateEvent.userId = ownerFluxVideo.id_user;
			volumeUpdateEvent.volume = volume;
			this.dispatchEvent(volumeUpdateEvent);
            // tracage volume the video
            var videoPanelTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_USER_VIDEO);
            videoPanelTracageEvent.typeActivity = RetroTraceModel.USER_VIDEO_VOLUME;
            videoPanelTracageEvent.volume = volume;
            videoPanelTracageEvent.userId = ownerFluxVideo.id_user;
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(videoPanelTracageEvent);
		}
	}
}