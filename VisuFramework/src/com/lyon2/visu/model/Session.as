package  com.lyon2.visu.model
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.visu.vo.SessionVO;
	
	import mx.collections.ArrayCollection;

	public class Session
	{
			public var id_session:int;
			public var id_user:int;
			public var theme:String;
			public var date_session:Date;
			public var isModel:Boolean;
			public var description:String;
			public var participants:ArrayCollection = new ArrayCollection();
			public var date_start_recording:Date;
			public var statusSession:int = -1;

		public function Session(session:SessionVO)
		{
			this.id_session = session.id_session;
			this.id_user = session.id_user;
			this.theme = session.theme;
			this.date_session = session.date_session;
			this.isModel = session.isModel;
			this.description = session.description;
			this.date_start_recording = session.start_recording;
			this.statusSession = session.status_session;
			
		}
		
		public function getSessionId():int {return this.id_session};
		public function getSessionDate():Date {return this.date_session};
		public function getTheme():String {return this.theme};
		
		public function setUsers(arUsers:Array):void
		{
			var nbrUser:uint = arUsers.length;
			if(nbrUser == 0)
			{
				// TODO MESSAGE
				return;
			}
			// clear list users of this session
			this.participants.removeAll();
			for(var nUser:uint = 0; nUser < nbrUser ; nUser++)
			{
				var user:User = new User(arUsers[nUser]);
				this.participants.addItem(user);
			}
		}
		
		public function checkConnectedUsers(arUsers:ArrayCollection):void{
			// clear status for all users 
			this.clearStatus();
			var nbrConnectedUsers:uint = arUsers.length;
			for(var nConnectedUsers:uint  = 0; nConnectedUsers < nbrConnectedUsers ; nConnectedUsers++){
				var connectedUser:User = arUsers[nConnectedUsers];
				var userId:uint = connectedUser.getId();
				updateStatus(userId, connectedUser.status);
			}
		}
		
		private function updateStatus(id:uint, status:int):void
		{
			var nbrUser:uint = this.participants.length;
			for(var nUser:uint = 0; nUser < nbrUser; nUser++){
				var user:User = this.participants[nUser];
				var userId:uint = user.getId();
				if(userId == id)
				{
				 	user.status = status;	
				}
			}
		}
		
		public function hasUser(value:int):Boolean
		{
			var nbrUsers:uint = this.participants.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var userId:uint	= (this.participants[nUser] as User).getId();
				if(userId == value)
				{
					return true;
				}
			}
			return false;
		}
			
		private function clearStatus():void{
			for each(var user:User in this.participants)
			{
				user.setStatus(ConnectionStatus.DISCONNECTED);
			}
		}		
	}
}