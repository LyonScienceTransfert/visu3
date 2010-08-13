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

public class ProfileDescription {
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column profile_descriptions.profile
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    private Integer profile;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column profile_descriptions.short_description
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    private String short_description;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column profile_descriptions.long_description
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    private String long_description;

    
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column profile_descriptions.profile
     *
     * @return the value of profile_descriptions.profile
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    public Integer getProfile() {
        return profile;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column profile_descriptions.profile
     *
     * @param id the value for profile_descriptions.profile
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    public void setProfile(Integer profile) {
        this.profile = profile;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column profile_descriptions.short_description
     *
     * @return the value of profile_descriptions.short_description
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    public String getShort_description() {
        return short_description;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column profile_descriptions.short_description
     *
     * @param name the value for profile_descriptions.short_description
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    public void setShort_description(String short_description) {
        this.short_description = short_description; 
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column profile_descriptions.long_description
     *
     * @return the value of profile_descriptions.long_description
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    public String getLong_description() {
        return long_description;
    }

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column profile_descriptions.long_description
     *
     * @param type the value for profile_descriptions.long_description
     *
     * @abatorgenerated Tue May 26 16:38:12 CEST 2009
     */
    public void setLong_description(String long_description) {
        this.long_description = long_description;
	}
	
	/**
     * toString will return String object representing the state of this 
     * valueObject. This is useful during application development, and 
     * possibly when application is writing object states in textlog.
     */
    public String toString() {
        StringBuffer out = new StringBuffer("\nclass ProfileDescription ");
        out.append("profile = " + this.profile + ", "); 
        out.append("short_description = " + this.short_description + ", ");  
        out.append("long_description = " + this.long_description );
        
        return out.toString();
    }
}
