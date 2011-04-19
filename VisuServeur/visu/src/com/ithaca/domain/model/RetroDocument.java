package com.ithaca.domain.model;

import java.util.Date;
import java.util.Set;

import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;

/**
 * The document that is created by users in the retrospection room
 * to summarize their session (le "bilan").
 * 
 * @author Damien Cram
 *
 */
public class RetroDocument {

	private Integer documentId;

	private String title;

	private String description;

	private Integer ownerId;

	private Integer sessionId;

	private Date creationDate;

	private Date lastModified;

	private String xml;

	
	// Added By Damien   
	private Set<Integer> inviteeIds;
	public void setInviteeIds(Set<Integer> inviteeIds) {
		this.inviteeIds = inviteeIds;
	}
	public Set<Integer> getInviteeIds() {
		return inviteeIds;
	}
	
	private Session session;
	public void setSession(Session session) {
		this.session = session;
	}
	public Session getSession() {
		return session;
	}
	
	public void setXml(String xml) {
		this.xml = xml;
	}

	public String getXml() {
		return xml;
	}

	public Integer getDocumentId() {
		return documentId;
	}

	public void setDocumentId(Integer documentId) {
		this.documentId = documentId;
	}


	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(Integer ownerId) {
		this.ownerId = ownerId;
	}

	public Integer getSessionId() {
		return sessionId;
	}

	public void setSessionId(Integer sessionId) {
		this.sessionId = sessionId;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getLastModified() {
		return lastModified;
	}

	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}

}
