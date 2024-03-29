/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.ithaca.documentarisation.model
{
	import com.ithaca.documentarisation.RetroDocumentConst;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.vo.RetroDocumentVO;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class RetroDocument
	{
		private var logger : ILogger = Log.getLogger('com.ithaca.documentarisation.model.RetroDocument');
		
		public var id:int;
		public var sessionId:int;	

		[Bindable]
	    private var fxgt: _FxGettext = FxGettext;

		[Bindable]
		public var title:String;

		[Bindable]
		public var listSegment:IList;

		[Bindable]
		public var description:String;

		[Bindable]
		public var createur:String;

		[Bindable]
		public var ownerId:int;

		[Bindable]
		public var creationDate:String; 

		[Bindable]
		public var creationDateAsDate:Date; 

		[Bindable]
		public var modifyDate:String;
		
		[Bindable]
		public var modifyDateAsDate:Date;

		[Bindable]
		public var inviteeIds:IList;		
		
		[Bindable]
		public var session:Session;		
		
		public function RetroDocument(vo:RetroDocumentVO = null)
		{
			listSegment = new ArrayCollection();
			
            // initialisation gettext
            fxgt = FxGettext;
            
			if(vo) {
				this.sessionId = vo.sessionId;
				this.id = vo.documentId;
				this.ownerId = vo.ownerId;	
	
				this.title = vo.title;
				this.description = vo.description;
				
				logger.debug("creationDate in VO: {0}", vo.creationDate);
				logger.debug("lastModified in VO: {0}", vo.lastModified);
				this.creationDateAsDate = vo.creationDate;
				this.modifyDateAsDate = vo.lastModified;
				this.inviteeIds = new ArrayCollection();	
					
				for each (var id:Number in vo.inviteeIds)
						this.inviteeIds.addItem(id);
				
				logger.debug("vo.session?");
				if(vo.session) {
						this.session = new Session(vo.session);
						logger.debug("YES: {0}" + session.id_user);
				} else {
						logger.debug("NO");
				}
				if(vo.xml)
					setRetroDocumentXML(vo.xml);
			}
		}
		
		
		public function isShared():Boolean {
			return this.inviteeIds.length > 0;
		}
		
		public function setRetroDocumentXML(value:String):void
		{
			listSegment.removeAll();
			var xml:XML = new XML(value);
			var listSegmentXML:XMLList = xml.block;
			var nbrSegment:int = listSegmentXML.length();
			for(var nSegment:int = 0 ; nSegment < nbrSegment; nSegment++)
			{
				var segmentXML:XML = listSegmentXML[nSegment] as XML;
				var segment:Segment = new Segment(this);
				segment.setSegmentXML(segmentXML);
				segment.order = nSegment + 1;
				listSegment.addItem(segment);				
			}
			description = xml.child(RetroDocumentConst.TAG_DOCUMENT_DESCRIPTION).toString(); 
			createur = xml.child(RetroDocumentConst.TAG_CREATOR).toString(); 
			creationDate = xml.child(RetroDocumentConst.TAG_CREATION_DATE).toString(); 
			modifyDate = xml.child(RetroDocumentConst.TAG_LAST_MODIFIED).toString(); 
		}
		
		public function getRetroDocumentXMLtoSTRING():String 
		{
			var rootString:String = "<"+RetroDocumentConst.TAG_RETROSPECTION_DOCUMENT+"/>";
			var root:XML = new XML(rootString); 
			var stringTitre:String = "<"+RetroDocumentConst.TAG_TITLE+"><![CDATA["+title+"]]></"+RetroDocumentConst.TAG_TITLE+">";
			var titre:XML = new XML(stringTitre);
			root.appendChild(titre);
			var stringDescription:String = "<"+RetroDocumentConst.TAG_DOCUMENT_DESCRIPTION+"><![CDATA["+description+"]]></"+RetroDocumentConst.TAG_DOCUMENT_DESCRIPTION+">";
			var description:XML = new XML(stringDescription);
			root.appendChild(description);
			var stringCreateur:String = "<"+RetroDocumentConst.TAG_CREATOR+"><![CDATA["+createur+"]]></"+RetroDocumentConst.TAG_CREATOR+">";
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
				var segmentXML:XML = new XML("<"+RetroDocumentConst.TAG_SEGMENT + " " +RetroDocumentConst.TAG_ID + "=" + "'" +segment.segmentId + "'" +"/>");
				var stringBeginTimeVideo:String = "<"+RetroDocumentConst.TAG_FROM_TIME+">"+segment.beginTimeVideo.toString()+"</"+RetroDocumentConst.TAG_FROM_TIME+">";
				var beginTimeVideo:XML = new XML(stringBeginTimeVideo);
				segmentXML.appendChild(beginTimeVideo);
				var stringEndTimeVideo:String = "<"+RetroDocumentConst.TAG_TO_TIME+">"+segment.endTimeVideo.toString()+"</"+RetroDocumentConst.TAG_TO_TIME+">";
				var endTimeVideo:XML = new XML(stringEndTimeVideo);
				segmentXML.appendChild(endTimeVideo);
				// comment
				var commentText:String = segment.comment;
				if(commentText == fxgt.gettext("Cliquer ici pour ajouter du texte"))
				{
					commentText = "";
				}
				var stringComment:String = "<"+RetroDocumentConst.TAG_COMMENT+"><![CDATA["+commentText+"]]></"+RetroDocumentConst.TAG_COMMENT+">";
				var comment:XML = new XML(stringComment);
				segmentXML.appendChild(comment);
				// type source 
				var stringTypeSource:String = "<"+RetroDocumentConst.TAG_TYPE_SOURCE+">"+segment.typeSource+"</"+RetroDocumentConst.TAG_TYPE_SOURCE+">";
				var typeSource:XML = new XML(stringTypeSource);
				segmentXML.appendChild(typeSource);
				// duration audio
				var stringDurationCommentAudio:String = "<"+RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO+">"+segment.durationCommentAudio.toString()+"</"+RetroDocumentConst.TAG_DURATION_COMMENT_AUDIO+">";
				var durationCommentAudio:XML = new XML(stringDurationCommentAudio);
				segmentXML.appendChild(durationCommentAudio);
				// path stream audio
				var stringPathCommentAudio:String = "<"+RetroDocumentConst.TAG_PATH_COMMENT_AUDIO+">"+segment.pathCommentAudio+"</"+RetroDocumentConst.TAG_PATH_COMMENT_AUDIO+">";
				var pathCommentAudio:XML = new XML(stringPathCommentAudio);
				segmentXML.appendChild(pathCommentAudio);
                // parent obsel when do DND
                if(segment.obselRef)
                {
                    var stringParentObsel:String = "<"+RetroDocumentConst.TAG_PARENT_OBSEL+"><![CDATA["+segment.obselRef.toRDF()+"]]></"+RetroDocumentConst.TAG_PARENT_OBSEL+">";
                    var parentObsel:XML = new XML(stringParentObsel);
                    segmentXML.appendChild(parentObsel);
                }
                root.appendChild(segmentXML);
			}
			
			var result:String = root.toXMLString();
			result = "<?xml version='1.0' encoding='UTF-8'?>" + result;
			return result;
		}
		/**
		 * Create export bilan in HTML format
		 */
		public function getExportRetroDocument(format:String):Array
		{
			// TODO check empty block
			var result:Array = new Array();
			var headHtml:String = "<html xmlns='http://www.w3.org/1999/xhtml'>" +
				"<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'>" +
				"<title>" + 
				this.title + "</title><center><br>";
			var endHtml:String = "</center></html>";
			var bodyHtml:String = "<table width='80%' border='1'><CAPTION>"+ "Bilan sur la séance : " + this.session.theme + " de " +this.createur + "</CAPTION><tr><th width='80'> Type de bloc </th><th>Comments</th></tr>";
			
			for each(var segment:Segment in listSegment)
			{
				var typeBlok:String;
				var tagBoldBegin:String = "";
				var tagBoldEnd:String = "";
				var propAlign:String = "align='left'";
				switch (segment.typeSource)
				{
					case RetroDocumentConst.TITLE_SEGMENT :
						typeBlok = 'Titre';
						tagBoldBegin = "<b>";
						tagBoldEnd = "</b>";
						propAlign = "align='center'";
						break;
					case RetroDocumentConst.TEXT_SEGMENT :
						typeBlok = 'Text';
						break;
					case RetroDocumentConst.VIDEO_SEGMENT :
						typeBlok = 'Vidéo';
						break;
					case RetroDocumentConst.COMMENT_AUDIO_SEGMENT :
						typeBlok = 'Audio';
						break;
				}
				bodyHtml += "<tr align='center'><td align='center'>"+ typeBlok + "</td><td " + propAlign + " >" + tagBoldBegin + segment.comment + tagBoldEnd + "</td></tr>"
			}
			bodyHtml += "</table>";
			
			result[1] = headHtml + bodyHtml + endHtml;
			var nameFileSave:String = "Bilan_de_" +this.createur;
			result[0] = (nameFileSave);
			return result;
		}
		
	}
}
