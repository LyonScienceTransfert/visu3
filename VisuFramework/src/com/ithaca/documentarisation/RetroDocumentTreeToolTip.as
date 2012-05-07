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
package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.utils.UtilFunction;
	
	import mx.collections.ArrayCollection;
	import mx.core.IToolTip;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class RetroDocumentTreeToolTip extends SkinnableComponent implements IToolTip
	{
		
		[SkinPart("true")]
		public var titleDocument:Label;
		
		[SkinPart("true")]
		public var dateModify:Label;
		
		[SkinPart("true")]
		public var ownerRetroDocument:Label;
		
		[SkinPart("true")]
		public var groupUser:Group;
		
		private var _retroDocumentView:RetroDocumentView;
		private var retroDocumentChange:Boolean;
		
		public function get retroDocument():RetroDocumentView
		{
			return _retroDocumentView;
		}
		public function set retroDocument(value:RetroDocumentView):void
		{
			_retroDocumentView = value;
			retroDocumentChange = true;
			invalidateProperties();
		}
		
		public function RetroDocumentTreeToolTip()
		{
			super();
		}
		
		public function get text():String
		{
			return null;
		}
		
		public function set text(value:String):void
		{
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(retroDocumentChange)
			{
				retroDocumentChange = false;
				
				groupUser.removeAllElements();
				addUsers();
				
				if(titleDocument != null && this._retroDocumentView != null )
				{
					this.titleDocument.text  = this._retroDocumentView.titleDocumentText;
				}
				
				if(dateModify != null && this._retroDocumentView != null)
				{
					this.dateModify.text  = this._retroDocumentView.retroDocument.modifyDate;
/*					var dateString:String = UtilFunction.getLabelDate(this._retroDocument.modifyDate,"-");
					var heureMinString:String = UtilFunction.getHourMinDate(this._retroDocument.modifyDate);
					this.dateModify.text  = dateString + " "+ heureMinString;*/
				}
				
			}
		}
		
		private function addUsers():void
		{
			if(this._retroDocumentView != null)
			{
				var listUser:Array = this._retroDocumentView.listShareUser;
				var nbrUser:int = listUser.length;
				for(var nUser:int = 0; nUser < nbrUser ; nUser++)
				{
					var userId:int = listUser[nUser];
					var userLabel:Label = new Label();
					userLabel.text = userId.toString()+ "xxxxxxxxx";
					userLabel.percentWidth = 100;
					this.groupUser.addElement(userLabel);
				}
			}
			
		}
	}
}