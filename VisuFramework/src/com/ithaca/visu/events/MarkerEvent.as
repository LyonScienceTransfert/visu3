package com.ithaca.visu.events
    
{

import flash.events.Event;


public class MarkerEvent extends Event
{
    // constants
    static public const SEND_MARKER : String = 'sendMarker';
    static public const START_ANIMATION_SEND_MARKER : String = 'startAnimationSendMarker';
    static public const STOP_ANIMATION_SEND_MARKER : String = 'stopAnimationSendMarker';
    
    // properties
    public var text:String;
    
    // constructor
    public function MarkerEvent(type : String,
        bubbles : Boolean = true,
        cancelable : Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
