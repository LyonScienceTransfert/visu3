/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2011)
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
package com.ithaca.visu.traces
{

import com.ithaca.traces.Obsel;
import com.ithaca.traces.TraceManager;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.traces.events.TracageEvent;

import mx.logging.ILogger;
import mx.logging.Log;

[Bindable]
public class TracageManager
{
    /**
     * Singleton instance of the TracageManager
     */
    private static var instance: TracageManager = null;
    
    private static var logger: ILogger = Log.getLogger("com.ithaca.tracage.TracageManager");
 
    /**
     * Returns the Singleton instance of the TracageManager
     */
    public static function getInstance() : TracageManager
    {
        if (instance == null)
        {
            logger.debug("Creating new TracageManager instance");
            instance = new TracageManager();
        }
        return instance;
    }
    
    public function addTracageActivity(event:TracageEvent):void
    {
        // get current time the serveur
        var currentTime:Number = Model.getInstance().getTimeServeur();
        // traceId salon Synchro room
        var parentTraceId:String = Model.getInstance().getParentTraceId();
        // traceId salon retro
        var retroTraceId:String = Model.getInstance().getTraceIdRetroRoom();
        // obsel the TimeLine
        var obselTimeLine:Obsel = event.obsel;
        // type obsel activity
        var typeObsel:String = event.typeActivity;
        // type activity
        var typeActivity:String = event.type;
        // property the obsel for saving
        var props:Object = new Object();
        // set parent trace id 
        props[RetroTraceModel.SYNC_ROOM_TRACE_ID] = parentTraceId;

        switch (typeActivity)
        {
        
        
        // activity on retro document 
        case TracageEvent.ACTIVITY_RETRO_DOCUMENT :

            props[RetroTraceModel.RETRO_DOCUMENT_ID] = event.retroDocumentId;
            
            switch (typeObsel)
            {
            case RetroTraceModel.RETRO_DOCUMENT_CREATE:
                
                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_DELETE:
                
                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_VIEW:
                
                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_EDIT_TITLE:
                
                props[RetroTraceModel.TITLE] = event.title;
                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_EDIT_SHARE:
                
                props[RetroTraceModel.USER_LIST] = event.userList;
                break;
            
            }

            TraceManager.trace("visu", typeObsel, props);
            
            break;
        // activity on retro document blocks
        case TracageEvent.ACTIVITY_RETRO_DOCUMENT_BLOCK :

            props[RetroTraceModel.ID] = event.id;
            
            switch (typeObsel)
            {
            case RetroTraceModel.RETRO_DOCUMENT_BLOCK_DELETE:
                
                props[RetroTraceModel.SERIALISATION] = event.serialisation;
                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_BLOCK_CREATE:
                
                props[RetroTraceModel.CREATE_TYPE] = event.createType;
                props[RetroTraceModel.SOURCE_TYPE] = event.sourceType;
                if(event.obsel != null)
                {
                    props[RetroTraceModel.OBSEL] = event.obsel.toRDF();
                }

                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_BLOCK_EDIT:
                
                props[RetroTraceModel.SERIALISATION] = event.serialisation;
                props[RetroTraceModel.DIFF] = event.diff;

                break;
            
            case RetroTraceModel.RETRO_DOCUMENT_BLOCK_EXPLORE:
                
                props[RetroTraceModel.EXPLORE_TYPE] = event.exploreType;

                break;
            }

            TraceManager.trace("visu", typeObsel, props);
            
            break;
        
        // activity on Timeline
        case TracageEvent.ACTIVITY_SESSION_VIDEO :
            
            switch (typeObsel)
            {
            case RetroTraceModel.SESSION_VIDEO_MUTE:
                
                props[RetroTraceModel.MODE_MUTE] = event.modeMute;
                break;
            
            case RetroTraceModel.SESSION_VIDEO_ZOOM_MODE:
                
                var modeZoom:String = RetroTraceModel.MAX;
                if(!event.modeZoomMax)
                {
                    modeZoom = RetroTraceModel.OPTIMIZED;
                }
                props[RetroTraceModel.MODE] = modeZoom;
                
                break;
            }

            TraceManager.trace("visu", typeObsel, props);
            
            break;
        
        // activity on user video
        case TracageEvent.ACTIVITY_USER_VIDEO :
           
            // user id video only action on video panel, addcomment on TimeLine and obsel hasn't userId 
            if(event.userId)
            {
                props[RetroTraceModel.USER_ID] = event.userId;
            }
            
            switch (typeObsel)
            {
                case RetroTraceModel.USER_VIDEO_ZOOM_MAX:
                    break;
                case RetroTraceModel.USER_VIDEO_VOLUME:
                    
                    props[RetroTraceModel.VOLUME]=event.volume;
                    break;
                
                case RetroTraceModel.USER_VIDEO_ADD_COMMENT:

                    props[RetroTraceModel.TEXT] = event.text;
                    props[RetroTraceModel.FOR_USER_ID] = event.forUserId;
                    props[RetroTraceModel.CLOSE_DIALOG] = event.closeDialog;
                    props[RetroTraceModel.ORIGIN] = event.origin;
                    break;
            }
            
            TraceManager.trace("visu", typeObsel, props);
            
            break;
        
        // activity on Timeline
        case TracageEvent.ACTIVITY_TIME_LINE :
            var obselRetroRoom:Obsel = obselTimeLine.clone();
            obselRetroRoom.begin = currentTime;
            // TODO : duration obsel 
            obselRetroRoom.end = currentTime;
            obselRetroRoom.props[RetroTraceModel.SYNC_ROOM_TRACE_ID] = parentTraceId;
            obselRetroRoom.uri = retroTraceId;
            
            TraceManager.trace("visu",obselRetroRoom.type, obselRetroRoom.props);
            
            break;
        default :
            break;
        }
        
    }
    
}
}
