package com.lyon2.visu.ktbs;

import java.sql.SQLException;
import java.util.Collection;
import java.util.List;

import org.liris.ktbs.domain.interfaces.IObsel;
import org.liris.ktbs.domain.interfaces.ITrace;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IConnection;
import org.slf4j.Logger;

public class KtbsService {

	protected static final Logger log = Red5LoggerFactory.getLogger(
			KtbsService.class, "visu2");
	
	// Injected by Spring
	private boolean pluggedToKtbs;
	public void setPluggedToKtbs(boolean pluggedToKtbs) {
		this.pluggedToKtbs = pluggedToKtbs;
	}
	
	// Injected by Spring
	private KtbsApplicationHelper ktbsHelper;
	public void setKtbsHelper(KtbsApplicationHelper ktbsHelper) {
		this.ktbsHelper = ktbsHelper;
	}
	
	public Collection<IObsel> getTraceObsels(IConnection conn, String traceId) {
		//Integer uid = (Integer)conn.getClient().getAttribute("uid");
		int uid = Integer.parseInt(traceId.split("-")[2]);
		log.warn("Id the bas ktbs est = {}", String.valueOf(uid));
		return ktbsHelper.getTraceObsels(uid, traceId);
	}
	public Collection<ITrace> getTraces(IConnection conn) {
		Integer uid = (Integer)conn.getClient().getAttribute("uid");
		Collection<ITrace> traces = ktbsHelper.getTraces(uid);
		return traces;
	}

	
	public void sendToKtbs(final IConnection conn, final Integer subject, final String trace,
			final String typeObsel, final List<Object> paramsObsel, final String[] traceType) {
		if(pluggedToKtbs)  {
			log.info("the KTBS is plugged");
			if(!ktbsHelper.isStarted()) {
				log.info("Starting the KTBS service");
				ktbsHelper.init();
			}
			Thread sentToKtbsThread = new Thread() {
				@Override
				public void run() {
					try {
						log.debug("Adding Obsel to KTBS");
						ktbsHelper.sendToKtbs(conn, subject, trace, typeObsel, paramsObsel, traceType);
					} catch (SQLException e) {
						log.error("A problem occurred when sending the obsel to the KTBS", e);
					}
				}
			};
			sentToKtbsThread.setPriority(Thread.MIN_PRIORITY);
			log.info("Start the the thread that adds the obsel to KTBS");
			sentToKtbsThread.start();
		} else 
			log.debug("Visu is not plugged to KTBS. Obsel not sent to KTBS.");
	}
}
