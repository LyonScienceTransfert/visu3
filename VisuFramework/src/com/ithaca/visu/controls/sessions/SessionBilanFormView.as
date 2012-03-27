package com.ithaca.visu.controls.sessions
{
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	
	import flash.events.MouseEvent;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.LinkButton;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SessionBilanFormView extends SkinnableComponent
	{
		[SkinPart("true")]
		public var labelListRecordedUser:Label;
		[SkinPart("true")]
		public var labelListAbsentUser:Label;
		[SkinPart("true")]
		public var labelDateDebut:Label;
		[SkinPart("true")]
		public var labelDuration:Label;
		[SkinPart("true")]
		public var labelBilan:Label;
		[SkinPart("true")]
		public var linkButtonGoSalonRetrospection:LinkButton;
		[SkinPart("true")]
		public var dataGridBilan:DataGrid;
		[SkinPart("true")]
		public var dataGridOwnerBilan:DataGridColumn;
		
		private var sessionChange:Boolean;
		
		private var _session:Session;
		private var _listUserPrevu:ArrayCollection;
		private var _listPresentUser:ArrayCollection;
		private var presentUsersChanged:Boolean;
		private var _durationRecorded:int = 0;
		private var durationRecordedChange:Boolean;
		
		private var _nbrRetroDocumentOwner:int = 0;
		private var _nbrRetroDocumentShare:int = 0;
		private var nbrRetrodocumentChange:Boolean;
        
        private var _listRetroDocument:ArrayCollection;
        private var listRetroDocumentChange:Boolean;
		
        [Bindable]
        private var fxgt: _FxGettext = FxGettext;
        
		public function SessionBilanFormView()
		{
			super();
			_listPresentUser = new ArrayCollection();
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		public function get session():Session {return _session}
		public function set session(value:Session):void
		{
			if( value != _session )
			{
				_session = value;
				if(value == null)
				{
					_listUserPrevu = null;
				}else
				{
					_listUserPrevu = value.participants;
				}
				
				sessionChange = true;
				this.invalidateProperties();
			}
		} 
		public function get listPresentUser():ArrayCollection
		{
			return _listPresentUser;
		}		
		public function set listPresentUser(value:ArrayCollection):void
		{	
			_listPresentUser = value;
			presentUsersChanged = true;
			invalidateProperties();
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
		// set nbrRetroDocumentOwner 
		public function set nbrRetroDocumentOwner(value:int):void
		{
			this._nbrRetroDocumentOwner = value;
			this.nbrRetrodocumentChange = true;
			invalidateProperties();
		}
		// set nbrRetroDocumentOwner 
		public function set nbrRetroDocumentShare(value:int):void
		{
			this._nbrRetroDocumentShare = value;
			this.nbrRetrodocumentChange = true;
			invalidateProperties();
		}
        // set list retrodocument 
        public function set listRetroDocument(value:ArrayCollection):void
        {
            this._listRetroDocument = value;
            this.listRetroDocumentChange = true;
			invalidateProperties();
        }
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
            if (instance == linkButtonGoSalonRetrospection)
            {
                linkButtonGoSalonRetrospection.addEventListener(MouseEvent.CLICK, onGoSalonRetrospection)
            }
            if (instance == dataGridOwnerBilan)
            {
                dataGridOwnerBilan.dataTipFunction = toolTipsFunctionOwnerBilan;
                dataGridOwnerBilan.labelFunction = labelFunctionOwnerBilan;
                dataGridOwnerBilan.sortCompareFunction = sortFunctionOwnerBilanName;
            }
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(sessionChange)
			{
				sessionChange = false;
				labelDateDebut.text = UtilFunction.getDateMonthHourMin(session.date_start_recording);
				labelDuration.text = UtilFunction.getHourMin(_durationRecorded);
				var str:String = "";
				for each (var user:User in _listUserPrevu)
				{
					str += VisuUtils.getUserLabelLastName(user,true) + " ("+ VisuUtils.getRoleLabel(user.role)+"), "; 
				}
				labelListRecordedUser.text = str;
				setListAbsences(); 
			}
			if(presentUsersChanged)
			{
				presentUsersChanged = false;
				setListAbsences();
			}
			if(durationRecordedChange)
			{
				durationRecordedChange = false;
				if(labelDuration != null){ labelDuration.text = UtilFunction.getHourMin(_durationRecorded)};
			}
            if(nbrRetrodocumentChange)
            {
                var nbrBilan:int = this._nbrRetroDocumentOwner + this._nbrRetroDocumentShare;
                if(nbrBilan == 0)
                {
                    labelBilan.text = fxgt.gettext("Pour cette séance il n'existe pas de bilan");
                } else
                {
                    labelBilan.text = StringUtil.substitute(
                        fxgt.gettext("Pour cette séance il y a {0} bilan(s) ({1} bilan(s) partagé(s))"),
                        nbrBilan.toString(),
                        this._nbrRetroDocumentShare.toString());
                }
            }
            if(listRetroDocumentChange)
            {
                listRetroDocumentChange = false;
                if(this._listRetroDocument && this._listRetroDocument.length > 0)
                {
                    // set session for this list retroDocument
                    for each(var retroDocument:RetroDocument in this._listRetroDocument)
                    {
                        retroDocument.session = this.session;
                    }
                    dataGridBilan.includeInLayout = dataGridBilan.visible = true;
                    dataGridBilan.dataProvider = this._listRetroDocument;
                }else
                {
                    dataGridBilan.includeInLayout = dataGridBilan.visible = false;
                }
            }
        }
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________
        
		private function onGoSalonRetrospection(event:MouseEvent):void
		{
			var goRetrospectionEvent:SessionEvent = new SessionEvent(SessionEvent.GO_RETROSPECTION_MODULE);
			goRetrospectionEvent.session = this.session;
			this.dispatchEvent(goRetrospectionEvent);
		}
        
		private function getListAbsentUser():ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			var nbrUser:int = this._listUserPrevu.length;
			for(var nUser:int = 0; nUser < nbrUser ; nUser++)
			{
				var user:User = this._listUserPrevu.getItemAt(nUser) as User;
				if(!hasUserInList(this.listPresentUser,user))
				{
					result.addItem(user);
				}	
			}
			return result;	
			
			function hasUserInList(list:ArrayCollection, value:User):Boolean
			{
				for each(var user:User in list)
				{
					if(user.id_user == value.id_user)
					{
						return true;	
					}
				}
				return false;
			}
		}
		
		private function setListAbsences():void
		{
			if (this.listPresentUser.length < 1)
            {
                labelListAbsentUser.text = fxgt.gettext("Aucun participant attendu n'était présent");
                return;
            }
			var listAbsentUser: ArrayCollection = getListAbsentUser();
			var strListAbsentUser: String =""; 
			if (listAbsentUser.length < 1)
            {
                labelListAbsentUser.text = fxgt.gettext("Tous les participants attendus étaient présents");
                return;
            };
			for each (var userAbsent: User in listAbsentUser)
			{
				strListAbsentUser += VisuUtils.getUserLabelLastName(userAbsent,true) + " ("+ VisuUtils.getRoleLabel(userAbsent.role)+"), "; 
			}
			labelListAbsentUser.text = strListAbsentUser;
		}
        
        ////////////////
        /// Utils
        ///////////////
        /**
         * Tooltips owner the bilan
         */ 
        private function toolTipsFunctionOwnerBilan(item:Object):String
        {
            var owner:User = Model.getInstance().getUserPlateformeByUserId(item.ownerId);
            var result:String = fxgt.gettext("Propriétaire de bilan : ")+ VisuUtils.getUserLabelLastName(owner,true);
            return result;
        }
        /**
         * Sort by name owner the bilan
         */
        private function sortFunctionOwnerBilanName(itemA:Object, itemB:Object):int
        {
            var valueA:String = (Model.getInstance().getUserPlateformeByUserId(itemA.ownerId) as User).lastname;
            var valueB:String = (Model.getInstance().getUserPlateformeByUserId(itemB.ownerId) as User).lastname
            return ObjectUtil.stringCompare(valueA, valueB, true);
        }
        /**
        * Label the owner bilan
        */
        private function labelFunctionOwnerBilan(item:Object, column:Object):String
        {
            var owner:User = Model.getInstance().getUserPlateformeByUserId(item.ownerId);
            var result:String = VisuUtils.getUserLabelLastName(owner,true);
            return result;
        }
	}
}