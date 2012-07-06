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
package com.lyon2.visu;

/*
 * RED5 Open Source Flash Server - http://www.osflash.org/red5
 *
 * Copyright (c) 2006-2008 by respective authors (see below). All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 2.1 of the License, or (at your option) any later
 * version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with this library; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.Red5;
import org.red5.server.api.scheduling.IScheduledJob;
import org.red5.server.api.scheduling.ISchedulingService;
import org.red5.server.api.scope.IScope;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.stream.IBroadcastStream;
import org.red5.server.stream.ClientBroadcastStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ithaca.domain.model.Obsel;
import com.lyon2.utils.ObselStringParams;
import com.lyon2.utils.ObselType;
import com.lyon2.utils.SessionStatus;
import com.lyon2.utils.UserColor;
import com.lyon2.utils.UserDate;
import com.lyon2.utils.UserStatus;
import com.lyon2.utils.UtilFunction;
import com.lyon2.visu.domain.model.Module;
import com.lyon2.visu.domain.model.ProfileDescription;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.SessionUser;
import com.lyon2.visu.domain.model.SessionWithoutListUser;
import com.lyon2.visu.domain.model.User;
import com.lyon2.visu.ktbs.KtbsService;
import com.lyon2.visu.red5.Red5Message;
import com.lyon2.visu.red5.RemoteAppEventType;
import com.lyon2.visu.red5.RemoteAppSecurityHandler;

/**
 * Sample application that uses the client manager.
 * 
 * @author The Red5 Project (red5@osflash.org)
 */
public class Application extends MultiThreadedApplicationAdapter implements
		IScheduledJob {

	// sheduling interval is 5 min.
	private static Integer SHEDULING_INTERVAL_MSEC = 50 * 60 * 1000;

	private static Logger log = LoggerFactory.getLogger(Application.class);
	

	public Application() {
		super();

		log.info("======== Instanciated {} ==========", Application.class
				.toString());
	}

	// Injected by Spring
	private KtbsService ktbsService;
	private SqlMapClient sqlMapClient;
	private String smtpserver = "";

	//
	// setter/getter sqlMapClient
	//
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	//
	// setter/getter smtpsever
	//
	public String getSmtpserver() {
		return smtpserver;
	}
	public void setSmtpserver(String smtpserver) {
		this.smtpserver = smtpserver;
	}
	//
	// setter/getter ktbsService
	//
	public KtbsService getKtbsService() {
		return ktbsService;
	}

	public void setKtbsService(KtbsService ktbsService) {
		this.ktbsService = ktbsService;
	}

	@SuppressWarnings("unchecked")
	public void execute(ISchedulingService service) {
		// get list recording/paused sessions
		List<Session> listSession = null;
		try {
			listSession = (List<Session>) getSqlMapClient().queryForList(
					"sessions.getRecordingPausedSessions");
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		for (Session session : listSession) {
			Integer sessionId = session.getId_session();
			Date dateNow = new Date();
			// duration session in min.
			Integer sessionDuration = session.getDuration_session();
			// start recording session
			Date sessionStartTime = session.getStart_recording();
			Long durationReal = dateNow.getTime() - sessionStartTime.getTime();
			log.warn("==== session = {} , duration =  {}", session.getTheme(),
					Long.toString(durationReal / (1000 * 60)) + "...."
							+ sessionDuration.toString());
			// check really duration of the session
			if (durationReal > sessionDuration) {
				// TODO static variables
				Integer sessionStatus = SessionStatus.CLOSE;
				// checking if has user in session
				if (!hasUserInSession(sessionId)) {
					// close session
					setStatusSession(sessionId, sessionStatus, null);
					// notification for all users that session had closed
					Object[] args = { 0, 0, sessionId, sessionStatus };
					// send message to all users on "Deck"
					log.warn("============== setStatusClose {} ", args);
					invokeOnScopeClients(scope, "setStatusStop", args);
				}
			}
		}
		log.warn("============= SchedulingService END");
	}

	private boolean hasUserInSession(Integer sessionId) {
		for (IClient clientConnected : this.getClients()) {
			// get sessionId for connected user
			Integer userSessionId = (Integer) clientConnected
					.getAttribute("sessionId");
			Integer diff = sessionId - userSessionId;
			if (diff == 0) {
				log.warn("==== has user(s) in sessionId : {}", sessionId
						.toString());
				return true;
			}
		}
		return false;
	}

	public boolean appStart(IScope app) {

		log.info("=== VisuServer start ===");
		log.debug("=== DEBUG test message ===");
		log.info("=== INFO test message ===");
		log.warn("=== WARN test message ===");
		log.error("=== ERROR test message ===");
		log.warn("=== SMTP Server: {} ===", this.getSmtpserver());

		registerSharedObjectSecurity(new RemoteAppSecurityHandler());

		// Query the SQL server every hour, so the connection does not time out.
		this.addScheduledJob(SHEDULING_INTERVAL_MSEC, this);
		return super.appStart(app);
	}

	public boolean appConnect(IConnection conn, Object[] params) {
		log.warn("param 0 .... {} ", params[0]);

		if (!super.appConnect(conn, params)) {
			return false;
		}

		User user = null;
		try {
			user = (User) getSqlMapClient().queryForObject(
					"users.getUserByUsernamePassword", params[0]);
			IClient client = conn.getClient();
			client.setAttribute("user", user);
			client.setAttribute("uid", 0);
		} catch (SQLException e) {
			user = null;
			log.error("unknow user {}", e);
		}

		log.warn("======appConnect USER : {}", user.toString());

		if (params == null || params.length == 0 || user == null) {
			// NOTE: "rejectClient" terminates the execution of the current
			// method!
			log.info("Wrong credentials {}", params[0]);
			rejectClient("Wrong credentials");
			return false;
		}
		return true;
	}

	@SuppressWarnings("unchecked")
	public boolean roomConnect(IConnection conn, Object[] params) {
		if (!super.roomConnect(conn, params)) {
			return false;
		}

		log.warn("====roomConnect====");
		log.warn("*** User " + "username" + " - " + conn.getClient().getId()
				+ " enter " + conn.getScope().getName());

		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		int userId = user.getId_user();
		 
		// checking if have user with the same id
		log.warn("====roomConnect userId = {}", userId);
		for (IClient clientConnected : this.getClients()) {
			int userConnectedId = (Integer) clientConnected.getAttribute("uid");
			log
					.warn("======roomConnect userConnectedId = {} ",
							userConnectedId);
			if (userConnectedId == userId) {
				log.warn("====roomConnect : same user");
				if (conn instanceof IServiceCapableConnection) {
					IServiceCapableConnection sc = (IServiceCapableConnection) conn;
					sc.invoke("sameUserId");
				}
				rejectClient("Wrong credentials");
				return false;
			}
		}

		log.warn("=====roomConnect USER:  {}", user.toString());
		Object[] args = { user };
		// Get the Client Scope
		IScope scope = conn.getScope();
		// notify all the client in the scope that one is join
		// "Deck"/"Plateforme"
		invokeOnScopeClients(scope, "joinDeck", args);

		// add info about client
		client.setAttribute("uid", userId);
		client.setAttribute("connection", conn);
		client.setAttribute("id", client.getId());
		client.setAttribute("sessionId", 0);
		// set status Session
		client.setAttribute("status", SessionStatus.PAUSE);
		// set status User
		client.setAttribute("userStatus", UserStatus.CONNECTED);

		UserDate userDate = new UserDate(userId,
				getDateStringFormat_YYYY_MM_DD(Calendar.getInstance()));
		List<Session> listSessionToday = null;
		try {
			log.warn("date today is {}", userDate.toString());
			listSessionToday = (List<Session>) sqlMapClient.queryForList(
					"sessions.getSessionsByDateByUser", userDate);
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		// get role of logged user
		Integer roleUser = getRoleUser(user.getProfil());
		// list all modules
		List<Module> listModules = null;
		try {
			listModules = (List<Module>) sqlMapClient
					.queryForList("modules.getModules");
		} catch (Exception e) {
			log.error("Probleme lors du listing des modules" + e);
		}

		// list module for logged user
		List<Module> listModulesUser = new ArrayList<Module>();
		for (Module module : listModules) {
			Integer profileUser = module.getProfileUser();
			if (roleUser <= profileUser) {
				listModulesUser.add(module);
			}
		}
		// Récupération des profiles utilisateurs
		List<ProfileDescription> profiles = null;
		try {
			profiles = (List<ProfileDescription>) sqlMapClient
					.queryForList("profile_descriptions.getProfils");
		} catch (SQLException e) {
			log.error("Loading profileDescription failed {}", e);
		}

		List<Integer> listUserIdConnectedPlateforme = new ArrayList<Integer>();
		List<String> listIdUserClientPlateforme = new ArrayList<String>();
		List<Integer> listUserSessionIdPlateforme = new ArrayList<Integer>();
		List<Integer> listUserStatusPlateforme = new ArrayList<Integer>();
		
		for (IClient clnt : this.getClients()) {
			User usr = (User) clnt.getAttribute("user");
			listUserIdConnectedPlateforme.add((Integer)usr.getId_user());
			listIdUserClientPlateforme.add((String) clnt.getAttribute("id"));
			listUserSessionIdPlateforme.add((Integer) clnt.getAttribute("sessionId"));
			listUserStatusPlateforme.add((Integer) clnt.getAttribute("userStatus"));
		}

		List<User> listUser = null;
		try {
			listUser = (List<User>) getSqlMapClient().queryForList(
					"users.getUsers");
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}

		log.warn("  listUserConnectedPlateforme = {}",listUserIdConnectedPlateforme.toString());
		
		Object[] argsLoggedUser = { user, listModulesUser, listSessionToday,
				profiles, 
				listUserIdConnectedPlateforme,
				listIdUserClientPlateforme, 
				listUserSessionIdPlateforme,
				listUserStatusPlateforme, 
				listUser};
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			sc.invoke("setLoggedUser", argsLoggedUser);
		}
		return true;
	}

	public void appDisconnect(IConnection conn) {
		super.appDisconnect(conn);
		log.warn("====appDisconnect====");
		log.warn("*** User " + "username" + " - " + conn.getClient().getId()
				+ " out from plateforme" + conn.getScope().getName());
		// set timestamp
		Date date = new Date();
		Long timeStamp = date.getTime();
		IClient client = conn.getClient();
		User user = null;
		Integer userId = 0;
		if (client.hasAttribute("uid")) {
			userId = (Integer) client.getAttribute("uid");
			try {
				user = (User) getSqlMapClient().queryForObject("users.getUser",
						userId);
				log.warn("appDisconnect the user is = {}", user.getFirstname());
			} catch (Exception e) {
				log.error("Probleme lors du listing des utilisateurs" + e);
			}
		}
		// add obsel retro room exit
		if (client.hasAttribute("traceRetroId")) {
			String traceRetroIdOutSession = (String) client
					.getAttribute("traceRetroId");
			String traceParentRetroId = (String) client
					.getAttribute("traceParentRetroId");
			List<Object> paramsObselRetroRoom = new ArrayList<Object>();
			paramsObselRetroRoom.add(ObselType.SYNC_ROOM_TRACE_ID);
			paramsObselRetroRoom.add(traceParentRetroId);
			paramsObselRetroRoom.add(ObselType.CAUSE);
			paramsObselRetroRoom.add(ObselType.UNKNOWN);
			Obsel obsel = null;
			try {
				obsel = setObsel(userId, traceRetroIdOutSession,
						ObselType.RETRO_ROOM_EXIT,
						paramsObselRetroRoom);
			} catch (SQLException sqle) {
				log.error("=====Errors===== {}", sqle);
			}
		}
		// list user how staying in the session
		List<IClient> listStayingClient = new ArrayList<IClient>();
		// get sessionId of disconnected user
		Integer sessionId = (Integer) client.getAttribute("sessionId");
		// set obsel "RoomExit" if user was in the session and session in status
		// recording
		Integer statusClient = (Integer) client.getAttribute("status");
		if (sessionId != 0 && statusClient == 3) {
			Session session = null;
			try {
				session = (Session) getSqlMapClient().queryForObject(
						"sessions.getSession", sessionId);
			} catch (Exception e) {
				log.error("Probleme lors du listing des sessions" + e);
			}
			// set obsel "stopActivity" for user walk out from the recording
			// session only if activity was started
			Integer activityId = session.getId_currentActivity();
			if (activityId != 0) {
				List<Object> paramsObsel = new ArrayList<Object>();
				paramsObsel.add("text");
				paramsObsel.add("void");
				paramsObsel.add("sender");
				paramsObsel.add("0");
				paramsObsel.add("activityid");
				paramsObsel.add(activityId.toString());
				;
				try {
					Obsel obsel = setObsel(
							(Integer) client.getAttribute("uid"),
							(String) client.getAttribute("trace"),
							"ActivityStop", paramsObsel);
				} catch (SQLException sqle) {
					log.error("=====Errors===== {}", sqle);
				}
			}
			// set Obsel "SessionExit" to all connected user of this session
			for (IClient connectedClient : this.getClients()) {
				Integer sessionIdConnectedUser = (Integer) connectedClient
						.getAttribute("sessionId");
				if (sessionId.equals(sessionIdConnectedUser)) {
					List<Object> paramsObsel = new ArrayList<Object>();
					paramsObsel.add("uid");
					paramsObsel.add(userId.toString());
					// add timeStamp
					paramsObsel.add("timestamp");
					paramsObsel.add(timeStamp.toString());
					paramsObsel.add("session");
					paramsObsel.add(sessionId.toString());
					paramsObsel.add("typeExit");
					paramsObsel.add("disconnect");
					// add obsel "RoomExit"
					try {
						setObsel((Integer) connectedClient.getAttribute("uid"),
								(String) connectedClient.getAttribute("trace"),
								"SessionExit", paramsObsel);
					} catch (SQLException sqle) {
						log.error("=====Errors===== {}", sqle);
					}
					// add staying client to list
					Integer connectedClientId = (Integer) connectedClient
							.getAttribute("uid");
					Integer diff = userId - connectedClientId;
					if (diff != 0) {
						listStayingClient.add(connectedClient);
					}
				}
			}
		}

		// Get the Client Scope
		IScope scope = conn.getScope();
		// start recording file for users how stay in session
		this.updateRecordingWhenUserWalkOutSession(scope, listStayingClient);
		Object[] args = { user };
		// notify all the client in the scope that one is disconnect from
		// "Deck"/"Plateforme"
		invokeOnScopeClients(scope, "outDeck", args);
		log.warn("client {} deconnect", user.getId_user());
		boolean hasTrace = client.hasAttribute("trace");
		List<Object> paramsObselDisconnected = new ArrayList<Object>();
		paramsObselDisconnected.add("session");
		paramsObselDisconnected.add(sessionId.toString());
		// add obsel "Disconected" only if user has trace for this sessionId
		if (hasTrace) {
			try {
				if (user != null) {
					setObsel(userId, (String) client.getAttribute("trace"),
							"Disconnected", paramsObselDisconnected);
				}

			} catch (SQLException sqle) {
				log.error("=====Errors===== {}", sqle);
			}
		}
		// set Session status
		client.setAttribute("status", SessionStatus.CLOSE);
		// set status User
		client.setAttribute("userStatus", UserStatus.DISCONNECTED);
	}

	@SuppressWarnings("unchecked")
	public Obsel setObsel(final Integer subject, final String trace,
			final String typeObsel, final List<Object> paramsObsel,
			final String... traceType) throws SQLException {
		// log.warn("===== setObsel ===== Name module est : {}",listParams);
		// do not add obsel if hasn't traceId
		if (trace == null) {
			log.warn("setObsel(),  TraceId = null");
			return null;
		}
		// TODO : add function getHeadObsel
		Calendar clnd = Calendar.getInstance();

		Integer year = clnd.get(Calendar.YEAR);
		Integer month = clnd.get(Calendar.MONTH) + 1;
		String monthStr = month.toString();
		if (month < 10) {
			monthStr = "0" + monthStr;
		}
		Integer day = clnd.get(Calendar.DATE);
		String dayStr = day.toString();
		if (day < 10) {
			dayStr = "0" + dayStr;
		}
		Integer hour = clnd.get(Calendar.HOUR_OF_DAY);
		String hourStr = hour.toString();
		if (hour < 10) {
			hourStr = "0" + hourStr;
		}
		Integer min = clnd.get(Calendar.MINUTE);
		String minStr = min.toString();
		if (min < 10) {
			minStr = "0" + minStr;
		}
		Integer sec = clnd.get(Calendar.SECOND);
		String secStr = sec.toString();
		if (sec < 10) {
			secStr = "0" + secStr;
		}

		// get time in milliseconds for property hasBegin/hasEnd
		Long timeBeginInMilliseconde = clnd.getTimeInMillis();
		Long timeEndInMilliseconde = timeBeginInMilliseconde;
		Integer nbrTraceType = traceType.length;
		if (nbrTraceType > 0) {
			if (traceType[0].equals("commentObsel") || traceType[0].equals("markerObsel")) {
				String timeBeginString = traceType[1];
				timeBeginInMilliseconde = Long.parseLong(timeBeginString);
				log.warn("timeBeginInMilliseconde= {}", timeBeginInMilliseconde
						.toString());
				String timeEndString = traceType[2];
				timeEndInMilliseconde = Long.parseLong(timeEndString);
			}
		}

		List<String> tempList = new ArrayList<String>();
		tempList.add("@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .");
		tempList.add("@prefix ktbs: <http://liris.cnrs.fr/silex/2009/ktbs#> .");
		tempList.add("@prefix : <../visu/> .");
		tempList.add("");
		tempList.add("[] a :" + typeObsel + ";");
		tempList.add("ktbs:hasTrace " + "<" + trace + "> ;");
		tempList.add("ktbs:hasBegin " + timeBeginInMilliseconde + ";");
		tempList.add("ktbs:hasEnd " + timeEndInMilliseconde + ";");
		tempList.add("ktbs:hasSubject " + '"' + subject + '"' + ";");
		// checking trace type
		// String tempTraceType = "first";
		// Integer nbrTraceType = traceType.length;
		// if(nbrTraceType == 1)
		// {
		// tempTraceType = "second";
		// }
		// tempList.add("ktbs:hasTraceType "+'"'+tempTraceType+'"'+";");

		String strRdf = "";
		for (String tmp : tempList) {
			strRdf = strRdf + tmp + '\n';
		}

		if (paramsObsel != null) {
			String parValue = "";
			String valueProperty = "";
			int nbrParamsObsel = paramsObsel.size();
			for (int nPramObsel = 0; nPramObsel < nbrParamsObsel; nPramObsel = nPramObsel + 2) {
				// name property
				String nameProp = (String) paramsObsel.get(nPramObsel);
				String firstLetter = Character.toString(nameProp.charAt(0))
						.toUpperCase();
				String parName = ":has" + firstLetter + nameProp.substring(1);
				valueProperty = "";
				Object param = paramsObsel.get(nPramObsel + 1);
				if (param.getClass().getName() == "java.util.ArrayList") {
					for (String value : (List<String>) param) {
						valueProperty = valueProperty + '"' + value.toString()
								+ '"' + '\n' + '\t';
					}
					parValue = "(" + '\n' + '\t' + valueProperty + ")" + ";";
					strRdf = strRdf + parName + " " + parValue + '\n';
				} else {
					valueProperty = (String) paramsObsel.get(nPramObsel + 1);
					parValue = '"' + valueProperty + '"' + ";";
					strRdf = strRdf + parName + " " + parValue + '\n';
				}
			}
		}

		strRdf = strRdf + "." + '\n';

		Obsel obsel = new Obsel();
		obsel.setId(1);
		obsel.setTrace(trace);
		obsel.setType(typeObsel);
		obsel.setBegin(new Date());
		obsel.setRdf(strRdf);

		log.info("Adding Obsel to BD");
		getSqlMapClient().insert("obsels.insert", obsel);

		// safety test in case the ktsb would be deactivated
		// log.info("Delegating the KTBS collect to KtbsService");
		// ktbsService.sendToKtbs(null, subject, trace, typeObsel, paramsObsel,
		// traceType);

		return obsel;
	}

	/**
	 * 
	 * Get ClientInfo
	 * 
	 * @return clientInfo : map
	 */
	public void getClientInfo(IConnection conn) {
		log.warn("getClientInfo client = {}", conn.getClient().getId());
		IClient client = conn.getClient();

		Map<String, String> o = new HashMap<String, String>();
		o.put("id", client.getId());
		// set time server to the client flex
		Long timeNumber = new Date().getTime();
		o.put("timeNumber", Long.toString(timeNumber));
		Object[] obj = { o };
		IConnection connectionClient = (IConnection) client
				.getAttribute("connection");
		if (connectionClient instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connectionClient;
			sc.invoke("checkClientInfo", obj);
		}
	}
	/**
	 * Update password connected user
	 * 
	 * @param an encrypted version of the user password
	 */
	public void updatePassword(IConnection conn, String password) throws SQLException {
		log.warn("updatePassword");
		IClient client = conn.getClient();
		Integer userId = (Integer) client.getAttribute("uid");
		
		try {
			getSqlMapClient().update(
					"users.updatePassword", UtilFunction.createParams("userId", userId, "password", password));
		} catch (Exception e) {
			log.error("Probleme lors du update password " + e);
		}
		
	}
	@SuppressWarnings("unchecked")
	public List<User> listUsers() throws SQLException {
		log.debug("listUsers");
		try {
			return (List<User>) sqlMapClient.queryForList("users.getUsers");
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public void updateSessionUserApplication(IConnection conn,
			SessionUser sessionUser, SessionUser newSessionUser)
			throws SQLException {
		log.warn("updateSessionUser {}", sessionUser);
		getSqlMapClient().delete("session_users.delete", sessionUser);
		getSqlMapClient().delete("session_users.delete", newSessionUser);
		getSqlMapClient().insert("session_users.insert", newSessionUser);
		Integer sessionId = newSessionUser.getId_session();
		log.warn("sessionId = {}", sessionId);

		Session session = (Session) getSqlMapClient().queryForObject(
				"sessions.getSession", sessionId);
		List<User> listUsers = (List<User>) getSqlMapClient().queryForList(
				"users.getUsersFromSession", sessionId);
		// FIXME
		// can check here connected users
		Object[] args = { session, listUsers };
		// Get the Client Scope
		IScope scope = conn.getScope();
		// send message to all users for updating session with sessionId
		invokeOnScopeClients(scope, "checkUpdateSessionListUser", args);
	}

	@SuppressWarnings("unchecked")
	private void startPub(String clientIdOfStreamString) {
		log.warn("========== startPub");
		log.warn("=== clientIdOfStreamString = {}", clientIdOfStreamString);
		Integer clientIdOfStreamInt = Integer.parseInt(clientIdOfStreamString);

		IClient clientRecording = null;
		for (IClient client : this.getClients()) {
			String clientId = (String) client.getAttribute("id");
			log.warn("===clientId = {}", clientId);
			Integer clientIdInt = Integer.parseInt(clientId);
			int diff = clientIdInt - clientIdOfStreamInt;
			if (diff == 0) {
				clientRecording = client;
			}
		}
		log.warn("=== client id = {}", clientRecording.getAttribute("uid"));

		Date date = new Date();
		Long timeStamp = date.getTime();
		// this client start streaming
		Integer status = (Integer) clientRecording.getAttribute("status");
		log.warn("status = {}", status.toString());
		// find time start recording
		Integer sessionId = (Integer) clientRecording.getAttribute("sessionId");
		// check if recording only audio stream

		log.warn("===sessionId = {}", sessionId);
		if (sessionId == 0) {
			return;
		}

		Session session = null;
		try {
			session = (Session) getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		Date startRecording = session.getStart_recording();

		// check if mode recording for this client
		if (status == 3) {
			// Get the Client Scope
			IConnection conn = (IConnection) clientRecording
					.getAttribute("connection");
			IScope scope = conn.getScope();
			// start recording
			GregorianCalendar calendar = new GregorianCalendar();
			DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
			String sDate = dateFormat.format(calendar.getTime());
			log.warn("date = {}", sDate);
			// String clientRecordingId =
			// (String)clientRecording.getAttribute("id");
			// ClientBroadcastStream stream = (ClientBroadcastStream)
			// getBroadcastStream(scope, clientRecordingId);

			// get time start recording for sending this to client flex(for
			// creation the obsel "SessionOut")
			// "joinRecordingSession", signature the type of recording, can see too types: "start"/"join" 
			Object[] timeStartRecording = { Calendar.getInstance()
					.getTimeInMillis(), "joinRecordingSession" };
			// call client that start recording
			IConnection connectionClient = (IConnection) clientRecording
					.getAttribute("connection");
			log.warn("startRecording-from Application");
			if (connectionClient instanceof IServiceCapableConnection) {
				IServiceCapableConnection sc = (IServiceCapableConnection) connectionClient;
				sc.invoke("startRecording", timeStartRecording);
			}

			// String filename = "record-" + sDate + "-" +
			// clientRecording.getAttribute("sessionId").toString() + "-" +
			// clientRecording.getAttribute("uid").toString();

			Integer userId = (Integer) clientRecording.getAttribute("uid");
			Map<Integer, Integer> listUserCodeColor = new HashMap<Integer, Integer>();
			List<Obsel> listObselSystemSessionStart = null;
			String typeObselSystem = "";
			String traceSystem = "";
			// try find obsel the system
			try {
				// get list obsel "SystemSessionStart"
				String traceParam = "%-0%";
				String refParam = "%:hasSession " + "\"" + sessionId.toString()
						+ "\"" + "%";
				ObselStringParams osp = new ObselStringParams(traceParam,
						refParam);
				listObselSystemSessionStart = (List<Obsel>) getSqlMapClient()
						.queryForList(
								"obsels.getTraceIdByObselSystemSessionStartSystemSessionEnter",
								osp);
				if (listObselSystemSessionStart != null) {
					// get traceId the system
					Obsel obselSystemSessionStart = listObselSystemSessionStart
							.get(0);
					traceSystem = obselSystemSessionStart.getTrace();
					typeObselSystem = "SystemSessionEnter";
					// set userColor
					listUserCodeColor = UserColor
							.setMapUserColor(listObselSystemSessionStart);
				} else {
					// generate traceId the system, "0" => owner the trace ,
					// here it's the system
					traceSystem = makeTraceId(0);
					typeObselSystem = "SystemSessionStart";
				}
			} catch (Exception e) {
				// generate traceId the system, "0" => owner the trace , here
				// it's the system
				traceSystem = makeTraceId(0);
				typeObselSystem = "SystemSessionStart";
			}

			// find traceId of this session using obsels type "SessionStart"
			// "SessionEnter"

			List<Obsel> listObselSessionStart = null;
			try {
				// String traceParam = "%-"+userId.toString()+"%";
				String traceParam = "%-" + userId.toString();
				String refParam = "%:hasSession " + "\"" + sessionId.toString()
						+ "\"" + "%";
				log.warn("====refParam {}", refParam);
				ObselStringParams osp = new ObselStringParams(traceParam,
						refParam);
				// log.warn("=====OSP : {}",osp.toString());
				listObselSessionStart = (List<Obsel>) getSqlMapClient()
						.queryForList(
								"obsels.getTraceIdByObselSessionStartSessionEnter",
								osp);
				if (listObselSessionStart != null) {
					Obsel obselSessionStart = listObselSessionStart.get(0);
					String trace = obselSessionStart.getTrace();
					clientRecording.setAttribute("trace", trace);
				} else {
					// generate traceId
					String trace = makeTraceId(userId);
					clientRecording.setAttribute("trace", trace);
					log.warn("empty BD, ListObsel = null");
				}
			} catch (Exception e) {
				log.error("Probleme lors du listing des sessions" + e);
				// generate traceId
				String trace = makeTraceId(userId);
				clientRecording.setAttribute("trace", trace);
				log.warn("empty BD, exception case");
			}

			List<IClient> listPresentsRecordingUsers = new ArrayList<IClient>();
			List<String> listPresentsIdUsers = new ArrayList<String>();
			List<String> listPresentsAvatarUsers = new ArrayList<String>();
			List<String> listPresentsNameUsers = new ArrayList<String>();
			List<String> listPresentsColorUsers = new ArrayList<String>();
			List<String> listPresentsColorUsersCode = new ArrayList<String>();

			for (IClient client : this.getClients()) {
				Integer sessionIdConnectedUser = (Integer) client
						.getAttribute("sessionId");
				Integer statusConnectedUser = (Integer) client
						.getAttribute("status");
				User user = (User) client.getAttribute("user");
				Integer diff = sessionId - sessionIdConnectedUser;
				if (diff == 0 && statusConnectedUser == 3) {

					listPresentsRecordingUsers.add(client);
					// set id recording users
					Integer userIdRecordingUser = (Integer) client
							.getAttribute("uid");
					// have to find all recording users
					listPresentsIdUsers.add(userIdRecordingUser.toString());
					listPresentsAvatarUsers.add(user.getAvatar());
					listPresentsNameUsers.add(user.getFirstname());
					// add code color
					Integer codeColorUser = 0;
					if (listUserCodeColor.containsKey(userIdRecordingUser)) {
						// get color code for this user
						codeColorUser = listUserCodeColor
								.get(userIdRecordingUser);
					} else {
						Integer colorCodeMax = UserColor
								.getMaxCodeColor(listUserCodeColor);
						codeColorUser = colorCodeMax + 1;
						listUserCodeColor.put(userIdRecordingUser,
								codeColorUser);
					}

					listPresentsColorUsersCode.add(codeColorUser.toString());

				}
			}

			// set Obsel "SystemSessionStart"/"SystemSessionEnter"
			List<Object> paramsObselSystem = new ArrayList<Object>();
			paramsObselSystem.add("session");
			paramsObselSystem.add(sessionId.toString());
			paramsObselSystem.add("presentids");
			paramsObselSystem.add(listPresentsIdUsers);
			paramsObselSystem.add("presentcolorscode");
			paramsObselSystem.add(listPresentsColorUsersCode);
			try {
				Obsel obsel = setObsel(0, traceSystem, typeObselSystem,
						paramsObselSystem);
			} catch (SQLException sqle) {
				log.error("=====Errors===== {}", sqle);
			}

			// set Obsel "SessionEnter" and "RecordFileName" to all connected
			// user of this session
			// timeBegin the obsel SessionStart
			// get obsel SessinEnter of the "clientRecording"
			Obsel obselSessionEnterOfRecordingClient = null;
			for (IClient connectedClient : listPresentsRecordingUsers) {
				List<Object> paramsObselSessionEnter = new ArrayList<Object>();
				paramsObselSessionEnter.add("uid");
				paramsObselSessionEnter.add(userId.toString());
				paramsObselSessionEnter.add("session");
				paramsObselSessionEnter.add(sessionId.toString());
				paramsObselSessionEnter.add("sessionTheme");
				paramsObselSessionEnter.add(session.getTheme());
				paramsObselSessionEnter.add("presentids");
				paramsObselSessionEnter.add(listPresentsIdUsers);
				paramsObselSessionEnter.add("presentavatars");
				paramsObselSessionEnter.add(listPresentsAvatarUsers);
				paramsObselSessionEnter.add("presentnames");
				paramsObselSessionEnter.add(listPresentsNameUsers);
				paramsObselSessionEnter.add("presentcolorscode");
				paramsObselSessionEnter.add(listPresentsColorUsersCode);
				paramsObselSessionEnter.add("presentcolors");
				paramsObselSessionEnter.add(listPresentsColorUsers);
				// add timeStamp
				paramsObselSessionEnter.add("timestamp");
				paramsObselSessionEnter.add(timeStamp.toString());

				// add obsel "SessionEnter"
				try {
					Obsel obsel = setObsel((Integer) connectedClient
							.getAttribute("uid"), (String) connectedClient
							.getAttribute("trace"), "SessionEnter",
							paramsObselSessionEnter);
					// get obsel for sending to client Flex
					if (clientRecording == connectedClient) {
						obselSessionEnterOfRecordingClient = obsel;
					}
				} catch (SQLException sqle) {
					log.error("=====Errors===== {}", sqle);
				}
			}
			this.updateRecordingWhenUserWalkOutSession(scope,
					listPresentsRecordingUsers);

			// set obsel start activity for user join the recording session only
			// if activity was start by other user
			Integer activityId = session.getId_currentActivity();
			if (activityId != 0) {
				List<Object> paramsObsel = new ArrayList<Object>();
				paramsObsel.add("text");
				paramsObsel.add("void");
				paramsObsel.add("sender");
				paramsObsel.add("0");
				paramsObsel.add("activityid");
				paramsObsel.add(activityId.toString());
				;
				try {
					Obsel obsel = setObsel((Integer) clientRecording
							.getAttribute("uid"), (String) clientRecording
							.getAttribute("trace"), "ActivityStart",
							paramsObsel);
				} catch (SQLException sqle) {
					log.error("=====Errors===== {}", sqle);
				}
			}

			log.warn(" ==== obselSessionEnterOfRecordingClient = {}",
					obselSessionEnterOfRecordingClient.toString());
			// notification for all users that user has status "recording" ,
			// send here date start recording == null , every users has this
			// date after start recording
			// last param of the list the "args" => obsel SessionEnter of the
			// recording client
			Object[] args = { (Integer) clientRecording.getAttribute("uid"),
					(Integer) clientRecording.getAttribute("userStatus"),
					(Integer) clientRecording.getAttribute("sessionId"),
					startRecording, obselSessionEnterOfRecordingClient };
			// send message to all users on "Deck"
			log.warn("== setStatusRecording {} ", args);
			invokeOnScopeClients(scope, "setStatusRecording", args);
		}

		// try send list of the obsels to client flex
		List<Obsel> result = null;
		// check if trace existe
		// IClient client = conn.getClient();
		String trace = (String) clientRecording.getAttribute("trace");
		log.warn("======== trace the client = {}", trace);
		if (trace == null) {
			// user join session when session was stopped
			Integer userId = (Integer) clientRecording.getAttribute("uid");
			Integer session_id = (Integer) clientRecording
					.getAttribute("sessionId");
			List<Obsel> listObselSessionStart = null;
			try {
				// String traceParam = "%-"+userId.toString()+"%";
				String traceParam = "%-" + userId.toString();
				String refParam = "%:hasSession " + "\""
						+ session_id.toString() + "\"" + "%";
				// log.warn("====refParam {}",refParam);
				ObselStringParams osp = new ObselStringParams(traceParam,
						refParam);
				listObselSessionStart = (List<Obsel>) getSqlMapClient()
						.queryForList(
								"obsels.getTraceIdByObselSessionStartSessionEnter",
								osp);
				if (listObselSessionStart != null) {
					Obsel obselSessionStart = listObselSessionStart.get(0);
					trace = obselSessionStart.getTrace();
					// set trace for this client, it's be need for update obsel
					// marker if session paused
					clientRecording.setAttribute("trace", trace);
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
			result = (List<Obsel>) getSqlMapClient().queryForList(
					"obsels.getTrace", trace);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}
		// get list obsel update marker
		List<Obsel> listObselUpdatedMarker = null;
		try {
			// get list obsel "SystemSessionStart"
			String traceParam = "%-0%";
			String refParam = "%:hasSession " + "\"" + sessionId.toString()
					+ "\"" + "%";
			ObselStringParams osp = new ObselStringParams(traceParam, refParam);
			listObselUpdatedMarker = (List<Obsel>) getSqlMapClient()
					.queryForList("obsels.getObselSystemUpdateMarker", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}
		Integer nbrObselSystemUpdateMarker = listObselUpdatedMarker.size();
		if (nbrObselSystemUpdateMarker > 0) {
			result.addAll(listObselUpdatedMarker);
		}
		log.warn("===== nbrSystemObselUpdateMarker = {}",
				nbrObselSystemUpdateMarker);
		Object[] args = { result, startRecording };
		IConnection connClient = (IConnection) clientRecording
				.getAttribute("connection");
		IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
		sc.invoke("checkListActiveObsel", args);
	}

	public void streamPublishStart(IBroadcastStream stream) {
		super.streamPublishStart(stream);
		log.warn("stream publish start: " + stream.getPublishedName());
		startPub(stream.getPublishedName());
	}

	@Override
	public void streamBroadcastStart(IBroadcastStream stream) {
		super.streamBroadcastStart(stream);
		log.warn("stream broadcast start: " + stream.getPublishedName());
	}

	public void sendPrivateMessage(Integer senderId, String message,
			Integer resiverId) {
		log.warn("====sendPrivateMessage====");
		log.warn("sender = {}", senderId);
		log.warn("message = {}", message);
		log.warn("resiver = {}", resiverId);

		User sender = null;
		try {
			sender = (User) getSqlMapClient().queryForObject("users.getUser",
					senderId);
			log.warn("sendPrivateMessage the user is = {}", sender
					.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		Object[] args = { message, sender };
		for (IClient client : this.getClients()) {
			Integer userId = (Integer) client.getAttribute("uid");
			log.warn("====sendPrivateMessage userId = {}", userId);
			int diff = userId - resiverId;
			// if(userId == resiverId)
			if (diff == 0) {
				// IConnection conn = (IConnection)
				// client.getConnections().toArray()[0];
				IConnection conn = (IConnection) client
						.getAttribute("connection");
				if (conn instanceof IServiceCapableConnection) {
					IServiceCapableConnection sc = (IServiceCapableConnection) conn;
					sc.invoke("checkPrivateMessage", args);
				}
			}
		}

	}

	public void sendPublicMessage(IConnection conn, Integer senderId,
			String message) {
		log.warn("====sendPublicMessage====");
		log.warn("sender = {}", senderId);
		log.warn("message = {}", message);
		User sender = null;
		try {
			sender = (User) getSqlMapClient().queryForObject("users.getUser",
					senderId);
			log.warn("sendPublicMessage the user is = {}", sender
					.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}
		Object[] args = { message, sender };
		// Get the Client Scope
		IScope scope = conn.getScope();
		// send message to all users on "Deck"
		invokeOnScopeClients(scope, "checkPublicMessage", args);
	}

	public void checkJoinSession(IConnection conn, Integer loggedUserId,
			String userIdClient, Integer sessionId) {
		log.warn("====checkJoinSession====");
		log.warn("loggedUserId = {}", loggedUserId.toString());
		log.warn("userIdClient = {}", userIdClient);
		log.warn("sessionId = {}", sessionId);
		// change users status
		IClient client = conn.getClient();
		// set session status
		client.setAttribute("status", SessionStatus.OPEN);
		// set status User
		client.setAttribute("userStatus", UserStatus.PENDING);
		// client in the session id
		client.setAttribute("sessionId", sessionId);
		// get logged userVO
		User loggedUser = null;
		try {
			loggedUser = (User) getSqlMapClient().queryForObject(
					"users.getUser", loggedUserId);
			log.warn("userFirstname is = {}", loggedUser.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}

		// checking if session in mode recording
		Session session = null;
		try {
			session = (Session) getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
			log.warn("====checkJoinSession=====");
			log.warn("session is = {}", session.toString());
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		// get status session
		Integer statuSession = session.getStatus_session();
		if (statuSession == 3) {
			// set status session recording
			client.setAttribute("status", SessionStatus.RECORDING);
			// set status User
			client.setAttribute("userStatus", UserStatus.RECORDING);
		}

		Object[] args = { loggedUser, userIdClient, sessionId,
				(Integer) client.getAttribute("status"),
				(Integer) client.getAttribute("userStatus") };
		// Get the Client Scope
		IScope scope = conn.getScope();
		// send message to all users on "Deck"
		invokeOnScopeClients(scope, "joinSession", args);

	}

	/**
	 * Set date start recording and status session
	 * 
	 * @param sessionId
	 */
	public void setStatusSession(Integer sessionId, Integer sessionStatus,
			Date dateStartRecording) {
		Session session = null;
		try {
			session = (Session) getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
			log.warn("====setStatusSession=====");
			log.warn("sessionId is = {}", session.getId_session().toString());
			log.warn("status is = {}", sessionStatus.toString());
			log.warn("dateRecording is = {}", dateStartRecording.toString());
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		// set start recording
		if (dateStartRecording != null) {
			session.setStart_recording(dateStartRecording);
		}
		// set status session
		session.setStatus_session(sessionStatus);

		try {
			getSqlMapClient().update("sessions.update", cloneSession(session));
			log.warn("updated= {} ", session.toString());
		} catch (Exception e) {
			log.error("Probleme lors du update des sessions" + e);
		}
	}

	private SessionWithoutListUser cloneSession(Session session) {
		// clone the session
		SessionWithoutListUser sessionWithoutUser = new SessionWithoutListUser();
		sessionWithoutUser.setDate_session(session.getDate_session());
		sessionWithoutUser.setDescription(session.getDescription());
		sessionWithoutUser.setDuration_session(session.getDuration_session());
		sessionWithoutUser.setId_currentActivity(session
				.getId_currentActivity());
		sessionWithoutUser.setId_session(session.getId_session());
		sessionWithoutUser.setId_user(session.getId_user());
		sessionWithoutUser.setIsModel(session.getIsModel());
		sessionWithoutUser.setStart_recording(session.getStart_recording());
		sessionWithoutUser.setStatus_session(session.getStatus_session());
		sessionWithoutUser.setTheme(session.getTheme());
		return sessionWithoutUser;
	}

	/**
	 * Set id of the current activity
	 * 
	 * @param sessionId
	 */
	public void setCurrentActivitySession(Integer sessionId,
			String currentActivityId) {
		Session session = null;
		try {
			session = (Session) getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
			log.warn("====setCurrentActivitySession=====");
			log.warn("sessionId is = {}", session.getId_session().toString());
			log.warn("currentActivityId is = {}", currentActivityId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des sessions" + e);
		}
		// set id of the current activity
		Integer activityId = Integer.parseInt(currentActivityId);
		session.setId_currentActivity(activityId);
		try {
			SessionWithoutListUser sessionWithOutListUser = cloneSession(session);
			getSqlMapClient().update("sessions.update", sessionWithOutListUser);
			log.warn("updated= {} ", sessionWithOutListUser.toString());
		} catch (Exception e) {
			log.error("Probleme lors du update des sessions" + e);
		}
	}

	/**
	 * 
	 * Set obsel "RoomExit", notification for all connected users that user walk
	 * out from session
	 * 
	 */
	public void checkOutSession(IConnection conn, Integer loggedUserId) {
		log.warn("====checkOutSession ====");
		log.warn("loggedUserId = {}", loggedUserId.toString());
		// set timestamp
		Date date = new Date();
		Long timeStamp = date.getTime();

		// change users status
		IClient client = conn.getClient();
		// get status client
		Integer statusClient = (Integer) client.getAttribute("status");
		// list user how staying in the session
		List<IClient> listStayingClient = new ArrayList<IClient>();
		// set Obsel "SessionExit" only if status recording

		log.warn("statusClient = {}", statusClient);

		if (statusClient == 3) {
			// get sessionId of the loggedUser
			Integer sessionId = (Integer) client.getAttribute("sessionId");
			Session session = null;
			try {
				session = (Session) getSqlMapClient().queryForObject(
						"sessions.getSession", sessionId);
			} catch (Exception e) {
				log.error("Probleme lors du listing des sessions" + e);
			}
			// set obsel "stopActivity" for user walk out from the recording
			// session only if activity was started
			Integer activityId = session.getId_currentActivity();
			if (activityId != 0) {
				List<Object> paramsObsel = new ArrayList<Object>();
				paramsObsel.add("text");
				paramsObsel.add("void");
				paramsObsel.add("sender");
				paramsObsel.add("0");
				paramsObsel.add("activityid");
				paramsObsel.add(activityId.toString());
				;
				try {
					Obsel obsel = setObsel(
							(Integer) client.getAttribute("uid"),
							(String) client.getAttribute("trace"),
							"ActivityStop", paramsObsel);
				} catch (SQLException sqle) {
					log.error("=====Errors===== {}", sqle);
				}
			}

			// set Obsel "RoomExit" to all connected user of this session
			for (IClient connectedClient : this.getClients()) {
				Integer sessionIdConnectedUser = (Integer) connectedClient
						.getAttribute("sessionId");
				int diff = sessionId - sessionIdConnectedUser;
				if (diff == 0) {
					List<Object> paramsObsel = new ArrayList<Object>();
					paramsObsel.add("uid");
					paramsObsel.add(loggedUserId.toString());
					// add timeStamp
					paramsObsel.add("timestamp");
					paramsObsel.add(timeStamp.toString());
					paramsObsel.add("session");
					paramsObsel.add(sessionId.toString());
					paramsObsel.add("typeExit");
					paramsObsel.add("normal");

					log.debug("uid : {}", connectedClient.getAttribute("uid"));
					log.debug("trace : {}", connectedClient
							.getAttribute("trace"));
					log.debug("paramsObsel {}", paramsObsel);

					// add obsel "SessionExit"
					try {
						setObsel((Integer) connectedClient.getAttribute("uid"),
								(String) connectedClient.getAttribute("trace"),
								"SessionExit", paramsObsel);
					} catch (SQLException sqle) {
						log.error("=====Errors===== {}", sqle);
					}
					// add staying client to list
					Integer connectedClientId = (Integer) connectedClient
							.getAttribute("uid");
					// Integer diff = loggedUserId - connectedClientId;
					// if (diff != 0) {
					if (loggedUserId != connectedClientId) {
						listStayingClient.add(connectedClient);
					}
				}
			}
		}
		// Get the Client Scope
		IScope scope = conn.getScope();
		// start recording fila for users how staying in session
		this.updateRecordingWhenUserWalkOutSession(scope, listStayingClient);
		// set status session
		client.setAttribute("status", SessionStatus.PAUSE);
		// set status User
		client.setAttribute("userStatus", UserStatus.CONNECTED);
		// clear sessionId
		client.setAttribute("sessionId", 0);
		// clear trace
		client.setAttribute("trace", null);
		// get loggedUser
		User loggedUser = null;
		try {
			loggedUser = (User) getSqlMapClient().queryForObject(
					"users.getUser", loggedUserId);
			log.warn("checkOutSession, userFirstname is = {}", loggedUser
					.getFirstname());
		} catch (Exception e) {
			log.error("Probleme lors du listing des utilisateurs" + e);
		}

		Object[] args = { loggedUser,
				(Integer) client.getAttribute("userStatus") };
		// send message to all users on "Deck"
		invokeOnScopeClients(scope, "outSession", args);
	}

	public void updateRecordingWhenUserWalkOutSession(IScope scope,
			List<IClient> listConnectedCleint) {

		log.warn("===updateRecordingWhenUserWalkOutSession===");
		log.warn(" <listConnectedCleint> {}", listConnectedCleint.toString());
		log.warn(" listConnectedCleint.size {}", listConnectedCleint.size());

		GregorianCalendar calendar = new GregorianCalendar();
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String sDate = dateFormat.format(calendar.getTime());

		for (IClient connectedClient : listConnectedCleint) {
			// start save files
			String clientId = (String) connectedClient.getAttribute("id");
			Integer userId = (Integer) connectedClient.getAttribute("uid");
			Integer sessionId = (Integer) connectedClient
					.getAttribute("sessionId");

			ClientBroadcastStream streamByClientId = (ClientBroadcastStream) getBroadcastStream(
					scope, clientId);
			// stop recording
			streamByClientId.stopRecording();
			// generate fileName
			String recordFileName = "record-" + sDate + "-" + sessionId + "-"
					+ userId;

			try {
				// save the stream to disk
				streamByClientId.saveAs(recordFileName, false);
			} catch (Exception e) {
				log.error("Error while saving stream: "
						+ streamByClientId.getName(), e);
			}

			// add obsel "RecordFileName" to all recording users of this session
			for (IClient clientRFN : listConnectedCleint) {
				List<Object> paramsObselRecordFileName = new ArrayList<Object>();
				paramsObselRecordFileName.add("path");
				paramsObselRecordFileName.add(recordFileName);
				paramsObselRecordFileName.add("session");
				paramsObselRecordFileName.add(sessionId.toString());
				paramsObselRecordFileName.add("uid");
				paramsObselRecordFileName.add(userId.toString());
				// add obsel "RecordFileName"
				try {
					setObsel((Integer) clientRFN.getAttribute("uid"),
							(String) clientRFN.getAttribute("trace"),
							"RecordFilename", paramsObselRecordFileName);
				} catch (SQLException sqle) {
					log.error("=====Errors===== {}", sqle);
				}
			}
		}

	}


	private String getDateStringFormat_YYYY_MM_DD(Calendar calendar) {
		// year today
		Integer year = calendar.get(Calendar.YEAR);
		String yearString = year.toString();
		// month today ++1, january = 0 ....december = 11
		Integer month = calendar.get(Calendar.MONTH) + 1;
		String monthString = month.toString();
		if (month < 10) {
			monthString = "0" + monthString;
		}
		// day
		Integer day = calendar.get(Calendar.DAY_OF_MONTH);
		String dayString = day.toString();
		if (day < 10) {
			dayString = "0" + dayString;
		}
		return yearString + "-" + monthString + "-" + dayString;
	}

	public Integer getRoleUser(String s) {
		// FIXME can be better keep it in BD
		final double RESPONSABLE = 8191.0;
		// idem that "00000001111111111111"
		final double TUTEUR = 511.0;
		// idem that "00000000000111111111"
		final double STUDENT = 15;
		// idem that "00000000000000001111"
		s = s.trim();
		int l = s.length();
		String charZero = "0";
		double rightUser = 0;
		for (int i = 0; i < l; i++) {
			rightUser = rightUser + (s.charAt(i) - charZero.charAt(0))
					* Math.pow(2, (s.length() - i - 1));
		}
		// log.warn("rightUser = {}"+rightUser);
		Integer result = 0;
		if (rightUser > RESPONSABLE) {
			result = 1;
		} else if (rightUser > TUTEUR) {
			result = 2;
		} else if (rightUser > STUDENT) {
			result = 3;
		} else {
			result = 4;
		}
		return result;
	}

	public void invokeOnScopeClients(IScope scope, String method, Object[] arg) {
		Collection<Set<IConnection>> conCollection = scope.getConnections();
		for (Set<IConnection> cons : conCollection) {
			for (IConnection client_cnx : cons) {
				if (client_cnx != null) {
					if (client_cnx instanceof IServiceCapableConnection) {
						log.info("invoke {}->{}", client_cnx.getClient(),
								method);
						ServiceUtils
								.invokeOnConnection(client_cnx, method, arg);
					}

				}
			}
		}
	}

	public String makeTraceId(Integer userId) {
		Calendar clnd = Calendar.getInstance();

		Integer year = clnd.get(Calendar.YEAR);
		Integer month = clnd.get(Calendar.MONTH) + 1;
		String monthStr = month.toString();
		if (month < 10) {
			monthStr = "0" + monthStr;
		}
		Integer day = clnd.get(Calendar.DATE);
		String dayStr = day.toString();
		if (day < 10) {
			dayStr = "0" + dayStr;
		}
		Integer hour = clnd.get(Calendar.HOUR_OF_DAY);
		String hourStr = hour.toString();
		if (hour < 10) {
			hourStr = "0" + hourStr;
		}
		Integer min = clnd.get(Calendar.MINUTE);
		String minStr = min.toString();
		if (min < 10) {
			minStr = "0" + minStr;
		}
		Integer sec = clnd.get(Calendar.SECOND);
		String secStr = sec.toString();
		if (sec < 10) {
			secStr = "0" + secStr;
		}

		String tarceStr = "trace-" + year.toString() + monthStr + dayStr
				+ hourStr + minStr + secStr + "-" + userId.toString();
		return tarceStr;
	}

	// / will used ///////////////////////////////////////
	// ///////////////////////////////////////////////////
	// ///////////////////////////////////////////////////
	// ///////////////////////////////////////////////////
	public String testUser(Integer id) {
		log.warn("==== testUser ==== {}", id);
		return "hello";
	}

	@Override
	public void streamBroadcastClose(IBroadcastStream stream) {
		super.streamBroadcastClose(stream);
		log.warn("streamBroadcastClose: " + stream.getPublishedName());

		IConnection current = Red5.getConnectionLocal();
		IScope room = current.getScope();
		IClient client = current.getClient();

		try {
			ISharedObject so = getSharedObject(room, "VisuServer");

			String username = (String) client.getAttribute("username");
			client.setAttribute("live", "no");
			client.setAttribute("recording", "no");

			so.setAttribute("message", new Red5Message(
					RemoteAppEventType.STREAM_BROADCAST_CLOSE, stream
							.getPublishedName(), username, current.getClient()
							.getId(), (Integer) current.getClient()
							.getAttribute("uid")));
		} catch (NullPointerException ex) {
			log.info("stream broadcast close error - no more visuserver: ");
		}

	}

	/**
	 * 
	 * Get getLiveClients
	 * 
	 * @return Clients UserName : List<String>
	 */
	public List<Integer> getLiveClients(IConnection conn) {
		IScope room = conn.getScope();

		List<Integer> userlist = new Vector<Integer>();

		log.debug("client {}", conn.getClient());
		for (IClient client : room.getClients()) {
			log.debug("\t{} live? {}", client, client.getAttribute("live"));

			if ((String) client.getAttribute("live") == "yes")
				userlist.add((Integer) client.getAttribute("uid"));
		}
		return userlist;
	}

	public void testMethod(IConnection conn) {
		log.debug("-----");
		// log.debug( "conn {} ", conn);
		log.debug("conn.getPath() {} ", conn.getPath());
		log.debug("conn.getScope().getName() {} ", conn.getScope().getName());
		log.debug("conn.getScope().getPath() {} ", conn.getScope().getPath());
		log.debug("conn.getScope().getContextPath() {} ", conn.getScope()
				.getContextPath());
		log.debug("-----");
	}

	/**
	 * Get streams. called from client
	 * 
	 * @return iterator of broadcast stream names
	 */
	public Set<String> getStreams(IConnection conn) {
		log.info("client " + conn.getClient().getId() + " getStreams");
		return getBroadcastStreamNames(conn.getScope());
	}

	public void enterSalon(IConnection conn) {
		log.debug("on Air {} live", conn.getClient());
		IScope room = conn.getScope();
		IClient client = conn.getClient();

		ISharedObject so = getSharedObject(room, "VisuServer");

		String username = (String) client.getAttribute("username");
		client.setAttribute("live", "yes");

		so.setAttribute("message", new Red5Message(
				RemoteAppEventType.CLIENT_JOIN, username
						+ " a rejoint le salon.", username, client.getId(),
				(Integer) client.getAttribute("uid")));

	}

	public void leaveSalon(IConnection conn) {
		IScope room = conn.getScope();
		IClient client = conn.getClient();

		ISharedObject so = getSharedObject(room, "VisuServer");

		String username = (String) client.getAttribute("username");
		client.setAttribute("live", "no");
		// FIXME: make sure that the recording is stopped ??
		client.setAttribute("recording", "no");

		so.setAttribute("message", new Red5Message(
				RemoteAppEventType.CLIENT_LEAVE, username
						+ " a quitté le salon.", username, client.getId(),
				(Integer) client.getAttribute("uid")));

	}

	public void roomLeave(IClient client, IScope scope) {
		ISharedObject so = getSharedObject(scope, "VisuServer");
		String username = (String) client.getAttribute("username");

		log.warn("*** User " + username + " - " + client.getId() + " left "
				+ scope.getName());

		if (so != null) {

			so.setAttribute("message", new Red5Message(
					RemoteAppEventType.CLIENT_LOGOUT, username
							+ " a quitté l'application", username, client
							.getId(), (Integer) client.getAttribute("uid")));
		} else {
			log.debug("roomLeave: null so (scope, VisuServer)");
		}
		super.roomLeave(client, scope);
	}

}
