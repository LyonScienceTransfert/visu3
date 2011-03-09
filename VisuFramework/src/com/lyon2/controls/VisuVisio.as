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
	 
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.Container;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	/**
	 *  Text color of the label as the user moves the mouse pointer over the button.
	 *  
	 *  @default 0xDCDCDC
	 */
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	
		
	
	public class VisuVisio extends Container
	{
		private var logger:ILogger = Log.getLogger("com.lyon2.controls.VisuVisio")

		// Dictionary of remote AV-streams, indexed by streamname
		private var streams:Object;
		// Dictionary of remote VideoComponents, indexed by streamname
		private var videos:Object;

        // Local stream/VideoComponent
		private var _localstream:NetStream;
		protected var localvideo:VideoComponent;

		private var publishing:Boolean=false;
		
		protected var _camera:Camera;
		protected var _microphone:Microphone;
        
        public var autoPlay:Boolean; 		
		
		private var _currentVolume:Number;
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
		
		/**
		 * Styles 
		 */
		private var padding:int = 5;
		private const DEFAULT_BACKGROUND_COLOR:uint = 0xDCDCDC;
				
		public function VisuVisio() 
		{
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
		
    	override protected function updateDisplayList(w:Number, h:Number): void
    	{
    		super.updateDisplayList(w,h);
    		
    		//Draw background
    		var bgColor:uint = getStyle("backgroundColor")||DEFAULT_BACKGROUND_COLOR;
    		var g:Graphics = graphics;
    		g.clear();
    		g.beginFill(bgColor);
    		g.drawRect(0,0,w,h);
    		g.endFill();
    		
            updateChildrenLayout(w, h);
    	}
    	
        public function updateChildrenLayout(w: Number, h: Number): void
        {
            var count: uint = getChildren().length;
            if (count == 0)
                return;

            // Last component in the stack -> toplevel video
            var topVideo: VideoComponent = getChildAt(count - 1) as VideoComponent;
            var d: VideoComponent;
            // Loop index
            var i: uint;
            // Horizontal offset, to center the video components
            var offset: int = 0;

			switch (count)
            {
            case 1:
                // Only 1 video -> fullscreen

                // Normalize component width/height, preserving 4/3 aspect ratio
                if ((w / h) > (4/3))
                {
                    offset = w;
                    w= h * 4 / 3;
                    offset = int((offset - w) / 2);
                }
                else
                {
                    h = w * 3 / 4;
                }

			    topVideo.setActualSize(w, h);
                topVideo.move(offset, 0);
                break;

            case 2:
                // 1 video fullscreen, topvideo in the corner

                // Normalize component width/height, preserving 4/3 aspect ratio
                if ((w / h) > (4/3))
                {
                    offset = w;
                    w= h * 4 / 3;
                    offset = int((offset - w) / 2);
                }
                else
                    h = w * 3 / 4;

                d = getChildAt(0) as VideoComponent;
                d.setActualSize(w, h);
                d.move(offset, 0);

                topVideo.setActualSize(int(w/4), int(h/4));
                topVideo.move(offset + w - int(w/4) - padding, 
                              h - int(h/4) - padding);
                break

            case 3:
                // 2 videos side-by-side, topvideo in the middle

                // FIXME: if the container space is more vertical, then put videos vertically

                // Normalize component width/height, preserving 4/3 aspect ratio for both videos
                if ((w / h) > (8/3))
                {
                    offset = w;
                    w= h * 8 / 3;
                    offset = int((offset - w) / 2);
                }
                else
                    h = w * 3 / 8;

			    for (i = 0 ; i < count - 1 ; i ++ )
                {
                    d = getChildAt(i) as VideoComponent;
                    d.setActualSize(w / 2, h);
                    d.move(offset + i * w / 2, 0);
			    }
                // Place toplevel video component reduced in the middle
                topVideo.setActualSize(w / 8, h / 4);
                topVideo.move(offset + (w / 2) - ( w / 8 / 2),
                               h - int(h / 4) - padding);
                break;
                
            case 4:
            case 5:
                // All 4 videos in a square

                // Normalize component width/height, preserving 4/3 aspect ratio
                if ((w / h) > (4/3))
                {
                    offset = w;
                    w= h * 4 / 3;
                    offset = int((offset - w) / 2);
                }
                else
                    h = w * 3 / 4;

			    for (i = 0 ; i < count ; i++ )
                {
                    d = getChildAt(i) as VideoComponent;
                    d.setActualSize(w / 2, h / 2);
                    d.move( offset + (i % 2) * w / 2, int(i / 2) * h / 2);
			    }
                if (count == 5)
                {
                    // Place toplevel video component reduced in the middle
                    topVideo.setActualSize(w / 6, h / 6);
                    topVideo.move(offset + ( w - (w / 6) ) / 2, 
                                  ( h - (h / 6) ) / 2);
                }
                break;

            default:
                // n rows, 2 columns.
                // Normalize component width/height, preserving 4/3 aspect ratio
                var num_cols: int = 2;
                var num_lines: int = int( (count + 1) / num_cols);

                if ( (w / h) > 2 )
                {
                    // Much more width... Let's switch the layout to 2 rows, n cols
                    num_lines = 2;
                    num_cols = int( (count + 1) / num_lines);
                }

                if ((w / h) > ( (4 * num_cols) / (3 * num_lines) ))
                {
                    offset = w;
                    w= h * 4 * num_cols / (3 * num_lines);
                    offset = int((offset - w) / 2);
                }
                else
                    h = w * num_lines * 3 / (4 * num_cols);

			    for ( i = 0 ; i < count ; i++ )
                {
                    d = getChildAt(i) as VideoComponent;
                    d.setActualSize(w / num_cols, h / num_lines);
                    d.move( offset + (i % num_cols) * w / num_cols, int((i / num_cols)) * h / num_lines);
			    }
                break;
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
                localvideo = new VideoComponent();
                localvideo.status = status;
                addChildAt(localvideo, 0);
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
					localvideo.attachCamera( _camera );
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
		        localvideo.attachCamera(null);
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
        /*
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
        public function addVideoStream(streamId : String, status: int = 0) : NetStream
        {
			var stream:NetStream = null;	
            // adding only other "streams", not my own. And do not add
            // if already present.
            if (streamId != streamID && !hasStreamId(streamId))
            {
                logger.debug('addVideoStream ' + streamId);
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
                    _status = status = VisuVisio.STATUS_PAUSE;	
	            }
                stream.addEventListener( NetStatusEvent.NET_STATUS, remoteStreamStatusHandler);
                streams[streamId] = stream;
				
                var vd:VideoComponent = new VideoComponent();
                vd.status = status;
                vd.attachNetStream(stream);
				
                videos[streamId] = vd;
               /* 
                   We add the video component at the beginning of the children list.
                  This way, the first added stream (which is meant to be the local one) will be at the beginning of the list, and we can minimize it and put it over the other children without being hidden.
                */
               addChildAt( vd , 0 );
			}
			return stream;
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
                removeChild(videos[sID]);
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
    			addVideoStream(stream, this.status);
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
    		logger.debug(debug());
            for (var streamname: String in streams)
            {
    			removeVideoStream(streamname);
    		}
    		logger.debug(debug());
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
		
		private function remoteStreamStatusHandler(e:NetStatusEvent):void
		{
			logger.debug("distantStreamStatus - "+e.info.code); 
            
/*			switch( e.info.code)
			{
				case "NetStream.Play.Start" :
					var messageEvent:MessageEvent = new MessageEvent(MessageEvent.CHECK_SEEK_STREAM);
					messageEvent.message = e.info.details;
					messageEvent.netStream = e.currentTarget as NetStream;
					this.dispatchEvent(messageEvent);			
				break;
			}*/
            
		}
		
    	private function debug():String
    	{
    		var out:String = "streams\n";
			out+= "[";
			for(var i:String in streams)
			{			
				out+= i + " : " + streams[i]+", "; 	
			}
			out+= "]\n[";
			for(var j:String in videos)
			{			
				out+= j + " : " + videos[j]+", "; 	
			}
			out+= "]"; 
			return out;
    	}

    	public function pauseStreams(): void
        {
            for (var n: String in streams)
            {
                streams[n].pause();
            }
        }

    	public function resumeStreams(): void
        {
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
    	 * 
    	 * Getter / setter
    	 * 
    	 */
 		
 		[Bindable(event="visioPropertyChange")]
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
		    dispatchEvent( new Event("visioPropertyChange"));
		}

    	 [Bindable(event="visioPropertyChange")]
    	 public function get quality():int { return _quality}
    	 public function set quality(value:int):void
    	 {
    	 	_quality = value;
    	 	invalidateProperties();
 			dispatchEvent( new Event("visioPropertyChange"));
    	 }
    	 [Bindable(event="visioPropertyChange")]
    	 public function get bandwidth():int { return _bandwidth}
    	 public function set bandwidth(value:int):void
    	 {
    		_bandwidth = value;
    		invalidateProperties();
    		dispatchEvent( new Event("visioPropertyChange")); 
    	 }
    	 [Bindable(event="visioPropertyChange")]
    	 public function get keyFrameInterval():int { return _keyFrameInterval}
    	 public function set keyFrameInterval(value:int):void
    	 {
    		_keyFrameInterval = value;
    		invalidateProperties(); 
    		dispatchEvent( new Event("visioPropertyChange"));
    	 }
    	 [Bindable(event="visioPropertyChange")]
    	 public function get fps():int { return _fps}
    	 public function set fps(value:int):void
    	 {
    		_fps = value;
    		invalidateProperties();
    		dispatchEvent( new Event("visioPropertyChange"));
    		
    	 }
    	 [Bindable(event="visioPropertyChange")]
    	 public function get microphoneRate():int { return _microphoneRate}
    	 public function set microphoneRate(value:int):void
    	 {
    		_microphoneRate = value;
    		invalidateProperties();
    		dispatchEvent( new Event("visioPropertyChange"));
    		
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
            invalidateDisplayList();          
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
	}
}

