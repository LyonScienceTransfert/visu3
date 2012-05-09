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
package com.ithaca.visu.events
{
	import com.ithaca.traces.Obsel;
	
	import flash.events.Event;
	
	public class SalonRetroEvent extends Event
	{
		static public const CLICK_BUTTON_PLAY : String = 'clickButtonPlaySalonRetro';
		static public const CLICK_BUTTON_PAUSE : String = 'clickButtonPauseSalonRetro';
		
		static public const ACTION_ON_VIDEO_PLAYER : String = 'actionOnVideoPlayer';
		static public const ACTION_ON_SLIDER_VIDEO_PLAYER : String = 'actionOnSliderVIdeoPlayer';
		static public const ACTION_ON_TIME_LINE : String = 'actionOnTimeLine';
		
		static public const ACTION_ON_EXPLORE_OBSEL : String = 'actionOnExploreObsel';
		static public const ACTION_ON_EXPAND_TRACE_LINE : String = 'actionOnExpandeTraceLine';
		
		static public const ACTION_ON_TRACE_LINE : String = 'actionOnTraceLine';
		static public const ACTION_ON_COMMENT_TRACE_LINE : String = 'actionOnCommentTraceLine';
		static public const ACTION_ON_OBSEL_COMMENT_START_EDIT_CANCEL_EDIT : String = 'actionOnObselCommentStartEditCancelEdit';
		static public const PRE_ACTION_ON_OBSEL_COMMENT_START_EDIT_CANCEL_EDIT : String = 'preActionOnObselCommentStartEditCancelEdit';
        
		static public const LOAD_TRACE_ID_RETRO_ROOM : String = 'loadTraceIdRetroRoom';
			
		// properties
		public var userId : int;
		public var nameUserTraceLine:String;
		public var avatarUser:String;
		public var isOpen:Boolean;
		public var isPlus:Boolean;
		public var userIdClient : String;
		public var typeAddedObsel:int;
		public var typeWidget:int;
		// action of the user const
		public var typeAction:String;
		public var timePlayer:Number;
		public var timeObselBegin:Number;
		public var timeObselEnd:Number;
		public var timeStamp:Number;
		public var text:String;
		public var editTypeCancel:String;
		public var obsel:Obsel;
		
		public function SalonRetroEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}