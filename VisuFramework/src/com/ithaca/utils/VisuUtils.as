package com.ithaca.utils
{
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.User;
	import mx.collections.IList;
	import com.ithaca.traces.Obsel;
	import flash.utils.Dictionary; 
	import com.ithaca.traces.model.TraceModel; 
	import com.ithaca.visu.model.vo.ObselVO;
	
	
    import mx.collections.ArrayCollection;
	
	import mx.logging.Log;
    import mx.logging.ILogger;
		
	import com.ithaca.utils.StringUtils;
			
	
	public class VisuUtils
	{
		private static var logger:ILogger = Log.getLogger("com.ithaca.utils.VisuUtils");
		
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
			var label:String = role < RoleEnum.STUDENT ? "Étudiant" :
 					role < RoleEnum.TUTEUR ? "Tuteur" :
 					role < RoleEnum.RESPONSABLE ? "Responsable" :
 					"Administrateur";
			return label;
		}

		public static function getUserLabel(user:User, firstnameAbbr:Boolean = false):String
		{
			var f = firstnameAbbr?(StringUtils.firstLetterCap(user.lastname) + "."):StringUtils.cap(user.lastname);
			return f + " " + StringUtils.cap(user.firstname);
		}
		
		public static function getSessionStatusInfoMessage(status:Number, dateRecording:Date):String
		{
			var recordingMessage:String = "";
				switch (status) {
					case SessionStatusEnum.SESSION_OPEN:
						recordingMessage = "La séance est ouverte";
						break;
					case SessionStatusEnum.SESSION_CLOSE:
						recordingMessage = "La séance est close";
						break;
					case SessionStatusEnum.SESSION_RECORDING:
						recordingMessage = "La séance est démarrée depuis " + dateRecording.getHours().toString()+"h "+dateRecording.getMinutes().toString()+"m";
						break;
					case SessionStatusEnum.SESSION_PAUSE:
						recordingMessage = "La séance est démarrée depuis " + dateRecording.getHours().toString()+ "h " + dateRecording.getMinutes().toString()+ "m" + " : Suspendue";
						break;
					default:
						recordingMessage = "Status de séance inconnu";
				}
				return recordingMessage;
		}

		public static function getStatusLabel(status:Number):String
		{
			return status == ConnectionStatus.CONNECTED ? "connected" :
					status == ConnectionStatus.PENDING ? "pending" :
					status == ConnectionStatus.RECORDING ? "recording" :
					"disconnected";
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
				
				label+= StringUtils.firstLetterCap(user.lastname) + ". " + StringUtils.cap(user.firstname);
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
			
			for each (var obselVO:ObselVO in obselList) {
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
			
			for each (var obselVO:ObselVO in obselList) {
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
						