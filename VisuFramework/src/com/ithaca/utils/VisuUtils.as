package com.ithaca.utils
{
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.model.User;
	import mx.logging.Log;
    import mx.logging.ILogger;
		
	
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
	}
}
						