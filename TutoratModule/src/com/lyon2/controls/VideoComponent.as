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
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.UIComponent;

	public class VideoComponent extends UIComponent
	{
		
		protected var _video:Video;
		
		private var _camera:Camera;
		
		private var _netStream:NetStream;
		
		private var _hitArea:Sprite;
		private var _overlay:Sprite;
		private var _tf:TextField;
		private var _strokeColor:uint=0xCC0000;
		private var _fillColor:uint=0x333333;

        private var _status: int = 0;
        
        public static var STATUS_NONE: int = 0;
        public static var STATUS_RECORD: int = 1;
        public static var STATUS_REPLAY: int = 2;
        public static var STATUS_PAUSE:  int = 3;

		public static var NO_CAMERA:String = "Pas de caméra."
		public function VideoComponent()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			if ( !_tf ) 
			{			
				_tf = new TextField();
				_tf.background = true;
				_tf.backgroundColor = _fillColor;
				_tf.textColor = _strokeColor;
				_tf.autoSize=TextFieldAutoSize.CENTER;
				_tf.text = NO_CAMERA;
				_tf.selectable = false;
			}
			addChild(_tf);
			
			if (!_video)  _video = new Video();
			addChild( _video );			
			_video.smoothing = true;
			
			if (_netStream) _video.attachNetStream(_netStream);
			if (_camera) _video.attachCamera(_camera);
			
			_hitArea = new Sprite();
			addChildAt(_hitArea,0);			
			_overlay = new Sprite();
			addChild(_overlay);
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredHeight = _video.height;
			measuredWidth = _video.width;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var g:Graphics = _hitArea.graphics;
			g.clear();
			g.beginFill(_fillColor);
			g.lineStyle(1,_strokeColor,1);
			g.drawRect(0, 0, unscaledWidth-1, unscaledHeight-1);
			g.moveTo(0,0);
			g.lineTo(unscaledWidth-1,unscaledHeight-1);
			g.moveTo(unscaledWidth-1,0);
			g.lineTo(0,unscaledHeight-1);
                g.endFill();
            if (unscaledWidth < 80)
            {
                // Do not display NO_CAMERA string if there is not enough space
                _tf.visible = false;
            }
            else
            {
                _tf.visible = true;
			    _tf.x = (unscaledWidth - _tf.width )/2 
			    _tf.y = (unscaledHeight - _tf.height)/2 
            }
			_video.width = unscaledWidth;
			_video.height = unscaledHeight;

            g = _overlay.graphics;
            g.clear();
            if (unscaledWidth > 60 && unscaledHeight > 40)
            {
                if (_status == STATUS_RECORD)
                {
                    g = _overlay.graphics;
                    g.beginFill(0xee4444);
                    g.lineStyle(1, 0xdd0000, 1);
                    g.drawCircle(10, 10, 6);
                    g.endFill();
                }
                else if (_status == STATUS_REPLAY)
                {
                    g = _overlay.graphics;
                    g.lineStyle(1, 0x000000, 1);
                    g.beginFill(0xeeeeee);
                    g.moveTo(3, 3);
                    g.lineTo(13, 10);
                    g.lineTo(3, 17);
                    g.lineTo(3, 3);
                    g.endFill();
                }
                else if (_status == STATUS_PAUSE)
                {
                    g = _overlay.graphics;
                    g.lineStyle(1, 0x000000, 1);
                    g.beginFill(0xeeeeee);
                    g.drawRect(3, 3, 4, 14);
                    g.drawRect(9, 3, 4, 14);
                    g.endFill();
                }
            }
		}
		
		public function get isLocalCam():Boolean
		{
			return (_camera!=null);
		}
		
		public function attachNetStream(p_netStream:NetStream):void
		{
			if (_video) 
			{
				_video.attachNetStream(p_netStream);
			}
			_netStream = p_netStream;
		}
		
		public function clear():void
		{
			if (_video) 
			{
				_video.clear();
			}
		}
		
		public function attachCamera(p_camera:Camera):void
		{
			if (_video) 
			{
				_video.attachCamera(p_camera);
			}
			_camera = p_camera;
		}
		
        public function get status(): int
        {
            return _status;
        }

        public function set status(s: int): void
        {
            _status = s;
            invalidateDisplayList();
        }
	}
}
