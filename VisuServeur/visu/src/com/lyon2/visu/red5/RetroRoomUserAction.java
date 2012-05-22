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
package com.lyon2.visu.red5;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;
import org.slf4j.Logger;

import com.ithaca.domain.model.Obsel;
import com.lyon2.utils.ObselStringParams;
import com.lyon2.utils.UserDate;
import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;
import com.lyon2.utils.ObselType;

/**
 * 
 */
public class RetroRoomUserAction {
	private Application app;

	protected static final Logger log = Red5LoggerFactory.getLogger(
			RetroRoomUserAction.class, "visu2");

	public void test() {
		log.warn("TEST OVER OBSEL----------");
	}

	public void retroStartCancelEditCommentEvent(IConnection conn,
			String typeObsel, Long commentBeginTime, Long commentEndTime,
			Long commentId, String commentText, String typeCancel)
			throws SQLException {
		log.warn("======== retroStartCancelEditCommentEvent ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		String traceRetroId = (String) client.getAttribute("traceRetroId");
		String traceParentRetroId = (String) client
				.getAttribute("traceParentRetroId");

		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);
		paramsObsel.add(traceParentRetroId);
		paramsObsel.add(ObselType.COMMENT_BEGIN_DATE);
		paramsObsel.add(commentBeginTime.toString());
		paramsObsel.add(ObselType.COMMENT_END_DATE);
		paramsObsel.add(commentEndTime.toString());
		paramsObsel.add(ObselType.COMMENT_ID);
		paramsObsel.add(commentId.toString());
		paramsObsel.add(ObselType.COMMENT_VALUE);
		paramsObsel.add(commentText);
		if (!typeCancel.equals("void")) {
			paramsObsel.add(ObselType.COMMENT_EDIT_TYPE);
			paramsObsel.add(typeCancel);
		}

		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceRetroId, typeObsel, paramsObsel);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}
	}

	public void retroStartCreateCommentEvent(IConnection conn,
			String typeObsel, Long commentBeginTime, Long commentEndTime)
			throws SQLException {
		log.warn("======== retroStartCreateCommentEvent ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		String traceRetroId = (String) client.getAttribute("traceRetroId");
		String traceParentRetroId = (String) client
				.getAttribute("traceParentRetroId");

		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);
		paramsObsel.add(traceParentRetroId);
		paramsObsel.add(ObselType.COMMENT_BEGIN_DATE);
		paramsObsel.add(commentBeginTime.toString());
		paramsObsel.add(ObselType.COMMENT_END_DATE);
		paramsObsel.add(commentEndTime.toString());

		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceRetroId, typeObsel, paramsObsel);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}
	}

	public void retroRoomVideoEvent(IConnection conn, String typeObsel,
			Long timeVideo) throws SQLException {
		log.warn("======== retroRoomVideoEvent ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		String traceRetroId = (String) client.getAttribute("traceRetroId");
		String traceParentRetroId = (String) client
				.getAttribute("traceParentRetroId");
		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);
		paramsObsel.add(traceParentRetroId);
		paramsObsel.add(ObselType.VIDEO_TIME);
		paramsObsel.add(timeVideo.toString());
		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceRetroId, typeObsel, paramsObsel);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}
	}

	public void retroExploreObselEvent(IConnection conn, String typeObsel,
			Long obselId, String text) throws SQLException {
		log.warn("======== retroExploreObselEvent ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		String traceRetroId = (String) client.getAttribute("traceRetroId");
		String traceParentRetroId = (String) client
				.getAttribute("traceParentRetroId");
		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);
		paramsObsel.add(traceParentRetroId);
		paramsObsel.add(ObselType.OBSEL_ID);
		paramsObsel.add(obselId.toString());
		paramsObsel.add(ObselType.TOOL_TIP_VALUE);
		paramsObsel.add(text);
		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceRetroId, typeObsel, paramsObsel);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}
	}

	public void retroExpandTraceLineEvent(IConnection conn,
			Integer userIdTraceLine, String nameUserTraceLine,
			String avatarUserTraceLine, Boolean isTraceLineOpen)
			throws SQLException {
		log.warn("======== retroExploreObselEvent ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		String traceRetroId = (String) client.getAttribute("traceRetroId");
		String traceParentRetroId = (String) client
				.getAttribute("traceParentRetroId");
		String typeObsel = ObselType.RETRO_EXPAND_TRACE_LINE;
		if (isTraceLineOpen) {
			typeObsel = ObselType.RETRO_MINIMIZE_TRACE_LINE;
		}
		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);
		paramsObsel.add(traceParentRetroId);
		paramsObsel.add(ObselType.TRACE_SUBJECT_ID);
		paramsObsel.add(userIdTraceLine.toString());
		// FIXME : here can add info about user, last name , first name.... etc.
		paramsObsel.add(ObselType.USER_NAME);
		paramsObsel.add(nameUserTraceLine);
		paramsObsel.add(ObselType.USER_AVATAR);
		paramsObsel.add(avatarUserTraceLine);
		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceRetroId, typeObsel, paramsObsel);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}
	}

	public void retroObselTypeLineEvent(IConnection conn,
			Integer userIdTraceLine, String nameUserTraceLine,
			String avatarUserTraceLine, Boolean isAddObsel,
			int idTypeAddedObsel, int idTypeWidget) throws SQLException {
		log.warn("======== retroExploreObselEvent ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		String traceRetroId = (String) client.getAttribute("traceRetroId");
		String traceParentRetroId = (String) client
				.getAttribute("traceParentRetroId");
		String typeObsel = ObselType.RETRO_DELETE_OBSEL_TYPE_FROM_LINE;
		if (isAddObsel) {
			typeObsel = ObselType.RETRO_ADD_OBSEL_TYPE_TO_LINE;
		}
		String typeAddedObsel = "";
		switch (idTypeAddedObsel) {
		case 1:
			typeAddedObsel = ObselType.INSTRUCTIONS;
			break;
		case 2:
			typeAddedObsel = ObselType.KEYWORDS;
			break;
		case 3:
			typeAddedObsel = ObselType.DOCUMENT;
			break;
		case 4:
			typeAddedObsel = ObselType.MESSAGE;
			break;
		case 5:
			typeAddedObsel = ObselType.MARKER;
			break;
		}

		String typeWidget = "";
		switch (idTypeWidget) {
		case 0:
			typeWidget = ObselType.PLUS_MINUS_BUTTON;
			break;
		case 1:
			typeWidget = ObselType.CHEKBOX;
			break;
		}

		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);
		paramsObsel.add(traceParentRetroId);
		paramsObsel.add(ObselType.TRACE_SUBJECT_ID);
		paramsObsel.add(userIdTraceLine.toString());
		// FIXME : here can add info about user, last name , first name.... etc.
		paramsObsel.add(ObselType.USER_NAME);
		paramsObsel.add(nameUserTraceLine);
		paramsObsel.add(ObselType.USER_AVATAR);
		paramsObsel.add(avatarUserTraceLine);
		paramsObsel.add(ObselType.OBSEL_TYPE_NAME);
		paramsObsel.add(typeAddedObsel);
		paramsObsel.add(ObselType.UI_WIDGET);
		paramsObsel.add(typeWidget);
		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceRetroId, typeObsel, paramsObsel);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}
	}

	@SuppressWarnings("unchecked")
	public void getObselSessionExitSessionPause(IConnection conn)
			throws SQLException {
		log.warn("====== getObselSessionExitSessionPause ======");
		IClient client = conn.getClient();
		Integer userId = (Integer) client.getAttribute("uid");
		List<Obsel> listObselSessionExitSessionPause = null;
		try {
			String traceParam = "%-" + userId.toString() + "%";
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

	public void goInSalonRetro(IConnection conn) {
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		String nameUser = user.getLastname() + " " + user.getFirstname();
		log.warn("USER : {} IS JOIN SALON RETRO", nameUser);
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
		String traceParam = "%-" + "void" + "%";
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
		Object[] args = { result, sessionStartRecordingDate };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselClosedSession", args);
		}
	}

	public void addObselComment(IConnection conn, String traceComment,
			String traceParent, String typeObsel, String textComment,
			String beginTime, String endTime, Integer forUserId,
			Integer sessionId, Long timeStamp) {
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();
		log.warn("traceComment =  {}", traceComment);
		if (traceComment.equals("void")) {
			// generate traceId user
			traceComment = app.makeTraceId(userId);
		}
		// set timestamp
		if (timeStamp == 0) {
			Date date = new Date();
			timeStamp = date.getTime();
		}

		List<Object> paramsObsel = new ArrayList<Object>();
		paramsObsel.add("commentforuserid");
		paramsObsel.add(forUserId.toString());
		// add timeStamp
		paramsObsel.add("timestamp");
		paramsObsel.add(timeStamp.toString());
		paramsObsel.add("session");
		paramsObsel.add(sessionId.toString());
		paramsObsel.add("parentTrace");
		paramsObsel.add(traceParent.toString());
		paramsObsel.add("text");
		paramsObsel.add(textComment.toString());

		log.debug("paramsObsel {}", paramsObsel);
		Obsel obsel = null;
		try {
			obsel = app.setObsel(userId, traceComment, typeObsel, paramsObsel,
					"commentObsel", beginTime, endTime);
		} catch (SQLException sqle) {
			log.error("=====Errors===== {}", sqle);
		}

		Object[] args = { obsel, beginTime, endTime };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkAddObselComment", args);
		}
	}

	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}
	
	
	/**********************************************************************************/
	/**********************************************************************************/
	/**********************************************************************************/
	/**
	 * UNUSER 
	 * 
	 * @param conn
	 */
	public void walkOutSalonRetro(IConnection conn) {
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		String nameUser = user.getLastname() + " " + user.getFirstname();
		log.warn("USER : {} IS WALK OUT SALON RETRO", nameUser);
		Integer userId = user.getId_user();
		Obsel obsel = null;
		if (client.hasAttribute("traceRetroId")) {
			String traceRetroIdOutSession = (String) client
					.getAttribute("traceRetroId");
			String traceParentRetroId = (String) client
					.getAttribute("traceParentRetroId");
			List<Object> paramsObsel = new ArrayList<Object>();
			paramsObsel.add("parentTrace");
			paramsObsel.add(traceParentRetroId);
			paramsObsel.add("cause");
			paramsObsel.add("LEAVE_ROOM");
			try {
				obsel = app.setObsel(userId, traceRetroIdOutSession,
						ObselType.RETRO_ROOM_EXIT_RETROSPECTED_SESSION,
						paramsObsel);
			} catch (SQLException sqle) {
				log.error("=====Errors===== {}", sqle);
			}
			log
					.debug("------------- OBSEL SalonRetroSessionOut when out from salon retro  START---------------------");
			log.warn(obsel.toString());
			log
					.debug("------------- OBSEL SalonRetroSessionOut xhen out from salon retro END---------------------");
			// remove attribute
			client.removeAttribute("traceRetroId");
			client.removeAttribute("traceParentRetroId");
		}
	}

}
