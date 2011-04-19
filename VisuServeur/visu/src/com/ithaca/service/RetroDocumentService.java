package com.ithaca.service;

import java.util.Collection;

import com.ithaca.domain.model.RetroDocument;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;

public interface RetroDocumentService {
	
	public Collection<RetroDocument> findDocumentsWhereUserIsInvited(int userId, boolean withXmlContent);
	public Collection<RetroDocument> findDocumentsByOwner(int ownerId, boolean withXmlContent);
	
	public Collection<RetroDocument> findDocumentsByOwner(User owner);
	
	public Collection<RetroDocument> findDocumentsByOwnerAndSession(User owner, Session session);

	public RetroDocument getRetroDocument(int docId);
	
	public boolean save(RetroDocument document);
	
	public boolean deleteDocument(RetroDocument document);
	
	public boolean inviteUser(RetroDocument document, User invitee);

	public boolean removeInvitee(RetroDocument document, User invitee);
}
