package com.ithaca.visu.events

{
import flash.events.Event;


public class ShortMarkerEvent extends Event
{
    // constants
    static public const INIT_SHORT_MARKER : String = 'initShortMarker';
    static public const SAVE_SHORT_MARKER : String = 'saveShortMarker';
    
    // properties
    public var listColor:Array;
    public var listText:Array;
    public var loggedUserId:int;
    
    // constructor
    public function ShortMarkerEvent(type : String,
        bubbles : Boolean = true,
        cancelable : Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
