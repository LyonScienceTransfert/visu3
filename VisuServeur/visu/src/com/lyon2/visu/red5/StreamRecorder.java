/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
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
package com.lyon2.visu.red5;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Set;
import java.util.Vector;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.IClient;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.stream.ClientBroadcastStream;
import org.slf4j.Logger;

import com.lyon2.visu.Application;
 
/**
 * 
 *  Service d'enregistrement des streams video dans un salon
 *
 */
public class StreamRecorder 
{
	/**
	 * Start recording the publishing stream for the specified
	 * IConnection.
	 *
	 * @param conn
	 */

	private Application app;
  	
	protected static final Logger log = Red5LoggerFactory.getLogger(StreamRecorder.class, "visu" );
	
	public void startRecordRoom(IConnection conn, Integer session_id)
	{
        /* We store the record filenames, in order to notify clients */
        List<String> filenames = new Vector<String>();
        
		//Get the Client Scope
		IScope scope = conn.getScope();
		
		//notify all the client in the scope that it is Recording
		invokeOnScopeClients(scope, "startRecord", null);
	
		GregorianCalendar calendar = new GregorianCalendar(); 
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");

		String sDate = dateFormat.format(calendar.getTime());
		
		//record all the streams in a scope
        for (String name: app.getBroadcastStreamNames(scope))
		{			
			ClientBroadcastStream stream = (ClientBroadcastStream) app.getBroadcastStream(scope, name);
            /* Note about the record filename: since we generate a
             * filename based on current time in seconds, we could
             * possibly overwrite the file if there was a
             * stoprecord/startrecord sequence in less than 1
             * second. Given that in this case, the previous recorded
             * information would be useless anyway, we do not make any
             * effort to avoid that. */
			String filename = "record-" + sDate + "-" + session_id.toString() + "-" + stream.getConnection().getClient().getAttribute("uid").toString();

			log.debug("Start recording stream {} to file {} ", stream.getPublishedName(), filename);
			
			try 
			{
				// Save the stream to disk.
				stream.saveAs(filename, false);
                // SaveAs specifies the prefix. getSaveFilename will return path + prefix + suffix.
                // filenames.add(stream.getSaveFilename());

                // However, NetStream takes the generated basename,
                // without prefix or suffix. So return only this part.
                filenames.add(filename);
			} 
			catch (Exception e) 
			{
				log.error("Error while saving stream: " + stream.getName(), e);
			}
		}
        
        /* Notify all clients of the recorded filenames */

        /* Generate a multiline String with 1 filename per line */
        /* Normally, we could just pass filenames to
         * invokeOnScopeClients, but the java-as3 bridge has trouble
         * dealing with variable arguments mappings */
        StringBuffer sb = new StringBuffer();
        for (String f: filenames)
            {
                sb.append(f);
                sb.append("\n");
            }
        String[] args = { sb.toString() };
        invokeOnScopeClients(scope, "recordFilename", args);
        
        for (IClient client: scope.getClients())
            client.setAttribute("recording", "yes");
	}

	public void stopRecordRoom(IConnection conn)
	{
		
		IScope scope = conn.getScope();
		
		invokeOnScopeClients(scope, "stopRecord", null);
		
		for (String name: app.getBroadcastStreamNames(scope))
		{			
			ClientBroadcastStream stream = 
				(ClientBroadcastStream) app.getBroadcastStream(scope, name);
			stream.stopRecording();
			log.debug("Stop recording stream {}", stream.getName()); 
		}
        for (IClient client: scope.getClients())
            client.setAttribute("recording", "no");
	}
	
    private void invokeOnScopeClients(IScope scope, String method, Object[] arg)
	{
		Collection<Set<IConnection>> conCollection = scope.getConnections();
		for (Set<IConnection> cons : conCollection) 
		{
			for (IConnection client_cnx : cons) 
			{
				if (client_cnx != null) 
				{
					if (client_cnx instanceof IServiceCapableConnection) 
					{
						log.info("invoke {}->{}", client_cnx.getClient(), method);
						ServiceUtils.invokeOnConnection(client_cnx, method, arg); 
					}
		    				
				}
			}
		}
		
	}

	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}
	
 
}
