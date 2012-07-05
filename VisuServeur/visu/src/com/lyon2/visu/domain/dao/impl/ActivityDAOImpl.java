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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.lyon2.visu.domain.dao.ActivityDAO;
import com.lyon2.visu.domain.model.Activity;
import com.lyon2.visu.domain.model.ActivityElement;
 

public class ActivityDAOImpl extends SqlMapClientTemplate implements ActivityDAO {

	/**
     * Logger
     */
    private static final Logger log = LoggerFactory.getLogger(ActivityDAOImpl.class);
	
	

	public Activity getActivity(Integer id_activity) throws SQLException 
	{
		log.debug("get activity by id_activity  {}", id_activity );
		return (Activity) getSqlMapClient().queryForObject("activities.getActivity",id_activity);		
	}

	@SuppressWarnings("unchecked")
	public List<Activity> getSessionActivities(Integer id_session) throws SQLException 
	{
		log.debug("getSessionActivities ", id_session );
		return  (List<Activity>)getSqlMapClient().queryForList("activities.getSessionActivities", id_session );
	}
	@SuppressWarnings("unchecked")
	public List<Activity> getActivities() throws SQLException 
	{
		log.debug("getActivities {} ");
		return  (List<Activity>)getSqlMapClient().queryForList("activities.getActivities" );
	}

	public Activity insert(Activity activity) throws SQLException 
	{
		log.debug("insert activty  {}", activity );
		Integer key = (Integer)getSqlMapClient().insert("activities.insert", activity);
		activity.setId_activity(key);
		return activity;
	}

	public Activity update(Activity activity) throws SQLException 
	{
		log.debug("update activity  {}", activity);
		getSqlMapClient().update("activities.update", activity);
		return activity;
	}
	
	@SuppressWarnings("unchecked")
	public Integer delete(Activity activity) throws SQLException 
	{
		log.debug("delete activity id  {}", activity);
		getSqlMapClient().delete("activities_elements.deleteByIdActivity", activity.getId_activity());
		getSqlMapClient().delete("activities.delete", activity);
		return activity.getId_activity();
	}
}
