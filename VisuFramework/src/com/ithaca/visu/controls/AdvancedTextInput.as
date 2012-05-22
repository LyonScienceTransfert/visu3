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
package com.ithaca.visu.controls
{
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.EventPhase;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import spark.components.Label;
import spark.components.TextInput;
import spark.events.TextOperationEvent;


/**
 *  The alpha of the focus ring for this component.
 */
[Style(name="promptColor", type="uint", format="Color", inherit="yes", theme="spark")]

public class AdvancedTextInput extends TextInput
{
	
	[Bindable] public override var  prompt:String=""; 
	
	
	[SkinPart("false")]
	public var clearIcon:InteractiveObject;
	
	[SkinPart("false")]
	public var _promptDisplay:Label;
	
	protected var showPrompt:Boolean=true;
	
	public function AdvancedTextInput()
	{
		super();
	}
	
	//-----------------------------------------------------------
	// 
	// Overridden Methods
	// 
	//-----------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == textDisplay)
		{
			textDisplay.addEventListener(FocusEvent.FOCUS_IN, textDisplay_focusInHandler);
			textDisplay.addEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler);
			textDisplay.addEventListener(TextOperationEvent.CHANGE, textDisplay_changeHandler);
		}
		if (instance == clearIcon )
		{
			clearIcon.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);	
		}
		if (instance == _promptDisplay)
		{
			if (prompt.length > 0) 
				_promptDisplay.text = prompt;
		}
	}
	
	/**
	 * @private
	 */
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		if (instance == textDisplay)
		{
			textDisplay.removeEventListener(FocusEvent.FOCUS_IN, textDisplay_focusInHandler);
			textDisplay.removeEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler);
			textDisplay.removeEventListener(TextOperationEvent.CHANGE, textDisplay_changeHandler);
		}
		if (instance == clearIcon )
		{
			clearIcon.removeEventListener(MouseEvent.CLICK, clearButton_clickHandler);	
		}
	}
	
	/**
	 * @private
	 */
	override protected function createChildren():void
	{
		super.createChildren();
	}
	
	/**
	 * @private
	 */
	override protected function getCurrentSkinState():String
	{
		return !enabled? "disabled" : 
				showPrompt ? "prompt" : "normal";
	}
	//-----------------------------------------------------------
	// 
	// Event handlers
	// 
	//-----------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function textDisplay_focusInHandler(event:FocusEvent):void
	{
		if( _promptDisplay && prompt.length > 0 )
		{
			showPrompt = false;
			invalidateSkinState();
		}
	}
	
	/**
	 * @private
	 */
	protected function textDisplay_focusOutHandler(event:FocusEvent):void
	{
		if( _promptDisplay && prompt.length > 0 
			&& text.length==0)
		{
			showPrompt = true;
			invalidateSkinState();
		}
		
	}
	
	/**
	 * @private
	 */
	protected function textDisplay_changeHandler(event:TextOperationEvent):void
	{
		showPrompt = text.length == 0;
		invalidateSkinState();
	}
	
	/**
	 * @private
	 */
	protected function clearButton_clickHandler(event:MouseEvent):void
	{
		clear();
	}
	
	
	//-----------------------------------------------------------
	// 
	// Methods
	// 
	//-----------------------------------------------------------
	/**
	 * Clear the inputText
	 */
	public function clear(keepFocus:Boolean=false):void
	{
		
		textDisplay.text = "";
		showPrompt = keepFocus;
		invalidateSkinState();
	}
}
}