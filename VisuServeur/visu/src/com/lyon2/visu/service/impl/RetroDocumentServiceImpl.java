package com.lyon2.visu.service.impl;

import java.sql.SQLException;
import java.util.Collection;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import com.ithaca.domain.dao.RetroDocumentDAO;
import com.ithaca.domain.model.RetroDocument;
import com.ithaca.service.RetroDocumentService;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;

public class RetroDocumentServiceImpl implements RetroDocumentService {

	private Logger logger = Red5LoggerFactory.getLogger(RetroDocumentServiceImpl.class,"visu");

	private RetroDocumentDAO retroDocumentDao;

	public void setRetroDocumentDao(RetroDocumentDAO retroDocumentDao) {
		this.retroDocumentDao = retroDocumentDao;
	}

	public Collection<RetroDocument> findDocumentsByOwner(User owner) {
		try {
			return retroDocumentDao.getRetroDocumentsByOwner(owner.getId_user());
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return null;
		}
	}

	public Collection<RetroDocument> findDocumentsByOwnerAndSession(
			User owner, Session session) {
		try {
			return retroDocumentDao.getRetroDocumentsByOwnerAndBySession(owner.getId_user(), session.getId_session());
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return null;
		}
	}

	public RetroDocument getRetroDocument(int docId) {
		try {
			return retroDocumentDao.getRetroDocumentById(docId);
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return null;
		}
	}

	public boolean save(RetroDocument document) {
		try {
			return retroDocumentDao.saveRetroDocument(document);
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return false;
		}
	}

	public boolean deleteDocument(RetroDocument document) {
		try {
			return retroDocumentDao.deleteRetroDocument(document.getDocumentId());
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return false;
		}
	}

	public boolean inviteUser(RetroDocument document, User invitee) {
		try {
			retroDocumentDao.createInvitee(document.getDocumentId(), invitee.getId_user());
			return retroDocumentDao.saveRetroDocument(document);
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return false;
		}
	}

	public boolean removeInvitee(RetroDocument document, User invitee) {
		try {
			return retroDocumentDao.removeInvitee(document.getDocumentId(), invitee.getId_user());
		} catch (SQLException e) {
			logger.warn(e.getMessage(), e);
			return false;
		}
	}

	public Collection<RetroDocument> findDocumentsWhereUserIsInvited(
			RetroDocument document, User invitee) {
		throw new UnsupportedOperationException("Not yet implemented");
	}

	public Collection<RetroDocument> findInvitees(RetroDocument document) {
		throw new UnsupportedOperationException("Not yet implemented");
	}
}
