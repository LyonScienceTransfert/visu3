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
package com.lyon2.visu.service.impl;

import java.util.List;
import java.util.Date;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import com.lyon2.visu.domain.dao.SessionDAO;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.service.SessionService;

import com.lyon2.utils.UserDate;

public class SessionServiceImpl implements SessionService 
{

	private static Logger log = Red5LoggerFactory.getLogger(SessionServiceImpl.class,"visu");
	
	private SessionDAO sessionDao;
	
	public SessionDAO getSessionDao() {
		return sessionDao;
	}

	public void setSessionDao(SessionDAO sessionDao) {
		this.sessionDao = sessionDao;
	}

	public Session addSession(Session session)
	{
		log.debug("addSession {}", session);	
		try
		{
			return this.sessionDao.insert(session);
		}
		catch (Exception e)
		{
			log.error("-- addSession : " + e.getMessage());
		}
		return null;
	}

	public Integer deleteSession(Session session) 
	{
		log.debug("deleteSession {}", session);	
		try
		{
			return this.sessionDao.delete(session);
		}
		catch (Exception e)
		{
			log.error("-- deleteSession : " + e.getMessage());
		}
		return null;
	}

	public Session getSession(Integer id) 
	{
		log.debug("getSession {}", id);	
		try
		{
			return this.sessionDao.getSession(id);
		}
		catch (Exception e)
		{
			log.error("-- getSession : " + e.getMessage());
		}
		return null;
	}
	
	public List<Session> listSessions(Integer userId ) 
	{
		log.debug("listSessions of the userId : {}", userId);	
		try
		{
			if (userId == 0){
				return this.sessionDao.getSessions();
			}else {
				return this.sessionDao.getSessionsByUser(userId);
			}
			
		}
		catch (Exception e)
		{
			log.error("-- listSessions : " + e.getMessage());
		}
		return null;
	}
	
	public List<Date> getSessionsDatesByUser(Integer userId ) 
	{
		log.debug("getDatesSessionsByUser of the userId : {}", userId);	
		try
		{
			if (userId == 0){
				return this.sessionDao.getDatesSessions();
			}else {
				return this.sessionDao.getDatesSessionsByUser(userId);
			}
			
		}
		catch (Exception e)
		{
			log.error("-- getDatesSessionsByUser : " + e.getMessage());
		}
		return null;
	}

	public List<Session> getSessionsByDateByUser(Integer userId , String date) 
	{
		log.debug("getSessionsByDateByUser of the userId : {} from date {}", userId, date);	
		// create Object
		UserDate userDate = new UserDate(userId,date);	
		try
		{
			if (userId == 0){
				return this.sessionDao.getSessionsByDate(date);
			}else {
				return this.sessionDao.getSessionsByDateByUser(userDate);
			}
			
		}
		catch (Exception e)
		{
			log.error("-- getDatesSessionsByUser : " + e.getMessage());
		}
		return null;
	}
		
	public List<Session> getSessionPlans() 
	{
		log.debug("getSessionPlans");	
		try
		{
			return this.sessionDao.getSessionPlans();
		}
		catch (Exception e)
		{
			log.error("-- getSessionPlans : " + e.getMessage());
		}
		return null;
	}

	public Session updateSession(Session session)
	{
		log.debug("updateSession {}", session);	
		try
		{
			return this.sessionDao.update(session);
		}
		catch (Exception e)
		{
			log.error("-- updateSession : " + e.getMessage());
		}
		return null;
	}

}
