/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010,2011)
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
package com.ithaca.traces.model
{
public final class RetroTraceModel
{
    
    // ** UserVideoVolume(xsd:int volume);
    public static const USER_VIDEO_VOLUME: String = "UserVideoVolume";
    // ** UserVideoZoomMax();
    public static const USER_VIDEO_ZOOM_MAX: String = "UserVideoZoomMax";
    //** UserVideoAddComment(xsd:string  text; xsd:int forUserId; xsd:string closeDialog["save", "delete",  "cancel", "close_window"], xsd:string origin["timeline", "button", "obsel"])); 
    public static const USER_VIDEO_ADD_COMMENT: String = "UserVideoAddComment";
    //*SessionVideoZoomMode(xsd:string mode ["max", "optimized"]);
    public static const SESSION_VIDEO_ZOOM_MODE: String = "SessionVideoZoomMode";
    // *SessionVideoMute(xsd:string modeMute["true","false"]):
    public static const SESSION_VIDEO_MUTE: String = "SessionVideoMute";
    // ** RetroDocumentBlockDelete(xsd:string serialisation ) // serialisation ancienne valuer
    public static const RETRO_DOCUMENT_BLOCK_DELETE: String = "RetroDocumentBlockDelete";
    // ** RetroDocumentBlockCreate(xsd:string createType : ["menu", "drag-drop"], xsd:string sourceType : ["title", "text", "video", "audio"],  xsd:string  sourceObsel // L'URI de l'obsel source, '' si c'est par menu)
    public static const RETRO_DOCUMENT_BLOCK_CREATE: String = "RetroDocumentBlockCreate";
    // ** RetroDocumentBlockEdit( xsd:string serialisation, // serialisation nouvelle valeur (représentation XML du bloc) xsd:string diff // diff avec l'ancienne, sous forme d'un dictionnaire   JSON { cle1: ancienne_valeur1 }, cf exemple plus bas)
    public static const RETRO_DOCUMENT_BLOCK_EDIT: String = "RetroDocumentBlockEdit";
    // ** RetroDocumentCreate()
    public static const RETRO_DOCUMENT_CREATE: String = "RetroDocumentCreate";
    // ** RetroDocumentDelete()
    public static const RETRO_DOCUMENT_DELETE: String = "RetroDocumentDelete";
    // ** RetroDocumentView() // passage à la visualisation du bilan, aller vers Bilan module
    public static const RETRO_DOCUMENT_VIEW: String = "RetroDocumentView";
    
    public static const VOLUME: String = "volume";
    public static const TEXT: String = "text";
    public static const FOR_USER_ID: String = "forUserId";
    public static const CLOSE_DIALOG: String = "closeDialog";
    public static const ORIGIN: String = "origin";
    public static const SAVE: String = "save";
    public static const DELETE: String = "delete";
    public static const CANCEL: String = "cancel";
    public static const CLOSE_WINDOW: String = "close_window";
    public static const TIMELINE: String = "timeline";
    public static const BUTTON: String = "button";
    public static const OBSEL: String = "obsel";
    public static const SYNC_ROOM_TRACE_ID: String = "syncRoomTraceId";
    public static const USER_ID: String = "userId";
    public static const MAX: String = "max";
    public static const OPTIMIZED: String = "optimized";
    public static const MODE_MUTE: String = "modeMute";
    public static const MODE: String = "mode";
    public static const ID: String = "id";
    public static const SERIALISATION: String = "serialisation";
    public static const CREATE_TYPE: String = "createType";
    public static const MENU: String = "menu";
    public static const DRAG_DROP: String = "drag-drop";
    public static const SOURCE_OBSEL: String = "sourceObsel";
    public static const SOURCE_TYPE: String = "sourceType";
    public static const TITLE: String = "title";
    public static const VIDEO: String = "video";
    public static const AUDIO: String = "audio";
    public static const DIFF: String = "diff";
    public static const RETRO_DOCUMENT_ID: String = "retroDocumentId";
    
}
}