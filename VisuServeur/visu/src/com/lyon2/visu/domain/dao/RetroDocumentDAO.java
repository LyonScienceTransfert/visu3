package com.lyon2.visu.domain.dao;

import java.sql.SQLException;
import java.util.Collection;

import com.ithaca.domain.model.RetroDocument;
import com.lyon2.visu.domain.model.User;

public interface RetroDocumentDAO {
	
	public Collection<RetroDocument> getRetroDocumentsByOwnerAndBySession(Integer ownerId, Integer sessionId) throws SQLException;
	
	public RetroDocument getRetroDocumentById(Integer id) throws SQLException;
	
	public RetroDocument createRetroDocument(Integer ownerId, Integer sessionId) throws SQLException;

	public boolean saveRetroDocument(RetroDocument document) throws SQLException;
	
	public boolean deleteRetroDocument(Integer documentId) throws SQLException;

	public Collection<RetroDocument> getRetroDocumentsByOwner(Integer ownerId) throws SQLException;

	public boolean createInvitee(Integer documentId, Integer inviteeId) throws SQLException;
	public boolean removeInvitee(Integer documentId, Integer inviteeId) throws SQLException;
	public Collection<User> getInviteeList(Integer documentId) throws SQLException;
	public Collection<RetroDocument> getRetroDocumentIdByInviteeId(Integer inviteeId) throws SQLException;
	
}
