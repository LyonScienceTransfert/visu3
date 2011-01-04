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

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.IClient;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.stream.ClientBroadcastStream;
import org.slf4j.Logger;

import com.ithaca.domain.model.Obsel;
import com.lyon2.utils.ObselStringParams;
import com.lyon2.utils.UserDate;
import com.lyon2.visu.domain.model.Session;
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
  	
	protected static final Logger log = Red5LoggerFactory.getLogger(SessionInfo.class, "visu2" );
	
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
    public List<Session> getListSessionsAndPlans() throws SQLException
    {
        log.debug("getListSessions");
        try
        {
            return (List<Session>)app.getSqlMapClient().queryForList("sessions.getSessionsAndPlans");
        } catch (Exception e) {
            log.error("Probleme lors du listing des utilisateurs" + e);
        }
        return null;
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
		log.warn("====== getSessionByIdSalonRetro =========");
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
			String traceParam = "%-"+userId.toString()+">%";
			String refParam = "%:hasSession "+"\""+"1"+"\""+"%";
			
			ObselStringParams osp = new ObselStringParams(traceParam,refParam);	
			log.warn("==== refParam  {}",osp.getRefParam());
			log.warn("====  traceParam {}",osp.getTraceParam());

			listObselTraceId = (List<Obsel>)app.getSqlMapClient().queryForList("obsels.getTracesByUserId", osp);			
			for(Obsel obsel : listObselTraceId)
			{
				addTraceId(listTraceId, obsel);
			}	
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
			log.warn("empty BD, hasn't sessions,  exception case");	
			// hasn't trace , hasn't obsels
		}
		
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
	
	private void addTraceId(List <String> listTraceId, Obsel value)
	{
		String newTraceId = value.getTrace();
		for(String traceId : listTraceId)
		{
			if(traceId.equals(newTraceId))
			{
				return ;
			}
		}
		listTraceId.add(newTraceId);
		return;
	}
	
	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}
	
 
}
