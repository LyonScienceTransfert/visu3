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



import java.sql.SQLException;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Set;
import java.util.Vector;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.IClient;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.stream.ClientBroadcastStream;
import org.slf4j.Logger;

import com.lyon2.visu.domain.model.User;
import com.lyon2.visu.Application;

import com.ithaca.domain.model.Obsel;
 
/**
 * 
 *  Service d'enregistrement des streams video dans un salon
 *
 */
public class SharedInfo 
{
	/**
	 * Start recording the publishing stream for the specified
	 * IConnection.
	 *
	 * @param conn
	 */

	private Application app;
  	
	protected static final Logger log = Red5LoggerFactory.getLogger(SharedInfo.class, "visu" );
	
	@SuppressWarnings("unchecked")
	public void sendSharedInfo(IConnection conn, Integer typeInfo, String info, Integer[] listUser, String urlElement, Integer codeSharedAction, Integer senderDocumentUserId)
	{
		log.warn("======== sendSharedInfo ");
		log.warn("======== codeSharedAction = {}",codeSharedAction);
		if (codeSharedAction == 0)
		{
			// do nothing			
			return;
		}else 
		{
			// sender the info
			IClient sender = conn.getClient();
			IScope scope = conn.getScope();
			// get all shared clients
			List<IClient> listSharedUsers = new ArrayList<IClient>();
			Integer sharedUserId=0;
			int nbrSharedUsers = listUser.length;
			for (IClient client : scope.getClients())
				{
					for(int nUser=0; nUser < nbrSharedUsers; nUser++)
					{
						sharedUserId = listUser[nUser];
						Integer userId = (Integer)client.getAttribute("uid");
						int diff = sharedUserId - userId;
						if(diff == 0)
						{
							listSharedUsers.add(client);
							log.warn(" == added client {}",(String)client.getAttribute("id"));
						}	
					}
				}
			// all others shared info when session is recording, STATUS_RECORD: int = 1;
			if (codeSharedAction == 1)
			{	
				log.warn("=====typeInfo = {}",typeInfo);
				log.warn("=====info = {}",info);
				log.warn("===== listInteger ={}",listUser);
				String typeObselSend ="void";
				String typeObselReceive = "void";
				String namePropertyObsel ="void";
				String typeDocument = "void";
				Boolean sendObselToSender = true;
				switch (typeInfo) 
				{
				case 1 :
					typeObselSend ="SendInstructions";
					typeObselReceive ="ReceiveInstructions";
					namePropertyObsel = "instructions";
					break;
				case 2 :
					typeObselSend ="SendKeyword";
					typeObselReceive ="ReceiveKeyword";
					namePropertyObsel = "keyword";
					break;
					// FIXME SendDocument = image or video
				case 3 :
					typeObselSend ="SendDocument";
					typeObselReceive ="ReceiveDocument";
					namePropertyObsel = "text";
					typeDocument = "image";
					break;
				case 4 :
					typeObselSend ="SendDocument";
					typeObselReceive ="ReceiveDocument";
					namePropertyObsel = "text";
					typeDocument = "video";
					break;
				case 5 :
					typeObselSend ="SendChatMessage";
					typeObselReceive ="ReceiveChatMessage";
					namePropertyObsel = "content";
					break;
				case 6 :
					typeObselSend ="SetMarker";
					typeObselReceive ="ReceiveMarker";
					namePropertyObsel = "text";
					break;
				case 7 :
					//typeObselSend ="SetMarker";
					// sendObselToSender will be false , don't send obsel to sender
					sendObselToSender = false;
					typeObselReceive ="ReadDocument";
					namePropertyObsel = "text";
					typeDocument = "image";
					break;
				case 8 :
					//typeObselSend ="SetMarker";
					// sendObselToSender will be false , don't send obsel to sender
					sendObselToSender = false;
					typeObselReceive ="ReadDocument";
					namePropertyObsel = "text";
					typeDocument = "video";
					break;
				case 9 :
					// sendObselToSender will be false , don't send obsel to sender
					sendObselToSender = false;
					typeObselReceive ="ActivityStart";
					namePropertyObsel = "text";
					break;
				case 10 :
					// sendObselToSender will be false , don't send obsel to sender
					sendObselToSender = false;
					typeObselReceive ="ActivityStop";
					namePropertyObsel = "text";
					break;
				default: 
					log.warn("== havn't type {} pour {}",typeInfo,info);
				break;
				}
				
				Integer senderUserId = (Integer)sender.getAttribute("uid");
				if(sendObselToSender)
				{
					// add obsels only for type = 1 to 6 (the key is var "sendObselToSender")
					// add obsels "SendInstructions", "SendKeyword", "SendDocument" 
					List<Object> paramsObselSend= new ArrayList<Object>();
			   		paramsObselSend.add(namePropertyObsel);paramsObselSend.add(info);
			   		// add url sending documents
			   		if(typeInfo == 3 || typeInfo == 4)
			   		{
			   			paramsObselSend.add("url");paramsObselSend.add(urlElement);
			   			paramsObselSend.add("typedocument");paramsObselSend.add(typeDocument);
			   		}
					try
					{
						app.setObsel(senderUserId, (String)sender.getAttribute("trace"), typeObselSend, paramsObselSend);					
					}
						catch (SQLException sqle)
					{
						log.error("=====Errors===== {}", sqle);
					}
				}
				
				if(typeInfo == 9)
				{
					// update session with new currentActivityId
					Integer sessionId = (Integer)sender.getAttribute("sessionId");	
					// here urlElement is id of the currentActivity
					app.setCurrentActivitySession(sessionId, urlElement);					
				}
				Obsel obsel = null;
				// add obsels "ReceiveInstructions", "ReceiveKeyword", "ReceiveDocument"
				for(IClient sharedClient : listSharedUsers)
				{
					List<Object> paramsObselReceive= new ArrayList<Object>();
		   			paramsObselReceive.add(namePropertyObsel);paramsObselReceive.add(info);
		   			paramsObselReceive.add("sender");paramsObselReceive.add(senderUserId.toString());
		   			// add url sending/reading documents
			   		if(typeInfo == 3 || typeInfo == 4 || typeInfo == 7 || typeInfo == 8)
			   		{
			   			paramsObselReceive.add("url");paramsObselReceive.add(urlElement);
			   			paramsObselReceive.add("typedocument");paramsObselReceive.add(typeDocument);
			   			// here send obsel only if typeInfo ==7 ==8
			   			if (!sendObselToSender)
			   			{
			   				paramsObselReceive.add("senderdocument");paramsObselReceive.add(senderDocumentUserId.toString());
			   			}
			   		}
			   		
			   		if(typeInfo == 9 || typeInfo == 10)
			   		{
			   			paramsObselReceive.add("activityid");paramsObselReceive.add(urlElement);
			   		}
			   		
					try
					{
						obsel = app.setObsel((Integer)sharedClient.getAttribute("uid"), (String)sharedClient.getAttribute("trace"), typeObselReceive, paramsObselReceive);					
					}
						catch (SQLException sqle)
					{
						log.error("=====Errors===== {}", sqle);
					}		
					// send shared info to shared users
					Object[] args = {typeInfo, info, senderUserId, urlElement, obsel};
					IConnection connSharedUser = (IConnection)sharedClient.getAttribute("connection");
					if (connSharedUser instanceof IServiceCapableConnection) 
					{
						IServiceCapableConnection sc = (IServiceCapableConnection) connSharedUser;
						sc.invoke("checkSharedInfo", args);
					} 
				}	
			}else
			// only chat message before recording session, 
			{
				log.warn("======== send message chat without setting the obsels ");
				Integer senderUserId = (Integer)sender.getAttribute("uid");
				for(IClient sharedClient : listSharedUsers)
				{		
					// send shared info to shared users
					Object[] args = {typeInfo, info, senderUserId, urlElement, null};
					IConnection connSharedUser = (IConnection)sharedClient.getAttribute("connection");
					if (connSharedUser instanceof IServiceCapableConnection) 
					{
						IServiceCapableConnection sc = (IServiceCapableConnection) connSharedUser;
						sc.invoke("checkSharedInfo", args);
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
