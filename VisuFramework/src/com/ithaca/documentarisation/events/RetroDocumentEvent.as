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
package  com.ithaca.documentarisation.events
{	
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.documentarisation.model.Segment;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.vo.RetroDocumentVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class RetroDocumentEvent extends Event
	{
		// constants
		static public const PRE_REMOVE_SEGMENT : String = 'preRemoveSegment';
		static public const LOAD_TREE_RETRO_DOCUMENT : String = 'loadTreeRetroDocument';
		static public const LOAD_LIST_RETRO_DOCUMENT : String = 'loadListRetroDocument';
		static public const LOAD_RETRO_DOCUMENT : String = 'loadRetroDocument';
		static public const SHOW_RETRO_DOCUMENT : String = 'showRetroDocument';
		static public const CREATE_RETRO_DOCUMENT : String = 'createRetroDocument';
		static public const DELETE_RETRO_DOCUMENT : String = 'deleteRetroDocument';
		static public const PRE_DELETE_RETRO_DOCUMENT : String = 'preDeleteRetroDocument';
		static public const PRE_UPDATE_RETRO_DOCUMENT : String = 'preUpdateRetroDocument';
		static public const UPDATE_RETRO_DOCUMENT : String = 'updateRetroDocument';
		static public const UPDATE_RETRO_SEGMENT : String = 'updateRetroSegment';
		static public const CHANGE_RETRO_SEGMENT : String = 'changeRetroSegment';
		static public const CHANGE_TIME_BEGIN_TIME_END : String = 'changeTimeBeginTimeEnd';
		static public const UPDATE_TITLE_RETRO_DOCUMENT : String = 'updateTitleRetroDocument';
		static public const LOAD_LIST_USERS : String = 'loadListUsers';
		static public const LOADED_ALL_USERS : String = 'loadedAllUsersRetroDocument';
		static public const UPDATE_STREAM_PATH_AUDIO_COMMENT_SEGMENT_RETRO_DOCUMENT : String = 'updateStremPathAudioCommentSegmentRetroDocument';
		static public const ADD_ON_STAGE_RETRO_DOCUMENT : String = 'addOnStageRetroDocument';
		static public const REMOVE_FROM_STAGE_RETRO_DOCUMENT : String = 'removeFromStageRetroDocument';
		
		static public const PLAY_RETRO_SEGMENT : String = 'playRetroSegment';
		static public const PAUSE_RETRO_SEGMENT : String = 'pauseRetroSegment';
		static public const STOP_RETRO_SEGMENT : String = 'stopRetroSegment';
		static public const CLICK_BUTTON_SWITCH : String = 'clickButtonSwitch';
		static public const UPDATE_ADDED_RETRO_DOCUMENT : String = 'updateAddedRetroDocument';
		static public const ADD_RETRO_DOCUMENT_EMPTY : String = 'addRetroDocumentEmpty';
		static public const ADD_RETRO_DOCUMENT_AUTO : String = 'addRetroDocumentAuto';
		static public const GO_BILAN_MODULE_FROM_RETRO : String = 'goBilanModuleFromRetro';
		static public const GO_RETRO_MODULE_FROM_BILAN : String = 'goRetroModuleFromBilan';
		static public const GO_RETRO_MODULE_FROM_SESSION : String = 'goRetroModuleFromSession';
		static public const GO_BILAN_MODULE_FROM_SESSION : String = 'goBilanModuleFromSession';
		
		static public const CHANGE_LIST_RETRO_SEGMENT : String = 'changeListRetroSegment';
		static public const READY_TO_DRAG_DROP_SEGMENT : String = 'readyToDragDropSegment';
		static public const READY_TO_DRAG_DROP_OBSEL : String = 'readyToDragDropObsel';
		static public const STOP_TO_DRAG_DROP_OBSEL : String = 'stopToDragDropObsel';
		
        static public const ADD_RETRO_SEGMENT : String = 'addRetroSegment';
        static public const REMOVE_RETRO_SEGMENT : String = 'removeRetroSegment';
        static public const UPDATE_LIST_RETRO_SEGMENT : String = 'updateListRetroSegment';
		// properties
		public var segment  :Segment;
		public var xmlRetrodocument:String;
		public var listRetroDocument:ArrayCollection;
		public var idRetroDocument:int;
		public var retroDocument:RetroDocument;
		public var editabled:Boolean;
		public var retroDocumentVO:RetroDocumentVO;
		public var sessionId:int;
		public var session:Session;
		public var listUser:Array;
		public var beginTime:Number;
		public var endTime:Number;
		public var titleRetrodocument:String;
		public var statusPlaySegment:Boolean;
		public var streamPathAudioCommentSegment:String;
		public var typeUpdate:String = "voidFromClassRetroDocumentEvent";
		
		public var value:Object;
		public var event:Object;
		
		// constructor
		public function RetroDocumentEvent(type : String,
								   bubbles : Boolean = true,
								   cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
	}
}
