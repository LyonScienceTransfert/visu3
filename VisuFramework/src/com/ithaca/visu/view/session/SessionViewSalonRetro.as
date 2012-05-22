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
package com.ithaca.visu.view.session
{
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.visu.model.User;
	
    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;

	import mx.controls.Image;
	import mx.graphics.GradientEntry;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	

	public class SessionViewSalonRetro extends SkinnableComponent
	{	
		[SkinPart("true")]
		public var themeTitleLabel:Label;
		
		[SkinPart("true")]
		public var themeLabel:Label;
		
		[SkinPart("true")]
		public var dateTitleLabel:Label;
		
		[SkinPart("true")]
		public var dateLabel:Label;
		
		[SkinPart("true")]
		public var ownerTitleLabel:Label;
		
		[SkinPart("true")]
		public var ownerNameLabel:Label;
		
		[SkinPart("true")]
		public var ownerImage:Image;
		
		[SkinPart("true")]
		public var gradientEntryFrom:GradientEntry;
		
		[SkinPart("true")]
		public var gradientEntryTo:GradientEntry;
		
        [Bindable]
        private var fxgt: _FxGettext = FxGettext;

		private var _date:Date;
		private var _theme:String;
		private var _user:User;
		private var _sessionId:int;
		private var _traceId:String;
		
		private var dateChange:Boolean = false;
		private var userChange:Boolean = false;
		
		public function SessionViewSalonRetro()
		{
			super();
            
            // initialisation gettext
            fxgt = FxGettext;
            
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		public function get traceId():String {return _traceId; }
		public function set traceId(value:String):void
		{
			_traceId = value;
		}
		public function get sessionId():int {return _sessionId; }
		public function set sessionId(value:int):void
		{
			_sessionId = value;
		}
		public function get theme():String {return _theme; }
		public function set theme(value:String):void
		{
			_theme = value;
		}
		public function get dateRecorded():Date {return _date; }
		public function set dateRecorded(value:Date):void
		{
			_date = value;
			dateChange = true;
			this.invalidateProperties();
		}
		
		public function get ownerSession():User {return _user; }
		public function set ownerSession(value:User):void
		{
			_user = value;
			userChange = true;
			this.invalidateProperties();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == themeLabel)
			{
				themeLabel.text = _theme;
				themeLabel.toolTip = _theme;

			}
			if(instance == dateLabel)
			{
				if(dateRecorded == null)
				{
					dateLabel.text = fxgt.gettext("Chargement des données.");
				}else
				{
					dateLabel.text = _date.toString();
				}
			}
			
			if(instance == ownerNameLabel)
			{
				if(ownerSession != null){
					ownerNameLabel.text = _user.lastname+" "+_user.firstname;					
				}
			}	
			
			if(instance == ownerImage)
			{
				if(ownerSession != null)
				{
					ownerImage.source = _user.avatar;
				}
			}			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (dateChange)
			{
				dateChange = false;
				
				dateLabel.text = UtilFunction.getLabelDate(this.dateRecorded,"-") + fxgt.gettext(" à ") + UtilFunction.getHourMinDate(this.dateRecorded);
			}
			if (userChange)
			{
				userChange = false;
				ownerImage.source = ownerSession.avatar;	
				ownerNameLabel.text = ownerSession.lastname+" "+ownerSession.firstname;
				ownerNameLabel.toolTip = ownerNameLabel.text;
				
			}
		}
		
		public function setSelected(value:Boolean):void
		{
			if(value)
			{
				gradientEntryFrom.color = new uint("0xcedbef");
				gradientEntryTo.color = new uint("0x70b2ee");
			}
			else
			{
				gradientEntryFrom.color = new uint("0xFFFFFF");
				gradientEntryTo.color = new uint("0xD8D8D8");
			}
		}

	}
}