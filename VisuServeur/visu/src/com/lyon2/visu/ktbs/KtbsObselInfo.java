package com.lyon2.visu.ktbs;

import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

import org.liris.ktbs.domain.interfaces.IAttributePair;
import org.liris.ktbs.domain.interfaces.IObsel;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;

import com.ithaca.domain.model.KtbsObsel;
import com.lyon2.utils.ObselStringParams;
import com.lyon2.visu.Application;

/**
 * 
 * Service d'enregistrement des streams video dans un salon
 * 
 */
public class KtbsObselInfo {
	private Application app;

	protected static final Logger log = LoggerFactory.getLogger(
			KtbsObselInfo.class);
	
	
	
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
		log.warn("TraceId = {}",traceId);
		
		Collection<IObsel>  listObsel = ktbsService.getTraceObsels(conn, traceId);
		
		log.warn(" !!!! URA OK we have list obsel ktbs");
		log.warn("Nb obsels in the trace: {}", listObsel.size());
	
		List<KtbsObsel>  listObselVO = new LinkedList<KtbsObsel>();
		for(IObsel obsel:listObsel) {
			listObselVO.add(KtbsResourceVOFactory.createKtbsObsel(obsel));
			log.warn("---------------------------------");
			log.warn("Type : {}", obsel.getTypeUri());
			log.warn("Begin: {}", obsel.getBeginDT());
			for(IAttributePair attribute:obsel.getAttributePairs())
				log.warn("         {}: {}", new Object[]{attribute.getAttributeType(), attribute.getValue()});
		}
		KtbsVOUtils.sortObselList(listObselVO);
		
		//Date sessionStartRecordingDate = session.getStart_recording();
		Object[] args = { listObselVO };
		IConnection connClient = (IConnection) client
				.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			log.warn("Start Red5 Mapping");
			sc.invoke("checkListObselClosedSessionViaKtbs", args);
			log.warn("Red5 Mapping finished");
		}


	}
	

	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

}
