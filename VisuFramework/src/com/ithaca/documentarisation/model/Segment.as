package com.ithaca.documentarisation.model
{
	import com.ithaca.documentarisation.RetroDocumentConst;
	import com.ithaca.documentarisation.RetroDocumentView;
	import com.ithaca.documentarisation.model.RetroDocument;
	
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import spark.components.Label;

	public class Segment
	{
		[Bindable]
		public var order:int;

		/*[Bindable]
		public var title:String="";*/

		[Bindable]
		public var beginTimeVideo:Number;

		[Bindable]
		public var endTimeVideo:Number;
		// duration of the comment audio file
		public var durationCommentAudio:Number = 0;
		
		public var typeSource:String;
		
		[Bindable]
		public var comment:String="";

		public var parentRetroDocument:RetroDocument;

		[Bindable]
		public var pathCommentAudio:String="";
		
		public var byteArray:ByteArray = null;

		public function Segment(parentRetroDocument:RetroDocument)
		{
			this.parentRetroDocument = parentRetroDocument;
		}
		
		public function setSegmentXML(segment:XML):void
		{
			beginTimeVideo = new Number(segment.child(RetroDocumentConst.TAG_FROM_TIME).toString()); 
			endTimeVideo = new Number(segment.child(RetroDocumentConst.TAG_TO_TIME).toString()); 
			comment = segment.child(RetroDocumentConst.TAG_COMMENT).toString(); 
			typeSource = segment.child(RetroDocumentConst.TAG_TYPE_SOURCE).toString(); 
			durationCommentAudio = segment.child(RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO).toString(); 
			pathCommentAudio = segment.child(RetroDocumentConst.TAG_PATH_COMMENT_AUDIO).toString(); 
		}
	}
}