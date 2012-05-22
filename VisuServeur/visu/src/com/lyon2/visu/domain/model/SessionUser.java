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
package com.lyon2.visu.domain.model;


public class SessionUser {
	
    /**
     * This field corresponds to the database column session_users.id_session_user
     */
    private Integer id_session_user;
	
    /**
     * This method returns the value of the database column session_users.id_session_user
     *
     * @param id the value for sessions.id_session_user
     */	
    public Integer getId_session_user() {
        return id_session_user;
    }
	
    /**
     * This method sets the value of the database column session_users.id_session_user
     *
     * @param id the value for sessions.id_session_user
	 *
     */
	public void setId_session_user(Integer id_session_user) {
        this.id_session_user = id_session_user;
    }
    /**
     * This field corresponds to the database column session_users.id_session
     */
    private Integer id_session;
	
    /**
     * This method returns the value of the database column session_users.id_session
     *
     * @param id the value for sessions.id_session
     */	
    public Integer getId_session() {
        return id_session;
    }
	
    /**
     * This method sets the value of the database column session_users.id_session
     *
     * @param id the value for sessions.id_session
	 *
     */
	public void setId_session(Integer id_session) {
        this.id_session = id_session;
    }
	
    /**
     * This field corresponds to the database column session_users.id_user
     */	
	private Integer id_user;
	
    /**
     * This method returns the value of the database column session_users.id_user
     *
     * @param id the value for session_users.id_user
     */		
	public Integer getId_user() {
        return id_user;
    }
	
    /**
     * This method sets the value of the database column session_users.id_user
     *
     * @param id the value for session_users.id_user
	 *
     */	
    public void setId_user(Integer id_user) {
        this.id_user = id_user;
    }

    /**
     * This field corresponds to the database column session_users.mask
     */
    private Integer mask;
	
    /**
     * This method returns the value of the database column session_users.mask
     *
     * @param id the value for session_users.mask
     */		
    public Integer getMask() {
        return mask;
    }

    /**
     * This method sets the value of the database column session_users.mask
     *
     * @param id the value for session_users.mask
	 *
     */	
    public void setMask(Integer mask) {
        this.mask = mask;
	}

	/**
     * toString will return String object representing the state of this 
     * valueObject. This is useful during application development, and 
     * possibly when application is writing object states in textlog.
     */
    public String toString() {
        StringBuffer out = new StringBuffer("\nclass SessionUser ");
        out.append("id_session = " + this.id_session + ", ");
		out.append("id_user = " + this.id_user + ", ");
        out.append("mask = " + this.mask + ", ");
        return out.toString();
    }

}
