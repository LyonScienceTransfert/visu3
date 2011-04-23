package com.ithaca.documentarisation.model
{
	import com.ithaca.documentarisation.RetroDocumentConst;
	import com.ithaca.documentarisation.model.RetroDocument;

	public class Segment
	{
		[Bindable]
		public var order:int;

		[Bindable]
		public var title:String="";

		[Bindable]
		public var beginTimeVideo:Number;

		[Bindable]
		public var endTimeVideo:Number;

		public var typeSource:String;

		[Bindable]
		public var comment:String="";

		public var parentRetroDocument:RetroDocument;

		[Bindable]
		public var link:String="";

		public function Segment(parentRetroDocument:RetroDocument)
		{
			this.parentRetroDocument = parentRetroDocument;
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