package com.lyon2.visu.red5;

import java.sql.SQLException;
import java.util.List;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;
import org.slf4j.Logger;

import com.lyon2.utils.UserDate;
import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.SessionWithoutListUser;
import com.lyon2.visu.domain.model.User;
import com.ithaca.domain.dao.impl.RetroDocumentDAOImpl;
import com.ithaca.domain.model.RetroDocument;


public class RetroDocumentInfo {
	

	private Application app;
  	
	protected static final Logger log = Red5LoggerFactory.getLogger(SessionInfo.class, "visu2" );

	@SuppressWarnings("unchecked")
	public void getRetroDocumentById(IConnection conn, int documentId, boolean editabled) 
	{
		log.warn("======== getRetroDocumentById ");
		log.warn("=====documentId = {}",documentId);

		IClient client = conn.getClient();
		RetroDocument retroDocument = null;
		try
		{
			retroDocument = (RetroDocument)app.getSqlMapClient().queryForObject("rd.getDocumentById", documentId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des retroDocument" + e);
		}
		List <Integer> listInvitees= null;
		try
		{
			listInvitees = (List<Integer>)app.getSqlMapClient().queryForList("rd.getInviteesByDocumentId", documentId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des Invitees" + e);
		}

		Object[] args = {retroDocument,listInvitees, editabled};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkRetroDocument", args);
		} 	
	}
	
	@SuppressWarnings("unchecked")
	public void createRetroDocument(IConnection conn, RetroDocument retroDocument, Integer sessionId)
	{
		log.warn("======== createRetroDocument ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();
		Integer retroDocumentId = 0;
		try
		{
			retroDocumentId = (Integer)app.getSqlMapClient().insert("rd.insertDocument",retroDocument);
		} catch (Exception e) {
			log.error("Probleme lors du listing des retroDocument" + e);
		}
		
		// get retroOdocuments of the owner
		List<RetroDocument> listRetroDocumentOwner = null;
		try {
			listRetroDocumentOwner = (List<RetroDocument>) app.getSqlMapClient().queryForList(
					"rd.getDocumentsByOwnerIdAndSessionIdWithoutXML", RetroDocumentDAOImpl.createParams("ownerId",userId, "sessionId", sessionId));
		} catch (Exception e) {
			log.error("Probleme lors du listing des retroDocument " + e, e);
		}
		if(listRetroDocumentOwner != null)
		{
			log.warn("size the list retroDocument = {}",listRetroDocumentOwner.size());
//			log.warn("xml the first retroDocument = {}",listRetroDocumentOwner.get(0).getCreationDate().toString());	
		}else
		{
			log.warn("List empty !!!!!!");
		}
		// get retroOdocuments of the other users
		List<RetroDocument> listRetroDocumentShared = null;
		try {
			listRetroDocumentShared = (List<RetroDocument>) app.getSqlMapClient().queryForList(
					"rd.getDocumentsByInviteeIdAndSessionIdWithoutXML", RetroDocumentDAOImpl.createParams("ownerId",userId, "sessionId", sessionId));
		} catch (Exception e) {
			log.error("Probleme lors du listing des listRetroDocumentShared " + e, e);
		}
		if(listRetroDocumentShared != null)
		{
			log.warn("size the list retroDocument = {}",listRetroDocumentShared.size());
//			log.warn("xml the first retroDocument = {}",listRetroDocumentShared.get(0).getCreationDate().toString());	
		}else
		{
			log.warn("List empty !!!!!!");
		}
		
		Object[] argsRetroDocument = { listRetroDocumentOwner, listRetroDocumentShared};
		if (conn instanceof IServiceCapableConnection) 
		{
			IConnection connClient = (IConnection) client.getAttribute("connection");
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListRetroDocument", argsRetroDocument);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void deleteRetroDocument(IConnection conn, int retroDocumentId, Integer sessionId)
	{
		log.warn("======== deleteRetroDocument ");
		log.warn("=====documentId = {}",retroDocumentId);
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();
		try
		{
			app.getSqlMapClient().delete("rd.deleteDocument",retroDocumentId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des deleteDocument" + e);
		}
		try
		{
			app.getSqlMapClient().delete("rd.deleteAllInvitations",retroDocumentId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des deleteAllInvitations" + e);
		}
		
		// get retroOdocuments of the owner
		List<RetroDocument> listRetroDocumentOwner = null;
		try {
			listRetroDocumentOwner = (List<RetroDocument>) app.getSqlMapClient().queryForList(
					"rd.getDocumentsByOwnerIdAndSessionIdWithoutXML", RetroDocumentDAOImpl.createParams("ownerId",userId, "sessionId", sessionId));
		} catch (Exception e) {
			log.error("Probleme lors du listing des retroDocument " + e, e);
		}
		if(listRetroDocumentOwner != null)
		{
			log.warn("size the list retroDocument = {}",listRetroDocumentOwner.size());
//			log.warn("xml the first retroDocument = {}",listRetroDocumentOwner.get(0).getCreationDate().toString());	
		}else
		{
			log.warn("List empty !!!!!!");
		}
		// get retroOdocuments of the other users
		List<RetroDocument> listRetroDocumentShared = null;
		try {
			listRetroDocumentShared = (List<RetroDocument>) app.getSqlMapClient().queryForList(
					"rd.getDocumentsByInviteeIdAndSessionIdWithoutXML", RetroDocumentDAOImpl.createParams("ownerId",userId, "sessionId", sessionId));
		} catch (Exception e) {
			log.error("Probleme lors du listing des listRetroDocumentShared " + e, e);
		}
		if(listRetroDocumentShared != null)
		{
			log.warn("size the list retroDocument = {}",listRetroDocumentShared.size());
//			log.warn("xml the first retroDocument = {}",listRetroDocumentShared.get(0).getCreationDate().toString());	
		}else
		{
			log.warn("List empty !!!!!!");
		}
		
		Object[] argsRetroDocument = { listRetroDocumentOwner, listRetroDocumentShared};
		if (conn instanceof IServiceCapableConnection) 
		{
			IConnection connClient = (IConnection) client.getAttribute("connection");
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListRetroDocument", argsRetroDocument);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void updateRetroDocument(IConnection conn, RetroDocument retroDocument, Integer[] listUser) throws SQLException
	{
		log.warn("======== updateRetroDocument ");
		try
		{
			app.getSqlMapClient().update("rd.updateDocument",retroDocument);
			log.warn("updated= {} ",retroDocument.toString());
		} catch (Exception e) {
			log.error("Probleme lors du update des sessions" + e);
		}
		
		// TODO update list user
	}
	
	
	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}
}
