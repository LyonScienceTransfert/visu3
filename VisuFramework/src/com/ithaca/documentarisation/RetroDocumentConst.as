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
package com.ithaca.documentarisation {
	
	public final class RetroDocumentConst {
		 public static const TAG_RETROSPECTION_DOCUMENT: String = "retro-document";
		 public static const TAG_TITLE: String = "title";
		 public static const TAG_DOCUMENT_DESCRIPTION: String = "description";
		 public static const TAG_CREATOR: String = "creator";
		 public static const TAG_CREATION_DATE: String = "creation-date";
		 public static const TAG_LAST_MODIFIED: String = "last-modified";
		 public static const TAG_SEGMENT: String = "block";
		 public static const TAG_ID: String = "id";
		 public static const TAG_FROM_TIME: String = "from-time";
		 public static const TAG_TO_TIME: String = "to-time";
		 public static const TAG_COMMENT: String = "comment";
		 public static const TAG_VIDEO_LINK: String = "link";
		 public static const TAG_TYPE_SOURCE: String = "typeSource";
		 public static const TAG_DURATION_COMMENT_AUDIO: String = "durationCommentAudio";
		 public static const TAG_PATH_COMMENT_AUDIO: String = "pathCommentAudio";
		 public static const TAG_PARENT_OBSEL: String = "parentObsel";
		 
		 public static const TEXT_SEGMENT:String = "TextBlock";
		 public static const TITLE_SEGMENT:String = "TitleBlock";
		 public static const COMMENT_AUDIO_SEGMENT:String = "CommentAudioBlock";
		 public static const VIDEO_SEGMENT:String = "VideoBlock";
         
         public static const ADD_BLOC:String = "addBlock";
         public static const DELETE_BLOC:String = "delBlock";
         public static const VOID:String = "void";
         public static const ADD_RETRO_DOCUMENT:String = "addRetroDocument";
	}
}
