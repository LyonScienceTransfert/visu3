package com.ithaca.visu.view.session
{
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.SessionFilterEnum;

    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Image;
	import mx.graphics.GradientEntry;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("sessionModel")]
	[SkinState("sessionWas")]
	[SkinState("sessionWill")]
	
	public class SessionViewSalonSession extends SkinnableComponent
	{
		[SkinPart("true")]
		public var groupUserSession:Group;
		
		[SkinPart("true")]
		public var themeTitleLabel:Label;
		
		[SkinPart("true")]
		public var themeLabel:Label;
		
		[SkinPart("true")]
		public var dateTitleLabel:Label;
		
		[SkinPart("true")]
		public var dateLabel:Label;
		
		[SkinPart("true")]
		public var ownerTitleLabel:Label;
		
		[SkinPart("true")]
		public var ownerNameLabel:Label;
		
		[SkinPart("true")]
		public var ownerImage:Image;

		[SkinPart("true")]
		public var gradientEntryFrom:GradientEntry;

		[SkinPart("true")]
		public var gradientEntryTo:GradientEntry;
		
        [Bindable]
        private var fxgt: _FxGettext = FxGettext;
		
        private var _date:Date;
		private var _theme:String;
		private var _user:User;
		private var _session:Session;
		private var _listUserSession:IList;

		
		private var dateChange:Boolean = false;
		private var themeChange:Boolean = false;
		private var userChange:Boolean = false;
		private var listUserSessionChange:Boolean = false;
		
		private var IMAGE_USER_SESSION_HEIGHT:int = 24;
		private var IMAGE_USER_SESSION_WIDTH :int = 24;
		
		private var model:Boolean = false;
		private var was:Boolean = false;
		
		public function SessionViewSalonSession()
		{
			super();
			this.buttonMode = true;
			this.useHandCursor = true;
			_listUserSession = new ArrayCollection();
		}

		public function get session():Session {return _session; }
		public function set session(value:Session):void
		{
			_session = value;
		}
		public function get theme():String {return _theme; }
		public function set theme(value:String):void
		{
			_theme = value;
			themeChange = true;
			this.invalidateProperties();
		}
		public function get dateRecorded():Date {return _date; }
		public function set dateRecorded(value:Date):void
		{
			_date = value;
			dateChange = true;
			this.invalidateProperties();
		}
		
		public function get ownerSession():User {return _user; }
		public function set ownerSession(value:User):void
		{
			_user = value;
			userChange = true;
			this.invalidateProperties();
		}
		
		public function get listUserSession():IList {return _listUserSession }
		public function set listUserSession(value:IList):void
		{
			_listUserSession = value;
			listUserSessionChange = true;
			this.invalidateProperties();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == themeLabel)
			{
				themeLabel.text = _theme;
				themeLabel.toolTip = _theme;
				
			}
			if(instance == dateLabel)
			{
				if(dateRecorded == null)
				{
					dateLabel.text = fxgt.gettext("Chargement des données.");
				}else
				{
					dateLabel.text = _date.toString();
				}
			}
			
			if(instance == ownerNameLabel)
			{
				if(ownerSession != null){
					ownerNameLabel.text = _user.lastname+" "+_user.firstname;					
				}
			}	
			
			if(instance == ownerImage)
			{
				if(ownerSession != null)
				{
					ownerImage.source = _user.avatar;
				}
			}
			
			if(instance == groupUserSession)
			{
				if(this._listUserSession.length > 0)
				{
					setAvatarUser();
				}
			}
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (dateChange)
			{
				dateChange = false;
				
				dateLabel.text = UtilFunction.getLabelDate(this.dateRecorded, "-") + fxgt.gettext(" à ") + UtilFunction.getHeurMinDate(this.dateRecorded);
			}
			if (userChange)
			{
				userChange = false;
				ownerImage.source = ownerSession.avatar;	
				ownerNameLabel.text = ownerSession.lastname+" "+ownerSession.firstname;
				ownerNameLabel.toolTip = ownerNameLabel.text;	
			}
			
			if (listUserSessionChange)
			{
				listUserSessionChange = false;
				if(this.groupUserSession != null)
				{
					setAvatarUser();			
				}
			}
			
			if (themeChange)
			{
				themeChange = false;
				themeLabel.text = _theme;
				themeLabel.toolTip = _theme;
			}
			
		}
		
		private function setAvatarUser():void
		{
			this.groupUserSession.removeAllElements();
			for each(var user:User in this.listUserSession)
			{
				var avatarUserUrl:String = user.avatar;
				var imageUser:Image = new Image();
				imageUser.height = IMAGE_USER_SESSION_HEIGHT;
				imageUser.width = IMAGE_USER_SESSION_WIDTH;					
				imageUser.source = avatarUserUrl;
				imageUser.toolTip = user.firstname +" "+ user.lastname;
				groupUserSession.addElement(imageUser);
			}		
		}
		public function setStatusSession(value:int):void
		{
			switch (value) {
				case SessionFilterEnum.SESSION_PLAN:
					model = true;
				break;
				case SessionFilterEnum.SESSION_WAS:
					was = true;
				break;
				default:
				break;
			}
			this.invalidateSkinState();		
		}
		
		override protected function getCurrentSkinState():String
		{
			if (!enabled)
			{
				return "disable";
			}else
				if(model){
					return "sessionModel"
				}else
				{
					if(was){
						return "sessionWas";
					}else{
						return "sessionWill";
					}
				} 
		}
		
		public function setSelected(value:Boolean):void
		{
			if(value)
			{
				gradientEntryFrom.color = new uint("0xcedbef");
				gradientEntryTo.color = new uint("0x70b2ee");
/*				gradientEntryFrom.color = 13556719;
				gradientEntryTo.color = 7385838;*/
			}
			else
			{
				gradientEntryFrom.color = new uint("0xFFFFFF");
				gradientEntryTo.color = new uint("0xD8D8D8");
			}
		}
	}
}