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
	import com.ithaca.visu.model.vo.ArrayDataVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class TraceLineEvent extends Event
	{
		// constants
		static public const REMOVE_TRACE_LINE_ELEMENT : String = 'removeTraceLineElement';
		static public const ADD_TRACE_LINE_ELEMENT : String = 'addTraceLineElement';
		static public const ADD_LIST_OBSEL : String = 'addListObsel';
		static public const REMOVE_LIST_OBSEL : String = 'removeListObsel';
		static public const ADD_COMMENT_OBSEL : String = 'addCommentObsel';
		static public const PRE_ADD_COMMENT_OBSEL : String = 'preAddCommentObsel';
		static public const UPDATE_COMMENT_OBSEL : String = 'updateCommentObsel';
		static public const UPDATE_MARKER_OBSEL : String = 'updateMarkerObsel';
		static public const ADDED_COMMENT_OBSEL : String = 'addedCommentObsel';
		// properties
		public var idElement:int;
		public var userId : int;
		public var listObsel :ArrayCollection;

		public var traceComment :String;
		public var traceParent :String;
		public var typeObsel :String;
		public var textComment :String;
		public var beginTime :String;
		public var endTime :String;
		public var forUserId :int;
		public var sessionId :int;
		public var obsel:Obsel;
		public var timeStamp:String;
		
		public var info : String;
		public var listUsers : Array;
		public var action:String = "";
		public var arrayData:ArrayDataVO;
		
		// constructor
		public function TraceLineEvent(type : String,
												 bubbles : Boolean = true,
												 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
		}
		
		public function cloneMe():TraceLineEvent 
		{ 
			var result:TraceLineEvent = new TraceLineEvent(type, bubbles, cancelable);
			result.idElement = idElement;
			result.userId = userId;
			result.listObsel = listObsel;
			
			result.traceComment = traceComment;
			result.traceParent = traceParent;
			result.typeObsel = typeObsel;
			result.textComment = textComment;
			result.beginTime = beginTime;
			result.endTime = endTime;
			result.forUserId = forUserId;
			result.sessionId = sessionId;
			result.obsel = obsel;
			result.obsel = obsel;
			result.timeStamp = timeStamp;
			
			result.info = info;
			result.listUsers = listUsers;
			result.action = action;
			
			return result;
		} 
	}
}
