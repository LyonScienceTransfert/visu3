package  com.ithaca.documentarisation.events
{	
	import com.ithaca.documentarisation.model.Segment;
	
	import flash.events.Event;
	
	public class RetroDocumentEvent extends Event
	{
		// constants
		static public const PRE_REMOVE_SEGMENT : String = 'preRemoveSegment';
		
		// properties
		public var segment  :Segment;
		// constructor
		public function RetroDocumentEvent(type : String,
								   bubbles : Boolean = true,
								   cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		// methods
	}
}
