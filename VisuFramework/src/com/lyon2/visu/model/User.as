package   com.lyon2.visu.model
{
	
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.ui.utils.RightStatus;
	import com.lyon2.visu.vo.UserVO;

	public class User extends UserVO
	{
		public var status:int;
		private var _role:int;
		public var id_client:String = "";
		public var currentSessionId:int;
		
		public function User(user:UserVO)
		{
			this.id_user = user.id_user;
			this.lastname = user.lastname;
			this.firstname = user.firstname;
			this.mail = user.mail;
			this.avatar = user.avatar;
			this.profil = user.profil || "";
			this.password = user.password || "";
		}
		public function getId():int
		{
			return this.id_user;
		}
		
		public function get role():int{
			return RightStatus.binaryToNumber(this.profil);
		}
		
		public function getFirstName():String
		{
			return this.firstname;
		}
		
		public function getProfile():String
		{
			return this.profil;
		}
		
		public function getShortProfileDescription():String
		{
			return "todo";
		}
		
		public function getLongProfileDescription():String
		{
			return "todo";
		}
		
		public function getStatus():int
		{
			return this.status;
		}
		
		public function setStatus(value:int):void
		{
			this.status = value;			
		}
		
	}
}