package com.ithaca.visu.view.session
{
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.visu.model.User;
	
    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;

	import mx.controls.Image;
	import mx.graphics.GradientEntry;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	

	public class SessionViewSalonRetro extends SkinnableComponent
	{	
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
		private var _sessionId:int;
		private var _traceId:String;
		
		private var dateChange:Boolean = false;
		private var userChange:Boolean = false;
		
		public function SessionViewSalonRetro()
		{
			super();
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		public function get traceId():String {return _traceId; }
		public function set traceId(value:String):void
		{
			_traceId = value;
		}
		public function get sessionId():int {return _sessionId; }
		public function set sessionId(value:int):void
		{
			_sessionId = value;
		}
		public function get theme():String {return _theme; }
		public function set theme(value:String):void
		{
			_theme = value;
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
				
				dateLabel.text = UtilFunction.getLabelDate(this.dateRecorded,"-") + fxgt.gettext(" à ") + UtilFunction.getHeurMinDate(this.dateRecorded);
			}
			if (userChange)
			{
				userChange = false;
				ownerImage.source = ownerSession.avatar;	
				ownerNameLabel.text = ownerSession.lastname+" "+ownerSession.firstname;
				ownerNameLabel.toolTip = ownerNameLabel.text;
				
			}
		}
		
		public function setSelected(value:Boolean):void
		{
			if(value)
			{
				gradientEntryFrom.color = new uint("0xcedbef");
				gradientEntryTo.color = new uint("0x70b2ee");
			}
			else
			{
				gradientEntryFrom.color = new uint("0xFFFFFF");
				gradientEntryTo.color = new uint("0xD8D8D8");
			}
		}

	}
}