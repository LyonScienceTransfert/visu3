package com.ithaca.visu.controls.sessions
{
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.ui.utils.SessionStatusEnum;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("planMine")]
	[SkinState("planOther")]
	[SkinState("sessionPast")]
	[SkinState("sessionComing")]
	
	public class SessionSummaryView extends SkinnableComponent
	{
		[SkinPart("true")]
		public var themeLabel:Label;
		[SkinPart("true")]
		public var ownerLabel:Label;
		[SkinPart("true")]
		public var partageLabel:Label;
		[SkinPart("true")]
		public var datePlanedLabel:Label;
		[SkinPart("true")]
		public var dateRecordingLabel:Label;
		[SkinPart("true")]
		public var durationPlanedLabel:Label;
		[SkinPart("true")]
		public var nbrUsersLabel:Label;
		[SkinPart("true")]
		public var durationRecordPlanedLabel:Label;
		[SkinPart("true")]
		public var nbrUsersRecordPlanedLabel:Label;
		[SkinPart("true")]
		public var nbrBilansLabel:Label;
		
		private var _session:Session;
		private var sessionChange:Boolean;
		private var _loggedUser:User;
		
		private var _durationPlaned:int;
		private var durationPlanedChange:Boolean;
		private var _durationRecorded:int = 0;
		private var durationRecordedChange:Boolean;
		private var _nbrRetrodocument:int = 0;
		private var nbrRetrodocumentChange:Boolean;
		private var dateSessionChange:Boolean;
		
		private var _listPresentUser:ArrayCollection;
		private var presentUsersChanged:Boolean;
		private var _nbrUserPlaned:int;
		private var _nbrUserPresent:int;

		private var _theme:String;
		private var themeChange:Boolean;
		
		private var planSkin:Boolean;
		private var planMineSkin:Boolean;
		private var sessionPastSkin:Boolean;
		private var emptySkin:Boolean;
		
		public function SessionSummaryView()
		{
			super();
			_listPresentUser = new ArrayCollection();
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________

		public function get session():Session
		{
			return _session;
		}
		
		public function set session(value:Session):void
		{
			if( _session == value || value == null) return;
			_session = value;
			
			planSkin = false;	
			planMineSkin  = false;
			sessionPastSkin = false;

			if(session.isModel)
			{
				planSkin = true;
				if(session.id_user == loggedUser.id_user)
				{ 
					planMineSkin = true;
				}
			}else{
				if(session.statusSession == SessionStatusEnum.SESSION_CLOSE && !session.isModel)
				{
					sessionPastSkin = true; 
				}
			}
			invalidateSkinState();
			
			_nbrUserPlaned = session.participants.length;
			sessionChange = true;
			invalidateProperties();
		}
		
		public function get loggedUser():User
		{
			return this._loggedUser;
		}
		
		public function set loggedUser(value:User):void
		{
			this._loggedUser = value;
		}
		public function set dateSession(value:Date):void
		{
			session.date_session = value;
			dateSessionChange = true;
			invalidateProperties();
		}		
		public function set durationPlaned(value:int):void
		{
			this._durationPlaned = value;
			this.durationPlanedChange = true;
			this.invalidateProperties();
		}
		// set duration recorded in miliseconds 
		public function set durationRecorded(value:Number):void
		{
			this._durationRecorded = (value - session.date_start_recording.time)/60000;
			// FIXME : if duration < one minute ? what will set 
			this.durationRecordedChange = true;
			// FIXME : update the session
			this.sessionChange = true;
			this.invalidateProperties();
		}
		// set nbrRetrodocument 
		public function set nbrRetrodocument(value:int):void
		{
			this._nbrRetrodocument = value;
			this.nbrRetrodocumentChange = true;
			this.invalidateProperties();
		}
		public function get listPresentUser():ArrayCollection
		{
			return _listPresentUser;
		}		
		public function set listPresentUser(value:ArrayCollection):void
		{	
			_listPresentUser = value;
			_nbrUserPresent = _listPresentUser.length;
			presentUsersChanged = true;
			invalidateProperties();
		}
		public function set theme(value:String):void
		{
			_theme = value;
			themeChange = true;
			invalidateProperties();
		}
		public function get theme():String
		{
			return _theme;
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(sessionChange)
			{
				sessionChange = false;
				
				themeLabel.text = session.theme;
				themeLabel.toolTip = session.theme;
				// FIXME : remove model
				ownerLabel.text = VisuUtils.getUserLabel(Model.getInstance().getUserPlateformeByUserId(session.id_user),true);
				if(partageLabel != null){ partageLabel.text = "?"};
				if(datePlanedLabel != null){ datePlanedLabel.text = UtilFunction.getDateMountYearHourMin(session.date_session)};
				if(dateRecordingLabel != null){ dateRecordingLabel.text = UtilFunction.getDateMountYearHourMin(session.date_start_recording)};
				if(durationPlanedLabel != null){ durationPlanedLabel.text = "?";};
				if(nbrUsersLabel != null){ nbrUsersLabel.text = session.participants.length.toString();};
				if(durationRecordPlanedLabel != null){ durationRecordPlanedLabel.text = "?/?";};
				if(nbrUsersRecordPlanedLabel != null){ nbrUsersRecordPlanedLabel.text = _nbrUserPresent.toString()+ "/" + _nbrUserPlaned.toString();};
				if(nbrBilansLabel != null){ nbrBilansLabel.text = "?";};
			}
			if(dateSessionChange)
			{
				dateSessionChange = false;
				if(datePlanedLabel != null){ datePlanedLabel.text = UtilFunction.getDateMountHourMin(session.date_session)};
			}
			if(durationPlanedChange)
			{
				durationPlanedChange = false;
				if(durationPlanedLabel != null){ durationPlanedLabel.text = UtilFunction.getHourMin(_durationPlaned)};
				if(durationRecordPlanedLabel != null){ durationRecordPlanedLabel.text = UtilFunction.getHourMin(_durationRecorded)+"/"+UtilFunction.getHourMin(_durationPlaned)};
			}
			if(durationRecordedChange)
			{
				durationRecordedChange = false;
				if(durationRecordPlanedLabel != null){ durationRecordPlanedLabel.text =  UtilFunction.getHourMin(_durationRecorded)+" /"+UtilFunction.getHourMin(_durationPlaned)};
			}
			
			if(presentUsersChanged)
			{
				presentUsersChanged = false;
				if(nbrUsersRecordPlanedLabel != null)
				{
					nbrUsersRecordPlanedLabel.text = _nbrUserPresent.toString()+ "/" + _nbrUserPlaned.toString();
				}
				if(nbrUsersLabel != null)
				{ 
					nbrUsersLabel.text = _nbrUserPresent.toString();
				}
				
			}
			
			if(nbrRetrodocumentChange)
			{
				nbrRetrodocumentChange = false;
				if(nbrBilansLabel != null){ nbrBilansLabel.text = this._nbrRetrodocument.toString();};
			}
			if(themeChange)
			{
				themeChange = false;
				themeLabel.text = _theme;
				session.theme = _theme;
			}

		}
		
		override protected function getCurrentSkinState():String
		{
			var skinName:String;
			if(!enabled)
			{
				skinName = "disable";
			}else if(planSkin)
			{
				if(planMineSkin){skinName = "planMine"}else{skinName = "planOther"}
			}else if(sessionPastSkin){skinName = "sessionPast"} else{skinName = "sessionComing"};
			
			return skinName;
		}
	}
}