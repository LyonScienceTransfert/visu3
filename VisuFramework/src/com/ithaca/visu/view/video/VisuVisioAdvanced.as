package com.ithaca.visu.view.video
{
	import com.ithaca.visu.events.VideoPanelEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.view.video.layouts.VideoLayout;
	import com.ithaca.visu.view.video.model.IStreamObsel;
	import com.lyon2.controls.VideoComponent;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	[Event(name="updateTime",type="com.ithaca.visu.view.video.VisuVisioAdvancedEvent")]
	
	public class VisuVisioAdvanced extends SkinnableComponent
	{
		[SkinPart("true")]
		public var groupVideoContener:Group;
		[SkinPart("true")]
		public var videoPanelLayout:VideoLayout;
		
		private var logger:ILogger = Log.getLogger("com.ithaca.visu.view.video.VisuVisioAdvance")
		
		// Dictionary of remote AV-streams, indexed by streamname
		private var streams:Object;
		// Dictionary of remote VideoComponents, indexed by streamname
		private var videos:Object;
		
		// Local stream/VideoComponent
		private var _localstream:NetStream;
		private var localvideo:VideoPanel;
		
		private var publishing:Boolean=false;
		
		protected var _camera:Camera;
		protected var _microphone:Microphone;
		
		public var autoPlay:Boolean; 		
		
		private var _currentVolume:Number = 1;
		private var _frameRateSplit:Number = 1000;
		
		// dataProvider : ArrayCollection of the StreamObsel
		private var _dataProvider:ArrayCollection;
		private var checkingSumFluxVideo:Number = -1;
		private var timeStartRetrospectionSession:Number;
		private var timer:Timer;
		private var _startTimeSession:Number;
		private var timePause:Number = 0;
		private var fistTimePlayFluxVideo:Boolean;

		private var currentTimeSessionMilliseconds:Number;
		// seek session in milliseconds
		private var _seekSession:Number = 0;
		/* 
		* Status constants
		*/
		public static var STATUS_NONE  : int = VideoComponent.STATUS_NONE  ;
		public static var STATUS_RECORD: int = VideoComponent.STATUS_RECORD;
		public static var STATUS_REPLAY: int = VideoComponent.STATUS_REPLAY;
		public static var STATUS_PAUSE:  int = VideoComponent.STATUS_PAUSE;
		
		private var _status: int = STATUS_NONE;
		
		/**
		 * Publish parameters
		 */
		public var streamID:String;
		public var connection:NetConnection
		
		/**
		 * Parameters
		 */
		private var _quality:Number = 0;
		private var _bandwidth:Number = 4000;
		private var _fps:Number = 24;
		private var _keyFrameInterval:Number = 18;
		private var _microphoneRate:Number = 22;
		private var _microphoneGain:Number = 50;
		
		
		/* Camera parameters */
		private var _width:int = 320;
		private var _height:int = 240;
		
		public function VisuVisioAdvanced()
		{
			super();
			streams = new Object();
			videos = new Object();
			
			_microphone = Microphone.getMicrophone();
			_camera = Camera.getCamera();
			if( _camera != null)
			{
				_camera.addEventListener(StatusEvent.STATUS,localStreamStatusHandler);
			}
			if( _microphone != null )
			{			
				_microphone.addEventListener(StatusEvent.STATUS, localStreamStatusHandler);
			}
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		public function get mute(): Boolean
		{
			return (_microphone.gain == 0);
		}
		
		public function set mute(value:Boolean): void
		{
			if( value == mute ) return;
			if(value)
			{
				_microphoneGain = _microphone.gain;
				_microphone.gain = 0;
			}
			else
			{
				_microphone.gain = _microphoneGain;
			}
		}
		
		public function get quality():int { return _quality}
		public function set quality(value:int):void
		{
			_quality = value;
		}
		public function get bandwidth():int { return _bandwidth}
		public function set bandwidth(value:int):void
		{
			_bandwidth = value;
		}
		public function get keyFrameInterval():int { return _keyFrameInterval}
		public function set keyFrameInterval(value:int):void
		{
			_keyFrameInterval = value;
		}
		public function get fps():int { return _fps}
		public function set fps(value:int):void
		{
			_fps = value;
		}
		public function get microphoneRate():int { return _microphoneRate}
		public function set microphoneRate(value:int):void
		{
			_microphoneRate = value;
		}
		
		public function set status(status: int): void
		{
			for (var name:String in videos)
			{
				if (videos[name])
					videos[name].status = status;
			}
			if (localvideo)
				localvideo.status = status;
			_status = status;       
		}
		
		public function get status(): int
		{
			return _status;
		}
		
		public function setVolume(value:Number):void
		{
			_currentVolume = value;
			updateVolume();
		}
		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider = value;
		}
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		public function set startTimeSession(value:Number):void
		{
			_startTimeSession = value;
		}
		public function get startTimeSession():Number
		{
			return _startTimeSession;
		}
		// in milliseconds
		public function set seekSession(value:Number):void
		{
			_seekSession = value;
			timeStartRetrospectionSession = new Date().time;
			this.timePause = 0;
			// set zero for case the jupm to time on the same flux
			this.checkingSumFluxVideo = 0
			if(this.timer != null && !this.timer.running)
			{
				this.timer.start();
			}
		}
		public function get seekSession():Number
		{
			return _seekSession;
		}
		
		//_____________________________________________________________________
		//
		// Handlers
		//
		//_____________________________________________________________________
		private function updateVolume():void
		{
			for (var n: String in streams)
			{
				var tempStream:NetStream = streams[n];
				var tempSoundTransforme:SoundTransform = tempStream.soundTransform;
				tempSoundTransforme.volume = _currentVolume;
				tempStream.soundTransform = tempSoundTransforme;		
			}
		}
		
		public function removeVideoStream(sID: String, videoOnly: Boolean = false): void
		{
			logger.debug('\tremoveVideoStream ' + sID + " from " + streams.toString());
			var stream:NetStream = streams[sID];
			if (!stream) 
			{
				logger.error('stream not found'); 
				return;
			}
			
			if (! videoOnly)
			{
				// Remove both audio and video
				stream.removeEventListener( NetStatusEvent.NET_STATUS, remoteStreamStatusHandler);
				stream.close();
				delete streams[sID];
			}
			
			if (videos[sID])
			{
				groupVideoContener.removeElement(videos[sID]);
				delete videos[sID];
			}
			
		}
		
		private function forceResize(event:Event):void
		{
			invalidateSize();
		}
		
		public function addVideoStreams(value:Array):void
		{ 
			for each (var stream: String in value)
			{
				addVideoStream(stream, null ,this.status);
			}
		}
		public function playVideoStreams(value:Array):void
		{ 
			for (var n: String in streams)
			{
				streams[n].play(n);
			}
		}
		public function removeAllStreams():void
		{
			logger.debug("removeAllStreams" + streams );
			for (var streamname: String in streams)
			{
				removeVideoStream(streamname);
			}
		}
		
		private function localStreamStatusHandler(event:StatusEvent):void
		{
			logger.debug('statusHandler ' + event.target.name + " - " + event.code)	    	
			if( event.code == "Camera.Unmuted")
			{
				if( publishing ) 
				{
					//the stream is already published, we only update the stream
					logger.debug("update camera settings" )
					updateCameraSetting( _camera );
					_localstream.attachCamera( _camera );
				}
				else
				{
					publishing = true;
					//the stream is not currently published
					logger.debug("publishStream publish stream n°" + streamID.toString() );
					_localstream.attachCamera( _camera );
					_localstream.publish(streamID.toString());
				}
			}
			
			if( event.code == "Microphone.Unmuted" ) 
			{
				if( publishing )
				{
					logger.debug("update microphone settings" )
					updateMicrophoneSetting( _microphone );
					_localstream.attachAudio( _microphone );	
				}
				else
				{
					publishing = true;
					//the stream is not currently published
					logger.debug("publishStream publish stream n°" + streamID.toString() );
					_localstream.attachAudio( _microphone );
					_localstream.publish(streamID.toString());					
				}
			}
		}
		private function remoteStreamStatusHandler(event:NetStatusEvent):void
		{
			var stream:NetStream = event.currentTarget as NetStream;
			switch( event.info.code)
			{
				case "NetStream.Buffer.Full" :
					// set status play for all streams
					this.status = VisuVisioAdvanced.STATUS_REPLAY;
					stream.removeEventListener( NetStatusEvent.NET_STATUS, remoteStreamStatusHandler);
					var streamObsel:IStreamObsel = this.getStreamObselByStreamId(stream);
					if(streamObsel == null)
					{
						trace("<hasn't streamObsel with stremId>");
					}else
					{
						var timeBeginStreamObsel:Number = streamObsel.begin;
						var deltaSeekSecond:Number = (this.currentTimeSessionMilliseconds - timeBeginStreamObsel)/1000;
						trace("==========================");
						trace("deltaSeekSecond = "+deltaSeekSecond.toString());
						trace("streamId = "+ streamObsel.pathStream);
						stream.seek(deltaSeekSecond);		
					}
					trace("Current time of the stream  after seek = "+stream.time.toString());
					break;
			}			
		}
		/**
		 * Get streamObsel by path(id) the stream
		 */
		private function getStreamObselByStreamId(netStream:NetStream):IStreamObsel
		{
			var pathStream:String = "";
			for (var n: String in streams)
			{
				var tempStream:NetStream = streams[n];
				if(tempStream == netStream)
				{
					pathStream = n;
					break;
				}
			}
			
			var nbrStreamObsel:int = dataProvider.length;
			for (var nStreamObsel:int = 0 ; nStreamObsel < nbrStreamObsel;  nStreamObsel++)
			{
				var streamObsel:IStreamObsel = dataProvider.getItemAt(nStreamObsel) as IStreamObsel;
				if(streamObsel.pathStream == pathStream)
				{
					return streamObsel;
				}
			}
			return null;
		}
		
		private function updateTime(event:TimerEvent = null):void
		{
			var beginTime:Number = new Date().time - this.timeStartRetrospectionSession + seekSession;
			
			this.currentTimeSessionMilliseconds = beginTime + startTimeSession
			// check end/start flux video 
			this.checkFluxVideo(this.currentTimeSessionMilliseconds);
			var updateTime:VisuVisioAdvancedEvent = new VisuVisioAdvancedEvent(VisuVisioAdvancedEvent.UPDATE_TIME);
			updateTime.beginTime = beginTime;
			this.dispatchEvent(updateTime);
		}
		
		private function onVideoPanelZoom(event:VideoPanelEvent):void
		{
			var elm:VideoPanel = event.currentTarget as VideoPanel;
			setZoom(elm);
			videoPanelLayout.updateZoom();
		}

		private function setZoom(value:VideoPanel):void
		{
			for (var name:String in videos)
			{
				if (videos[name] == value)
				{
					videos[name].zoomIn = true;			
				}else
				{
					videos[name].zoomIn = false;	
				}
				
			}
		}
		public function addLocalDevice():void
		{
			logger.debug("addLocalDevice");
			
			if(!connection ) 
			{
				logger.error('pas de connection');
				return ;
			}
			
			if( !localvideo )
			{
				localvideo = new VideoPanel()
				localvideo.status = status;
				groupVideoContener.addElement(localvideo);
			}
			
			if( _camera == null && _microphone == null )
			{
				logger.info("local devices not found");
				return;
			} 
			
			if( _localstream == null)
			{
				_localstream = new NetStream(connection);
				
				if( _microphone )
				{
					updateMicrophoneSetting(_microphone );
					_localstream.attachAudio( _microphone );
				}
				
				if( _camera ) 
				{
					updateCameraSetting( _camera);
					_localstream.attachCamera( _camera );
					localvideo.attachCamera = _camera ;
				}
				
				if (_microphone)
				{
					logger.debug("publish stream n°" + streamID.toString() )
					_localstream.publish(streamID.toString());
					publishing = true;
				}
				
			}
			else
			{
				logger.error("local devices are already published!")
			}
		}
		
		
		public function removeLocalDevice():void
		{
			if( _localstream )
			{
				logger.debug("removeLocalvideo _localStream");
				_localstream.attachAudio(null);
				_localstream.attachCamera(null);
				_localstream.close();
				_localstream = null;				
				localvideo.attachCamera = null;
				localvideo.clear();
				removeChild(localvideo);
				localvideo = null;
				
				publishing = false;
			}
		}
		public function updateCameraSetting(cam:Camera):void
		{
			if( cam )
			{
				cam.setKeyFrameInterval(_keyFrameInterval);
				cam.setQuality(_bandwidth,_quality);
				cam.setMode(_width,_height,_fps);
			}
		}	
		public function updateMicrophoneSetting(mic:Microphone):void
		{
			if( mic )
			{
				mic.rate = _microphoneRate;
				
				mic.setUseEchoSuppression(true);
				mic.setLoopBack(false);
				mic.setSilenceLevel(0);
			}
		}
		public function onMetaData(infoObject:Object):void {
			trace("metadata");
			for (var propName:String in infoObject) 
			{
				trace(propName + " = " + infoObject[propName]);
			}
		}
		
		public function onCuePoint(infoObject:Object):void {
			trace("onCuePoint:");
			for (var propName:String in infoObject) 
			{
				if (propName != "parameters")
				{
					trace(propName + " = " + infoObject[propName]);
				}
				else
				{
					trace("parameters =");
					if (infoObject.parameters != undefined) {
						for (var paramName:String in infoObject.parameters)
						{
							trace("   " + paramName + ": " + infoObject.parameters[paramName]);
						}
					}
					else
					{
						trace("undefined");
					}
				}        
			}
		}
		
		public function onPlayStatus(infoObject:Object):void {
			trace("on play status");
			for (var prop: String in infoObject) {
				trace("\t"+prop+":\t"+infoObject[prop]);
			}
			trace("---");
		}
		/**
		* Verification if the stream existe 
		* @param : id stream 
		*/
		private function hasStreamId(streamId: String): Boolean
		{
			return streams.hasOwnProperty(streamId);
		}
		public function getStreams():Object
		{
			return this.streams;
		}
		public function addVideoStream(streamId : String, ownerFluxVideo:User, status: int = 0) : NetStream
		{
			var stream:NetStream = null;	
			// adding only other "streams", not my own. And do not add
			// if already present.
			if (streamId != streamID && !hasStreamId(streamId))
			{
				logger.debug('addVideoStream ' + streamId);
				trace('addVideoStream ' + streamId);
				stream = new NetStream(connection);
				// set current volume 
				var tempSoundTransforme:SoundTransform = stream.soundTransform;
				tempSoundTransforme.volume = _currentVolume;
				stream.soundTransform = tempSoundTransforme;
				
				stream.client = this;
				stream.play(streamId);
				// pause immediately when mode autoPlay = false
				if (!autoPlay){
					stream.pause();
					_status = status = VisuVisioAdvanced.STATUS_PAUSE;	
				}
				stream.addEventListener( NetStatusEvent.NET_STATUS, remoteStreamStatusHandler);
				streams[streamId] = stream;
				
				var videoPanel:VideoPanel = new VideoPanel();
				videoPanel.status = status;			
				videoPanel.attachNetStream = stream;
				videoPanel.ownerFluxVideo = ownerFluxVideo;				
				videos[streamId] = videoPanel;
				/* 
				We add the video component at the beginning of the children list.
				This way, the first added stream (which is meant to be the local one) will be at the beginning of the list, and we can minimize it and put it over the other children without being hidden.
				*/
				groupVideoContener.addElement(videoPanel);
				// add listener for zoom video
				videoPanel.addEventListener(VideoPanelEvent.VIDEO_PANEL_ZOOM, onVideoPanelZoom);
				// set zoomIn for new stream
				setZoom(videoPanel);
			}
			
			return stream;
		}
		//_____________________________________________________________________
		//
		// Play/Pause Streams 
		//
		//_____________________________________________________________________

		public function pauseStreams(): void
		{
			for (var n: String in streams)
			{
				streams[n].pause();
				streams[n].addEventListener( NetStatusEvent.NET_STATUS, remoteStreamStatusHandler);
			}
			
			// set timer stop if existe
			if(this.timer != null)
			{
				this.timer.stop();
				this.timePause = new Date().time;
			}
			trace("------ PAUSED ALL STREAMS -------");
			this.status = VisuVisioAdvanced.STATUS_PAUSE;
		}
		
		public function resumeStreams(): void
		{
			if(this.timer != null && !this.timer.running)
			{
				var timePausedNumber:Number = new Date().time -  this.timePause;
				this.timeStartRetrospectionSession = this.timeStartRetrospectionSession  + timePausedNumber;
				this.timer.start();
				this.timePause = 0;
			}
			for (var n: String in streams)
			{
				streams[n].resume();
			}
		}
		
		public function playStreams(): void
		{
			for (var n: String in streams)
			{
				streams[n].play();
			}
		}
		
		/**
		 * Seek streams (in s)
		 */
		public function seekStreams(offset: Number): void
		{
			for (var n: String in streams)
			{
				streams[n].seek(offset);
			}
		}
		
		public function replayTime(): uint
		{
			var t: uint = 0;
			for (var n: String in streams)
			{
				/* We return the first stream time */
				t = streams[n].time * 1000;
				break;
			}
			return t;
		}
		
		/**
		 * check flux video for add on the stage
		 */
		private function checkFluxVideo(value:Number):void
		{
			var sumBeginTimeStamp:Number = 0;
			var listCurrentIStreamObsel:ArrayCollection = getIStreamObselByTimestamp(value);
			var nbrObsel:int = listCurrentIStreamObsel.length;
			if(nbrObsel == 0 ){this.removeAllStreams(); return;}
			// get sem the begin of obsels sessionIn 
			sumBeginTimeStamp = getSumBeginTimeStreamObsel(listCurrentIStreamObsel);
			if(sumBeginTimeStamp != this.checkingSumFluxVideo)
			{
				this.removeAllStreams();
				this.addFluxVideo(listCurrentIStreamObsel);
				this.checkingSumFluxVideo = sumBeginTimeStamp;
			}	
			// set volume
		//	this.visio.setVolume(this.currentVolume);
		}

		public function getIStreamObselByTimestamp(value:Number):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			if(_dataProvider != null)
			{
				var nbrObsel:int = _dataProvider.length;
				for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
				{
					var streamObsel:IStreamObsel = _dataProvider.getItemAt(nObsel) as IStreamObsel;
					if(streamObsel.begin < value && value < streamObsel.end)
					{
						result.addItem(streamObsel);	
					}
				}
			}
			return result;
		}
		private function getSumBeginTimeStreamObsel(value:ArrayCollection):Number
		{
			var result:Number = 0;
			var nbrStreamObsel:int = value.length;
			for(var nObsel:int = 0; nObsel < nbrStreamObsel ; nObsel++ )
			{
				var streamObsel:IStreamObsel = value.getItemAt(nObsel) as IStreamObsel;
				var begin:Number = streamObsel.begin;
				result += begin;
			}	
			return result;
		}
		private function addFluxVideo(value:ArrayCollection):void
		{
			var nbrObsel:int = value.length;
			for(var nObsel:int= 0; nObsel < nbrObsel; nObsel++ )
			{
				var streamObsel:IStreamObsel = value.getItemAt(nObsel) as IStreamObsel;
				var pathVideo:String = streamObsel.pathStream;
				var ownerFluxVideoId:int = streamObsel.userId;
				var ownerFluxVideo:User = Model.getInstance().getUserPlateformeByUserId(ownerFluxVideoId);
				var stream:NetStream = addVideoStream(pathVideo, ownerFluxVideo); 
			}
		}
		public function removeTimer():void
		{
			if(timer != null)
			{
				timer.stop();
				timer = null;
			}
		}
		public function startTimer():void
		{
			this.timeStartRetrospectionSession = new Date().time;
			if(!timer)
			{
				timer = new Timer(1000,0);
				timer.addEventListener(TimerEvent.TIMER, updateTime);
				fistTimePlayFluxVideo = false;
			}
			timer.start();
		}
	}
}

