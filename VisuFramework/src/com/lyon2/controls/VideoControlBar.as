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
package com.lyon2.controls
{
	import mx.formatters.DateFormatter;
	
	public class VideoControlBar extends VideoControlBarView
	{ 
		public static const DEFAULT_TRACK_HEIGHT:int = 15;
		public static const DEFAULT_HEIGHT:int = 30;
		
		private var _duration:Number;
		private var durationChanged:Boolean;
		
		private var _playHeadTime:Number;
		private var playHeadTimeChanged:Boolean
		
		protected var timeFormat:String="NN:SS";
		
		private var dateFormatter:DateFormatter;
				
		public function VideoControlBar()
		{
			super();
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = timeFormat;
		}
		
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			setStyle("trackHeight",getStyle("trackHeight")||DEFAULT_TRACK_HEIGHT);
						
			playHeadSlider.styleName = this;			
			playHeadSlider.dataTipFormatFunction = dataTipFormat;
			
		}
		
		override protected function measure():void
		{
			measuredHeight = getExplicitOrMeasuredHeight() || DEFAULT_HEIGHT;
		}
		
		override protected function commitProperties():void
		{
			if( durationChanged )
			{
				durationChanged = false;
				playHeadSlider.maximum = _duration;
				durationLabel.text = formatTime( new Date(_duration*1000));
			}
			if( playHeadTimeChanged )
			{
				playHeadTimeChanged = false;
				playHeadSlider.value = _playHeadTime;
				playHeadTimeLabel.text = formatTime( new Date(_playHeadTime*1000));
			}

		}
		
		/**
		 * 
		 * Facility Method
		 * 
		 */
		private function formatTime(item:Date):String 
		{
			return dateFormatter.format(item);
        }
		public function dataTipFormat(value:Number):String
		{
			return formatTime( new Date(value*1000) );
		}
		/**
		 * 
		 * Getter / Setter
		 * 
		 */		
		public function get duration():Number {return _duration;}		
		public function set duration(value:Number):void
		{
			_duration = value;
			durationChanged = true;
			invalidateProperties();
		}
		public function get playHeadTime():Number {return _playHeadTime;}

		public function set playHeadTime(value:Number):void
		{
			_playHeadTime = value;
			playHeadTimeChanged = true;
			invalidateProperties();
		}

		
		
		
	}
}
