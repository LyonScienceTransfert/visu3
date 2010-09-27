/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
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
package com.lyon2.controls
{
	
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.setTimeout;

import mx.controls.Button;
import mx.controls.Menu;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
import mx.events.DropdownEvent;
import mx.events.FlexMouseEvent;
import mx.events.InterManagerRequest;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
	
use namespace mx_internal;
	
[DefaultProperty("popup")]
	
	
//--------------------------------------
//  Events
//-------------------------------------- 

/**
 *  Dispatched when the specified UIComponent closes. 
 *
 *  @eventType mx.events.DropdownEvent.CLOSE
 */
[Event(name="close", type="mx.events.DropdownEvent")]

/**
 *  Dispatched when the specified UIComponent opens.
 *
 *  @eventType mx.events.DropdownEvent.OPEN
 */
[Event(name="open", type="mx.events.DropdownEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Length of a close transition, in milliseconds.
 *  The default value is 250.
 */
[Style(name="closeDuration", type="Number", format="Time", inherit="no")]

/**
 *  Length of an open transition, in milliseconds.
 *  The default value is 250.
 */
[Style(name="openDuration", type="Number", format="Time", inherit="no")]

/**
 *  Easing function to control component opening tween.
 */
[Style(name="easingFunction", type="Function", inherit="no")]

/**
 *  Number of vertical pixels between the PopUpButton and the
 *  specified popup UIComponent.
 *  The default value is 0.
 */
[Style(name="popUpGap", type="Number", format="Length", inherit="no")]
	
	
	public class SimplePopupButton extends Button
	{
		
		
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var inTween:Boolean = false;

    /**
     *  @private
     *  Is the popUp list currently shown?
     */
    private var showingPopUp:Boolean = false;

    /**
     *  @private
     *  The tween used for showing/hiding the popUp.
     */
    private var tween:Tween = null;

    /**
     *  @private
     */
    private var popUpChanged:Boolean = false;
	

    /**
     *  @private
     */
    private var timer:uint;
	
	
	/**
	 *  @private
	 */
	private var debugMode:Boolean=true;
	 
	public function SimplePopupButton()
	{
		super();
       	addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
       	addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
       	addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
	}
	
    //----------------------------------
    //  popUp
    //----------------------------------
    
    /**
     *  @private
     *  Storage for popUp property.
     */    
    private var _popup:IUIComponent = null;
    
    [Bindable(event='popUpChanged')]
    public function get popup():IUIComponent
    {
        return _popup;
    }
    
    /**
     *  @private
     */  
    public function set popup(value:IUIComponent):void
    {
        _popup = value;
        popUpChanged = true;

        invalidateProperties();
    }

   //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */    
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (popUpChanged)
        {
            if (_popup is IFocusManagerComponent)
                IFocusManagerComponent(_popup).focusEnabled = false;
                
            _popup.cacheAsBitmap = true;
            _popup.scrollRect = new Rectangle(0, 0, 0, 0);        
            
                  
                        
            _popup.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,
                                    popMouseDownOutsideHandler);
            
            _popup.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,
                                    popMouseDownOutsideHandler);
            _popup.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,
                                    popMouseDownOutsideHandler);
            _popup.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,
                                    popMouseDownOutsideHandler);
            //weak reference to stage
             var sm:ISystemManager = systemManager.topLevelSystemManager;
            sm.getSandboxRoot().addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
                
            _popup.owner = this;
            
            popUpChanged = false;
        }
        
        // Close if we're disabled and we happen to still be showing our popup.
        if (showingPopUp && !enabled)
            close();
    }
 
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Opens the UIComponent object specified by the <code>popUp</code> property.
     */  
    public function open():void
    {
        openWithEvent(null);
    }
    
    /**
     *  @private
     */
    private function openWithEvent(trigger:Event = null):void
    {
        if (!showingPopUp && enabled)
        {
            displayPopUp(true);

            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.OPEN);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
        }
    }
    
    /**
     *  Closes the UIComponent object opened by the PopUpButton control.
     */  
    public function close():void
    {
        closeWithEvent(null);
    }

    /**
     *  @private
     */
    private function closeWithEvent(trigger:Event = null):void
    {
        if (showingPopUp)
        {
            displayPopUp(false);

            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.CLOSE);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
        }
    }


    /**
     *  @private
     */
    private function displayPopUp(show:Boolean):void
    {
        if (!initialized || (show == showingPopUp))
            return;
        // Subclasses may extend to do pre-processing
        // before the popUp is displayed
        // or override to implement special display behavior
        
        var popUpGap:Number = getStyle("popUpGap")||0;
        var point:Point = new Point(0, 0);
        point = localToGlobal(point);
        //Show or hide the popup
        var initY:Number;
        var endY:Number;
        var easingFunction:Function;
        var duration:Number;
        var sm:ISystemManager = systemManager.topLevelSystemManager;
        var sbRoot:DisplayObject = sm.getSandboxRoot();
        var screen:Rectangle;

        if (sm != sbRoot)
        {
            var request:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, 
                                    false, false,
                                    "getVisibleApplicationRect"); 
            sbRoot.dispatchEvent(request);
            screen = Rectangle(request.value);
        }
        else
            screen = sm.getVisibleApplicationRect();
		
        if (show)
        {
           	if (_popup.parent == null)
            {
                PopUpManager.addPopUp(_popup, this, false);
                _popup.owner = this;
            }
            else
            {
	 			PopUpManager.bringToFront(_popup);
            }
			
            if (point.y - _popup.height < screen.top )
            { 
                // PopUp will go below the bottom of the stage
                // and be clipped. Instead, have it grow up.
                //point.y -= (unscaledHeight + _popup.height + 2*popUpGap);
                initY = _popup.height;
                point.y += unscaledHeight;
            }
            else
            {
            	point.y -= (_popup.height + 2*popUpGap);
                initY = -_popup.height;
            }
            
			
            point.x = Math.min( point.x, screen.right - _popup.getExplicitOrMeasuredWidth());
            point.x = Math.max( point.x, 0);
            
            point = _popup.parent.globalToLocal(point);
            if (_popup.x != point.x || _popup.y != point.y)
                _popup.move(point.x, point.y);

            _popup.scrollRect = new Rectangle(0, initY,
                    _popup.width, _popup.height);
            
            if (!_popup.visible)
                _popup.visible = true;
            
            endY = 0;
            showingPopUp = show;
            duration = getStyle("openDuration");
            easingFunction = getStyle("openEasingFunction") as Function;
        }
        else
        {
            showingPopUp = show;
            
            if (_popup.parent == null)
                return;

            point = _popup.parent.globalToLocal(point);

            endY = (point.y - _popup.height < screen.top )
                               ?  _popup.height + 2
                               : -_popup.height - 2;
            initY = 0;
            duration = getStyle("closeDuration")
            easingFunction = getStyle("closeEasingFunction") as Function;
        }
        
        inTween = true;
        UIComponentGlobals.layoutManager.validateNow();
        
        // Block all layout, responses from web service, and other background
        // processing until the tween finishes executing.
        UIComponent.suspendBackgroundProcessing();
        
        tween = new Tween(this, initY, endY, duration); 
        if (easingFunction != null)
            tween.easingFunction = easingFunction;
    }
    
    /**
     *  @private
     */
    mx_internal function onTweenUpdate(value:Number):void
    {
        _popup.scrollRect =
            new Rectangle(0, value, _popup.width, _popup.height);
    }
    /**
     *  @private
     */
    mx_internal function onTweenEnd(value:Number):void
    {
        _popup.scrollRect =
            new Rectangle(0, value, _popup.width, _popup.height);

        inTween = false;
        UIComponent.resumeBackgroundProcessing();

        if (!showingPopUp)
        {
            _popup.visible = false;
            _popup.scrollRect = null;
        }
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        // Note: event.relatedObject is the object getting focus.
        // It can be null in some cases, such as when you open
        // the popUp and then click outside the application.

        // If the dropdown is open...
        if (showingPopUp && _popup)
        {
            // If focus is moving outside the popUp...
            if (!event.relatedObject)
            {
                close();
            }
            else if (event.relatedObject is Menu)
            {
                // For nested Menu's find parent.
                var target:Menu = Menu(event.relatedObject);
                while (target.parentMenu) 
                {
                    target = target.parentMenu;
                }
                if (_popup is DisplayObjectContainer && !DisplayObjectContainer(_popup).contains(target))
                    close();
            }
            else if (_popup is DisplayObjectContainer && !DisplayObjectContainer(_popup).contains(event.relatedObject))
            {
                close();
            }
        }

        super.focusOutHandler(event);
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: Button
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function clickHandler(event:MouseEvent):void
    {
		super.clickHandler(event);
        if (showingPopUp)
            closeWithEvent(event);
        else
            openWithEvent(event);       
    } 
	
	

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    
    /**
     *  @private
     */
    private function stage_resizeHandler(event:Event):void 
    {
        // Hide the popUp and don't show tweening when popUp is closed
        // due to resizing.
        _popup.visible = false;

        close();
    }
    
	/**
     *  @private
     */
    private function removedFromStageHandler(event:Event):void
    {
        // Ensure we've unregistered ourselves from PopupManager, else
        // we'll be leaked.
        if (_popup) {
            PopUpManager.removePopUp(_popup);
            showingPopUp = false;
        }
    }
	    
    /**
     *  @private
     */    
    private function popMouseDownOutsideHandler(event:Event):void
    {
        if (event is MouseEvent)
        {
            // for automated testing, since we're generating this event and
            // can only set localX and localY, transpose those coordinates
            // and use them for the test point.
            var mouseEvent:MouseEvent = MouseEvent(event);
            var p:Point = event.target.localToGlobal(new Point(mouseEvent.localX, 
                                                               mouseEvent.localY));
            if (hitTestPoint(p.x, p.y, true))
            {
                // do nothing
            }
            else
            {
                close();
            }
        }
        else if (event is SandboxMouseEvent)
            close();
    }    

	
	/**
     *  @private
     */
    private function mouseOverHandler(event:MouseEvent):void 
    {
        // Hide the popUp and don't show tweening when popUp is closed
        // due to resizing.
		open();
    }
	/**
     *  @private
     */
    private function mouseOutHandler(event:MouseEvent):void 
    {
        // Hide the popUp and don't show tweening when popUp is closed
        // due to resizing.
        closeTimeOut();
    }
	
	private function closeTimeOut():void
	{
		timer = setTimeout( testClose, 300 );
	}
	private function testClose():void
	{
		var point:Point = new Point(0, 0);
		point = localToGlobal(point);
		
		if( overButton() || overPopup() )
		{
			_popup.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);	
		}
		else
		{
			_popup.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			close();
		}
	}
	
	/**
	 * @private
	 */
	private function overButton():Boolean
	{
		var point:Point = new Point(0, 0);
		//point = localToGlobal(point);
		
		return  mouseX > point.x 
			 && mouseX < point.x + unscaledWidth
			 && mouseY > point.y
			 && mouseY < point.y + unscaledHeight;
	}
	/**
	 * @private
	 */
	private function overPopup():Boolean
	{
		var point:Point = new Point(mouseX,mouseY)
		point = localToGlobal(point);
		
		return  point.x > _popup.x 
			 && point.x < _popup.x + _popup.width
			 && point.y > _popup.y
			 && point.y < _popup.y + _popup.height;
	}

	
	    
	}
}
