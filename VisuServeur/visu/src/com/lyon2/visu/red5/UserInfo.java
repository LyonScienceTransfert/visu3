package com.lyon2.visu.red5;

import java.sql.SQLException;
import java.util.List;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;
import org.slf4j.Logger;

import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.User;
 
/**
 * 
 *  
 *
 */
public class UserInfo 
{
	private Application app;
  	
	protected static final Logger log = Red5LoggerFactory.getLogger(SessionInfo.class, "visu2" );
	
	@SuppressWarnings({ "unchecked" })
	public void getListUser(IConnection conn) throws SQLException 
	{
		log.warn("======== getListUser ");

		// get role of logged user
		IClient client = conn.getClient();
		List<User> listUser = null;
		try
		{
			listUser = (List<User>) app.getSqlMapClient().queryForList("users.getUsers");
		} catch (Exception e) {
			log.error("Probleme lors du listing des users " + e);
		}	
		
		Object[] args = {listUser};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListUser", args);
			} 	
	}
	
	public void setApplication(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}
	
 
}
