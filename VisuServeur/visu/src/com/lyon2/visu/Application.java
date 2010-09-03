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
package com.lyon2.visu;

/*
 * RED5 Open Source Flash Server - http://www.osflash.org/red5
 *
 * Copyright (c) 2006-2008 by respective authors (see below). All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 2.1 of the License, or (at your option) any later
 * version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with this library; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.Red5;
import org.red5.server.api.scheduling.IScheduledJob;
import org.red5.server.api.scheduling.ISchedulingService;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.stream.IBroadcastStream;
import org.slf4j.Logger;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.lyon2.utils.MailerFacade;
import com.lyon2.utils.UserDate;
import com.lyon2.visu.domain.model.Module;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.SessionUser;
import com.lyon2.visu.domain.model.User;
import com.lyon2.visu.red5.Red5Message;
import com.lyon2.visu.red5.RemoteAppEventType;
import com.lyon2.visu.red5.RemoteAppSecurityHandler;


/**
 * Sample application that uses the client manager.
 *
 * @author The Red5 Project (red5@osflash.org)
 */
public class Application extends MultiThreadedApplicationAdapter implements IScheduledJob
{

    private SqlMapClient sqlMapClient;
    private String smtpserver = "";

    private static Logger log = Red5LoggerFactory.getLogger( Application.class , "visu2" );


    public Application()
    {
        super();

        log.info("======== Instanciated {} ==========", Application.class.toString());
    }

    public void execute(ISchedulingService service)
    {
        // Make a dummy SQL request in order to keep the connection alive.
        try
        {
            sqlMapClient.queryForList("profile_descriptions.getProfils");
        }
        catch (Exception e)
        {
            log.error("Could not do a scheduled query : {}", e.toString());
        }
    }

    public boolean appStart(IScope app)
    {

        log.info("=== VisuServer start ===");
        log.debug("=== DEBUG test message ===");
        log.info("=== INFO test message ===");
        log.warn("=== WARN test message ===");
        log.error("=== ERROR test message ===");
        log.warn("=== SMTP Server: {} ===", getSmtpServer());

        registerSharedObjectSecurity( new RemoteAppSecurityHandler() );

        // Query the SQL server every hour, so the connection does not time out.
        this.addScheduledJob(60 * 60 * 1000, this);
        return super.appStart(app);
    }

    public boolean appConnect(IConnection conn, Object[] params)
    {
		if( !super.appConnect(conn, params))
		{
			return false;
		}
		
		// set all params in the List, framework "Mate+RTMP" send only one object 
		//User listParams = (User)params[0];
		
		
		log.warn("====appConnect====");
		log.debug("{}",params[0]);
		log.debug("{}",params[0].getClass());
		
		User user =null;
		
		try {
			user = (User) getSqlMapClient().queryForObject("users.getUserByUsernamePassword",params[0]);
			
		} catch (SQLException e) {
			user = null;
			log.error("recuperation du user impossible {}", e);
		}
		
		
        if (params == null || params.length == 0 || user == null)
        {
			// NOTE: "rejectClient" terminates the execution of the current method!
			rejectClient("Bad client information");
        }
        else
        {
        	//store client information
    		IClient client = conn.getClient();
    		client.setAttribute("user", user);
    		User u2 = (User) client.getAttribute("user");
    		log.debug("user attempt to log in {}",u2);
        }
				
        
        
        return true;
    }
	
	@SuppressWarnings("unchecked")
	public boolean roomConnect(IConnection conn, Object[] params)
    {
        if( !super.roomConnect(conn, params))
        {
            return false;
        }
		
		log.warn("====roomConnect====");
		User user = null;
		IClient client = conn.getClient();

		//recupération de l'utilisateur 
		if( client.hasAttribute("user") )
		{
			user = (User) client.getAttribute("user");
		}
		
        log.debug("*** User {} enter {}",user, conn.getScope().getName());
		
		

		Object[] args = { user };
		//Get the Client Scope
		IScope scope = conn.getScope();
		//notify all the client in the scope that one is join "Deck"/"Plateforme"
		invokeOnScopeClients(scope, "joinDeck", args);	
		
		// add info about client
		client.setAttribute("status", 2);


		UserDate userDate = new UserDate(user.getId_user(),getDateStringFormat_YYYY_MM_DD(Calendar.getInstance()));		
		List<Session> listSessionToday = null;
		try
		{
			log.debug("date today is {}",userDate);
			listSessionToday = (List<Session>)sqlMapClient.queryForList("sessions.getSessionsByDateByUser",userDate);
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions {}",e);
		}

		for(Session session : listSessionToday)
		{
			log.warn("{}", session);
		}
		

		// get role of logged user
		Integer roleUser = getRoleUser(user.getProfil());
		log.debug("{}",roleUser);
		// all modules
		List<Module> listModules = null;
		try
		{
			listModules = (List<Module>)sqlMapClient.queryForList("modules.getModules");
		} catch (Exception e) {
			log.error("Probleme lors du listing des modules {}", e);
		}
		
		// list module for logged user
		List<Module> listModulesUser = new ArrayList<Module>();
		log.debug("getListModules");
		for( Module module : listModules)
		{
			//log.warn("inside module = {}"+ module.toString());
			Integer profileUser = module.getProfileUser();
			if(roleUser <= profileUser)
			{
				listModulesUser.add(module);
			}
		}
		
		Object[] argsLoggedUser = {user , listModulesUser, listSessionToday};
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			sc.invoke("setLoggedUser", argsLoggedUser);
		} 
		
		log.warn("start userdata");
		UserDate userDateTest = new UserDate(5,"2010-07-20");
		//// TESTING
		List<Session> ls = null;
		try
		{
			ls = (List<Session>)sqlMapClient.queryForList("sessions.getSessionsByDateByUser",userDateTest);
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions {}", e);
		}
		
		for(Session session : ls)
		{
			log.debug("session = {}", session.toString());
		}
	/*
		log.warn("strat date");
		List<Date> dateSession = null;		
		try
		{
			dateSession = (List<Date>)sqlMapClient.queryForList("sessions.getDatesSessionsByUser",userId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des dates" + e);
		}
		log.warn("end date");
		for(Date date : dateSession)
		{
			log.warn("dates = {}", date.toString());
		}
		//// END TESTING
	*/	
        return true;
    }	
	
    public void appDisconnect(IConnection conn)
    {
        super.appDisconnect(conn);
		IClient client = conn.getClient();
		log.warn("{}",client);
		
		client.setAttribute("status", 1);
		
		User user = null;
		if (client.hasAttribute("user"))
		{
			user = (User)client.getAttribute("user"); 
		}
		Object [] args = {user};
		//Get the Client Scope
		IScope scope = conn.getScope();
		//notify all the client in the scope that one is disconnect from "Deck"/"Plateforme"
		invokeOnScopeClients(scope, "outDeck", args);
        log.warn("client {} deconnect",user.getId_user());
    }


	public void testApp(String name)
	{
		log.warn("===== testApp ===== Name module est : {}",name);
	}


    /**
     *
     * Get ClientInfo
     * @return clientInfo : map
     */
    public Map<String, String> getClientInfo(IConnection conn)
    {
        log.warn("getClientInfo client = {}", conn.getClient().getId() );
        IClient client = conn.getClient();

        Map<String,String> o = new HashMap<String, String>();
        o.put("id", client.getId());
       // o.put("username", (String)client.getAttribute("username"));		
        return o;
    }

    @SuppressWarnings("unchecked")
    public List<User> listUsers() throws SQLException
    {
        log.debug("listUsers");
        try
        {
            return (List<User>)sqlMapClient.queryForList("users.getUsers");
        } catch (Exception e) {
            log.error("Probleme lors du listing des utilisateurs {}",e);
        }
        return null;
    }

	//////
	@SuppressWarnings("unchecked")
	public void updateSessionUserApplication(IConnection conn, SessionUser sessionUser, SessionUser newSessionUser) throws SQLException 
	{
		log.warn("updateSessionUser {}", sessionUser);
		getSqlMapClient().delete("session_users.delete",sessionUser);
		getSqlMapClient().delete("session_users.delete",newSessionUser);
		getSqlMapClient().insert("session_users.insert",newSessionUser);
		Integer sessionId = newSessionUser.getId_session();
		log.warn("sessionId = {}",sessionId);
		
		
		Session session = (Session) getSqlMapClient().queryForObject("sessions.getSession",sessionId);
		List<User> listUsers = (List<User>) getSqlMapClient().queryForList("users.getUsersFromSession",sessionId);
		// FIXME
		// can check here connected users how in this session 
		Object[] args = {session, listUsers};
		//Get the Client Scope
		IScope scope = conn.getScope();
		//send message to all users for updating session with sessionId
		invokeOnScopeClients(scope, "checkUpdateSession", args);	
	}
	/////


	
    public void streamPublishStart(IBroadcastStream stream)
    {
        super.streamPublishStart(stream);
        log.warn("stream publish start: "+ stream.getPublishedName());

    }

    @Override
    public void streamBroadcastStart(IBroadcastStream stream)
    {
        super.streamBroadcastStart(stream);
        log.warn("stream broadcast start: "+ stream.getPublishedName());
    }

    /**
     *
     * Get getConnectedClients
     * @return Clients : List<String>
     */
	 public List<List<Object>> getConnectedClients()
	 {
		 List<List<Object>> userlist = new Vector<List<Object>>();
	 
		 for (IClient client : this.getClients())
		 {
			 List<Object> info = new Vector<Object>();
			// IConnection conn = (IConnection)client.getConnections().toArray()[0];
			// StringBuffer scopes = new StringBuffer();
			 Integer status = (Integer)client.getAttribute("status");
	 
			// for (IScope s: client.getScopes())
			// {
			//	 scopes.append(s.getName());
			//	 scopes.append(" ");
			// }
			 
			 
			 User user = (User) client.getAttribute("user");
			  
			// info.add(scopes.toString());
			// if (client.getAttribute("recording") == "yes")
			//	 status = User.RECORDING;
			// else if (client.getAttribute("live") == "yes" )
			//	 status = User.IN_A_ROOM;
			// else
			//	 status = User.ONLINE;
			 String userIdClient = client.getId();
			 
			 info.add(status);
             info.add(user);
			 info.add(userIdClient);

	 
			// IP client 
			// info.add(conn.getRemoteAddress());
			// info.add(conn.getConnectParams().toString() );
	 
			 userlist.add(info);
		 }
	  
		 return userlist;
	 }
	 
	
	public void sendPrivateMessage(Integer senderId, String message, Integer resiverId)
	{
		log.warn("====sendPrivateMessage====");
		log.warn("sender = {}",senderId);
		log.warn("message = {}",message);
		log.warn("resiver = {}",resiverId);

		User sender = null;
		try
		{
			sender = (User) getSqlMapClient().queryForObject("users.getUser",senderId);
			log.warn("sendPrivateMessage the user is = {}",sender.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		Object[] args = {message, sender};
		for( IClient client : this.getClients())
		{
			Integer userId = (Integer)client.getAttribute("uid");
			if(userId == resiverId)
			{
				//IConnection conn = (IConnection) client.getConnections().toArray()[0];
				IConnection conn = (IConnection)client.getAttribute("connection");
				if (conn instanceof IServiceCapableConnection) {
					IServiceCapableConnection sc = (IServiceCapableConnection) conn;
					sc.invoke("checkPrivateMessage", args);
					} 	
			}
		}
	
	}
	
	public void sendPublicMessage(IConnection conn, Integer senderId, String message)
	{
		log.warn("====sendPublicMessage====");
		log.warn("sender = {}",senderId);
		log.warn("message = {}",message);
		User sender = null;
		try
		{
			sender = (User) getSqlMapClient().queryForObject("users.getUser",senderId);
			log.warn("sendPublicMessage the user is = {}",sender.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		Object[] args = {message, sender};
		//Get the Client Scope
		IScope scope = conn.getScope();
		//send message to all users on "Deck"
		invokeOnScopeClients(scope, "checkPublicMessage", args);		
	}
	
	public void checkJoinSession(IConnection conn, Integer loggedUserId, String userIdClient)
	{
		log.warn("====checkJoinSession====");
		log.warn("loggedUserId = {}",loggedUserId.toString());
		log.warn("userIdClient = {}",userIdClient);
		// change users status 
		IClient client = conn.getClient();
		// TODO var static status
		client.setAttribute("status", 0);
		User loggedUser = null;
		try
		{
			loggedUser = (User) getSqlMapClient().queryForObject("users.getUser",loggedUserId);
			log.warn("userFirstname is = {}",loggedUser.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		
		Object[] args = {loggedUser, userIdClient};
		//Get the Client Scope
		IScope scope = conn.getScope();
		//send message to all users on "Deck"
		invokeOnScopeClients(scope, "joinSession", args);	
	}

	public void checkOutSession(IConnection conn, Integer loggedUserId)
	{
		log.warn("====checkOutSession====");
		log.warn("loggedUserId = {}",loggedUserId.toString());
		// change users status 
		IClient client = conn.getClient();
		// TODO var static status
		client.setAttribute("status", 2);
		User loggedUser = null;
		try
		{
			loggedUser = (User) getSqlMapClient().queryForObject("users.getUser",loggedUserId);
			log.warn("checkOutSession, userFirstname is = {}",loggedUser.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		
		Object[] args = {loggedUser, 2};
		//Get the Client Scope
		IScope scope = conn.getScope();
		//send message to all users on "Deck"
		invokeOnScopeClients(scope, "outSession", args);	
	}



    public void setSqlMapClient(SqlMapClient sqlMapClient)
    {
        this.sqlMapClient = sqlMapClient;
    }

    public SqlMapClient getSqlMapClient() {
        return sqlMapClient;
    }

	public void setSmtpServer(String server)
    {
        // Configure the MailerFacade
        MailerFacade.setSmtpServer(server);
        this.smtpserver = server;
    }

    public String getSmtpServer() {
        return this.smtpserver;
    }

	private String getDateStringFormat_YYYY_MM_DD(Calendar calendar) {	  
  	    // year today
	    Integer year = calendar.get(Calendar.YEAR);	    
	    String yearString = year.toString();	    
		// month today ++1, january = 0 ....december = 11
	    Integer month = calendar.get(Calendar.MONTH)+1;
		String monthString = month.toString();
		if(month < 10){
	    	monthString = "0"+monthString;
	    }
		// day
	    Integer day = calendar.get(Calendar.DAY_OF_MONTH);
	    String dayString = day.toString();
		if(day < 10){
	    	dayString = "0"+dayString;
	    }		
	    return yearString+"-"+monthString+"-"+dayString;
	}
	
	
	private Integer getRoleUser(String s){
		// FIXME can be better keep it in BD
		final double RESPONSABLE = 8191.0;
		// idem that "00000001111111111111"
		final double TUTEUR      = 511.0;
		// idem that "00000000000111111111"
		final double STUDENT     = 15;
		// idem that "00000000000000001111"
		s = s.trim();
		int l = s.length();
		String charZero= "0";
		double rightUser = 0;
		for (int i = 0; i < l; i++)
		{
			rightUser = rightUser + (s.charAt(i)-charZero.charAt(0)) * Math.pow(2, (s.length() - i - 1));
		}
		log.warn("rightUser = {}"+rightUser);
		Integer result = 0;
	    if (rightUser > RESPONSABLE) {
			result = 1;
		} else if (rightUser > TUTEUR) {
			result = 2;
		} else if (rightUser > STUDENT) {
			result = 3;
		} else {
			result = 4;
		}
		return result;
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
	
	/// will used ///////////////////////////////////////
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	public String testUser(Integer id)
	{
		log.warn("==== testUser ==== {}",id);
		return "hello";
	}

	@Override
    public void streamBroadcastClose(IBroadcastStream stream)
    {
        super.streamBroadcastClose(stream);
        log.warn("streamBroadcastClose: "+ stream.getPublishedName());
		
        IConnection current = Red5.getConnectionLocal();
        IScope room = current.getScope();
        IClient client = current.getClient();
		
        try {
            ISharedObject so = getSharedObject(room, "VisuServer");
			
            String username = (String) client.getAttribute("username");
            client.setAttribute("live", "no");
            client.setAttribute("recording", "no");
			
            so.setAttribute("message",
                            new Red5Message(
                                            RemoteAppEventType.STREAM_BROADCAST_CLOSE,
                                            stream.getPublishedName(),
                                            username,
                                            current.getClient().getId(),
                                            (Integer)current.getClient().getAttribute("uid")));
        }
        catch (NullPointerException ex) {
            log.info("stream broadcast close error - no more visuserver: ");
        }
		
    }
    /**
     *
     * Get getLiveClients
     * @return Clients UserName : List<String>
     */
    public List<Integer> getLiveClients(IConnection conn)
    {
        IScope room = conn.getScope();
		
        List<Integer> userlist = new Vector<Integer>();
		
        log.debug("client {}",conn.getClient());
        for (IClient client : room.getClients())
        {
            log.debug("\t{} live? {}", client,  client.getAttribute("live") );
			
            if( (String)client.getAttribute("live") == "yes" )
                userlist.add( (Integer)client.getAttribute("uid"));
        }
        return userlist;
    }
    public void testMethod(IConnection conn)
    {
        log.debug("-----");
        //log.debug( "conn {} ", conn);
        log.debug( "conn.getPath() {} ", conn.getPath() );
        log.debug( "conn.getScope().getName() {} ", conn.getScope().getName());
        log.debug( "conn.getScope().getPath() {} ", conn.getScope().getPath());
        log.debug( "conn.getScope().getContextPath() {} ", conn.getScope().getContextPath());
        log.debug("-----");
    }
	/**
     * Get streams. called from client
     * @return iterator of broadcast stream names
     */
    public List<String> getStreams(IConnection conn)
    {
        log.info("client "+ conn.getClient().getId() +" getStreams");
        return getBroadcastStreamNames(conn.getScope());
    }
	
    public void enterSalon(IConnection conn)
    {
        log.debug("on Air {} live",conn.getClient());
        IScope room = conn.getScope();
        IClient client = conn.getClient();
		
        ISharedObject so = getSharedObject(room, "VisuServer");
		
        String username= (String)client.getAttribute("username");
        client.setAttribute("live", "yes");
		
        so.setAttribute("message",
						new Red5Message(
										RemoteAppEventType.CLIENT_JOIN,
										username+" a rejoint le salon.",
										username,
										client.getId(),
										(Integer)client.getAttribute("uid")));
		
    }
	
    public void leaveSalon(IConnection conn)
    {
        IScope room = conn.getScope();
        IClient client = conn.getClient();
		
        ISharedObject so = getSharedObject(room, "VisuServer");
		
        String username= (String)client.getAttribute("username");
        client.setAttribute("live", "no");
        // FIXME: make sure that the recording is stopped ??
        client.setAttribute("recording", "no");
		
        so.setAttribute("message",
						new Red5Message(
										RemoteAppEventType.CLIENT_LEAVE,
										username+" a quitté le salon.",
										username,
										client.getId(),
										(Integer)client.getAttribute("uid")));
		
    }
	
	public void roomLeave(IClient client, IScope scope)
    {
        ISharedObject so = getSharedObject(scope, "VisuServer");
        String username = (String)client.getAttribute("username");
		
        log.warn("*** User " + username + " - " + client.getId() + " left " + scope.getName());
        
        if (so != null)
		{
			
			so.setAttribute("message",
							new Red5Message(RemoteAppEventType.CLIENT_LOGOUT,
											username + " a quitté l'application",
											username,
											client.getId(),
											(Integer)client.getAttribute("uid")));
		}
        else
		{
			log.debug("roomLeave: null so (scope, VisuServer)");
		}
        super.roomLeave(client, scope);
    }
	
}
