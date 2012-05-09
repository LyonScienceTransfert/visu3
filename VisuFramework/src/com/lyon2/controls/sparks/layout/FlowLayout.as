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
package com.lyon2.controls.sparks.layout
{
import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

[Style(name="verticalGap", type="Number", inherit="no", minValue="0.0")]

public class FlowLayout extends LayoutBase
{
    
    //---------------------------------------------------------------
    //
    //  Class properties
    //
    //---------------------------------------------------------------
	//---------------------------------------------------------------
	//  verticalGap
	//---------------------------------------------------------------
	
	private var _verticalGap:Number = 3;
	
	public function set verticalGap(value:Number):void
	{
		_verticalGap = value;
		
		// We must invalidate the layout
		var layoutTarget:GroupBase = target;
		if (layoutTarget)
			layoutTarget.invalidateDisplayList();
	}
	
    //---------------------------------------------------------------
    //  horizontalGap
    //---------------------------------------------------------------

    private var _horizontalGap:Number = 7;

    public function set horizontalGap(value:Number):void
    {
        _horizontalGap = value;
        
        // We must invalidate the layout
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
            layoutTarget.invalidateDisplayList();
    }
    
    //---------------------------------------------------------------
    //  verticalAlign
    //---------------------------------------------------------------

    private var _verticalAlign:String = "bottom";
    
    public function set verticalAlign(value:String):void
    {
        _verticalAlign = value;
        
        // We must invalidate the layout
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
            layoutTarget.invalidateDisplayList();
    }
    
	//---------------------------------------------------------------
	//  horizontalAlign
	//---------------------------------------------------------------
	
	private var _horizontalAlign:String = "left"; // center, right
	
	public function set horizontalAlign(value:String):void
	{
		_horizontalAlign = value;
		
		// We must invalidate the layout
		var layoutTarget:GroupBase = target;
		if (layoutTarget)
			layoutTarget.invalidateDisplayList();
	}
	
    //---------------------------------------------------------------
    //
    //  Class methods
    //
    //---------------------------------------------------------------
    
    override public function updateDisplayList(containerWidth:Number,
                                               containerHeight:Number):void
    {
        var element:ILayoutElement;
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
        var hGap:Number = _horizontalGap;
		var vGap:Number = _verticalGap;
		
        // The position for the current element
        var x:Number = 0;
        var y:Number = 0;
        var elementWidth:Number;
        var elementHeight:Number;

        var vAlign:Number = 0;
        switch (_verticalAlign)
        {
            case "middle" : vAlign = 0.5; break;
            case "bottom" : vAlign = 1; break;
        }

        // Keep track of per-row height, maximum row width
        var maxRowWidth:Number = 0;

        // loop through the elements
        // while we can start a new row
        var rowStart:int = 0;
        while (rowStart < count)
        {
            // The row always contains the start element
            element = useVirtualLayout ? layoutTarget.getVirtualElementAt(rowStart) :
										 layoutTarget.getElementAt(rowStart);
									     
            var rowWidth:Number = element.getPreferredBoundsWidth();
            var rowHeight:Number =  element.getPreferredBoundsHeight();
            
            // Find the end of the current row
            var rowEnd:int = rowStart;
            while (rowEnd + 1 < count)
            {
                element = useVirtualLayout ? layoutTarget.getVirtualElementAt(rowEnd + 1) :
										     layoutTarget.getElementAt(rowEnd + 1);
                
                // Since we haven't resized the element just yet, get its preferred size
                elementWidth = element.getPreferredBoundsWidth();
                elementHeight = element.getPreferredBoundsHeight();

                // Can we add one more element to this row?
                if (rowWidth + hGap + elementWidth > containerWidth)
                    break;

                rowWidth += hGap + elementWidth;
                rowHeight = Math.max(rowHeight, elementHeight);
                rowEnd++;
            }
            
			x = 0;
			switch (_horizontalAlign)
			{
				case "center" : x = Math.round(containerWidth - rowWidth) / 2; break;
				case "right" : x = containerWidth - rowWidth;
			}
			
            // Keep track of the maximum row width so that we can
            // set the correct contentSize
            maxRowWidth = Math.max(maxRowWidth, x + rowWidth);

            // Layout all the elements within the row
            for (var i:int = rowStart; i <= rowEnd; i++) 
            {
                element = useVirtualLayout ? layoutTarget.getVirtualElementAt(i) : 
											 layoutTarget.getElementAt(i);

                // Resize the element to its preferred size by passing
                // NaN for the width and height constraints
                element.setLayoutBoundsSize(NaN, NaN);

                // Find out the element's dimensions sizes.
                // We do this after the element has been already resized
                // to its preferred size.
                elementWidth = element.getLayoutBoundsWidth();
                elementHeight = element.getLayoutBoundsHeight();

                // Calculate the position within the row
                var elementY:Number = Math.round((rowHeight - elementHeight) * vAlign);

                // Position the element
                element.setLayoutBoundsPosition(x, y + elementY);

                x += hGap + elementWidth;
            }

            // Next row will start with the first element after the current row's end
            rowStart = rowEnd + 1;

            // Update the position to the beginning of the row
            x = 0;
            y += rowHeight+ vGap;
        }

        // Set the content size which determines the scrolling limits
        // and is used by the Scroller to calculate whether to show up
        // the scrollbars when the the scroll policy is set to "auto"
        layoutTarget.setContentSize(maxRowWidth, y);
    }
}
}