package com.ithaca.visu.traces
{
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.logging.ILogger;
import mx.logging.Log;

public class TracageEventDispatcherFactory 
{
    private static var instance: EventDispatcher = null;
    
    private static var logger: ILogger = Log.getLogger("com.ithaca.tracage.TracageEventDispatcherFactory");
    
    
    /**
     * Returns the Singleton instance of the EventDispatcher
     */
    public static function getEventDispatcher() : EventDispatcher
    {
        if (instance == null)
        {
            logger.debug("Creating new dispatcher instance");
            instance = new EventDispatcher();
        }
        return instance;
    }

}
}