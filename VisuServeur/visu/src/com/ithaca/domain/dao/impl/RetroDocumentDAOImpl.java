package com.ithaca.domain.dao.impl;

import java.sql.SQLException;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ithaca.domain.dao.RetroDocumentDAO;
import com.ithaca.domain.model.RetroDocument;
import com.lyon2.visu.domain.model.User;

@SuppressWarnings("unchecked")
public class RetroDocumentDAOImpl extends SqlMapClientTemplate implements RetroDocumentDAO {

    private static final Logger logger = Red5LoggerFactory.getLogger(RetroDocumentDAOImpl.class,"visu");

	public Collection<RetroDocument> getRetroDocumentsByOwnerAndBySession (
			Integer ownerId, Integer sessionId)  throws SQLException {
		return (List<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentsByOwnerIdAndSessionId", 
				createParams("ownerId",ownerId, "sessionId",sessionId));
	}

	public RetroDocument getRetroDocumentById(Integer id)  throws SQLException {
		return (RetroDocument) getSqlMapClient().queryForObject(
				"rd.getDocumentById", 
				id);
	}

	
	public RetroDocument createRetroDocument(Integer ownerId,
			Integer sessionId)   throws SQLException {
		
		RetroDocument doc = new RetroDocument();
		Date creationDate = new Date();
		doc.setCreationDate(creationDate);
		doc.setLastModified(creationDate);
		doc.setSessionId(sessionId);
		doc.setOwnerId(ownerId);
		
		doc.setDocumentId((Integer)getSqlMapClient().insert(
				"rd.insertDocument", 
				doc));
		
		return doc;
	}

	public static Map<String, Object> createParams(Object... params) {
		Map<String, Object> map = new HashMap<String, Object>();
		for(int k=0;k<params.length/2;k++) 
			map.put((String) params[2*k],params[2*k+1]);
		return map;
	}

	public boolean saveRetroDocument(RetroDocument document)  throws SQLException {
		return getSqlMapClient().update("rd.updateDocument", document) == 1;
	}

	public boolean deleteRetroDocument(Integer documentId)  throws SQLException{
		SqlMapClient sqlMapClient = getSqlMapClient();
		sqlMapClient.startTransaction();
		boolean b = sqlMapClient.delete("rd.deleteDocument", documentId) == 1
				&& sqlMapClient.delete("rd.deleteAllInvitations", documentId) == 1;
		sqlMapClient.commitTransaction();
		return b;
	}

	public Collection<RetroDocument> getRetroDocumentsByOwner(Integer ownerId)  throws SQLException {
		return (Collection<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentsByOwner", 
				ownerId);
	}

	public void createInvitee(Integer documentId, Integer inviteeId)
			throws SQLException {
		getSqlMapClient().insert("rd.insertInvitation", createParams("documentId", documentId, "userId", inviteeId));
	}

	public boolean removeInvitee(Integer documentId, Integer inviteeId)
			throws SQLException {
		return getSqlMapClient().delete("rd.deleteInvitation", createParams("documentId", documentId, "userId", inviteeId)) == 1;
	}

	public Collection<String> getInviteeList(Integer documentId)
			throws SQLException {
		return getSqlMapClient().queryForList("rd.getInviteesByDocumentId", documentId);
	}

	public Collection<RetroDocument> getRetroDocumentIdByInviteeId(
			Integer inviteeId) throws SQLException {
		return getSqlMapClient().queryForList("rd.getDocumentsByInviteeId", inviteeId);
	}

	public Collection<RetroDocument> getRetroDocumentsByOwnerAndBySessionWithoutXML(
			Integer ownerId, Integer sessionId) throws SQLException {
		return (List<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentsByOwnerIdAndSessionIdWithoutXML", 
				createParams("ownerId",ownerId, "sessionId",sessionId));
	}

	public Collection<RetroDocument> getRetroDocumentsByOwnerWithoutXML(Integer ownerId) throws SQLException {
		return (List<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentsAndInviteeListAndSessionByOwnerIdWithoutXML",  ownerId);
	}

	public Collection<RetroDocument> getRetroDocumentsByInviteeWithoutXML(Integer inviteeId) throws SQLException {
		return (List<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentsAndInviteeListAndSessionByInviteeIdWithoutXML", inviteeId);
	}
	
	public Collection<RetroDocument> getRetroDocumentWithoutXMLByInviteeIdAndSessionId(
			Integer inviteeId, Integer sessionId) throws SQLException {
		return (List<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentsByInviteeIdAndSessionIdWithoutXML", 
				createParams("inviteeId",inviteeId, "sessionId",sessionId));
	}
}
