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
package com.ithaca.visu.controls.users
{
	import com.ithaca.visu.controls.users.event.UserFilterEvent;
	import com.ithaca.visu.model.vo.ProfileDescriptionVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	
	[Event(name="viewUngroup",type="com.ithaca.visu.controls.users.event.UserFilterEvent")]
	[Event(name="viewAll",type="com.ithaca.visu.controls.users.event.UserFilterEvent")]
	[Event(name="viewProfile",type="com.ithaca.visu.controls.users.event.UserFilterEvent")]
	
	public class UserFilters extends SkinnableComponent
	{
		[SkinPart("true")]
		public var list:List;
		
		protected var filterElements:ArrayList;
		
		protected static var log:ILogger = Log.getLogger("components.FilterPanel");
		
		[Bindable]
		private var fxgt: _FxGettext = FxGettext;
		
		public function UserFilters()
		{
			super();
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
			filterElements.addItem( {label:fxgt.gettext("Tous les utilisateurs"), value:"all", style:"bold"} );
			// Not implemented yet
			//filterElements.addItem( {label:"UNGROUP_USERS", value:"ungroup", style:"bold"} );
		}
		
		//_____________________________________________________________________
		//
		// Event Handlers
		//
		//_____________________________________________________________________

		
		protected function onSelectFilter(event:IndexChangeEvent):void
		{		
			var o:Object = filterElements.getItemAt(event.newIndex);
			
			var e:UserFilterEvent;
			
			switch(o.value)
			{
				case "ungroup":
					e = new UserFilterEvent(UserFilterEvent.VIEW_UNGROUP);		
					break;
				case "profile":
					e = new UserFilterEvent(UserFilterEvent.VIEW_PROFILE);
					e.profile_max = o.profile+1;
					if (event.newIndex == 0)
						e.profile_min = 0
					else
						e.profile_min = filterElements.getItemAt(event.newIndex-1).profile+1;
					break;
				default://all
					e = new UserFilterEvent(UserFilterEvent.VIEW_ALL);
					break;
			}
			dispatchEvent(e);
				
		}
		
		
		//_____________________________________________________________________
		//
		// Methods
		//
		//_____________________________________________________________________

		/**
		 * Add Dynamic filter based on user profile
		 * @param profile : Array 
		 */
		
		private var _profiles:Array = [];
		
		[Bindable("update")]
		public function get profiles():Array {return _profiles;}
		public function set profiles(value:Array):void
		{
			if( value != _profiles )
			{
				_profiles = value;
				for each( var p:ProfileDescriptionVO in value)
				{
					filterElements.addItem({label:p.short_description,value:"profile",profile:p.profile})
				}
				dispatchEvent( new Event("update") );
			}
		} 		
	}
}