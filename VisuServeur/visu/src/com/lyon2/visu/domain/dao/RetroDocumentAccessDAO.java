package com.lyon2.visu.domain.dao;

import java.sql.SQLException;

public interface RetroDocumentAccessDAO {

	public boolean addInvitee(Integer documentId, Integer inviteeId) throws SQLException;
	
	public boolean deleteDocument(Integer documentId) throws SQLException; 
	
	public boolean deleteInvitee(Integer documentId, Integer inviteeId) throws SQLException; 
}
