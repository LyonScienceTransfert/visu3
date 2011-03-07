package  com.ithaca.documentarisation.events
{	
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.documentarisation.model.Segment;
	import com.ithaca.visu.model.vo.RetroDocumentVO;
	
	import flash.events.Event;
	
	import mx.core.INavigatorContent;
	
	public class RetroDocumentEvent extends Event
	{
		// constants
		static public const PRE_REMOVE_SEGMENT : String = 'preRemoveSegment';
		static public const LOAD_TREE_RETRO_DOCUMENT : String = 'loadTreeRetroDocument';
		static public const LOAD_RETRO_DOCUMENT : String = 'loadRetroDocument';
		static public const SHOW_RETRO_DOCUMENT : String = 'showRetroDocument';
		static public const CREATE_RETRO_DOCUMENT : String = 'createRetroDocument';
		static public const DELETE_RETRO_DOCUMENT : String = 'deleteRetroDocument';
		static public const PRE_UPDATE_RETRO_DOCUMENT : String = 'preUpdateRetroDocument';
		static public const UPDATE_RETRO_DOCUMENT : String = 'updateRetroDocument';
		static public const UPDATE_RETRO_SEGMENT : String = 'updateRetroSegment';
		static public const CHANGE_RETRO_SEGMENT : String = 'changeRetroSegment';
		static public const CHANGE_TIME_BEGIN_TIME_END : String = 'changeTimeBeginTimeEnd';
		static public const UPDATE_TITLE_RETRO_DOCUMENT : String = 'updateTitleRetroDocument';
		static public const LOAD_LIST_USERS : String = 'loadListUsers';
		static public const LOADED_ALL_USERS : String = 'loadedAllUsers';
		
		static public const PLAY_RETRO_SEGMENT : String = 'playRetroSegment';
		
		// properties
		public var segment  :Segment;
		public var xmlTreeRetroDocument:XML;
		public var idRetroDocument:int;
		public var retroDocument:RetroDocument;
		public var editabled:Boolean;
		public var retroDocumentVO:RetroDocumentVO;
		public var sessionId:int;
		public var listUser:Array;
		public var beginTime:Number;
		public var endTime:Number;
		public var titleRetrodocument:String;
		public var statusPlaySegment:Boolean;
		
		
		
		
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
