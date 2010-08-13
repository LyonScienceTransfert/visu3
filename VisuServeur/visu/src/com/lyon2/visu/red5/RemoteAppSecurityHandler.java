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
package com.lyon2.visu.red5;

import static org.red5.server.api.ScopeUtils.getScopeService;

import java.util.List;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IScope;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.so.ISharedObjectListener;
import org.red5.server.api.so.ISharedObjectSecurity;
import org.red5.server.api.so.ISharedObjectService;
import org.red5.server.so.SharedObjectService;
import org.slf4j.Logger;


/**
 * Classe qui gère la sécurité pour la création / l'accès au sharedObject
 * 
 * Avant la creation d'un Remote sharedObject, la classe est appellée.
 * Ici on force l'ajout d'une classe pour ecouter les événements du RemoteSharedObject (création / modification / suppression ) 
 *
 */


public class RemoteAppSecurityHandler implements ISharedObjectSecurity
{ 
	protected static Logger logger = Red5LoggerFactory.getLogger(RemoteAppSecurityHandler.class, "visu" );
	
 
	  public boolean isConnectionAllowed(ISharedObject so) 
	  {
	      // Note: we don't check for the name here as only one SO can be
		  //       created with this handler.
		  logger.debug("isConnectionAllowed {}",so);
		  return true;
	  }
	  
	  
	  public boolean isCreationAllowed(IScope scope, String name, boolean persistent)
	  {
		  logger.debug("isCreationAllowed {} - {}",scope,name);
 
		  
		  if ( "VisuServer".equals(name) )
		  {
			  // get the SO creation service. Basically the following lines are exactly what MultiThreadedApplicationAdapter does.
			  // You can also pass a reference to your Application to this SecurityHandler and use it instead
			  ISharedObjectService service = (ISharedObjectService) getScopeService(scope, ISharedObjectService.class, SharedObjectService.class, false);
			  
			  if( service.createSharedObject(scope, name, persistent) == true )
			  {
				  logger.debug("Creation du SO "+name);
				  ISharedObject so = service.getSharedObject(scope, name);
				  // Adding SO listenner here
			  }
		  }
		  return true;
	  }

	  
	  public boolean isDeleteAllowed(ISharedObject so, String key) 
	  {
		  logger.debug("isDeleteAllowed {} - {}",so,key);
	      return true;
	  }
	  
	  @SuppressWarnings("unchecked")
	public boolean isSendAllowed(ISharedObject so, String message, List arguments) 
	  {
		  logger.debug("isSendAllowed {} - {} ",so,message);
		  return true;
	  }
	  
	  public boolean isWriteAllowed(ISharedObject so, String key, Object value) 
	  {
		  logger.debug("isWriteAllowed {} - {} ",so,key);
	      return true;
	  }
	  
}
