package com.lyon2.visu.red5;

import java.sql.SQLException;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.scope.IScope;
import org.red5.server.api.service.IServiceCapableConnection;

import com.ithaca.domain.dao.impl.RetroDocumentDAOImpl;
import com.ithaca.domain.model.RetroDocument;
import com.ithaca.service.RetroDocumentService;
import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;

public class RetroDocumentInfo {

	private Application app;

	public Application getApp() {
		return app;
	}

	public void setApp(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

	// Injected by Spring
	private RetroDocumentService retroDocumentService;

	public RetroDocumentService getRetroDocumentService() {
		return retroDocumentService;
	}

	public void setRetroDocumentService(
			RetroDocumentService retroDocumentService) {
		this.retroDocumentService = retroDocumentService;
	}

	protected static final Logger log = LoggerFactory
			.getLogger(RetroDocumentInfo.class);

	public void getAllRetroDocuments(IConnection conn) {
		log.info("Requesting for the list of all retro documents");
		Collection<RetroDocument> docs = this.retroDocumentService.findAllRetroDocuments(true);
		
		Collection<RetroDocument> allDocs = new HashSet<RetroDocument>();
		allDocs.addAll(docs);
		
		// DEBUG
		for(RetroDocument doc:allDocs) {
			log.debug("The bilan {} has been retrieved. It has {} invitees", doc.getDocumentId(), doc.getInviteeIds().size());
			for(int inviteeId:doc.getInviteeIds()) {
				log.debug("\t" + inviteeId);
			}
		}
		
		Map<Integer, Session> filterSessionMap = new TreeMap<Integer, Session>();
		for(RetroDocument doc:allDocs)
		{
			filterSessionMap.put(doc.getSessionId(), doc.getSession());
			log.debug("\t",doc.getSession().getTheme());
		}
		
		Object[] args = new Object[]{allDocs, filterSessionMap.values()};
		IConnection connClient = (IConnection)conn.getClient().getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			log.debug("Returning {} all retro documents and {} filter sessions", allDocs.size(), filterSessionMap.values().size());
			sc.invoke("bilanListRetrieved", args);
		} 	
	}
	
	public void getOwnedAndSharedRetroDocumentsByUserId(IConnection conn, int userId)  {
		log.warn("======== getOwnedAndSharedRetroDocumentsByUserId");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		
		// check role the user
		Integer roleUser = app.getRoleUser(user.getProfil());
		log.warn("roleUser = {}",roleUser);	
		// logged user responsable or admin
		if((roleUser == 2) || (roleUser == 1))
		{
			getAllRetroDocuments(conn);
		}else
		{
			log.info("Requesting for the list of owned and shared retro documents for the user {}", userId);
			Collection<RetroDocument> ownedRetroDocs = this.retroDocumentService.findDocumentsByOwner(userId, true);
			Collection<RetroDocument> sharedRetroDocs = this.retroDocumentService.findDocumentsWhereUserIsInvited(userId, true);
			
			Collection<RetroDocument> allDocs = new HashSet<RetroDocument>();
			allDocs.addAll(ownedRetroDocs);
			allDocs.addAll(sharedRetroDocs);
			
			// DEBUG
			for(RetroDocument doc:allDocs) {
				log.debug("The bilan {} has been retrieved. It has {} invitees", doc.getDocumentId(), doc.getInviteeIds().size());
				for(int inviteeId:doc.getInviteeIds()) {
					log.debug("\t" + inviteeId);
				}
			}
			
			Map<Integer, Session> filterSessionMap = new TreeMap<Integer, Session>();
			for(RetroDocument doc:allDocs)
				filterSessionMap.put(doc.getSessionId(), doc.getSession());
			
			Object[] args = new Object[]{allDocs, filterSessionMap.values()};
			IConnection connClient = (IConnection)conn.getClient().getAttribute("connection");
			if (conn instanceof IServiceCapableConnection) 
			{
				IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
				log.debug("Returning {} retro documents and {} filter sessions", allDocs.size(), filterSessionMap.values().size());
				sc.invoke("bilanListRetrieved", args);
			} 	
		}
	}
	
	@SuppressWarnings("unchecked")
	public void getRetroDocumentById(IConnection conn, Integer documentId) 
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
		log.warn("list shared by retroDocument id = {}",listInvitees.size());
		
		Object[] args = {retroDocument,listInvitees};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) 
		{
			log.debug("Returning the retro document {} to the client [Creation date: {}, Modif: {}, Title: {}, Description: {}, Nb invitees: {}]", new Object[]{
					retroDocument.getDocumentId(),
					retroDocument.getCreationDate(),
					retroDocument.getLastModified(),
					retroDocument.getTitle(),
					retroDocument.getDescription(),
					retroDocument.getInviteeIds().size()}
					);
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkRetroDocument", args);
		} 	
	}
	
	@SuppressWarnings("unchecked")
	public void createRetroDocument(IConnection conn, RetroDocument retroDocument)
	{
		log.warn("======== createRetroDocument ");
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();
		int retroDocumentId = 0;
		try
		{
			retroDocumentId = (Integer)app.getSqlMapClient().insert("rd.insertDocument",retroDocument);
		} catch (Exception e) {
			log.error("Probleme lors du listing des retroDocument" + e);
		}
		
		Object[] argsRetroDocument = { retroDocumentId };
		if (conn instanceof IServiceCapableConnection) 
		{
			IConnection connClient = (IConnection) client.getAttribute("connection");
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkUpdateAddedRetrodocument", argsRetroDocument);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void deleteRetroDocument(IConnection conn, int retroDocumentId, int sessionId)
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
	}
	
	@SuppressWarnings("unchecked")
	public void updateRetroDocument(IConnection conn, RetroDocument retroDocument, int[] listUser, String typeUpdate) throws SQLException
	{
		log.warn("======== updateRetroDocument {}",retroDocument.getXml());

		IClient client = conn.getClient();
		IScope scope = conn.getScope();
		try
		{
			app.getSqlMapClient().update("rd.updateDocument",retroDocument);
			log.warn("updated= {} ",retroDocument.toString());
		} catch (Exception e) {
			log.error("Probleme lors du update des sessions" + e);
		}
		
		// TODO 
		// 1.get old list invited
		// 2.if hasn't invited in the list the document call "deleteRetroDocument"
		// 3. send all users in the new list retroDocument with new list users.
		
		// delete all invitations
		int retroDocumentId = retroDocument.getDocumentId();
		try
		{
			app.getSqlMapClient().delete("rd.deleteAllInvitations",retroDocumentId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des deleteAllInvitations" + e);
		}
		// add new invitations
		for (int userId : listUser)
		{		
			try {
				app.getSqlMapClient().insert(
						"rd.insertInvitation", RetroDocumentDAOImpl.createParams("userId",userId, "documentId", retroDocumentId));
			} catch (Exception e) {
				log.error("Probleme lors du insert insertInvitation " + e, e);
			}
		}
		log.warn("shared for : {}", listUser.toString());
		// call function updated on the client side 
		// FIXME : not need update retroDocument for owner of this document
//		Object[] argsRetroDocument = {retroDocument};
//		IConnection connClient = (IConnection) client.getAttribute("connection");
//		IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
//		sc.invoke("checkUpdateRetroDocument", argsRetroDocument);
		
//		int sharedUserId=0;
//		int nbrSharedUsers = listUser.length;
//		for (IClient shareClient : scope.getClients())
//		{
//			for(int nUser=0; nUser < nbrSharedUsers; nUser++)
//			{
//				sharedUserId = listUser[nUser];
//				int userId = (Integer)shareClient.getAttribute("uid");
//				if(userId == sharedUserId)
//				{
//					Object[] argsRetroDocumentShare = {retroDocument, listUser};
//					IConnection connShareClient = (IConnection) shareClient.getAttribute("connection");
//					IServiceCapableConnection scShareClient = (IServiceCapableConnection) connShareClient;
//					scShareClient.invoke("checkUpdateRetroDocument", argsRetroDocumentShare);
//					log.warn(" == added client {}",(String)client.getAttribute("id"));
//				}	
//			}			
//		}	
		// notification owner retroDocument, document was updated
		IConnection connClient = (IConnection) client.getAttribute("connection");
		Object[] argsRetroDocument = {typeUpdate};
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkUpdateRetroDocument", argsRetroDocument);
		}	
	}
	
	@SuppressWarnings("unchecked")
	public void getRetrodocumentsBySessionIdForUser(IConnection conn, Integer sessionId) {
		log.warn("======== getRetrodocumentsBySessionIdForUser = {}",sessionId.toString());
		IClient client = conn.getClient();
		User user = (User) client.getAttribute("user");
		Integer userId = user.getId_user();
		
		// get retroDocuments of the owner
		List<RetroDocument> listRetroDocumentOwner = null;
		// get retroDocuments of the other users
		List<RetroDocument> listRetroDocumentShared = null;
		
		// check role the user
		Integer roleUser = app.getRoleUser(user.getProfil());
		log.warn("roleUser = {}",roleUser);	
		// logged user responsable or admin
		if((roleUser == 2) || (roleUser == 1)){
			try {
				listRetroDocumentOwner = (List<RetroDocument>) app.getSqlMapClient().queryForList(
						"rd.getDocumentsBySessionIdWithXML", RetroDocumentDAOImpl.createParams("sessionId", sessionId));
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
			try {
				listRetroDocumentShared = (List<RetroDocument>) app.getSqlMapClient().queryForList(
						"rd.getDocumentsSharedBySessionIdWithXML", RetroDocumentDAOImpl.createParams("sessionId", sessionId));
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
			// remove shared bilan from the list the all bilan
			if(listRetroDocumentShared != null && listRetroDocumentOwner != null)
			{
				for (RetroDocument retrodocumentShared : listRetroDocumentShared )
				{
					for(RetroDocument retrodocument : listRetroDocumentOwner)
					{
						if (retrodocument.getDocumentId().equals(retrodocumentShared.getDocumentId()))
						{
							listRetroDocumentOwner.remove(retrodocument);
							break;
						}   
					}
				}
			}
		}else
		{
			// get the bilans of the tuteur and student
			try {
				listRetroDocumentOwner = (List<RetroDocument>) app.getSqlMapClient().queryForList(
						"rd.getDocumentsByOwnerIdAndSessionIdWithXML", RetroDocumentDAOImpl.createParams("ownerId",userId, "sessionId", sessionId));
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
			try {
				listRetroDocumentShared = (List<RetroDocument>) app.getSqlMapClient().queryForList(
						"rd.getDocumentsByInviteeIdAndSessionIdWithXML", RetroDocumentDAOImpl.createParams("inviteeId",userId, "sessionId", sessionId));
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
		}
		

		log.warn("===== sessionId closed session = {}",sessionId.toString());
		
		IConnection connClient = (IConnection) client
		.getAttribute("connection");
		Object[] argsRetroDocument = { listRetroDocumentOwner, listRetroDocumentShared};
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListRetroDocumentBySessionId", argsRetroDocument);
		}
	}
}
