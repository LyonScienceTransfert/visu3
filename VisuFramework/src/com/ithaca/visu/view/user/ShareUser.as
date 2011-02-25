package com.ithaca.visu.view.user
{
	import com.ithaca.visu.model.User;
	
	import flash.events.Event;
	
	import spark.components.CheckBox;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import com.ithaca.visu.ui.utils.RoleEnum;
	
	public class ShareUser extends SkinnableComponent
	{
		[SkinPart("true")]
		public var fistLastNameUser:Label;
		
		[SkinPart("true")]
		public var checkBoxUser:CheckBox;
		
		private var _fistLastName:String;
		private var _user:User;
		private var _share:Boolean;
		
		public function get user():User {return _user;}
		public function set user(value:User):void
		{
			this._user = value;
			this._fistLastName = value.firstname + " "+value.lastname;
		}
		public function get share():Boolean {return _share;}
		public function set share(value:Boolean):void
		{
			this._share = value;
		}
			
		public function ShareUser()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == checkBoxUser)
			{
				checkBoxUser.selected = _share;
				checkBoxUser.addEventListener(Event.CHANGE, onChangeShare);
			}
			if (instance == fistLastNameUser)
			{
				fistLastNameUser.text = _fistLastName;
				// set color red for admins
				if(user.role > RoleEnum.RESPONSABLE-1)
				{
					fistLastNameUser.setStyle("color","0xe34545");					
				}
				
			}
		}
		
		private function onChangeShare(event:Event):void
		{
			var t:uint = 1;
			_share = checkBoxUser.selected;
		}
	}
}