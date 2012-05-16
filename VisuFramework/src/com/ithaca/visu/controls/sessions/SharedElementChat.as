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
package com.ithaca.visu.controls.sessions
{
	import mx.controls.Image;
	import mx.graphics.GradientEntry;
	
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("vciel")]
	
	public class SharedElementChat extends SkinnableComponent
	{
		[SkinPart("true")]
		public var titleDisplay : RichEditableText;
		
		[SkinPart("true")]
		public var avatar : Image;
		
		[SkinPart("true")]
		public var imageInfo :Image;
		
		[SkinPart("false")]
		public var nameUser :Label;
        
		[SkinPart("false")]
		public var fullColorGradientExit :GradientEntry;

		private var _msgSystem:Boolean;
		private var infoChanged:Boolean;
		private var _pathAvatar:String;
		private var _nameSender:String;
		private var _sourceImageInfo;
		private var _info:String;
		private var _backGroundColor:uint;
		
		private var _viewVciel:Boolean = false;
		
		public var defaultColorFullColorGradientExit:uint = 0xD8D8D8;
		
		public function SharedElementChat()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleDisplay)
			{
				//titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == titleDisplay)
			{
				//titleDisplay.removeEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (infoChanged)
			{
				infoChanged = false;
				
				avatar.source = _pathAvatar;
				avatar.toolTip = _nameSender;
				titleDisplay.text = _info;
				imageInfo.source = _sourceImageInfo;
				nameUser.text = _nameSender;
				nameUser.toolTip = _nameSender;
				this.percentWidth = 100; 
                if(_msgSystem)
                {
                    titleDisplay.setStyle("fontStyle", "italic");
                }else
                {
                    fullColorGradientExit.color = _backGroundColor;
                }
			}
		}
		public function set statVciel(value:Boolean):void
		{
			this._viewVciel = value;
			this.invalidateSkinState();
		}
		override protected function getCurrentSkinState():String
		{
			if(this._viewVciel)
			{
				return "vciel";
			}
			return "normal";
		}
		
		public function setElementChat(pathAvatar:String, nameSender:String, info:String, sourceImageInfo:*, backGroundColor:uint, msgSystem:Boolean = false):void
		{
			infoChanged = true;
            _msgSystem = msgSystem;
			_pathAvatar = pathAvatar;
			_nameSender = nameSender;
			_info = info;
			_sourceImageInfo = sourceImageInfo;
			_backGroundColor = backGroundColor;
			invalidateProperties();
		}
	}
}