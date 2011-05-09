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
package com.lyon2.visu.domain.model;

import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

public class Session {
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.id_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private Integer id_session;

	/**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.id_user
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
	private Integer id_user;
	
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.theme
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String theme;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.date
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private Date date_session;
	
	/**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.start_recording
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private Date start_recording;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.isModel
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private Boolean isModel;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.description
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String description;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.status_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private Integer status_session;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.duration_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */

    private Integer duration_session;
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column sessions.id_currentActivity
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
 
    private Integer id_currentActivity;
    
    private List<User> listUser;

    private List<Integer> attendeeIds;

    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.id_session
     *
     * @return the value of sessions.id_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public List<User> getListUser(){
    	return listUser;
    }
    public void setListUser(List<User> value) {
        this.listUser = value ;
    }
    
    public Integer getId_session() {
        return id_session;
    }
    public void setAttendeeIds(List<Integer> attendeeIds) {
		this.attendeeIds = attendeeIds;
	}
    public List<Integer> getAttendeeIds() {
		return attendeeIds;
	}

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.id_session
     *
     * @param id the value for sessions.id_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setId_session(Integer id_session) {
        this.id_session = id_session;
    }
	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.id_user
     *
     * @return the value of sessions.id_user
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
	public Integer getId_user() {
        return id_user;
    }

	/**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.id_user
     *
     * @param id the value for sessions.id_user
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
	
    public void setId_user(Integer id_user) {
        this.id_user = id_user;
    }
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.theme
     *
     * @return the value of sessions.theme
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getTheme() {
        return theme;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.theme
     *
     * @param theme the value for sessions.theme
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setTheme(String theme) {
        this.theme = theme == null ? null : theme.trim();
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.date
     *
     * @return the value of sessions.date
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Date getDate_session() {
        return date_session;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.date
     *
     * @param date the value for sessions.date
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setDate_session(Date date_session) {
        this.date_session = date_session;
    }

	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.start_recording
     *
     * @return the value of sessions.date
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Date getStart_recording() {
        return start_recording;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.start_recording
     *
     * @param date the value for sessions.date
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setStart_recording(Date start_recording) {
        this.start_recording = start_recording;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.isModel
     *
     * @return the value of sessions.isModel
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Boolean getIsModel() {
        return isModel;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.isModel
     *
     * @param isModel the value for sessions.isModel
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setIsModel(Boolean isModel) {
        this.isModel = isModel;
    }

	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.description
     *
     * @return the value of sessions.description
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getDescription() {
        return description;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.description
     *
     * @param description the value for sessions.description
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }

	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.status_session
     *
     * @return the value of sessions.status_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Integer getStatus_session() {
        return status_session;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.id_session
     *
     * @param id the value for sessions.id_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setStatus_session(Integer status_session) {
        this.status_session = status_session;
    }
    
	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.duration_session
     *
     * @return the value of sessions.duration_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Integer getDuration_session() {
        return duration_session;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.duration_session
     *
     * @param id the value for sessions.duration_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setDuration_session(Integer duration_session) {
        this.duration_session = duration_session;
    }
    
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column sessions.id_currentActivity
     *
     * @return the value of sessions.duration_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Integer getId_currentActivity() {
    	return id_currentActivity;
    }
    
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column sessions.id_currentActivity
     *
     * @param id the value for sessions.duration_session
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setId_currentActivity(Integer id_currentActivity) {
    	this.id_currentActivity = id_currentActivity;
    }

    /**
     * toString will return String object representing the state of this 
     * valueObject. This is useful during application development, and 
     * possibly when application is writing object states in textlog.
     */
    public String toString() {
        StringBuffer out = new StringBuffer("\nclass Session ");
        out.append("id_session = " + this.id_session + ", ");
		out.append("id_user = " + this.id_user + ", ");
        out.append("theme = " + this.theme + ", ");
        out.append("date_session = " + this.date_session + ", ");
        out.append("isModel = " + this.isModel + ", ");
		out.append("start_recording = " + this.start_recording + ", ");
		out.append("duration_session = " + this.duration_session + ", ");
		out.append("status_session = " + this.status_session + ", ");
		out.append("id_currentActivity = " + this.id_currentActivity + ", ");
		if(this.listUser != null)
		{
			out.append("listUsers size = " + this.listUser.size() +  " | ");			
		}else
		{
			out.append("listUsers is empty" +  " | ");		
		}
		if(this.attendeeIds != null)
		{
			out.append("attendeeIds size = " + this.attendeeIds.size() +  " | ");			
		}else
		{
			out.append("attendeeIds is empty" +  " | ");		
		}
        return out.toString();
    }
    
    @Override
    public boolean equals(Object obj) {
    	if (obj instanceof Session) {
			Session o = (Session) obj;
			return id_session.equals(o.id_session);
		}
    	return false;
    }
}
