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

package com.ithaca.visu.view.session.controls
{
	import com.ithaca.visu.ui.utils.SessionFilterEnum;
	import com.ithaca.visu.view.session.controls.event.SessionFilterEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayList;
	
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	public class SessionFilters extends SkinnableComponent
	{
		[SkinPart("true")]
		public var list:List
		
		protected var filterElements:ArrayList;
		
		[Bindable]
		private var fxgt: _FxGettext = FxGettext;
		
		public function SessionFilters()
		{
			super();
            // initialisation gettext
            fxgt = FxGettext;	
            populateDefaultFilter();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			list.dataProvider = filterElements;
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if( instance == list)
			{
				list.addEventListener(IndexChangeEvent.CHANGE, onSelectFilter);
			}		
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if( instance == list)
			{
				list.removeEventListener(IndexChangeEvent.CHANGE, onSelectFilter);
			}
		}
		
		
		/**
		 * @private 
		 */
		public function populateDefaultFilter():void
		{
			filterElements = new ArrayList();
			filterElements.addItem( {label:fxgt.gettext("Mes séances"), value: SessionFilterEnum.SESSION_MY, style:"bold"} );
			filterElements.addItem( {label:fxgt.gettext("Toutes les séances"), value:SessionFilterEnum.SESSION_ALL, style:"bold"} );
			filterElements.addItem( {label:fxgt.gettext("Séances à venir"), value:SessionFilterEnum.SESSION_WILL, style:"bold"} );
			filterElements.addItem( {label:fxgt.gettext("Séances passées"), value:SessionFilterEnum.SESSION_WAS, style:"bold"} );
			filterElements.addItem( {label:fxgt.gettext("Plans de séance"), value:SessionFilterEnum.SESSION_PLAN, style:"bold"} );
		}
		
		//_____________________________________________________________________
		//
		// Event Handlers
		//
		//_____________________________________________________________________
		
		
		protected function onSelectFilter(event:IndexChangeEvent):void
		{		
			var obj:Object = filterElements.getItemAt(event.newIndex);
			
			var eventSessionFilter:SessionFilterEvent = new SessionFilterEvent(SessionFilterEvent.VIEW_SESSION);
			eventSessionFilter.filterSession = obj.value;
			dispatchEvent(eventSessionFilter);
			
		}
		
		public function setSelectedFilter(value:int):void
		{
			var selectedIndex:int=0;
			var nbrFilter:int = filterElements.length;
			for(var nFilter:int = 0; nFilter < nbrFilter ; nFilter++)
			{
				var filter:Object = filterElements.getItemAt(nFilter);
				if(filter.value == value)
				{
					selectedIndex = nFilter;
				}
			}
			list.selectedIndex = selectedIndex;
		}
		
		//_____________________________________________________________________
		//
		// Methods
		//
		//_____________________________________________________________________
		
	}
}