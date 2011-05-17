package com.ithaca.visu.view.video
{
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.utils.components.IconButton;
	import com.ithaca.visu.events.VideoPanelEvent;
	import com.ithaca.visu.model.User;
	import com.lyon2.controls.VideoComponent;
	
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import gnu.as3.gettext._FxGettext;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
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
		public var buttonVolume:Button;

		[SkinPart("true")]
		public var buttonVolumeUserZoomOut:Button;
		[SkinPart("true")]
		public var buttonVolumeUserZoomIn:Button;
		[SkinPart("true")]
		public var labelUserZoomOut:Label;
		[SkinPart("true")]
		public var labelUserZoomIn:Label;
		
		private var _zoom:Boolean;
		private var mouseOver:Boolean;
		private var _streamId:String;
		private var _status:int;
		private var statusChange:Boolean;
		private var _stream:NetStream;
		private var streamChange:Boolean;
		private var _camera:Camera;
		private var cameraChange:Boolean;
		private var _ownerFluxVideo:User;
		private var ownerFluxVideoChange:Boolean;
		
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
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == buttonZoom)
			{
				buttonZoom.removeEventListener(MouseEvent.CLICK, onClickButtonZoom);
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
	}
}