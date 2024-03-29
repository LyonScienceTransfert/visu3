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
package com.ithaca.domain.dao.impl;

import java.util.List;

import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.ithaca.domain.dao.ObselDAO;
import com.ithaca.domain.model.Obsel;
import com.lyon2.utils.ObselStringParams;

public class ObselDAOImpl extends SqlMapClientTemplate implements ObselDAO 
{

	/**
     * Logger
     */
    private static final Logger log = LoggerFactory.getLogger(ObselDAOImpl.class);

	@SuppressWarnings("unchecked")
	public List<String> getTraces() throws SQLException 
	{
		return (List<String>) getSqlMapClient().queryForList("obsels.getTraces");
		
	}

	@SuppressWarnings("unchecked")
	public List<Obsel> getTrace(String uri) throws SQLException 
	{
		return (List<Obsel>) getSqlMapClient().queryForList("obsels.getTrace", uri);	
	}

	public Obsel getObsel(Integer id) throws SQLException
	{
		return (Obsel) getSqlMapClient().queryForObject("obsels.getObsel", id);
	}

	public Obsel insert(Obsel obsel) throws SQLException 
	{
		Integer id = (Integer)getSqlMapClient().insert("obsels.insert", obsel);
		obsel.setId(id);
		return obsel; 
	}

	public Obsel update(Obsel obsel) throws SQLException 
	{
		getSqlMapClient().update("obsels.update",obsel);
		return obsel;
	}
	
	public Obsel delete(Obsel obsel) throws SQLException 
	{
		getSqlMapClient().delete("obsels.delete",obsel);
		return obsel;
	}
	
	@SuppressWarnings("unchecked")
    public List<Obsel> getSessionStartObselsForUserId(Integer uid) throws SQLException
    {
        // FIXME: we are hacking uid passing, which was not stored as
        // such in the table but is part of the trace field. When
        // redefining the table structure, id should be put in its own
        // field.
		return (List<Obsel>) getSqlMapClient().queryForList("obsels.getSessionStartObselsForUserId", "%-" + Long.toString(uid));
    }
	
	@SuppressWarnings("unchecked")
    public List<Obsel> getTextCommentsObselsForStartObsel(Long timeBegin) throws SQLException
    {
        // FIXME: we are hacking timeBegin passing, which was not stored as
        // such in the table but is part of the trace field. When
        // redefining the table structure, id should be put in its own
        // field.
        return (List<Obsel>) getSqlMapClient().queryForList("obsels.getTextCommentsObselsForStartObsel", "%" + Long.toString(timeBegin) + "%");
    }
	
	@SuppressWarnings("unchecked")
    public String getTraceIdByObselRoomEnter(ObselStringParams param) throws SQLException
    {
        // FIXME: we are hacking timeBegin passing, which was not stored as
        // such in the table but is part of the trace field. When
        // redefining the table structure, id should be put in its own
        // field.
       // return (String) getSqlMapClient().queryForObject("obsels.getTraceIdByObselRoomEnter", "%-" + tempTrace + ">%", "%:hasSession " + "\""+tempRdf+"\"%");
		return (String) getSqlMapClient().queryForObject("obsels.getTraceIdByObselRoomEnter", param);
    }

}
