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
package com.ithaca.visu.ui.utils
{
	public class IconEnum
	{	
		import com.ithaca.traces.model.TraceModel;
		
		[Bindable]
		[Embed("images/marqueurBlanc-bas-20px.png")]
		static private var markerIcon:Class;
		
		[Bindable]
		[Embed("images/messageChat.png")]
		static private var messageChatIcon:Class;
		
		[Bindable]
		[Embed("images/motCleVisu1.png")]
		static private var keywordIcon:Class;
		
		[Bindable]
		[Embed("images/video.jpg")]
		static private var videoIcon:Class;
		
		[Bindable]
		[Embed("images/chatMessageVisu1.png")]
		static private var messageChatIconVisu1:Class;
		
		[Bindable]
		[Embed("images/consigneVisu1.png")]
		static private var consigneIconVisu1:Class;
		
		[Bindable]
		[Embed("images/fichierVisu1.png")]
		static private var fichierIconVisu1:Class;

		[Bindable]
		[Embed("images/ShareThisToOtherGreenVer1.png")]
		static private var sharedOkThisToOther:Class;
		
		[Bindable]
		[Embed("images/ShareOtherToThisGreenVer1.png")]
		static private var sharedOkOtherToThis:Class;

		[Bindable]
		[Embed("images/ShareThisToOtherRedVer1.png")]
		static private var sharedNonThisToOther:Class;
		
		[Bindable]
		[Embed("images/ShareOtherToThisRedVer1.png")]
		static private var sharedNonOtherToThis:Class;
		
		public static function getIconByTypeObsel(code:String):Class
		{
			var icon:Class;
			switch (code)
			{
				case TraceModel.SET_MARKER: 
				case TraceModel.RECEIVE_MARKER: 
					icon = markerIcon;
					break;
				case TraceModel.SEND_CHAT_MESSAGE: 
				case TraceModel.RECEIVE_CHAT_MESSAGE: 
					icon = messageChatIconVisu1;
					break;
				case TraceModel.SEND_KEYWORD: 
				case TraceModel.RECEIVE_KEYWORD: 
					icon = keywordIcon;
					break;
				case TraceModel.SEND_INSTRUCTIONS: 
				case TraceModel.RECEIVE_INSTRUCTIONS: 
					icon = consigneIconVisu1;
					break;
				case TraceModel.SEND_DOCUMENT: 
				case TraceModel.RECEIVE_DOCUMENT: 
				case TraceModel.READ_DOCUMENT: 
					icon = videoIcon;
					break;
				default :
					break;				
			}
			return icon;
		}
		
		public static function getIconByCodeShared(code:String):Class
		{
			var icon:Class;
			switch (code)
			{
				case SharedSatusEnum.SHARED_OK_THIS_TO_OTHER : 
					icon = sharedOkThisToOther;
					break;
				case SharedSatusEnum.SHARED_OK_OTHER_TO_THIS : 
					icon = sharedOkOtherToThis;
					break;
				case SharedSatusEnum.SHARED_NON_THIS_TO_OTHER : 
					icon = sharedNonThisToOther;
					break;
				case SharedSatusEnum.SHARED_NON_OTHER_TO_THIS : 
					icon = sharedNonOtherToThis;
					break;
				default :
					break;				
			}
			return icon;
		}
		
	}
}