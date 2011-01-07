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

package com.ithaca.visu.view.session.controls
{
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	import com.visualempathy.display.controls.datetime.DateTimePickerFR;
	
	import spark.components.RichEditableText;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SessionDetail  extends SkinnableComponent
	{
		[SkinPart("true")]
		public var sessionPlanEdit:SessionPlanEdit;
		
		[SkinPart("true")]
		public var themeSession:RichEditableText;
		
		[SkinPart("true")]
		public var picker:DateTimePickerFR;
		
		public var theme:String="";
		public var description:String="";
		private var _session:Session;
		private var sessionChanged:Boolean;
		
		[SkinPart("true")]
		public var descriptionSession:RichEditableText;
		
		public function SessionDetail()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == themeSession)
			{
				
			}
			if (instance == descriptionSession)
			{
				
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (sessionChanged)
			{
				sessionChanged = false;
				
				theme = _session.theme;
				description = _session.description;
				picker.selectedDate = _session.date_session;
				
				if(theme != "")
				{
					themeSession.text = themeSession.toolTip = theme;
				}else
				{
					setMessageTheme();
				}
				
				if(description != "")
				{
					descriptionSession.text = descriptionSession.toolTip = description;
				}else
				{
					setMessageDescription();
				}
				
			}
		}
		
// SETTER/GETTER
		public function get session():Session
		{
			return _session;
		}
		
		public function set session(value:Session):void
		{
			if( _session == value) return;
			_session = value;
			sessionChanged = true;
			invalidateProperties();
		}

// THEME 		
		public function updateTheme(value:String):void
		{
			_session.theme = value;
			var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
			updateSession.session = _session;
			this.dispatchEvent(updateSession);
			
		}
		public function setMessageTheme():void
		{
			themeSession.text = "entrer un nouveau themè de la séance ici";
			themeSession.setStyle("fontStyle","italic");
			themeSession.setStyle("color","#CCCCCC");
		}	
// DESCRIPTION		
		public function updateDescription(value:String):void
		{
			_session.description = value;
			var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
			updateSession.session = _session;
			this.dispatchEvent(updateSession);
			
		}
		
		public function setMessageDescription():void
		{
			descriptionSession.text = "entrer un nouveau description de la séance ici";
			descriptionSession.setStyle("fontStyle","italic");
			descriptionSession.setStyle("color","#CCCCCC");
		}
// DATE
		public function updateDateSession(value:Date):void
		{
			if( _session.date_session.time != value.time)
			{
				_session.date_session = value;
				var updateSession:SessionEditEvent = new SessionEditEvent(SessionEditEvent.UPDATE_SESSION);
				updateSession.session = _session;
				this.dispatchEvent(updateSession);
			}
		}
	}
}