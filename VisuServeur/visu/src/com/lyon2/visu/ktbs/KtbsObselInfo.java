package com.lyon2.visu.ktbs;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.liris.ktbs.domain.interfaces.IObsel;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;
import org.slf4j.Logger;

import com.ithaca.domain.dao.impl.RetroDocumentDAOImpl;
import com.ithaca.domain.model.Obsel;
import com.ithaca.domain.model.RetroDocument;
import com.lyon2.utils.ObselStringParams;
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
public class KtbsObselInfo {
	private Application app;

	protected static final Logger log = Red5LoggerFactory.getLogger(
			KtbsObselInfo.class, "visu2");
	
	
	
	// Injected by Spring
	private KtbsService ktbsService;
	public void setKtbsService(KtbsService ktbsService) {
		this.ktbsService = ktbsService;
	}

	
	
	@SuppressWarnings("unchecked")
	public void getObselByClosedSession(IConnection conn, Integer sessionId, int statusLoggedUser) {
		log.warn("======== call on KTBS ======");
		log.warn("======== getObselByClosedSession = {}",sessionId.toString());
		IClient client = conn.getClient();
		
		
		String traceParam = "%-" + "void" + "%";
	    String refParam = "%:hasSession " + "\"" + sessionId.toString() + "\"" + "%";

		
		List<String> listTrace = null;
		try {
			listTrace = (List<String>) app.getSqlMapClient().queryForList(
					"obsels.getTracesBySessionId",   new ObselStringParams(traceParam, refParam));
		} catch (Exception e) {
			log.error("Probleme lors du listing des traces" + e);
		}
		if(listTrace.size() < 1)
		{
			log.warn("hasn't trace");
		}
		String traceId = listTrace.get(0);
		Collection<IObsel>  listObsel = ktbsService.getTraceObsels(conn, traceId);
		
		log.warn(" !!!! URA OK we have list obsel ktbs");
	
		//Date sessionStartRecordingDate = session.getStart_recording();
		Object[] args = { listObsel };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListObselClosedSessionViaKtbs", args);
		}


	}
	

	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

}
