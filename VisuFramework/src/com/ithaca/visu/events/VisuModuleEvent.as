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
	import flash.events.Event;
	
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;

	public class VisuModuleEvent extends ModuleEvent
	{
		 public function VisuModuleEvent(type:String, 
		 						bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                bytesLoaded:uint = 0, bytesTotal:uint = 0,
								errorText:String = null, module:IModuleInfo = null)
		{
		    super(type, bubbles, cancelable, bytesLoaded, bytesTotal,errorText,module);
		}
		
		public static const CONFIGURE:String = "configure";
		public static const LOAD:String = "load";
		public static const LOAD_LIST_MODULES:String = "loadListModules";
		public static const WALK_OUT_MODULE:String = "walkOutModule";
		public static const GO_IN_MODULE:String = "goInModule";
		public static const READY_FOR_USE:String = "readyForUse";
		
		public static const TUTORAT_MODULE:String = "tutoratModule";
		public static const RETROSPECTION_MODULE:String = "retrospectionModule";
		public static const USER_MODULE:String = "userModule";
		public static const SESSION_MODULE:String = "sessionModule";
		public static const BILAN_MODULE:String = "bilanModule";
		public static const HOME_MODULE:String = "homeModule";
		public static const PROFIL_MODULE:String = "profilModule";
		
		public var listModules:Array;
		public var moduleName:String;
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			var event:VisuModuleEvent = new VisuModuleEvent(type, bubbles, cancelable,
				bytesLoaded, bytesTotal, errorText, module);
			event.listModules = this.listModules;
			event.moduleName = this.moduleName;
			return event;
		}
	}
}