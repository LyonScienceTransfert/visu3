package com.ithaca.documentarisation.model
{
	import com.ithaca.documentarisation.RetroDocumentConst;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	public class RetroDocument
	{
		public var id:int;
		public var sessionId:int;	
		public var title:String;
		public var listSegment:IList;
		public var description:String;
		public var createur:String;
		public var ownerId:int;
		public var creationDate:String; 
		public var modifyDate:String; 
		
		public function RetroDocument()
		{
			listSegment = new ArrayCollection();
		}
		
		public function setRetroDocumentXML(value:String):void
		{

			var xml:XML = new XML(value);
			var listSegmentXML:XMLList = xml.segment;
			var nbrSegment:int = listSegmentXML.length();
			for(var nSegment:int = 0 ; nSegment < nbrSegment; nSegment++)
			{
				var segmentXML:XML = listSegmentXML[nSegment] as XML;
				var segment:Segment = new Segment();
				segment.setSegmentXML(segmentXML);
				listSegment.addItem(segment);				
			}
			title = xml.child(RetroDocumentConst.TAG_TITLE).toString(); 
			description = xml.child(RetroDocumentConst.TAG_DOCUMENT_DESCRIPTION).toString(); 
			createur = xml.child(RetroDocumentConst.TAG_CREATOR).toString(); 
			creationDate = xml.child(RetroDocumentConst.TAG_CREATION_DATE).toString(); 
			modifyDate = xml.child(RetroDocumentConst.TAG_LAST_MODIFIED).toString(); 
		}
		
		public function getRetroDocumentXMLtoSTRING():String
		{
			var rootString:String = "<"+RetroDocumentConst.TAG_RETROSPECTION_DOCUMENT+"/>";
			var root:XML = new XML(rootString); 
			var stringTitre:String = "<"+RetroDocumentConst.TAG_TITLE+">"+title+"</"+RetroDocumentConst.TAG_TITLE+">";
			var titre:XML = new XML(stringTitre);
			root.appendChild(titre);
			var stringDescription:String = "<"+RetroDocumentConst.TAG_DOCUMENT_DESCRIPTION+">"+description+"</"+RetroDocumentConst.TAG_DOCUMENT_DESCRIPTION+">";
			var description:XML = new XML(stringDescription);
			root.appendChild(description);
			var stringCreateur:String = "<"+RetroDocumentConst.TAG_CREATOR+">"+createur+"</"+RetroDocumentConst.TAG_CREATOR+">";
			var createur:XML = new XML(stringCreateur);
			root.appendChild(createur);
			var stringCreateDate:String = "<"+RetroDocumentConst.TAG_CREATION_DATE+">"+creationDate+"</"+RetroDocumentConst.TAG_CREATION_DATE+">";
			var createDate:XML = new XML(stringCreateDate);
			root.appendChild(createDate);
			var stringModifyDate:String = "<"+RetroDocumentConst.TAG_LAST_MODIFIED+">"+modifyDate+"</"+RetroDocumentConst.TAG_LAST_MODIFIED+">";
			var modifyDate:XML = new XML(stringModifyDate);
			root.appendChild(modifyDate);

			var nbrSegment:int = listSegment.length;
			for(var nSegment:int = 0; nSegment < nbrSegment ; nSegment++ )
			{
				var segment:Segment = listSegment.getItemAt(nSegment) as Segment;
				var segmentXML:XML = new XML("<"+RetroDocumentConst.TAG_SEGMENT+"/>");
				var stringTitleSegment:String = "<"+RetroDocumentConst.TAG_TITLE+">"+segment.title+"</"+RetroDocumentConst.TAG_TITLE+">";
				var titleSegment:XML = new XML(stringTitleSegment);
				segmentXML.appendChild(titleSegment);
				var stringBeginTimeVideo:String = "<"+RetroDocumentConst.TAG_FROM_TIME+">"+segment.beginTimeVideo.toString()+"</"+RetroDocumentConst.TAG_FROM_TIME+">";
				var beginTimeVideo:XML = new XML(stringBeginTimeVideo);
				segmentXML.appendChild(beginTimeVideo);
				var stringEndTimeVideo:String = "<"+RetroDocumentConst.TAG_TO_TIME+">"+segment.endTimeVideo.toString()+"</"+RetroDocumentConst.TAG_TO_TIME+">";
				var endTimeVideo:XML = new XML(stringEndTimeVideo);
				segmentXML.appendChild(endTimeVideo);
				var stringComment:String = "<"+RetroDocumentConst.TAG_COMMENT+">"+segment.comment+"</"+RetroDocumentConst.TAG_COMMENT+">";
				var comment:XML = new XML(stringComment);
				segmentXML.appendChild(comment);
				var stringLink:String = "<"+RetroDocumentConst.TAG_VIDEO_LINK+">"+segment.link+"</"+RetroDocumentConst.TAG_VIDEO_LINK+">";
				var link:XML = new XML(stringLink);
				segmentXML.appendChild(link);
				
				root.appendChild(segmentXML);
			}
			
			var result:String = root.toXMLString();
			result = "<?xml version='1.0' encoding='UTF-8'?>" + result;
			return result;
		}
	}
}