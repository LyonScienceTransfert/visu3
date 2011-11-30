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

import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.traces.Obsel;
import com.ithaca.traces.Trace;
import com.ithaca.traces.TraceManager;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.traces.model.TraceModel;
import com.ithaca.visu.model.Model;

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
        // obsel the TimeLine
        var obselTimeLine:Obsel = event.obsel;
        // type activity
        var typeActivity:String = event.type;
        switch (typeActivity)
        {
        // activity on Timeline
        case TracageEvent.ACTIVITY_TIME_LINE :
            var obselRetroRoom:Obsel = obselTimeLine.clone();
            obselRetroRoom.begin = currentTime;
            // TODO : duration obsel 
            obselRetroRoom.end = currentTime;
            obselRetroRoom.props[RetroTraceModel.SYNC_ROOM_TRACE_ID] = parentTraceId;
            
            TraceManager.trace("visu",obselRetroRoom.type, obselRetroRoom.props);
            
            break;
        // activity on user video
        case TracageEvent.ACTIVITY_USER_VIDEO :
            // property the obsel for saving
            var propsActivityUserVideo:Object = new Object();
            // type obsel activity
            var typeObsel:String = event.typeActivity;
            // user id video only action on video panel, addcomment on TimeLine and obsel hasn't userId 
            if(event.userId)
            {
                propsActivityUserVideo[RetroTraceModel.USER_ID] = event.userId;
            }
            propsActivityUserVideo[RetroTraceModel.SYNC_ROOM_TRACE_ID] = parentTraceId;
            
            switch (typeObsel)
            {
                case RetroTraceModel.USER_VIDEO_ZOOM_MAX:
                    break;
                case RetroTraceModel.USER_VIDEO_VOLUME:
                    
                    propsActivityUserVideo[RetroTraceModel.VOLUME]=event.volume;
                    break;
                
                case RetroTraceModel.USER_VIDEO_ADD_COMMENT:

                    propsActivityUserVideo[RetroTraceModel.TEXT] = event.text;
                    propsActivityUserVideo[RetroTraceModel.FOR_USER_ID] = event.forUserId;
                    propsActivityUserVideo[RetroTraceModel.CLOSE_DIALOG] = event.closeDialog;
                    propsActivityUserVideo[RetroTraceModel.ORIGIN] = event.origin;
                    break;
                
            }
            
            TraceManager.trace("visu", typeObsel, propsActivityUserVideo);
            
            break;
        default :
            break;
        }
        
    }
    
}
}
