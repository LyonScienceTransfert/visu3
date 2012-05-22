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

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import com.lyon2.visu.domain.dao.ActivityDAO;
import com.lyon2.visu.domain.model.Activity;
import com.lyon2.visu.service.ActivityService;

public class ActivityServiceImpl implements ActivityService 
{

	private Logger logger = Red5LoggerFactory.getLogger(ActivityServiceImpl.class,"visu");
	
	private ActivityDAO activityDao;
	
	public Integer deleteActivity(Activity activity) 
	{
		logger.debug("deleteActivity {}",activity);
		try 
		{
			return activityDao.delete(activity);
		}
		catch (Exception e) 
		{
			logger.error("-- delete activity " + e.getMessage());
		}
		return null;
	}

	public Activity getActivity(Integer id_activity) 
	{
		logger.debug("getActivity {}",id_activity);
		try 
		{
			return activityDao.getActivity(id_activity);
		}
		catch (Exception e) 
		{
			logger.error("-- getActivity " + e.getMessage());
		}
		return null;
	}

	public List<Activity> getSessionActivities(Integer id_session) 
	{
		logger.debug("getSessionActivities {}",id_session);
		try 
		{
			return activityDao.getSessionActivities(id_session);
		}
		catch (Exception e) 
		{
			logger.error("-- getSessionActivities " + e.getMessage());
		}
		return null;
	}

	public Activity addActivity(Activity activity) 
	{
		logger.debug("addActivity {}",activity);
		logger.warn("addActivity {}",activity.toString());
		try 
		{
			return activityDao.insert(activity);
		}
		catch (Exception e) 
		{
			logger.error("-- insertActivity " + e.getMessage());
		}
		return null;
	}

	public Activity updateActivity(Activity activity) 
	{
		
		logger.debug("updateActivity {}",activity);
		try 
		{
			return activityDao.update(activity);
		}
		catch (Exception e) 
		{
			logger.error("-- updateActivity " + e.getMessage());
		}
		return null;
	}

	public boolean saveActivitiesOrder(List<Activity> activities) {
		logger.debug("save activity order {}",activities);
		for(Activity activity : activities)
		{
			try {
				activityDao.update(activity);
			} catch (Exception e) {
				// TODO: handle exception
				logger.error("--save activity order {}",e.getMessage());
				return false;
			}
		}
		return true;
	}

	
	public ActivityDAO getActivityDao() {
		return activityDao;
	}

	public void setActivityDao(ActivityDAO activityDao) {
		this.activityDao = activityDao;
	}


}
