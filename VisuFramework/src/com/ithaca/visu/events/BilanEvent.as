package  com.ithaca.visu.events
{
	import com.ithaca.visu.model.vo.RetroDocumentVO;

	import flash.events.Event;


	public class BilanEvent extends Event
	{
		// constants
		static public const BILAN_MODULE_LOADED : String = 'bilanModuleLoaded';

		static public const SHOW_RETRIEVED_BILAN_LIST : String = 'showRetrievedBilanList';

		static public const SESSION_OBSEL_LIST_RETRIEVED : String = 'sessionObselListRetrieved';
		
		static public const BILAN_LOADED : String = 'bilanLoaded';
		
		static public const NEW_BILAN_SELECTED : String = 'newBilanSelected';
  
		// properties
		
		public var obselList : Array;
		public var sessionId : int;
		public var userId : int;
		public var bilanId : int;
		public var retroDocuments : Array;
		public var filterSessionCollection : Array;
		
		// constructor
		public function BilanEvent(type : String,
									 bubbles : Boolean = true,
									 cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
