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

package com.lyon2.utils;

import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

public class MailerFacade
{
    private static Logger log = Red5LoggerFactory.getLogger(MailerFacade.class, "visu" );

    // If smtp == "local", then we log messages to the logger rather
    // than sending them through a mailserver.
    // Any other value is considered as the name of the webserver.
    private static String smtpserver =  "local";

    public static void setSmtpServer(String server)
    {
	log.debug("Setting SMTP server to {}", server);
	smtpserver=server;
    }

    public static String getSmtpServer()
    {
	return smtpserver;
    }

    public static void sendMail(String subject, String[] recipients, String sender, String message) throws MessagingException
    {
	//Set the host smtp address
	Properties props = new Properties();
	props.put("mail.smtp.host", smtpserver);

	// create some properties and get the default Session
	Session session = Session.getDefaultInstance(props, null);

	// create a message
	Message msg = new MimeMessage(session);

	// set the from and to address
	InternetAddress addressFrom = new InternetAddress(sender);
	msg.setFrom(addressFrom);

	InternetAddress[] addressTo = new InternetAddress[recipients.length];
	for (int i = 0; i < recipients.length; i++)
	    {
		addressTo[i] = new InternetAddress(recipients[i]);
	    }
	msg.setRecipients(Message.RecipientType.TO, addressTo);

	// Optional : You can also set your custom headers in the Email if you Want
	//msg.addHeader("MyHeaderName", "myHeaderValue");
	msg.setHeader("X-Mailer", "msgsend");
	msg.setSentDate(new Date());


	// Setting the Subject and Content Type
	msg.setSubject(subject);
	msg.setText(message);

	try
	    {
		log.debug("send mail to {}", recipients);
		if ( smtpserver.equals("local") )
		    {
			// Local fallback: use log
			log.debug("Pseudo-sendmail to {}:", recipients);
			log.debug("-------------\n{}\n-------------\n", message);
		    }
		else
		    {
			Transport.send(msg);
		    }
	    }
	catch (MessagingException mex)
	    {
		log.error("fail to send mail to {}", recipients);
		mex.printStackTrace();
		Exception ex = mex.getNextException();
		if (ex != null)
		    {
			ex.printStackTrace();
		    }
	    }
    }
}
