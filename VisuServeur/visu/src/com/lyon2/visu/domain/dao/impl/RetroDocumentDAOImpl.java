package com.lyon2.visu.domain.dao.impl;

import java.sql.SQLException;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.ithaca.domain.model.RetroDocument;
import com.lyon2.visu.domain.dao.RetroDocumentDAO;
import com.lyon2.visu.domain.model.User;

@SuppressWarnings("unchecked")
public class RetroDocumentDAOImpl extends SqlMapClientTemplate implements RetroDocumentDAO {

    private static final Logger logger = Red5LoggerFactory.getLogger(RetroDocumentDAOImpl.class,"visu");

	public Collection<RetroDocument> getRetroDocumentsByOwnerAndBySession (
			Integer ownerId, Integer sessionId)  throws SQLException {
		return (List<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocument", 
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
				"rd.createDocument", 
				doc));
		
		return doc;
	}

	private Map<String, Object> createParams(Object... params) {
		Map<String, Object> map = new HashMap<String, Object>();
		for(int k=0;k<params.length/2;k++) 
			map.put((String) params[k],params[k+1]);
		return map;
	}

	public boolean saveRetroDocument(RetroDocument document)  throws SQLException {
		return getSqlMapClient().update("rd.updateDocument", document) == 1;
	}

	public boolean deleteRetroDocument(Integer documentId)  throws SQLException{
		return getSqlMapClient().delete("rd.delete", documentId) == 1;
	}

	public Collection<RetroDocument> getRetroDocumentsByOwner(Integer ownerId)  throws SQLException {
		return (Collection<RetroDocument>) getSqlMapClient().queryForList(
				"rd.getDocumentByOwnerId", 
				ownerId);
	}

	public boolean createInvitee(Integer documentId, Integer inviteeId)
			throws SQLException {
		throw new UnsupportedOperationException("Not yet implemented");
	}

	public boolean removeInvitee(Integer documentId, Integer inviteeId)
			throws SQLException {
		throw new UnsupportedOperationException("Not yet implemented");
	}

	public Collection<User> getInviteeList(Integer documentId)
			throws SQLException {
		throw new UnsupportedOperationException("Not yet implemented");
	}

	public Collection<RetroDocument> getRetroDocumentIdByInviteeId(
			Integer inviteeId) throws SQLException {
		throw new UnsupportedOperationException("Not yet implemented");
	}
}
