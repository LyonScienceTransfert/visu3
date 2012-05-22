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
package com.ithaca.visu.test
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.model.User;
	
	import flash.events.KeyboardEvent;
	
	import mx.collections.ICollectionView;
	
	import spark.components.DropDownList;
	import com.ithaca.visu.controls.ConnectionLight;
	
	
	public class ConnectedUser extends DropDownList
	{
		
		[SkinPart("true")]
		public var statusIcon:ConnectionLight;
	
		private var userChanged:Boolean;
		private var _user:User = null;
		
		public function ConnectedUser()
		{
			super();
			labelField = "firstname";
			dataProvider
		}
		
		private var _editable:Boolean=false;
		public function get editable():Boolean
		{
			return _editable;
		}
		public function set editable(value:Boolean):void
		{
			_editable = value; 
		}

		
		/**
		 *  @private
		 */		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if( instance == labelDisplay )
			{
				if(  _user != null ) labelDisplay.text = _user.firstname;
			}
			
		}
		
		/**
		 *  @private
		 */		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{ 
			return !enabled ? "disabled" : isDropDownOpen && _user.status != ConnectionStatus.CONNECTED ? "open" : _editable  && _user.status != ConnectionStatus.CONNECTED ? "normal" : "simple" ;
		}
		
		/**
		 *  @private
		 */ 
		override public function set selectedItem(value:*):void
		{
			super.selectedItem = value; 
			if( _user != value as User )
			{
				_user = User(value);
				userChanged = true;
			}
		}
		
		/**
		 *  @private
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
			if( userChanged )
			{ 
				userChanged = false;
                // TODO : find other solution for setting style, havn't in SDK 4.5
				/*if( _user.role > 32) 
					labelDisplay.setStyle("fontWeight","bold");
				else
					labelDisplay.setStyle("fontWeight","normal");*/
				statusIcon.status = _user.status;
			}
		}
		/**
		 *  @private
		 */ 
		override protected function keyDownHandler(event:KeyboardEvent) : void
		{
			if ( _user.status == ConnectionStatus.CONNECTED) return; 
			super.keyDownHandler(event);			
		}
		
		/**
		 *  @private
		 */ 
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var retVal:Boolean = super.commitSelection(dispatchChangedEvents);
			_user = selectedItem as User;
			invalidateProperties();
			return retVal; 
		}
	}
}