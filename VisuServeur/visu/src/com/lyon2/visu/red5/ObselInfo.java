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
 * Service d'enregistrement des streams video dans un salon
 * 
 */
public class ObselInfo {
	private Application app;

	protected static final Logger log = Red5LoggerFactory.getLogger(
			ObselInfo.class, "visu2");

	@SuppressWarnings("unchecked")
	public void getObselSessionExitSessionPause(IConnection conn)
			throws SQLException {
		log.warn("====== getObselSessionExitSessionPause ======");
		IClient client = conn.getClient();
		Integer userId = (Integer) client.getAttribute("uid");
		List<Obsel> listObselSessionExitSessionPause = null;
		try {
			String traceParam = "%-" + userId.toString() + ">%";
			String refParam = "void";
			// log.warn("====refParam {}",refParam);
			ObselStringParams osp = new ObselStringParams(traceParam, refParam);
			listObselSessionExitSessionPause = (List<Obsel>) app
					.getSqlMapClient().queryForList(
							"obsels.getSessionExitSessionPauseObselsForUserId",
							osp);

		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
			log.warn("empty BD, exception case");

		}
		log.warn("====== numbers obsel = {}", listObselSessionExitSessionPause
				.size());
		Object[] args = { listObselSessionExitSessionPause };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselSessionExitSessionPause", args);
		}
	}

	@SuppressWarnings("unchecked")
	public List<Obsel> getObselSetMark(IConnection conn) throws SQLException {
		log.warn("====== getObselSetMark ======");
		List<Obsel> listObselSessionStart = null;
		try {
			listObselSessionStart = (List<Obsel>) app.getSqlMapClient()
					.queryForList("obsels.getObselSetMark");

		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
			log.warn("empty BD, exception case");

		}
		log.warn("====== numbers obsel = {}", listObselSessionStart.size());
		return listObselSessionStart;
	}

	@SuppressWarnings("unchecked")
	public void getActiveTraceUser(IConnection conn) throws SQLException {
		log.warn("======== getActiveTraceUser ");
		List<Obsel> result = null;
		// check if trace existe
		IClient client = conn.getClient();
		String trace = (String) client.getAttribute("trace");
		log.warn("======== trace the client = {}", trace);
		if (trace == null) {
			// user join session when session was stopped
			Integer userId = (Integer) client.getAttribute("uid");
			Integer session_id = (Integer) client.getAttribute("sessionId");
			List<Obsel> listObselSessionStart = null;
			try {
				String traceParam = "%-" + userId.toString() + ">%";
				String refParam = "%:hasSession " + "\""
						+ session_id.toString() + "\"" + "%";
				// log.warn("====refParam {}",refParam);
				ObselStringParams osp = new ObselStringParams(traceParam,
						refParam);
				listObselSessionStart = (List<Obsel>) app
						.getSqlMapClient()
						.queryForList(
								"obsels.getTraceIdByObselSessionStartSessionEnter",
								osp);
				if (listObselSessionStart != null) {
					Obsel obselSessionStart = listObselSessionStart.get(0);
					trace = obselSessionStart.getTrace();
				} else {
					// hasn't trace , hasn't obsels
					// CALLBACK
				}
			} catch (Exception e) {
				log.error("Probleme lors du listing des sessions" + e);
				log.warn("empty BD, exception case");
				// hasn't trace , hasn't obsels
				// CALLBACK
			}
		}
		log.warn("======== trace in BD = {}", trace);
		// get list obsel
		try {
			result = (List<Obsel>) app.getSqlMapClient().queryForList(
					"obsels.getTrace", trace);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}

		Object[] args = { result };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListActiveObsel", args);
		}
	}

	@SuppressWarnings("unchecked")
	public void getTraceUser(IConnection conn, String traceId, Integer sessionId)
			throws SQLException {
		log.warn("======== getTraceUser ");
		IClient client = conn.getClient();
		List<Obsel> result = null;
		Session session = null;
		// get list obsel
		try {
			result = (List<Obsel>) app.getSqlMapClient().queryForList(
					"obsels.getTrace", traceId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}
		// get session
		try {
			session = (Session) app.getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des session" + e);
		}
		Date sessionStartRecordingDate = session.getStart_recording();
		Long sessionStartRecording = sessionStartRecordingDate.getTime();
		Object[] args = { result, sessionStartRecording };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListUserObsel", args);
		}
	}

	@SuppressWarnings("unchecked")
	public void getSessionsByDateByUser(IConnection conn, Integer userId,
			String date) {
		log.warn("======== getSessionsByDateByUser ");
		log.warn("=====userId = {}", userId);
		log.warn("=====date = {}", date);
		// get role of logged user
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer roleUser = app.getRoleUser(user.getProfil());
		List<Session> result = null;
		// create Object
		UserDate userDate = new UserDate(userId, date);
		// check if user has rights admin or responsable
		if ((roleUser == 2) || (roleUser == 1)) {
			try {
				result = (List<Session>) app.getSqlMapClient().queryForList(
						"sessions.getSessionsByDate", date);
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		} else {
			try {
				result = (List<Session>) app.getSqlMapClient().queryForList(
						"sessions.getSessionsByDateByUser", userDate);
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		}
		Object[] args = { result, date };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListSession", args);
		}
	}

	@SuppressWarnings("unchecked")
	public void getObselByClosedSession(IConnection conn, Integer sessionId) {
		log.warn("======== getObselByClosedSession ");

		IClient client = conn.getClient();
		List<Obsel> result = null;
		Session session = null;
		String traceParam = "%-" + "void" + ">%";
		String refParam = "%:hasSession " + "\"" + sessionId.toString() + "\""
				+ "%";
		ObselStringParams osp = new ObselStringParams(traceParam, refParam);
		try {
			result = (List<Obsel>) app.getSqlMapClient().queryForList(
					"obsels.getObselBySessionId", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}
		// get session
		try {
			session = (Session) app.getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des session" + e);
		}
		Date sessionStartRecordingDate = session.getStart_recording();
		Long sessionStartRecording = sessionStartRecordingDate.getTime();
		Object[] args = { result, sessionStartRecording };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselClosedSession", args);
		}
	}

	public void addListObsel(List<Obsel> listObsel) {
		Integer nbrObsel = listObsel.size();
		log.warn("== nbrObsel = {}", nbrObsel.toString());
		for (Obsel obsel : listObsel) {
			try {
				app.getSqlMapClient().insert("obsels.insert", obsel);
			} catch (Exception e) {
				log.error("Probleme lors du adding obsel" + e);
			}
		}
	}

	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

}
