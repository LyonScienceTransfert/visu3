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
package com.lyon2.visu.red5;



import java.sql.SQLException;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Set;
import java.util.Vector;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import java.util.List;
import java.util.Date;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.red5.server.api.IConnection;
import org.red5.server.api.scope.IScope;
import org.red5.server.api.IClient;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.stream.ClientBroadcastStream;

import com.ithaca.domain.model.Obsel;
import com.lyon2.utils.ObselStringParams;
import com.lyon2.utils.UserDate;
import com.lyon2.visu.domain.model.Activity;
import com.lyon2.visu.domain.model.ActivityElement;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.SessionUser;
import com.lyon2.visu.domain.model.SessionWithoutListUser;
import com.lyon2.visu.domain.model.User;
import com.lyon2.visu.Application;
 
/**
 * 
 *  Service d'enregistrement des streams video dans un salon
 *
 */
public class SessionInfo 
{
	/**
	 * Start recording the publishing stream for the specified
	 * IConnection.
	 *
	 * @param conn
	 */

	private Application app;
  	
	public Application getApp() {
		return app;
	}
	public void setApp(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

	protected static final Logger log = LoggerFactory.getLogger(SessionInfo.class);
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public void getSessionsDatesByUser(IConnection conn, Integer userId ) throws SQLException 
	{
		log.warn("======== getSessionsDatesByUser ");
		log.warn("=====userId = {}",userId);
		// get role of logged user
		IClient client = conn.getClient();
		User user = (User)client.getAttribute("user");
		Integer roleUser = app.getRoleUser(user.getProfil());
		List <Date> result = null;
		// check if user has rights admin or responsable
		if((roleUser == 2) || (roleUser == 1)){
			try
			{
				result = (List<Date>)app.getSqlMapClient().queryForList("sessions.getDatesSessions");
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		}else{
			try
			{
				result = (List<Date>)app.getSqlMapClient().queryForList("sessions.getDatesSessionsByUser",userId);
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		}
		log.warn("size = {}",result.size());
		List <String> listDateString= new ArrayList<String>();
		for (Date dateSession : result)
		{	
			// the date now is example : Tue Jan 05 00:00:00 BRST 2010
			// time 00:00:00 will give Jan 04
			// have to add one second for having date like this :  Tue Jan 05 00:00:01 BRST 2010
			dateSession.setSeconds(1);
			log.warn("sessionDate = {}",dateSession.toString());
			String year = String.valueOf(dateSession.getYear()+1900);
			String mount = String.valueOf(dateSession.getMonth());
			String day = String.valueOf(dateSession.getDate());
			String hour = String.valueOf(dateSession.getHours());
			String minute = String.valueOf(dateSession.getMinutes());
			String seconde = String.valueOf(dateSession.getSeconds());
			// add string 
			listDateString.add(year+"-"+mount+"-"+day+"-"+hour+"-"+minute+"-"+seconde);
		}
		Object[] args = {listDateString};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListDates", args);
			} 	
	}
	@SuppressWarnings("unchecked")
    public List<Session> getListSessionsAndPlans(IConnection conn) throws SQLException
    {
        log.debug("getListSessionsAndPlans");
        IClient client = conn.getClient();
		User user = (User)client.getAttribute("user");
		Integer roleUser = app.getRoleUser(user.getProfil());
		List<Session> listSession = null;
		// logged user responsable or admin
		if((roleUser == 2) || (roleUser == 1)){
			try
			{
				listSession = (List<Session>)app.getSqlMapClient().queryForList("sessions.getSessionsAndPlans");
			} catch (Exception e) {
				log.error("Probleme lors du listing des sessions" + e);
			}			
		}else if(roleUser == 3)
			// logged user is tuteur
		{
			Integer idUser = user.getId_user();
			try
			{
				listSession =  (List<Session>)app.getSqlMapClient().queryForList("sessions.getSessionsAndPlansByIdUser",idUser);
			} catch (Exception e) {
				log.error("Probleme lors du listing des session and plans for idUser = {}" + e,idUser.toString());
			}			
		}  
		for(Session session : listSession)
		{
			List<User> listUser = (List<User>) app.getSqlMapClient().queryForList("users.getUsersFromSession",session.getId_session());
			session.setListUser(listUser);
//			log.warn("Size of the users  = {}",listUser.size());	
		}
        return listSession;
    }
	
	@SuppressWarnings("unchecked")
	public Session addSessionUser(IConnection conn, SessionUser sessionUser) throws SQLException
	{
		log.warn("======== addSessionUser ");
		log.warn("addSessionUser {}", sessionUser.toString());
		Session session = null;
		app.getSqlMapClient().insert("session_users.insert",sessionUser);
		Integer sessionId = sessionUser.getId_session();
		session =  (Session)app.getSqlMapClient().queryForObject("sessions.getSession",sessionId);
		List<User> listUser = (List<User>) app.getSqlMapClient().queryForList("users.getUsersFromSession",sessionId);
		session.setListUser(listUser);
		return session;
	}
	
	@SuppressWarnings("unchecked")
	public Session removeSessionUser(IConnection conn, SessionUser sessionUser) throws SQLException
	{
		log.warn("======== remoteSessionUser ");
		log.warn("remoteSessionUser {}", sessionUser.toString());
		Session session = null;
		app.getSqlMapClient().delete("session_users.delete",sessionUser);
		Integer sessionId = sessionUser.getId_session();
		session =  (Session)app.getSqlMapClient().queryForObject("sessions.getSession",sessionId);
		List<User> listUser = (List<User>) app.getSqlMapClient().queryForList("users.getUsersFromSession",sessionId);
		session.setListUser(listUser);
		return session;
	}
	
	@SuppressWarnings("unchecked")
	public Session updateSession(IConnection conn, SessionWithoutListUser sessionWithoutListUser) throws SQLException
	{
		log.warn("======== updateSession ");
		try
		{
			app.getSqlMapClient().update("sessions.update",sessionWithoutListUser);
			log.warn("updated= {} ",sessionWithoutListUser.toString());
		} catch (Exception e) {
			log.error("Probleme lors du update des sessions" + e);
		}
		
		Integer sessionId = sessionWithoutListUser.getId_session();
		log.warn("sessionId = {}",sessionId.toString());
		List<User> listUser = null;
		Session session = null;
		try
		{
			session =  (Session)app.getSqlMapClient().queryForObject("sessions.getSession",sessionId);
			listUser = (List<User>) app.getSqlMapClient().queryForList("users.getUsersFromSession",sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des session " + e);
		}	
		
		log.warn("list user = {}",listUser.toString());
		log.warn("session = {}", session.toString());
		
		session.setListUser(listUser);
		
		// notification all users update session
		Object[] args = { session };
		// Get the Client Scope
		IScope scope = conn.getScope();
		// send message to all users on "Deck"
		app.invokeOnScopeClients(scope, "checkUpdateSession", args);
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public void addSession(IConnection conn, SessionWithoutListUser sessionWithoutListUser, int userId) throws SQLException
	{
		log.warn("======== addSession ");
		// id session for cloned
		Integer idSessionToClone  = sessionWithoutListUser.getId_session();
		
		IClient client = conn.getClient();
		int sessionId = 0;
		try
		{
			sessionId = (Integer)app.getSqlMapClient().insert("sessions.insert",sessionWithoutListUser);
			log.warn("updated= {} ",sessionWithoutListUser.toString());
		} catch (Exception e) {
			log.error("Probleme lors du update des sessions" + e);
		}
		log.warn("sessionId = {}",sessionId);
		if(userId != 0)
		{
			SessionUser sessionUser = new SessionUser();
			sessionUser.setId_session(sessionId);
			sessionUser.setMask(0);
			sessionUser.setId_user(userId);
			log.warn("sessionUser = {}",sessionUser.toString());
			app.getSqlMapClient().insert("session_users.insert",sessionUser);			
		}
		
		List<User> listUser = null;
		sessionWithoutListUser.setId_session(sessionId);
		try
		{
			listUser = (List<User>)app.getSqlMapClient().queryForList("users.getUsersFromSession",sessionId);			
		} catch (Exception e) {
			log.error("Probleme lors du listing des session " + e);
		}	
			
		// clone the session
		Session session = new Session();
		session.setDate_session(sessionWithoutListUser.getDate_session());
		session.setDescription(sessionWithoutListUser.getDescription());
		session.setDuration_session(sessionWithoutListUser.getDuration_session());
		session.setId_currentActivity(0);
		session.setId_session(sessionId);
		session.setId_user(sessionWithoutListUser.getId_user());
		session.setIsModel(sessionWithoutListUser.getIsModel());
		session.setStart_recording(sessionWithoutListUser.getStart_recording());
		session.setStatus_session(sessionWithoutListUser.getStatus_session());
		session.setTheme(sessionWithoutListUser.getTheme());	
		session.setListUser(listUser);
		
		// clone new session with all activity and all activityElements
		List<Activity> listActivityToClone= null;
		try
		{
			listActivityToClone = (List<Activity>)app.getSqlMapClient().queryForList("activities.getSessionActivities", idSessionToClone );
		} catch (Exception e) {
			log.error("Probleme lors du listing des activities " + e);
		}
		
		for(Activity activityToClone : listActivityToClone)
		{
			int idActivityToClone = activityToClone.getId_activity();
			// clone activity by activity
			Activity activity = activityToClone.cloneMe(sessionId);
			int idActivity = (Integer)app.getSqlMapClient().insert("activities.insert", activity);
			List<ActivityElement> listActivityElementToClone = null;
			try
			{
				listActivityElementToClone = (List<ActivityElement>)app.getSqlMapClient().queryForList("activities_elements.getActivityElements", idActivityToClone);			
			} catch (Exception e) {
				log.error("Probleme lors du listing des activitiyElement " + e);
			}
			for(ActivityElement activityElementToClone : listActivityElementToClone)
			{
				// clone activityElement by activityElement
				ActivityElement activityElement = activityElementToClone.cloneMe(idActivity);
				// add activityElement
				app.getSqlMapClient().insert("activities_elements.insert", activityElement);
			}
		}
		
		Object[] args = {session};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkAddSession", args);
		} 	
	}
	
	@SuppressWarnings("unchecked")
	public void getSessionActivities(IConnection conn, Integer sessionId) throws SQLException
	{
		log.warn("======== getSessionActivities ");
		
		IClient client = conn.getClient();
		// session activityElements
		List<Activity> listActivity= null;
		try
		{
			listActivity = (List<Activity>)app.getSqlMapClient().queryForList("activities.getSessionActivities", sessionId );
		} catch (Exception e) {
			log.error("Probleme lors du listing des activities " + e);
		}
		Object[] args = {listActivity};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkSessionActivities", args);
		} 	
	}
	
	@SuppressWarnings("unchecked")
	public void getActivityElements(IConnection conn, Integer activityId) throws SQLException
	{
		log.warn("======== getActivityElements ");
		
		IClient client = conn.getClient();
		List<ActivityElement> listActivityElement = null;
		try
		{
			listActivityElement = (List<ActivityElement>)app.getSqlMapClient().queryForList("activities_elements.getActivityElements", activityId);			
		} catch (Exception e) {
			log.error("Probleme lors du listing des activitiyElement " + e);
		}
		Object[] args = {listActivityElement, activityId};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkActivityElements", args);
		} 
	}
	
	public void updateActivity(Activity activity) throws SQLException 
	{
		log.debug("update activity  {}", activity);
		try
		{
			app.getSqlMapClient().update("activities.update", activity);
		} catch (Exception e) {
			log.error("Probleme lors du updating d'activitiy " + e);
		}
	}
	public void deleteActivity(Activity activity) throws SQLException 
	{
		log.debug("delete activity id  {}", activity);
		try
		{
			app.getSqlMapClient().delete("activities_elements.deleteByIdActivity", activity.getId_activity());
			app.getSqlMapClient().delete("activities.delete", activity);
		} catch (Exception e) {
			log.error("Probleme lors du deleting d'activitiy " + e);
		}
	}
	
	public void addActivity(IConnection conn, Activity activity) throws SQLException 
	{
		log.debug("insert activty  {}", activity );
		IClient client = conn.getClient();
		Integer key = 0;
		try
		{
			key = (Integer)app.getSqlMapClient().insert("activities.insert", activity);
		} catch (Exception e) {
			log.error("Probleme lors du adding d'activitiy " + e);
		}
		
		//activity.setId_activity(key);
		
		Object[] args = {key};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkAddActivity", args);
			} 	
	}
	
	public void updateActivityElement(ActivityElement activityElement) throws SQLException 
	{
		log.debug("update activityElement  {}", activityElement);
		try
		{
			app.getSqlMapClient().update("activities_elements.update", activityElement);
		} catch (Exception e) {
			log.error("Probleme lors du updating d'activitiyElement " + e);
		}
	}
	
	public void deleteActivityElement(ActivityElement activityElement) throws SQLException 
	{
		log.debug("delete activityElement  {}", activityElement);
		try
		{
			app.getSqlMapClient().delete("activities_elements.delete", activityElement);
		} catch (Exception e) {
			log.error("Probleme lors du updating d'activitiyElement " + e);
		}
	}
	
	public void addActivityElement(IConnection conn, ActivityElement activityElement) throws SQLException 
	{
		log.debug("insert activtyElement {}", activityElement );
		IClient client = conn.getClient();
		Integer key = 0;
		try
		{
			key = (Integer)app.getSqlMapClient().insert("activities_elements.insert", activityElement);
		} catch (Exception e) {
			log.error("Probleme lors du adding d'activitiy element " + e);
		}
		
		Object[] args = {activityElement.getId_activity(), key};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkAddActivityElement", args);
			} 	
	}
	
	@SuppressWarnings("unchecked")
	public void getSessionsByDateByUser(IConnection conn, Integer userId , String date) 
	{
		log.warn("======== getSessionsByDateByUser ");
		log.warn("=====userId = {}",userId);
		log.warn("=====date = {}",date);
		// get role of logged user
		IClient client = conn.getClient();
		User user = (User)client.getAttribute("user");
		Integer roleUser = app.getRoleUser(user.getProfil());
		List <Session> result = null;
		// create Object
		UserDate userDate = new UserDate(userId,date);
		// check if user has rights admin or responsable
		if((roleUser == 2) || (roleUser == 1)){
			try
			{
				result = (List<Session>)app.getSqlMapClient().queryForList("sessions.getSessionsByDate",date);
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		}else{
			try
			{
				result = (List<Session>)app.getSqlMapClient().queryForList("sessions.getSessionsByDateByUser",userDate);
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		}
		Object[] args = {result,date};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListSession", args);
			} 	
	}
	
	@SuppressWarnings("unchecked")
	public void getListClosedSessionByUser(IConnection conn)
	{
		log.warn("====== getListClosedSessionByUser =========");
		IClient client = conn.getClient();
		Integer userId = (Integer)client.getAttribute("uid");
		List <Session> result = null;
		try
		{
			result = (List<Session>)app.getSqlMapClient().queryForList("sessions.getClosedSessionsByUser",userId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		Object[] args = {result};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListClosedSession", args);
		} 		
	}
	
	@SuppressWarnings("unchecked")
	public void getListClosedSession(IConnection conn)
	{
		log.warn("====== getListClosedSession =========");
		IClient client = conn.getClient();
		List <Session> result = null;
		try
		{
			result = (List<Session>)app.getSqlMapClient().queryForList("sessions.getClosedSessions");
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		Object[] args = {result};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListClosedSession", args);
		} 		
	}
	
	@SuppressWarnings("unchecked")
	public void getSessionById(IConnection conn, Integer sessionId)
	{
		log.warn("====== getSessionById =========");
		IClient client = conn.getClient();
		Session session = null;
		// get session
		try {
			session = (Session) app.getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des session" + e);
		}
		Object[] args = {session};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkLastSession", args);
		} 	
	}
	
	public void getSessionByIdSalonRetro(IConnection conn, Integer sessionId)
	{
//		log.warn("====== getSessionByIdSalonRetro =========");
		IClient client = conn.getClient();
		Session session = null;
		// get session
		try {
			session = (Session) app.getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des session" + e);
		}
		log.warn("sessionId = {}, session = {} ",sessionId.toString(), session.toString());
		Object[] args = {session};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkSessionSalonRetro", args);
		} 	
	}
	
	@SuppressWarnings("unchecked")
	public void getSessionsByUser(IConnection conn){
		log.warn("====== getSessionsByUser =========");
		IClient client = conn.getClient();
		Integer userId = (Integer)client.getAttribute("uid");
		log.warn("userId = {}", userId.toString() );
		List <String> listTraceId = new ArrayList<String>();
		List <Obsel> listObselTraceId = null;
		List <Obsel> listResultObselOneBySession = new ArrayList<Obsel>();
		try
		{	
			String traceParam = "%-"+userId.toString();
			String refParam = "%:hasSession "+"\""+"1"+"\""+"%";
			
			ObselStringParams osp = new ObselStringParams(traceParam,refParam);	
			log.warn("==== refParam  {}",osp.getRefParam());
			log.warn("====  traceParam {}",osp.getTraceParam());

			listObselTraceId = (List<Obsel>)app.getSqlMapClient().queryForList("obsels.getTracesByUserId", osp);	
			
			log.warn("size ={}",listObselTraceId.size());

			for(Obsel obsel : listObselTraceId)
			{
//				log.warn("obsel of the user = {}",obsel.toString());
				addTraceId(listTraceId, obsel);
			}
			
			for(String str : listTraceId)
			{
				log.warn("traceID for user  = {}",str);	
			}
			
			
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
			log.warn("empty BD, hasn't sessions,  exception case");	
			// hasn't trace , hasn't obsels
		}
		
		log.warn("listTraceId ={}",listTraceId.size());
		
		List <Obsel> listObselByTraceId = new ArrayList<Obsel>(); 
		for(String traceId : listTraceId)
		{
			try
			{	
				listObselByTraceId	 = (List<Obsel>)app.getSqlMapClient().queryForList("obsels.getObselsSessionStartSessionEnterByTraceId", traceId);	
			} catch (Exception e) {
				log.error("Probleme lors du listing des sessions" + e);
				log.warn("empty BD, hasn't obsels,  exception case");	
			}
			
			log.warn("listObselByTraceId ={}",listObselByTraceId.size());
			
			if(listObselByTraceId.size() > 0)
			{
				Obsel firstObsel = listObselByTraceId.get(0);
				listResultObselOneBySession.add(firstObsel);				
			}
		}
		Object[] args = {listResultObselOneBySession};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselStartSession", args);
		} 	
	}
	
	@SuppressWarnings("unchecked")
	public Session deleteSession(IConnection conn, int sessionId, int userId) throws SQLException
	{
		log.warn("======== deleteSession ");
		log.warn("sessionId = {}",sessionId);
		// delete Users from this session
		app.getSqlMapClient().delete("session_users.deleteSessionUserByIdSession",sessionId);
		// delete Activities
		log.warn("deleting all activities of session id = {}",sessionId);
		
		List<Activity> activities = app.getSqlMapClient().queryForList("activities.getSessionActivities", sessionId);
		
		for(Activity activity : activities)
		{
			try {
				app.getSqlMapClient().delete("activities_elements.deleteByIdActivity", activity.getId_activity());
				app.getSqlMapClient().delete("activities.delete", activity);				
			} catch (Exception e) {
				log.error("-- activities_elements.delete {}",e.getMessage());
			}
		}
		
		app.getSqlMapClient().delete("sessions.delete",sessionId);		
		
		// notification all users removed from session
		Object[] args = { sessionId, userId };
		// Get the Client Scope
		IScope scope = conn.getScope();
		// send message to all users on "Deck"
		app.invokeOnScopeClients(scope, "checkDeleteSession", args);
		
		return null;
	}
	
	private void addTraceId(List <String> listTraceId, Obsel value)
	{
		String newTraceId = value.getTrace();
//		log.warn("newTraceId = {}",newTraceId);
		for(String traceId : listTraceId)
		{
//			log.warn("traceId = {}",traceId);
			
			if(traceId.equals(newTraceId))
			{
				return ;
			}
		}
		listTraceId.add(newTraceId);
		return;
	}
}
