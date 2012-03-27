package com.ithaca.visu.view.user
{
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.RoleEnum;
	import com.ithaca.utils.VisuUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.CheckBox;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ShareUser extends SkinnableComponent
	{
		[SkinPart("true")]
		public var firstLastNameUser:Label;
		
		[SkinPart("true")]
		public var checkBoxUser:CheckBox;
		
		private var _firstLastName:String;
		private var _user:User;
		private var _share:Boolean;
		
		public function get user():User {return _user;}
		public function set user(value:User):void
		{
			this._user = value;
			this._firstLastName = value.firstname + " "+value.lastname;
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
			if (instance == firstLastNameUser)
			{
				firstLastNameUser.text = _firstLastName + " (" + VisuUtils.getRoleLabel(user.role) + ")";
				// set color red for admins
				if(user.role > RoleEnum.RESPONSABLE-1)
				{
					firstLastNameUser.setStyle("color","0xe34545");
				}
                
                firstLastNameUser.buttonMode = true;
                // listener click on label 
                firstLastNameUser.addEventListener(MouseEvent.CLICK, onClickFirstLastNameUser);
			}
		}
		
        private function onClickFirstLastNameUser(event:MouseEvent):void
        {
            if(checkBoxUser.selected)
            {
                checkBoxUser.selected = false;
            }else
            {
                checkBoxUser.selected = true;
            }
            
            _share = checkBoxUser.selected;
            dispatcherChangeShare();
        }
        
		private function onChangeShare(event:Event):void
		{
			_share = checkBoxUser.selected;
            dispatcherChangeShare();
		}
        
        private function dispatcherChangeShare():void
        {
            var changeCheckBox:Event = new Event("selectedSharedUser");
            this.dispatchEvent(changeCheckBox);
        }
	}
}