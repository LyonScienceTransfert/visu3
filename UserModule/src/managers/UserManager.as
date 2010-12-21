package managers
{
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.User;
	import com.lyon2.visu.vo.UserVO;
	
	import flash.events.Event;
	
	import modules.UserModule;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;

	public class UserManager
	{
		import flash.events.IEventDispatcher;
		
		protected static var log:ILogger = Log.getLogger("managers.UserManager");
		
		private var dispatcher:IEventDispatcher;
		
		public function UserManager(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
			
		}
		/*
		* this variable contains the list of profileDescription 
		*/	
		/*
		[Bindable] public var profiles:Array=[];	
		public function setProfiles(value:Array):void { log.debug(value.toString());profiles = value; }
		*/
		[Bindable] public var users:Array=[];	
		public function setUsers(value:Array):void 
		{ 
			log.debug( ObjectUtil.toString(value));
			var ar:Array = []
			for each (var vo:UserVO in value)
			{
				ar.push(new User(vo)) ; 
			}
			users = ar;
			log.debug("setUsers "+ users);
		}
			
		/**
		 * get the list of users 
		 */
		public function getUsers():void
		{
			var e:UserEvent = new UserEvent(UserEvent.LOAD_USERS);
			dispatcher.dispatchEvent( e );
		}
		
		/**
		 * Default error Handler for rtmp method call
		 */
		public function onError(event:Event):void
		{
			log.error(event.toString());
		}
		
		/**
		 * return updated user
		 */
		public function onUpdateUser(userVO:UserVO):void{
			//var userEvent:UserEvent = new UserEvent(UserEvent.UPDATE_VIEW_USER);
			//userEvent.userVO = userVO;
			var userModule:UserModule = Model.getInstance().getCurrentUserModule() as UserModule;
			userModule.setModeEditUpdatedUser(userVO);
			// FIXME : If using dispatcher => Error : many instances the UserModule
			//TypeError: Error #1034: Echec de la contrainte de type 
			//dispatcher.dispatchEvent(userEvent);
		}
		
		/**
		 * return added user
		 */
		public function onAddUser(userVO:UserVO):void{
			var userModule:UserModule = Model.getInstance().getCurrentUserModule() as UserModule;
			userModule.setModeEditAddedUser(userVO);
		}
		
		/**
		 * return id of the deleted user
		 */
		public function onDeleteUser(userId:int):void{
			var userModule:UserModule = Model.getInstance().getCurrentUserModule() as UserModule;
			userModule.setModeEditDeletedUser(userId);
		}
	}
}