/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
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
package com.ithaca.utils
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.model.vo.SGBDObsel;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	
	import flash.utils.Dictionary;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
    
	public class VisuUtils
	{
        [Bindable]
        private static var fxgt: _FxGettext = FxGettext;
        
		public static var FOLDER_AUDIO_COMMENT_FILES:String = "usersAudioRetroDocument";
		
		private static var logger:ILogger = Log.getLogger("com.ithaca.utils.VisuUtils");
		
        public static function isAddTraceSalonSynchrone(loggedUser:User, checkUser:User, unidistance:Boolean):Boolean
        {
            if(unidistance)
            {
                if(loggedUser.id_user == checkUser.id_user || isResponsable(loggedUser) || isAdmin(loggedUser))
                {
                    return true;
                }else if(isTuteur(loggedUser) || isStudent(loggedUser))
                {
                    if(isResponsable(checkUser) || isAdmin(checkUser))
                    {
                       // hide admin, responsable for tuteur,admin
                       return false;
                    }else return true;
                }else return false;
            }
                
            if(loggedUser.id_user == checkUser.id_user || isResponsable(loggedUser) || isAdmin(loggedUser))
            {
                return true;
            }else if(isTuteur(loggedUser) && isStudent(checkUser))
            {
              return true;
            }else return false;
        }
        
		public static function isStudent(user:User) : Boolean {
			return getRoleConstantValue(user.role) == RoleEnum.STUDENT;
		}
		
		public static function isTuteur(user:User) : Boolean {
			return getRoleConstantValue(user.role) == RoleEnum.TUTEUR;
		}
		
		public static function isResponsable(user:User) : Boolean {
			return getRoleConstantValue(user.role) == RoleEnum.RESPONSABLE;
		}
		
		public static function isAdmin(user:User) : Boolean {
			return getRoleConstantValue(user.role) == RoleEnum.ADMINISTRATEUR;
		}
		
		public static function getRoleConstantValue(role:Number):int
		{
			return role < RoleEnum.STUDENT ? RoleEnum.STUDENT :
 					role < RoleEnum.TUTEUR ? RoleEnum.TUTEUR :
 					role < RoleEnum.RESPONSABLE ? RoleEnum.RESPONSABLE :
 							RoleEnum.ADMINISTRATEUR;
		}
		
		public static function getRoleLabel(role:int):String
		{
			var label:String = role < RoleEnum.STUDENT ? fxgt.gettext("Étudiant") :
 					role < RoleEnum.TUTEUR ? fxgt.gettext("Tuteur") :
 					role < RoleEnum.RESPONSABLE ? fxgt.gettext("Responsable") :
                    fxgt.gettext("Administrateur");
			return label;
		}

		public static function getUserLabelLastName(user:User, lastnameAbbr:Boolean = false):String
		{
			if(user == null) return "";
			var f:String = lastnameAbbr?(StringUtils.firstLetterCap(user.firstname) + "."):StringUtils.cap(user.firstname);
			return f + " " + StringUtils.cap(user.lastname);
		}
		
		public static function getUserLabelFirstName(user:User, firstnameAbbr:Boolean = false):String
		{
			if(user == null) return "";
			var f:String = firstnameAbbr?(StringUtils.firstLetterCap(user.lastname) + "."):StringUtils.cap(user.lastname);
			return f + " " + StringUtils.cap(user.firstname);
		}
		
		public static function getSessionStatusInfoMessage(status:Number, dateRecording:Date):String
		{
			var recordingMessage:String = "";
				switch (status) {
					case SessionStatusEnum.SESSION_OPEN:
						recordingMessage = fxgt.gettext("La séance est ouverte");
						break;
					case SessionStatusEnum.SESSION_CLOSE:
						recordingMessage = fxgt.gettext("La séance est fermée");
						break;
					case SessionStatusEnum.SESSION_RECORDING:
						recordingMessage = fxgt.gettext("La séance est démarrée depuis")+ " " + dateRecording.getHours().toString()+fxgt.gettext("h")+" "+dateRecording.getMinutes().toString()+fxgt.gettext("m");
						break;
					case SessionStatusEnum.SESSION_PAUSE:
						recordingMessage = fxgt.gettext("La séance est démarrée depuis") +" "+ dateRecording.getHours().toString()+ fxgt.gettext("h") + " "+ dateRecording.getMinutes().toString()+ fxgt.gettext("m") + " : "+ fxgt.gettext("Suspendue");
						break;
					default:
						recordingMessage = fxgt.gettext("Statut de séance inconnu");
				}
				return recordingMessage;
		}

		public static function getStatusLabel(status:Number):String
		{
			return status == ConnectionStatus.CONNECTED ? fxgt.gettext("connected") :
					status == ConnectionStatus.PENDING ? fxgt.gettext("pending") :
					status == ConnectionStatus.RECORDING ? fxgt.gettext("recording") :
                    fxgt.gettext("disconnected");
		}
		
		public static function getStatusImageSource(status:int):Class {
				if(status == ConnectionStatus.CONNECTED) {
					return IconEnum.getIconByName('ballGreen');
				} else if(status == ConnectionStatus.DISCONNECTED) {
					return IconEnum.getIconByName('ballGrey');
				} else if(status == ConnectionStatus.PENDING) {
					return IconEnum.getIconByName('ballBlue');
				} else if(status == ConnectionStatus.RECORDING) {
					return IconEnum.getIconByName('ballRed');
				} else {
					return null;
				}
		}
		
		public static function joinUserList(userList:Array):String
		{
			var label:String = "";
			var first:Boolean = true;
			for each (var user:User in userList) {
				label+= first ? '': ', ';
				
				label+= getUserLabelLastName(user, true);
				first = false;
			}
			return label;
		}
		
		/*
		 * Returns a hash where keys are user ids and values are hashes structured followings this example :
		 * {userId: 'the user id', path: 'path to the stream', date:'date of the record file name event'}
		 * 
		 *  
		 */
		public static function getStreamInfoFromSessionObselList(obselList:Array):Dictionary
		{
			var entriesPerUser:Dictionary = new Dictionary();
			
			for each (var obselVO:SGBDObsel in obselList) {
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				if (obsel.type == TraceModel.RECORD_FILE_NAME) {
						
						var path:String = obsel.props[TraceModel.PATH];
						var uid:Number = parseInt(obsel.props[TraceModel.UID]);
						var date:Number = obsel.begin;
						
						var entry:Object = new Object();
						entry['path']=path;
						entry['userId']=uid;
						entry['date']=date;
						
						if(!entriesPerUser[uid]) 
							entriesPerUser[uid] = new Array();
						
						
						// logger.debug("RecordFileName found for the user {0} (string: {3}), date: {1}, path: {2}", uid, date, path, obsel.props[TraceModel.UID]);
						
						var userEntries:Array = entriesPerUser[uid];
						
						var contains:Boolean = false;
						for each (var e:Object in userEntries) {
							if(e['path'] == path) {
								contains = true;
								break;
							}
						}
						
						if(!contains) {
							userEntries.push(entry);
						}
				}
			}
			
			for (var userId:Object in entriesPerUser) {
				var entries:Array = entriesPerUser[userId];
				entries.sortOn("date", Array.NUMERIC);
			}
			
			return entriesPerUser;
		}
		
		
		public static function getSessionStartTimeFromObselList(obselList:Array):Number
		{
			var sessionStart:Number;
			
			for each (var obselVO:SGBDObsel in obselList) {
				var obsel:Obsel = Obsel.fromRDF(obselVO.rdf);
				if (obsel.type == TraceModel.SESSION_START) 
						return obsel.begin;
			}
			
			return -1;
			
		}
		
		public static function joinUserListFromUserIds(userIdList:ArrayCollection):String
		{
			var userList:Array = new Array();
			
			for each (var userId:Number in userIdList) {
				
				userList.push(Model.getInstance().getUserPlateformeByUserId(userId));
			
			}
			return joinUserList(userList);
		}
	}
}
						