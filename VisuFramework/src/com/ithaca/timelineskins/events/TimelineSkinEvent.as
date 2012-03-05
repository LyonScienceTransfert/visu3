package com.ithaca.timelineskins.events
{

import flash.events.Event;

public class TimelineSkinEvent extends Event
{
    // constants
    static public const OBSEL_SKIN_ADDED_TO_STAGE : String = 'obselSkinAddedToStage';
    static public const OBSEL_SKIN_REMOVED_FROM_STAGE : String = 'obselSkinRemovedFromStage';
    
    // properties
    public var obselSkin : Object;
    
    // constructor
    public function TimelineSkinEvent(type : String,
        bubbles : Boolean = true,
        cancelable : Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}

