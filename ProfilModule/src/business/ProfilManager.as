package business
{
import flash.events.IEventDispatcher;

import mx.logging.ILogger;
import mx.logging.Log;

public class ProfilManager
{
    private var logger : ILogger = Log.getLogger('ProfilManager');
    
    private var dispatcher:IEventDispatcher;
    
    public function ProfilManager(dispatcher:IEventDispatcher)
    {
        this.dispatcher = dispatcher;
    }
    
    public function error(event:Object):void
    {
        
    }
}
}