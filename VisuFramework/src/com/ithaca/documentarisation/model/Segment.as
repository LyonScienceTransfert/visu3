package com.ithaca.documentarisation.model
{
	import com.ithaca.documentarisation.RetroDocumentConst;

	public class Segment
	{
		public var order:int;
		public var title:String;
		public var beginTimeVideo:Number;
		public var endTimeVideo:Number;
		public var typeSource:String;
		public var comment:String;
		public var link:String;
		public function Segment()
		{
		}
		
		public function setSegmentXML(segment:XML):void
		{
			title = segment.child(RetroDocumentConst.TAG_TITLE).toString();
			beginTimeVideo = new Number(segment.child(RetroDocumentConst.TAG_FROM_TIME).toString()); 
			endTimeVideo = new Number(segment.child(RetroDocumentConst.TAG_TO_TIME).toString()); 
			comment = segment.child(RetroDocumentConst.TAG_COMMENT).toString(); 
			link = segment.child(RetroDocumentConst.TAG_VIDEO_LINK).toString(); 
		}
	}
}