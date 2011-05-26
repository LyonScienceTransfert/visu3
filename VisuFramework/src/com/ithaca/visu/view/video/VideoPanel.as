package com.ithaca.visu.view.video
{
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.utils.components.IconButton;
	import com.ithaca.visu.events.VideoPanelEvent;
	import com.ithaca.visu.model.User;
	import com.lyon2.controls.VideoComponent;
	
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
		public var buttonVolumeUserZoomOut:ImageVolume;
		[SkinPart("true")]
		public var buttonVolumeUserZoomIn:ImageVolume;
		[SkinPart("true")]
		public var labelUserZoomOut:Label;
		[SkinPart("true")]
		public var labelUserZoomIn:Label;
		
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
		public function set volumeMute(value:Boolean):void
		{
			_volumeMute = value;
			volumeMuteChange = true;
			invalidateProperties();
		}
		public function get volumeMute():Boolean
		{
			return _volumeMute;
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
			}
			if (instance == labelUserZoomOut)
			{	
				labelUserZoomOut.text = VisuUtils.getUserLabel(_ownerFluxVideo, true);
			}
			if (instance == labelUserZoomIn)
			{	
				labelUserZoomIn.text = VisuUtils.getUserLabel(_ownerFluxVideo, true);
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
			if (instance == buttonVolumeUserZoomIn)
			{
				buttonVolumeUserZoomIn.addEventListener(VideoPanelEvent.CHANGE_VOLUME, onChangeVolume);
				buttonVolumeUserZoomIn.volume = _volume;
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
					labelUserZoomOut.text = VisuUtils.getUserLabel(_ownerFluxVideo, true);
				}
				if(labelUserZoomIn != null)
				{
					labelUserZoomIn.text = VisuUtils.getUserLabel(_ownerFluxVideo, true);
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
				if(buttonVolumeUserZoomIn != null)
				{
					buttonVolumeUserZoomIn.volume = _volume;
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
			return;
		}
		private function onClickButtonChat(event:MouseEvent):void
		{
			return;
		}
		private function onClickButtonZoom(even:MouseEvent):void
		{
			var zoomEvent:VideoPanelEvent = new VideoPanelEvent(VideoPanelEvent.VIDEO_PANEL_ZOOM);
			dispatchEvent(zoomEvent);
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
		
		public function clear():void
		{
			if(videoUser != null)
			{
				videoUser.clear();
			}
		}
		private function updateStreamVolumeMute():void
		{
			// FIXME : can update image volume
			var tempVolume:Number;
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
			volume = event.volume;

		}
	}
}