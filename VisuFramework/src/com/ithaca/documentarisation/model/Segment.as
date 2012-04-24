package com.ithaca.documentarisation.model
{
	import com.ithaca.documentarisation.RetroDocumentConst;
	import com.ithaca.documentarisation.RetroDocumentView;
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.traces.Obsel;
	
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.utils.UIDUtil;
	
	import spark.components.Label;

	public class Segment
	{
		[Bindable]
		public var order:int;

        [Bindable]
        private var fxgt: _FxGettext = FxGettext;

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
        
        public var segmentId:String = "";
        
        // obsel was DND for create new bloc
        private var _obselRef:Obsel = null;

		public function Segment(parentRetroDocument:RetroDocument)
		{
			this.parentRetroDocument = parentRetroDocument;
            segmentId = UIDUtil.createUID();
		}
		
        public function set obselRef(value:Obsel):void
        {
            _obselRef = value;
        }
        public function get obselRef():Obsel
        {
            return _obselRef;
        }
		public function setSegmentXML(segment:XML):void
		{
            segmentId = segment.attribute(RetroDocumentConst.TAG_ID).toString();
			beginTimeVideo = new Number(segment.child(RetroDocumentConst.TAG_FROM_TIME).toString()); 
			endTimeVideo = new Number(segment.child(RetroDocumentConst.TAG_TO_TIME).toString()); 
			comment = segment.child(RetroDocumentConst.TAG_COMMENT).toString(); 
			typeSource = segment.child(RetroDocumentConst.TAG_TYPE_SOURCE).toString(); 
			durationCommentAudio = segment.child(RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO).toString(); 
			pathCommentAudio = segment.child(RetroDocumentConst.TAG_PATH_COMMENT_AUDIO).toString();
            var obselRefString:String = segment.child(RetroDocumentConst.TAG_PARENT_OBSEL).toString();
            if(obselRefString)
            {
                obselRef = Obsel.fromRDF(obselRefString);
            }
		}
        
        public function getSegmentXML():XML
        {
            var segmentXML:XML = new XML("<"+RetroDocumentConst.TAG_SEGMENT + " " +RetroDocumentConst.TAG_ID + "=" + "'" + segmentId + "'" +"/>");
            var stringBeginTimeVideo:String = "<"+RetroDocumentConst.TAG_FROM_TIME+">"+beginTimeVideo.toString()+"</"+RetroDocumentConst.TAG_FROM_TIME+">";
            var beginTimeVideo:XML = new XML(stringBeginTimeVideo);
            segmentXML.appendChild(beginTimeVideo);
            var stringEndTimeVideo:String = "<"+RetroDocumentConst.TAG_TO_TIME+">"+ endTimeVideo.toString()+"</"+RetroDocumentConst.TAG_TO_TIME+">";
            var endTimeVideo:XML = new XML(stringEndTimeVideo);
            segmentXML.appendChild(endTimeVideo);
            // comment
            var commentText:String = comment;
            if (commentText == fxgt.gettext("Cliquer ici pour ajouter du texte"))
            {
                commentText = "";
            }
            var stringComment:String = "<"+RetroDocumentConst.TAG_COMMENT+"><![CDATA["+commentText+"]]></"+RetroDocumentConst.TAG_COMMENT+">";
            var comment:XML = new XML(stringComment);
            segmentXML.appendChild(comment);
            // type source 
            var stringTypeSource:String = "<"+RetroDocumentConst.TAG_TYPE_SOURCE+">"+typeSource+"</"+RetroDocumentConst.TAG_TYPE_SOURCE+">";
            var typeSource:XML = new XML(stringTypeSource);
            segmentXML.appendChild(typeSource);
            // duration audio
            var stringDurationCommentAudio:String = "<"+RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO+">"+durationCommentAudio.toString()+"</"+RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO+">";
            var durationCommentAudio:XML = new XML(stringDurationCommentAudio);
            segmentXML.appendChild(durationCommentAudio);
            // path stream audio
            var stringPathCommentAudio:String = "<"+RetroDocumentConst.TAG_PATH_COMMENT_AUDIO+">"+pathCommentAudio+"</"+RetroDocumentConst.TAG_PATH_COMMENT_AUDIO+">";
            var pathCommentAudio:XML = new XML(stringPathCommentAudio);
            segmentXML.appendChild(pathCommentAudio);
            // parent obsel when do DND
            if(obselRef)
            {
                var stringParentObsel:String = "<"+RetroDocumentConst.TAG_PARENT_OBSEL+"><![CDATA["+obselRef.toRDF()+"]]></"+RetroDocumentConst.TAG_PARENT_OBSEL+">";
                var parentObsel:XML = new XML(stringParentObsel);
                segmentXML.appendChild(parentObsel);
            }
            return segmentXML;
        }
        
	}
}
