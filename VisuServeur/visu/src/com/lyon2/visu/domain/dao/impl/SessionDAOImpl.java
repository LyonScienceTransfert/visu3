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
package com.lyon2.visu.domain.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Vector;
import java.util.Date;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.lyon2.visu.domain.dao.SessionDAO;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.Activity;

import com.lyon2.utils.UserDate;

public class SessionDAOImpl extends SqlMapClientTemplate implements SessionDAO 
{
	/**
     * Logger
     */
    private static final Logger log = Red5LoggerFactory.getLogger(SessionDAOImpl.class,"visu");
	
	@SuppressWarnings("unchecked")
	public List<Session> getSessions() throws SQLException 
	{
		log.debug("getSessions");
		return (List<Session>)getSqlMapClient().queryForList("sessions.getSessions");
	}

	@SuppressWarnings("unchecked")
	public List<Session> getSessionPlans() throws SQLException 
	{
		log.debug("getSessionPlans");
		return (List<Session>)getSqlMapClient().queryForList("sessions.getSessionPlans");
	}
	
	@SuppressWarnings("unchecked")
	public List<Session> getSessionsByUser(Integer userId) throws SQLException 
	{
		log.debug("getSessionsByUser {}",userId);
		return (List<Session>)getSqlMapClient().queryForList("sessions.getSessionsByUser",userId);
	}

	@SuppressWarnings("unchecked")
	public List<Date> getDatesSessionsByUser(Integer userId) throws SQLException 
	{
		log.debug("getDatesSessionsByUser {}",userId);
		return (List<Date>)getSqlMapClient().queryForList("sessions.getDatesSessionsByUser",userId);
	}

	@SuppressWarnings("unchecked")
	public List<Session> getSessionsByDate(String date) throws SQLException 
	{
		log.debug("getSessionsByDate {}",date);
		return (List<Session>)getSqlMapClient().queryForList("sessions.getSessionsByDate",date);
	}

	@SuppressWarnings("unchecked")
	public List<Session> getSessionsByDateByUser(UserDate userDate) throws SQLException 
	{
		log.debug("getSessionsByDateByUser {}",userDate.toString());
		return (List<Session>)getSqlMapClient().queryForList("sessions.getSessionsByDateByUser",userDate);
	}
	
	public Session getSession(Integer id_session) throws SQLException 
	{
		log.debug("getSession {}",id_session);
		return (Session) getSqlMapClient().queryForObject("sessions.getSession",id_session);
	}

	@SuppressWarnings("unchecked")
	public List<Date> getDatesSessions() throws SQLException 
	{
		log.debug("getDatesSessions {}");
		return (List<Date>)getSqlMapClient().queryForList("sessions.getDatesSessions");
	}
		
	public Session insert(Session session) throws SQLException 
	{
		log.debug("insert {}", session);
		log.warn("date is : {}", session.toString());
		session.setId_session( (Integer)getSqlMapClient().insert("sessions.insert", session) ) ;
		return session;
	}

	public Session update(Session session) throws SQLException 
	{
		log.debug("update {}", session);
		getSqlMapClient().update("sessions.update",session);
		return session;
	}
	
	@SuppressWarnings("unchecked")
	public Integer delete(Session session) throws SQLException 
	{
		log.debug("delete {}",session);
		Integer id_session = session.getId_session();
		// delete Users from this session
		getSqlMapClient().delete("session_users.deleteSessionUserByIdSession",id_session);
		// delete Activities
		log.warn("deleting all activities of session id = {}",id_session);
		
		List<Activity> activities = getSqlMapClient().queryForList("activities.getSessionActivities", id_session);
		
		for(Activity activity : activities)
		{
			try {
				log.warn("before deleteing id activityElement is : {}",activity.getId_activity());
				getSqlMapClient().delete("activities_elements.deleteByIdActivity", activity.getId_activity());
				getSqlMapClient().delete("activities.delete", activity);
				log.warn("after deleteing id activityElement is : {}",activity.getId_activity());
				
			} catch (Exception e) {
				log.error("-- activities_elements.delete {}",e.getMessage());
				return 0;
			}
		}
		
		getSqlMapClient().delete("sessions.delete",session);
		return session.getId_session();
	}
	
}
