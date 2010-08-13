/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.lyon2.visu.web;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

import com.lyon2.visu.Application;
import com.lyon2.visu.domain.model.User;

public class UserHandler extends HttpServlet 
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Red5LoggerFactory.getLogger( UserHandler.class , "visu" );
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException 
	{

		String url = "/user_management.jsp";
		
		String key = req.getParameter("key");
		String uid = req.getParameter("uid");
		
		log.debug("request uid:{} - key:{}",uid,key);
		
		HttpSession session = req.getSession(true);
		
		if( key != null && uid != null )
		{

			Integer userId = Integer.decode( uid );
			log.debug("search user with id {}", userId);
			
			User user = getUser(userId);
			if( user != null)
			{
				
				log.debug("user found {} {}", user, user.isActive() );
				if ( user.isActive() )
				{
					session.invalidate();
					req.setAttribute("user", user);
					req.setAttribute("msg", "Votre compte est déja activé");
					url="/activated.jsp";	
				}
				else if( user.getActivation_key().equals(key) )
				{ 
					log.debug("found user {}", user);   				
					session.setAttribute("userBean",user);
				}
				else
				{
					log.debug("bad activation key ");
				}
			}
			
		}
		RequestDispatcher disp = this.getServletContext().getRequestDispatcher(url); 
		disp.forward(req,resp); 
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException ,IOException 
	{
		
		HttpSession session = req.getSession();
		User user = (User)session.getAttribute("userBean");
		
		String url = "error.jsp";
		
		String password = req.getParameter("password");
		String confirmation =  req.getParameter("confirmation");

		log.debug("Send password pass:{} =? {}",password,confirmation);		
		log.debug("set password for user {}",user);
		
		if( user != null )
		{
			if( password.equals(confirmation) )
			{
				user.setActive(true);
				user.setPassword(password);			
				updateUserAccount(user);
				
				session.invalidate();
				req.setAttribute("user", user );
				req.setAttribute("msg", "Félicitaion, Votre compte est maintenant déja activé");
				url = "/activated.jsp"; 
			}
			else
			{
				log.error("les mots de passes fourni sont différents");
			}	 
		}
		
		

		RequestDispatcher disp = this.getServletContext().getRequestDispatcher(url);
		disp.forward(req,resp); 
		
	}
	
	
	
	protected User getUser(int id)
	{
		if( id > 0 )
		{	
			try 
			{
				ApplicationContext appCtx = (ApplicationContext) getServletContext().getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
				Application app = (Application) appCtx.getBean("web.handler"); 
				return (User)app.getSqlMapClient().queryForObject("users.getUser", id );
			}
			catch (SQLException e) 
			{
				// TODO Auto-generated catch block
				log.error("récupération du user impossible {}", e.getStackTrace() );
			}
		}
		return null;
	}
	
	protected void updateUserAccount(User user)
	{
		if( user != null )
		{	
			try 
			{
				log.debug("update user {} account info", user);
				ApplicationContext appCtx = (ApplicationContext) getServletContext().getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
				Application app = (Application) appCtx.getBean("web.handler"); 
				app.getSqlMapClient().update("users.update", user );
			}
			catch (SQLException e) 
			{
				// TODO Auto-generated catch block
				log.error("récupération du user impossible {}", e.getStackTrace() );
			}
		}
		return;
	}
	

}
