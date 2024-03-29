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

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;

import com.ithaca.domain.dao.impl.RetroDocumentDAOImpl;
import com.ithaca.domain.model.ArrayData;
import com.ithaca.domain.model.Obsel;
import com.ithaca.domain.model.RetroDocument;
import com.lyon2.utils.ObselStringParams;
import com.lyon2.utils.UserColor;
import com.lyon2.utils.UserDate;
import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;
import com.lyon2.utils.ObselType;
import com.lyon2.utils.UtilFunction;

import java.util.Iterator;

/**
 * 
 * Service d'enregistrement des streams video dans un salon
 * 
 */
public class ObselInfo {
	private Application app;

	public Application getApp() {
		return app;
	}

	public void setApp(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

	protected static final Logger log = LoggerFactory.getLogger(
			ObselInfo.class);

	@SuppressWarnings("unchecked")
	public void getObselSessionExitSessionPause(IConnection conn)
			throws SQLException {
		log.warn("====== getObselSessionExitSessionPause ======");
		IClient client = conn.getClient();
		Integer userId = (Integer) client.getAttribute("uid");
		List<Obsel> listObselSessionExitSessionPause = null;
		try {
			String traceParam = "%-" + userId.toString();
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
	
	public void goInSalonRetro(IConnection conn)
	{
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		String nameUser = user.getLastname() + " " + user.getFirstname();
		log.warn("USER : {} IS JOIN SALON RETRO",nameUser);
	}
	public void walkOutSalonRetro(IConnection conn)
	{
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		String nameUser = user.getLastname() + " " + user.getFirstname();
		log.warn("ObselInfo : walkOutSalonRetro :  USER : {} IS WALK OUT SALON RETRO",nameUser);
		Integer userId = user.getId_user();
		Obsel obsel = null;
		if(client.hasAttribute("traceRetroId"))
		{
			String traceRetroIdOutSession = (String)client.getAttribute("traceRetroId");
			String traceParentRetroId = (String)client.getAttribute("traceParentRetroId");
			List<Object> paramsObsel= new ArrayList<Object>();
			paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);paramsObsel.add(traceParentRetroId);
			paramsObsel.add(ObselType.CAUSE);paramsObsel.add(ObselType.LEAVE_ROOM);
			try
			{
				obsel = app.setObsel(userId, traceRetroIdOutSession, ObselType.RETRO_ROOM_EXIT, paramsObsel);					
			}
			catch (SQLException sqle)
			{
				log.error("=====Errors===== {}", sqle);
			}
			log.debug("------------- OBSEL SalonRetroSessionOut when out from salon retro  START---------------------");
			log.warn(obsel.toString());
			log.debug("------------- OBSEL SalonRetroSessionOut xhen out from salon retro END---------------------");
			// remove attribute 
			client.removeAttribute("traceRetroId");
			client.removeAttribute("traceParentRetroId");
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
	public void getObselByTypeSessionExitSessionPause(IConnection conn, Integer sessionId) {
		log.warn("======== getObselByTypeSessionExitSessionPause = {}",sessionId.toString());
		IClient client = conn.getClient();
		List<Obsel> result = null;
		String traceParam = "%-" + "void" + "%";
		String refParam = "%:hasSession " + "\"" + sessionId.toString() + "\""
				+ "%";
		ObselStringParams osp = new ObselStringParams(traceParam, refParam);
		log.warn("OSP = {}",osp.toString());
		try {
			result = (List<Obsel>) app.getSqlMapClient().queryForList(
					"obsels.getObselBySessionIdBySessionExitSessionPause", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}
		// log.warn("Result is = {}",result.toString());	
		Object[] args = { result};
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselSessioExitSessionPause", args);
		}
	}

	@SuppressWarnings("unchecked")
	public void getObselRetroRoomByUserIdSession(IConnection conn, int userId, int sessionId){
		IClient client = conn.getClient();
		// check user was in the recorded session 
		List<String> listTraceId = null;
		// list obsels activity in the salon retrospection
		List<Obsel> listObselRetro = null;
		String traceRetroId = "";
		
		String traceParam = "%-" + userId;
		String refParam = "%:hasSession " + "\"" + String.valueOf(sessionId) + "\""
				+ "%";
		ObselStringParams osp = new ObselStringParams(traceParam, refParam);
		log.warn("OSP = {}",osp.toString());
		try {
			listTraceId = (List<String>) app.getSqlMapClient().queryForList(
					"obsels.getTracesBySessionIdAndUserId", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing de list traceId" + e);
			// TODO return message error
		}
		log.warn("listTraceId");
		if(listTraceId.size() != 0)
		{
			if(listTraceId.size() > 1 )
			{
				// TODO message error, can't be more than one trace for one user in salon synchrone
				log.warn("Probleme, peut pas avoir plus que une trace pour utilisateur dans salon synchrone");
			}else
			{
				traceRetroId = listTraceId.get(0);
				log.warn("Trace id salon retro pour user id = "+String.valueOf(userId)+"est "+traceRetroId);
				
				// get list retro room
				String paramTraceIdSynchroRoom = "%:"+ObselType.PREFICS_PARAM_OBSEL+UtilFunction.changeFirstCharUpper(ObselType.SYNC_ROOM_TRACE_ID)+" "+"\"" + traceRetroId + "\"" + "%";

				try {
					listObselRetro = (List<Obsel>) app.getSqlMapClient().queryForList(
							"obsels.getTraceComment", paramTraceIdSynchroRoom);
				} catch (Exception e) {
					log.error("Probleme lors du listing des obsels retro room" + e);
				}
			}
		}
		
		// send list obsels retro room to client
		Object[] args = { listObselRetro, userId };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselRetroRoom", args);
		}
		
	}
	
	@SuppressWarnings("unchecked")
	private void checkTraceIdRetro(IConnection conn, IClient client, Session session){
		User user = (User) client.getAttribute("user");
		int userId = user.getId_user();
		// check user was in the recorded session 
		List<String> listTraceId = null;
		// list obsels activity in the salon retrospection
		List<Obsel> retro = null;
		String traceRetroId = "";
		String traceId = "";
		
		String traceParam = "%-" + userId;
		String refParam = "%:hasSession " + "\"" + String.valueOf(session.getId_session()) + "\""
				+ "%";
		ObselStringParams osp = new ObselStringParams(traceParam, refParam);
		log.warn("OSP = {}",osp.toString());
		try {
			listTraceId = (List<String>) app.getSqlMapClient().queryForList(
					"obsels.getTracesBySessionIdAndUserId", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing de list traceId" + e);
		}
		// user name
		String nameUser = user.getLastname() + " " + user.getFirstname();
		if(listTraceId.size() == 0)
		{
			log.warn(nameUser + " hasn't trace for retrospection module. ");
			traceRetroId = null;
			traceId = null;
		}else
		{
			log.warn(nameUser + " has trace, was recorded.");
			// Initialization trace id of the salon retrospection 
			// get trace id 
			traceId = listTraceId.get(0);
			// in version red5-1.0.0, have to remove attribute
			client.removeAttribute("traceParentRetroId");
			// set traceId parent
			client.setAttribute("traceParentRetroId", traceId);
			
			String refParamTypeObsel = "%"+ObselType.PREFICS_RETRO_ROOM +"%";
			String refParamParentTraceId = "%:"+ObselType.PREFICS_PARAM_OBSEL+UtilFunction.changeFirstCharUpper(ObselType.SYNC_ROOM_TRACE_ID)+" "+"\"" + traceId + "\"" + "%";
			ObselStringParams ospRetro = new ObselStringParams(refParamTypeObsel, refParamParentTraceId);
			log.warn(ospRetro.toString());
			try {
				retro = (List<Obsel>) app.getSqlMapClient().queryForList(
						"obsels.getTraceRetro", ospRetro);
			} catch (Exception e) {
				log.error("Probleme lors du listing des obsels retro" + e);
			}
			
			if(retro.size() < 1)
			{
				// create new traceId for trace activity in retrospection module
				traceRetroId = app.makeTraceId(userId);
				log.warn("do new traceRetroId = " + traceRetroId);
			}else
			{
				for(Obsel obsel : retro)
					{
						log.warn("== obsel retro, trace id = {}, obsel id in BDD = {}",obsel.getTrace(),obsel.getId());
					}
				Obsel obsel = retro.get(0);
				traceRetroId = obsel.getTrace();
			}
			log.warn("traceRetroId = {}",traceRetroId );
			// in version red5-1.0.0, have to remove attribute
			client.removeAttribute("traceParentRetroId");
			// set traceId retrospection module
			client.setAttribute("traceRetroId", traceRetroId);	
			
			// add obsel "RetroRoomEnter"
			List<Object> paramsObsel= new ArrayList<Object>();
			paramsObsel.add(ObselType.SYNC_ROOM_TRACE_ID);paramsObsel.add(traceId);
			paramsObsel.add(ObselType.REFERER);paramsObsel.add("void");
			paramsObsel.add(ObselType.SESSION_ID);paramsObsel.add(String.valueOf(session.getId_session()));
			paramsObsel.add(ObselType.SESSION_TITLE);paramsObsel.add(session.getTheme());
			paramsObsel.add(ObselType.SESSION_DESCRIPTION);paramsObsel.add(session.getDescription());
			paramsObsel.add(ObselType.SESSION_START_RECORD_DATE);paramsObsel.add(Long.toString(session.getStart_recording().getTime()));
			paramsObsel.add(ObselType.SESSION_OWNER_ID);paramsObsel.add(String.valueOf(session.getId_user()));
			
			Obsel obsel = null;
			try
			{
				obsel = app.setObsel(userId, traceRetroId, ObselType.RETRO_ROOM_ENTER , paramsObsel);					
			}
			catch (SQLException sqle)
			{
				log.error("=====Errors===== {}", sqle);
			}
			log.debug("------------- OBSEL SalonRetroSESSIONin START---------------------");
			log.warn(obsel.toString());
			log.debug("------------- OBSEL SalonRetroSESSIONin END---------------------");
		}

		Object[] args = { traceRetroId, traceId };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkTracesIdRetroRoom", args);
		}
		
		
	}
	
	@SuppressWarnings("unchecked")
	public void getObselByClosedSession(IConnection conn, Integer sessionId, String labelModule) {
		log.warn("======== getObselByClosedSession = {}",sessionId.toString());

		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();
		List<Obsel> result = null;
		Session session = null;
		
		String traceParam = "%-" + "void" + "%";
		String refParam = "%:hasSession " + "\"" + sessionId.toString() + "\""
				+ "%";
		ObselStringParams osp = new ObselStringParams(traceParam, refParam);
		log.warn("OSP = {}",osp.toString());
		try {
			result = (List<Obsel>) app.getSqlMapClient().queryForList(
					"obsels.getObselBySessionId", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels" + e);
		}
		// get role of logged user
		List<String> listTraceId = null;
		int roleUser = app.getRoleUser(user.getProfil());
		// admin and responsable has role 1 and 2
		// tuteur has role 3
		/**
		 * FIXME : special for UNIDISTANCE,
		 * tuteur have to see trace the other tuteur
		 * was :  if (roleUser == 1 || roleUser == 2 )
		 * now : if (roleUser == 1 || roleUser == 2 || roleUser == 3)
		 */
		if (roleUser == 1 || roleUser == 2 || roleUser == 3)
		{
			traceParam = "%-" + "void" + "%";
			refParam = "%:hasSession " + "\"" + sessionId.toString() + "\""
					+ "%";
			osp = new ObselStringParams(traceParam, refParam);
			log.warn("OSP = {}",osp.toString());
			try {
				listTraceId = (List<String>) app.getSqlMapClient().queryForList(
						"obsels.getTracesBySessionId", osp);
			} catch (Exception e) {
				log.error("Probleme lors du listing des traceId" + e);
			}
		}else
		{
			traceParam = "%-" + userId;
			refParam = "%:hasSession " + "\"" + String.valueOf(sessionId) + "\""
					+ "%";
			osp = new ObselStringParams(traceParam, refParam);
			log.warn("OSP = {}",osp.toString());
			try {
				listTraceId = (List<String>) app.getSqlMapClient().queryForList(
						"obsels.getTracesBySessionIdAndUserId", osp);
			} catch (Exception e) {
				log.error("Probleme lors du listing de list traceId" + e);
			}
		}
			
			List<Obsel> listObselUser = null;
			List<Obsel> listObselSession = new ArrayList<Obsel>();
			for (String traceId : listTraceId) {
				try {
					listObselUser = app.getSqlMapClient().queryForList("obsels.getTrace", traceId);
				} catch (Exception e) {
					log.error("Probleme lors du listing obsel" + e);
				}
				listObselSession.addAll(listObselUser);
				log.warn("listObselSession size = {}", listObselSession.size());
			}
			result = listObselSession;
		

		// get session
		log.warn("result = {}",result.size());
		try {
			session = (Session) app.getSqlMapClient().queryForObject(
					"sessions.getSession", sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des session" + e);
		}
		
		// get system trace id, will parent trace for comment trace and for trace the tracage salon retro
		String systemTraceId = "";
		String refParamSystemTraceId = "%:"+ObselType.PREFICS_PARAM_OBSEL+UtilFunction.changeFirstCharUpper(ObselType.SESSION)+" "+"\"" + sessionId.toString() + "\"" + "%";
		try {
			systemTraceId = (String) app.getSqlMapClient().queryForObject(
					"obsels.getTraceSystemIdBySessionId", refParamSystemTraceId);
		} catch (Exception e) {
			log.error("Probleme lors du listing de trace system id" + e);
		}
		log.warn("=========== systemTraceId =>"+systemTraceId);
	
		traceParam = "%:"+ObselType.PREFICS_PARAM_OBSEL+UtilFunction.changeFirstCharUpper(ObselType.SUBJECT)+" "+"\"" + userId.toString() + "\"" + "%";
		refParam = "%:"+ObselType.PREFICS_PARAM_OBSEL+UtilFunction.changeFirstCharUpper(ObselType.PARENT_TRACE_ID)+" "+"\"" + systemTraceId + "\"" + "%";
		osp = new ObselStringParams(traceParam, refParam);
		List<Obsel> comment = null;
		try {
			comment = (List<Obsel>) app.getSqlMapClient().queryForList(
					"obsels.getTraceCommentBySujetAndParentTraceId", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing des obsels retro room" + e);
		}
		
		Date sessionStartRecordingDate = session.getStart_recording();
		Object[] args = { result, sessionStartRecordingDate , comment, systemTraceId};
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselClosedSession", args);
		}
		
		// get retroDocuments of the owner
		List<RetroDocument> listRetroDocumentOwner = null;
		try {
			listRetroDocumentOwner = (List<RetroDocument>) app.getSqlMapClient().queryForList(
					"rd.getDocumentsByOwnerIdAndSessionId", RetroDocumentDAOImpl.createParams("ownerId",userId, "sessionId", sessionId));
		} catch (Exception e) {
			log.error("Probleme lors du listing des retroDocument " + e, e);
		}
		if(listRetroDocumentOwner != null)
		{
			log.warn("size the list retroDocument = {}",listRetroDocumentOwner.size());	
		}else
		{
			log.warn("List empty !!!!!!");
		}
		// get retroOdocuments of the other users
		List<RetroDocument> listRetroDocumentShared = null;
		try {
			listRetroDocumentShared = (List<RetroDocument>) app.getSqlMapClient().queryForList(
					"rd.getDocumentsByInviteeIdAndSessionIdWithoutXML", RetroDocumentDAOImpl.createParams("inviteeId",userId, "sessionId", sessionId));
		} catch (Exception e) {
			log.error("Probleme lors du listing des listRetroDocumentShared " + e, e);
		}
		if(listRetroDocumentShared != null)
		{
			log.warn("size the list retroDocument = {}",listRetroDocumentShared.size());	
		}else
		{
			log.warn("List empty !!!!!!");
		}
		log.warn("===== sessionId closed session = {}",sessionId.toString());
		Object[] argsRetroDocument = { listRetroDocumentOwner, listRetroDocumentShared};
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListRetroDocument", argsRetroDocument);
		}
		
		// check traceId only for Retrospection module
		if(labelModule.equals("retrospectionModule"))
		{
			// check traceId Retrospection room
			checkTraceIdRetro( conn, client, session);
		}
	}
	
	public void addObselComment(IConnection conn, String traceComment, String traceParent, String typeObsel, String textComment, String beginTime, String endTime, Integer forUserId, Integer sessionId, String timeStamp )
	{
		log.warn("=== addObselComment ===");
		IClient client = conn.getClient();
		User user = (User)client.getAttribute("user");
		Integer userId = user.getId_user();
		log.warn("traceComment =  {}",traceComment);
		if(traceComment.equals("void"))
		{
			// generate traceId user
			traceComment = app.makeTraceId(userId);
		}
		// set timestamp
		if(timeStamp.equals("0")){
			Date date = new Date();
			timeStamp = String.valueOf(date.getTime());			
		}
		
		List<Object> paramsObsel= new ArrayList<Object>();
		paramsObsel.add("commentforuserid");paramsObsel.add(forUserId.toString());
		 // add timeStamp
		paramsObsel.add("timestamp");paramsObsel.add(timeStamp);
		paramsObsel.add("session");paramsObsel.add(sessionId.toString());
		paramsObsel.add("parentTrace");paramsObsel.add(traceParent.toString());
		paramsObsel.add("text");paramsObsel.add(textComment.toString());

		log.debug("paramsObsel {}",paramsObsel);
		Obsel obsel = null;
		try
		{
			obsel = app.setObsel(userId, traceComment, typeObsel, paramsObsel, "commentObsel", beginTime, endTime );					
		}
		catch (SQLException sqle)
		{
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

    /**
     * 
     * Set short markers, add info in system trace
     * 
     * @param conn
     * @param userId
     * @param arayData
     */
    @SuppressWarnings("unchecked")
    public void addObselSaveShortMarker(IConnection conn, Integer userId, ArrayData arrayData ) {
            log.warn("======== addObselSaveShortMarker = {}",userId);
            IClient clientRecording = conn.getClient();
            List<Obsel> listObselSystemSessionStart = null;
         // find time start recording
    		Integer sessionId = (Integer) clientRecording.getAttribute("sessionId");
			String typeObselSystem = "SystemSessionShortMarker";
			String traceSystem = "";
			// try find obsel the system
			try {
	        	// get list obsel "SystemSessionStart"
				String traceParam = "%-0%";
				String refParam = "%:hasSession "+"\""+sessionId.toString()+"\""+"%";
				ObselStringParams osp = new ObselStringParams(traceParam,refParam);	
				log.warn("======== addObselSaveShortMarker = osp  {}",osp.toString());
				
				listObselSystemSessionStart = (List<Obsel>) app.getSqlMapClient().queryForList("obsels.getTraceIdByObselSystemSessionStartSystemSessionEnter", osp);
	           
				log.warn("======== addObselSaveShortMarker = listObselSystemSessionStart  {}",listObselSystemSessionStart.toString());

				if(listObselSystemSessionStart != null)
	            {
	            	// get traceId the system 
					Obsel obselSystemSessionStart = listObselSystemSessionStart.get(0);
					traceSystem = obselSystemSessionStart.getTrace();
					
				} else {
					// TODO : message error
				}
				log.warn("======== addObselSaveShortMarker = traceSystem = {}",traceSystem);
			} catch (Exception e) {
				// TODO : message error
			}
			// set list text short marker
			List<String> listText = new ArrayList<String>();
			for (String textMarker : arrayData.getListText())
			{
				listText.add(textMarker);
			}
			// set list text short color
			List<String> listColor = new ArrayList<String>();
			for (String colorMarker : arrayData.getListColor())
			{
				listColor.add(colorMarker);
			}
			// set obsel init short marker
			List<Object> paramsObselSystem = new ArrayList<Object>();
			paramsObselSystem.add("session");
			paramsObselSystem.add(sessionId.toString());
			paramsObselSystem.add("presenttextshortmarker");
			paramsObselSystem.add(listText);
			paramsObselSystem.add("presentcolorsshortmarker");
			paramsObselSystem.add(listColor);
			paramsObselSystem.add("idUserFor");
			paramsObselSystem.add(String.valueOf(userId));
			Obsel obsel = null;
			try {
				 	obsel = app.setObsel(0, traceSystem, typeObselSystem,
						paramsObselSystem);
			} catch (SQLException sqle) {
				log.error("=====Errors===== {}", sqle);
			}
			log.warn("======== addObselSaveShortMarker = obsel = {}", obsel);
    }
	
	
	@SuppressWarnings("unchecked")
	public List<User> getListPresentUserInSession(IConnection conn, Integer sessionId) {
		log.warn("======== getListPresentUserInSession = {}",sessionId);

		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();

		List<String> listTraceId = null;
		String traceParam = "%-" + "void" + "%";
		String refParam = "%:hasSession " + "\"" + sessionId.toString() + "\""
				+ "%";
		ObselStringParams osp = new ObselStringParams(traceParam, refParam);
		log.warn("OSP = {}",osp.toString());
		try {
			listTraceId = (List<String>) app.getSqlMapClient().queryForList(
					"obsels.getTracesBySessionId", osp);
		} catch (Exception e) {
			log.error("Probleme lors du listing des traceId" + e);
		}
		log.warn("listTraceId size = {}", listTraceId.size());
		List<User> listRecordingUser= new ArrayList<User>();
		for (String traceId : listTraceId) 
		{
			String []splitUserId = traceId.split("-");
			String id = splitUserId[2];
			userId = Integer.valueOf(id);
			log.warn("id the user == {}",id);
			try {
				user = (User) app.getSqlMapClient().queryForObject("users.getUser",userId);
			} catch (Exception e) {
				log.error("Probleme lors du listing de User" + e);
			}
			listRecordingUser.add(user);
		}
		return listRecordingUser;
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
}
