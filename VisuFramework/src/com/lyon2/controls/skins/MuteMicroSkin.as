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
package com.lyon2.controls.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;
	
	import mx.skins.ProgrammaticSkin;

	public class MuteMicroSkin extends ProgrammaticSkin
	{
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var themeColor:uint = getStyle("themeColor");
			var w:Number = unscaledWidth;
			var h:Number = unscaledHeight;
			var  fillColor:uint;
    		var  fillColor2:uint;
    		var strokeColor:uint = 0x555555;
    		var strokeColor2:uint = 0x777777;
    		
    		switch (name) 
    		{
			case "upSkin":
    		case "selectedUpSkin":
				fillColor = 0xCCCCCC;
				fillColor2 = 0x999999;
				break;
			case "overSkin":
			case "selectedOverSkin":
				fillColor = 0xdddddd;
				fillColor2 = 0xaaaaaa;
				break;
			case "downSkin":
			case "selectedDownSkin":
				fillColor = 0xaaaaaa;
				fillColor2 = 0xaaaaaa;
				break;
			case "disabledSkin":
			case "selectedDisabledSkin":
				strokeColor = strokeColor2 = 0xaaaaaa;
				fillColor = 0xCCCCCC;
				fillColor2 = 0xCCCCCC;
				break;
			}
			// reference the graphics object of this skin class
			var g:Graphics = graphics;
 			g.clear(); 
 			
 			// Drawing Stroke		
 			g.beginGradientFill(
				GradientType.LINEAR,
				[0x555555,0x666666],
				[1,1],
				[0,255],
				verticalGradientMatrix(0,0,unscaledWidth,unscaledHeight));			
			g.drawRoundRect(0,0,unscaledWidth,unscaledHeight,6,6);
			
			// Drawing Fill	
 			g.beginGradientFill(
				GradientType.LINEAR,
				[fillColor,fillColor2],
				[1,1],
				[0,255],
				verticalGradientMatrix(0,0,unscaledWidth,unscaledHeight));		 	 
			g.drawRoundRect(1,1,unscaledWidth-2,unscaledHeight-2,4,4);
			 
			g.endFill();
			// if we're not showing the down skin, show the shadow. Otherwise hide it on the "down state" to look like it's being pressed
	        filters = [new DropShadowFilter(1,90,0xFFFFFF,.8,2,2)];
			
		}
		
	}
}
