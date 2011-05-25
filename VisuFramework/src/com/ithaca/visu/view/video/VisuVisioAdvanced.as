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
		
		// dataProvider : ArrayCollection of the StreamObsel;
		// class StreamObsel implements IStreamObsel;
		// basic properties : 
		//             begin -  begin time obsel "RecordFileName"/"SessionIn";
		//             end   -  end time obsel SessionIn"
		//            userId -  id of thee owner stream
		//        pathStream -  name file video format flv/mp4 etc.
		private var _dataProvider:ArrayCollection;
		private var checkingSumStreamVideo:Number = -1;
		// time when user start analyse the streams(VISU 2 : came in Retrospection Module )
		private var timeStartRetrospectionSession:Number;
		private var timer:Timer;
		// time start session (milliseconds after 1970 year)
		private var _startTimeSession:Number;
		// duration of the pause in ms.(pause the analyse video, example : click button "Pause")
		private var timePause:Number = 0;
		// current time sessionin ms., value current time session is [startSession, endSession]
		private var currentTimeSessionMilliseconds:Number;
		// seek session in milliseconds, call outside, example : play RetroDocument
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
		
		/**
		 * Camera parameters 
		 */
		private var _width:int = 320;
		private var _height:int = 240;
		
		/**
		 * Properties
		*/
		// enabled chat buttons
		private var _buttonChatEnabled:Boolean = false;
		private var buttonChatEnabledChange:Boolean = false;
		// enabled marker buttons
		private var _buttonMarkerEnabled:Boolean = false
		private var buttonMarkerEnabledChange:Boolean = false;
		
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
		// in milliseconds
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
			// set checkSum in zero 
			this.checkingSumStreamVideo = 0
			if(this.timer != null && !this.timer.running)
			{
				this.timer.start();
			}
		}
		public function get seekSession():Number
		{
			return _seekSession;
		}
		public function getStreams():Object
		{
			return this.streams;
		}
		// enabled chat buttons
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
		// enabled marker buttons
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
				// check when stream show on the screen 
				case "NetStream.Buffer.Full" :
					// set status play for all streams
					this.status = VisuVisioAdvanced.STATUS_REPLAY;
					// just first time do this synchronisation
					stream.removeEventListener( NetStatusEvent.NET_STATUS, remoteStreamStatusHandler);
					var streamObsel:IStreamObsel = this.getStreamObselByStream(stream);
					if(streamObsel == null)
					{
						logger.debug("Hasn't streamObsel for stream");
					}else
					{
						// time begin obsel
						var timeBeginStreamObsel:Number = streamObsel.begin;
						// seek stream in seconds 
						var deltaSeekSecond:Number = (this.currentTimeSessionMilliseconds - timeBeginStreamObsel)/1000;
						logger.debug("(Seek on : {0} secons , for stremId: {1})",
							deltaSeekSecond.toString(),
							streamObsel.pathStream
						);
						stream.seek(deltaSeekSecond);		
					}
					break;
			}			
		}
		/**
		 * Get streamObsel by stream
		 */
		private function getStreamObselByStream(netStream:NetStream):IStreamObsel
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
		
		private function onVideoPanelZoom(event:VideoPanelEvent):void
		{
			var elm:VideoPanel = event.currentTarget as VideoPanel;
			setZoom(elm);
			// update layout
			videoPanelLayout.updateZoom();
		}
		/**
		 *  Update property zoomIn
		 */
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
				// FIXME : During the session(mode synchrone) tuter can set disabled the button chat prive for user 				
				videoPanel.buttonChatEnabled = this._buttonChatEnabled;
				videoPanel.buttonMarkerEnabled = this._buttonMarkerEnabled;
				
				videoPanel.attachNetStream = stream;
				videoPanel.ownerFluxVideo = ownerFluxVideo;				
				videos[streamId] = videoPanel;
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
		 * Check if streams end 
		 */
		private function checkUpdateStreams(value:Number):void
		{
			// init sum 
			var sumBeginTimeStamp:Number = 0;
			// list current StreamObsel
			var listCurrentIStreamObsel:ArrayCollection = getIStreamObselByTimestamp(value);
			var nbrObsel:int = listCurrentIStreamObsel.length;
			if(nbrObsel == 0 ){this.removeAllStreams(); return;}
			// sum of the begin time in ms. of the current StreamObsels
			sumBeginTimeStamp = getSumBeginTimeStreamObsel(listCurrentIStreamObsel);
			if(sumBeginTimeStamp != this.checkingSumStreamVideo)
			{
				// one or more stream end, have to update streams
				this.removeAllStreams();
				this.addVideoStreamsFromListCurrentStreamObsel(listCurrentIStreamObsel);
				this.checkingSumStreamVideo = sumBeginTimeStamp;
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
		
		/**
		 * Add video streams from list StreamObsel
		 */
		private function addVideoStreamsFromListCurrentStreamObsel(value:ArrayCollection):void
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
		
		/**
		 * Stop end remove timer
		 */
		public function removeTimer():void
		{
			if(timer != null)
			{
				timer.stop();
				timer = null;
			}
		}
		/**
		 * Start timer, listener call every second
		 */ 
		public function startTimer():void
		{
			this.timeStartRetrospectionSession = new Date().time;
			if(!timer)
			{
				timer = new Timer(1000,0);
				timer.addEventListener(TimerEvent.TIMER, updateTime);
			}
			timer.start();
		} 
		
		/**
		 * Listener of timer, call every second
		 */
		private function updateTime(event:TimerEvent = null):void
		{
			// time from start session in ms.
			var beginTime:Number = new Date().time - this.timeStartRetrospectionSession + seekSession;
			// update current time
			this.currentTimeSessionMilliseconds = beginTime + startTimeSession
			// check if stream need upload, if end stream 
			this.checkUpdateStreams(this.currentTimeSessionMilliseconds);
			// notify change time
			var updateTime:VisuVisioAdvancedEvent = new VisuVisioAdvancedEvent(VisuVisioAdvancedEvent.UPDATE_TIME);
			updateTime.beginTime = beginTime;
			this.dispatchEvent(updateTime);
		}						
	}
}

