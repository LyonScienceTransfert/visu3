package com.lyon2.visu.red5;

import java.sql.SQLException;
import java.util.List;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.service.IServiceCapableConnection;

import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.Session;
import com.lyon2.visu.domain.model.User;
 
/**
 * 
 *  
 *
 */
public class UserInfo 
{
	private Application app;
  	
	public Application getApp() {
		return app;
	}

	public void setApp(Application app) {
		this.app = app;
		log.debug("set application " + app);
	}

	protected static final Logger log = LoggerFactory.getLogger(SessionInfo.class);
	
	@SuppressWarnings({ "unchecked" })
	public void getListUser(IConnection conn, String typeModule) throws SQLException 
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
		
		Object[] args = {listUser, typeModule};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkListUser", args);
			} 	
	}
	
	@SuppressWarnings("unchecked")
	public void getUsersFromSession(IConnection conn, Integer sessionId, String sessionDate) {
		log.warn("======== getUsersFromSession ");
		log.warn("=====sessionId = {}", sessionId);
		IClient client = conn.getClient();
		List<User> listUser = null;
		try
		{
			listUser = (List<User>) app.getSqlMapClient().queryForList("users.getUsersFromSession",sessionId);
		} catch (Exception e) {
			log.error("Probleme lors du listing des users dans la séance id = {}" + e,sessionId);
		}	
		
		Object[] args = {listUser,sessionId, sessionDate};
		IConnection connClient = (IConnection)client.getAttribute("connection");
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) connClient;
			sc.invoke("checkUsersFromSession", args);
			} 	
		
	}
}
