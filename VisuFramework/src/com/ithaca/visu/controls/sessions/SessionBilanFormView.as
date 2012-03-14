package com.ithaca.visu.controls.sessions
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.utils.VisuUtils;
	import com.ithaca.visu.events.SessionEvent;
	import com.ithaca.visu.model.Model;
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.RetroDocumentVO;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.LinkButton;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.events.ListEvent;
	
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
		public var linkButtonGoSalonBilan:LinkButton;
		[SkinPart("true")]
		public var dataGridBilan:DataGrid;
		[SkinPart("true")]
		public var dataFieldCreationDate:DataGridColumn;
		[SkinPart("true")]
		public var datFieldOwnerBilan:DataGridColumn;
		
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
            if (instance == linkButtonGoSalonBilan)
            {
                linkButtonGoSalonBilan.addEventListener(MouseEvent.CLICK, onGoBilanRetrospection)
            }
            if (instance == dataGridBilan)
            {
                dataGridBilan.addEventListener(ListEvent.ITEM_CLICK, onItemDataGridBilanClick);
            }
            if (instance == dataFieldCreationDate)
            {
                dataFieldCreationDate.labelFunction = labelFunctionDateCreationBilan;
            }
            if (instance == datFieldOwnerBilan)
            {
                datFieldOwnerBilan.labelFunction = labelFunctionOwnerBilan;
            }
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(sessionChange)
			{
				sessionChange = false;
				labelDateDebut.text = UtilFunction.getDateMountHourMin(session.date_start_recording);
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
                    labelBilan.text = "Pour cette séance il n'existe pas le bilan";
                    linkButtonGoSalonBilan.includeInLayout = linkButtonGoSalonBilan.visible = false;
                }else
                {
                    var endSBilansAll:String = "";   if(nbrBilan > 1){endSBilansAll = "s";};
                    var endSBilanShared:String = ""; if(this._nbrRetroDocumentShare > 1){endSBilanShared ="s"};
                    labelBilan.text = "Pour cette séance il y a "+nbrBilan.toString() + " bilan"+endSBilansAll+" ("+this._nbrRetroDocumentShare.toString()+" bilan"+endSBilanShared+" partagé)";
                    linkButtonGoSalonBilan.includeInLayout = linkButtonGoSalonBilan.visible = false;
                }
            }
            if(listRetroDocumentChange)
            {
                listRetroDocumentChange = false;
                if(this._listRetroDocument && this._listRetroDocument.length > 0)
                {
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
		
		private function onGoBilanRetrospection(event:MouseEvent):void
		{
			var goBilanEvent:SessionEvent = new SessionEvent(SessionEvent.GO_BILAN_MODULE);
			goBilanEvent.session = this.session;
			this.dispatchEvent(goBilanEvent);
		}
		/**
        * Handler dataGrid the bilan 
        */
        private function onItemDataGridBilanClick(event:ListEvent):void
        {
            var itemRenderer:DataGridItemRenderer = event.itemRenderer as DataGridItemRenderer; 
            var retroDocumentVO:RetroDocumentVO = itemRenderer.data as RetroDocumentVO; 
            
            var retroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.GO_RETRO_MODULE_FROM_SESSION);
            retroDocumentEvent.sessionId = retroDocumentVO.sessionId;
            retroDocumentEvent.idRetroDocument = retroDocumentVO.documentId;
            this.dispatchEvent(retroDocumentEvent);
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
			if(this.listPresentUser.length < 1){ labelListAbsentUser.text = "Aucun participant attendu n'a été présent"; return;}
			var listAbsentUser:ArrayCollection = getListAbsentUser();
			var strListAbsentUser:String =""; 
			if(listAbsentUser.length < 1){ labelListAbsentUser.text = "Tous les participants attendus ont été présents"; return;};
			for each (var userAbsent:User in listAbsentUser)
			{
				strListAbsentUser += VisuUtils.getUserLabelLastName(userAbsent,true) + " ("+ VisuUtils.getRoleLabel(userAbsent.role)+"), "; 
			}
			labelListAbsentUser.text = strListAbsentUser;
		}
        ////////////////
        /// Utils
        ///////////////
        private function labelFunctionDateCreationBilan(item:Object, column:Object):String
        {
            var result:String = UtilFunction.getDateMountHourMin(item.creationDate);
            return result;
        }
        
        private function labelFunctionOwnerBilan(item:Object, column:Object):String
        {
            var owner:User = Model.getInstance().getUserPlateformeByUserId(item.ownerId);
            var result:String = VisuUtils.getUserLabelLastName(owner,true);
            return result;
        }
	}
}