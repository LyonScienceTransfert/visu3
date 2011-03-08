package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.documentarisation.model.Segment;
	import com.ithaca.utils.ShareUserTitleWindow;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.RetroDocumentVO;
	import com.ithaca.visu.ui.utils.RoleEnum;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;
	
	public class RetroDocumentView extends SkinnableComponent
	{
		[SkinState("normal")]
		[SkinState("edited")]
		
		
		[SkinPart("true")]
		public var titleDocument:Label;
		
		[SkinPart("true")]
		public var titleDocumentTextInput:TextInput;
		
		[SkinPart("true")]
		public var shareButton:Button;
		
		[SkinPart("true")]
		public var removeButton:Button;
		
		[SkinPart("true")]
		public var addButton:Button;
		
		[SkinPart("true")]
		public var groupSegment:Group;
		
		private var _labelRetroDocument:String;
		private var normal:Boolean = true;
		private var retroDocumentChange:Boolean = false; 
		private var titleChange:Boolean = false; 
		private var listSegment:IList;
		private var _retroDocument:RetroDocument;
		private var _startDateSession:Number;
		private var _durationSession:Number;
		private var timer:Timer;
		private var needUpdateRetroDocument:Boolean = false;
		private var _profiles:Array;
		private var _listUser:Array;
		private var _listUsersPresentOnTimeLine:Array;
		
		private var removingSegment:Segment;
		private var removingSegementView:RetroDocumentSegment;
		private var TIME_UPDATE_RETRODOCUMENT:Number = 1000;
		
		[Bindable]
		private var fxgt:_FxGettext;
		
		public function RetroDocumentView()
		{
			super();
			listSegment = new ArrayCollection();
			_listUser = new Array();
			fxgt = FxGettext;
		}
		public function get retroDocument():RetroDocument
		{
			return _retroDocument;
		}
		public function set retroDocument(value:RetroDocument):void
		{
			_retroDocument = value;
			retroDocumentChange = true;
			invalidateProperties();
		}
		public function get titleDocumentText():String
		{
			return _labelRetroDocument;
		};
		public function set startDateSession(value:Number):void{_startDateSession = value;};
		public function get startDateSession():Number{return _startDateSession;};
		public function set durationSession(value:Number):void{_durationSession = value;};
		public function get durationSession():Number{return _durationSession;};
		public function set listShareUser(value:Array):void{_listUser = value;};
		public function get listShareUser():Array{return _listUser;};
		public function set profiles(value:Array):void
		{
			this._profiles = value;
		}
		public function get listUsersPresentOnTimeLine():Array{return _listUser;};
		public function set listUsersPresentOnTimeLine(value:Array):void
		{
			this._listUsersPresentOnTimeLine = value;
		}
		public function set allUsers(value:Array):void
		{
			var listUserShow:Array = this.getListUserShow(value);
			var shareUser:ShareUserTitleWindow = ShareUserTitleWindow(PopUpManager.createPopUp( 
				this, ShareUserTitleWindow , true) as spark.components.TitleWindow);
			shareUser.addEventListener(UserEvent.SELECTED_USER, onSelectUser);
			shareUser.x = (this.parentApplication.width - shareUser.width)/2;
			shareUser.y = (this.parentApplication.height - shareUser.height)/2;		
			shareUser.shareUserManagement.listShareUser = listShareUser;
			shareUser.shareUserManagement.users = listUserShow;
			shareUser.shareUserManagement.profiles = _profiles;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == shareButton)
			{
				shareButton.addEventListener(MouseEvent.CLICK, onSharedDocument);	
				shareButton.toolTip = fxgt.gettext("Partager ce bilan");
			}
			if(instance == removeButton)
			{
				removeButton.addEventListener(MouseEvent.CLICK, onRemoveDocument);	
				removeButton.toolTip = fxgt.gettext("Supprimer ce bilan");
			}
			if(instance == addButton)
			{
				addButton.addEventListener(MouseEvent.CLICK, onAddSegment);	
				addButton.toolTip = fxgt.gettext("Ajouter un nouveau segment");
			}
			if(instance == titleDocument)
			{
				titleDocument.text = _labelRetroDocument;
			}
			
			if(instance == titleDocumentTextInput)
			{
				titleDocumentTextInput.text = _labelRetroDocument;
				titleDocumentTextInput.addEventListener(TextOperationEvent.CHANGE, titleDocumentTextInput_changeHandler);
			}	
		}
		
		public function setEditabled(value:Boolean):void
		{
			normal = !value;
			this.invalidateSkinState();
			startTimer();
		}
		
		private function startTimer():void
		{
			if(!timer)
			{
				timer = new Timer(TIME_UPDATE_RETRODOCUMENT,0);
				timer.addEventListener(TimerEvent.TIMER, checkUpdateSegment);
			}
			timer.start();
		}
		private function checkUpdateSegment(event:TimerEvent):void
		{
			if(needUpdateRetroDocument)
			{
				needUpdateRetroDocument = false;
				updateRetroDocument();
			}
		}
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : normal? "normal" : "edited";
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(retroDocumentChange)
			{
				retroDocumentChange = false;
				
				groupSegment.removeAllElements();
				perseRetroDocument();
				addSegment();	
				
				if(titleDocument != null)
				{
					this.titleDocument.text  = this._labelRetroDocument;
				}
				if(titleDocumentTextInput != null)
				{
					this.titleDocumentTextInput.text  = this._labelRetroDocument;
				}
			}
		}
		
		private function perseRetroDocument():void
		{
			_labelRetroDocument = this._retroDocument.title;
			var nbrSegment:int = this._retroDocument.listSegment.length;
			for(var nSegment:int = 0; nSegment < nbrSegment; nSegment++ )
			{
				var segment:Segment = this._retroDocument.listSegment.getItemAt(nSegment) as Segment;
				this.listSegment.addItem(segment);
			}	
			
		}
		protected function addSegment():void
		{
			for each( var segment:Segment in this.listSegment)
			{
				var segmentView:RetroDocumentSegment = new RetroDocumentSegment();
				segmentView.percentWidth = 100;
				segmentView.title = segment.title;
				segmentView.setEmpty(false);
				segmentView.setEditabled(!normal);
				segmentView.segment = segment;
				segmentView.startDateSession = _startDateSession;
				segmentView.durationSession = _durationSession;
				segmentView.addEventListener(RetroDocumentEvent.PRE_REMOVE_SEGMENT, onRmoveSegment);
				segmentView.addEventListener(RetroDocumentEvent.UPDATE_RETRO_SEGMENT, updateRetroDocument);
				segmentView.addEventListener(RetroDocumentEvent.CHANGE_RETRO_SEGMENT, onChangeRetroSegment);
				groupSegment.addElement(segmentView);
			}
		}
		private function onSharedDocument(event:MouseEvent):void
		{
			var loadListUsers:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOAD_LIST_USERS);
			this.dispatchEvent(loadListUsers);
		}
		private function onRemoveDocument(event:MouseEvent):void
		{
			Alert.yesLabel = fxgt.gettext("Oui");
			Alert.noLabel = fxgt.gettext("Non");
			Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le bilan intitulé "+'"'+this.retroDocument.title+'"'+" ?"),
				fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeRetroDocumentConformed); 
		}
		private function removeRetroDocumentConformed(event:CloseEvent):void
		{
			if( event.detail == Alert.YES)
			{
				var removeRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.DELETE_RETRO_DOCUMENT);
				removeRetroDocumentEvent.idRetroDocument = this._retroDocument.id;
				removeRetroDocumentEvent.sessionId = this._retroDocument.sessionId;
				this.dispatchEvent(removeRetroDocumentEvent);
			}
			
		}
			
		private function onAddSegment(event:MouseEvent):void
		{
			var segment:Segment = new Segment();
			segment.title = "";
			this.listSegment.addItem(segment);
			this._retroDocument.listSegment.addItem(segment);
			var segmentView:RetroDocumentSegment = new RetroDocumentSegment();
			segmentView.percentWidth = 100;
			segmentView.startDateSession = _startDateSession;
			segmentView.durationSession = _durationSession;
			segmentView.setEmpty(true);
			segmentView.setEditabled(true);
			segmentView.setOpen(true);
			segmentView.segment = segment;
			segmentView.addEventListener(RetroDocumentEvent.PRE_REMOVE_SEGMENT, onRmoveSegment);
			segmentView.addEventListener(RetroDocumentEvent.UPDATE_RETRO_SEGMENT, updateRetroDocument);
			segmentView.addEventListener(RetroDocumentEvent.CHANGE_RETRO_SEGMENT, onChangeRetroSegment);
			groupSegment.addElement(segmentView);
			// update retroDocument
			this.updateRetroDocument();		
		}
		
		private function onRmoveSegment(event:RetroDocumentEvent):void
		{
			removingSegment = event.segment;
			removingSegementView =event.currentTarget as RetroDocumentSegment;
			
			Alert.yesLabel = fxgt.gettext("Oui");
			Alert.noLabel = fxgt.gettext("Non");
			Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le segment intitulé "+'"'+removingSegment.title+'"'+"?"),
				fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeSegmentConformed); 
		}
		private function removeSegmentConformed(event:CloseEvent):void
		{
			if( event.detail == Alert.YES)
			{
				var indexSegment:int = -1;
				var listSegment:ArrayCollection = this.listSegment as ArrayCollection;
				var nbrSegment:int = listSegment.length;
				for(var nSegment:int = 0 ; nSegment < nbrSegment ; nSegment++)
				{
					var segment:Segment = listSegment.getItemAt(nSegment) as Segment;
					if(segment == this.removingSegment)
					{
						indexSegment = nSegment;
					}
				}
				if(indexSegment < 0)
				{
					Alert.show("you havn't segment for delete","bug message...");
				}else
				{
					listSegment.removeItemAt(indexSegment);
					this._retroDocument.listSegment.removeItemAt(indexSegment);
					groupSegment.removeElementAt(indexSegment);
					// update the retroDocument
					this.updateRetroDocument();
				}
			}
		}
		private function updateRetroDocument(event:*=null):void
		{
			var retroDocumentVO:RetroDocumentVO = new RetroDocumentVO();
			retroDocumentVO.documentId = _retroDocument.id;
			retroDocumentVO.title = _retroDocument.title;
			retroDocumentVO.description = _retroDocument.description;
			retroDocumentVO.ownerId = _retroDocument.ownerId;
			var xml:String = _retroDocument.getRetroDocumentXMLtoSTRING();
			retroDocumentVO.xml = xml;
			retroDocumentVO.sessionId = _retroDocument.sessionId;
			var updateRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_UPDATE_RETRO_DOCUMENT);
			updateRetroDocumentEvent.retroDocumentVO = retroDocumentVO;
			updateRetroDocumentEvent.listUser = this._listUser;
			this.dispatchEvent(updateRetroDocumentEvent);
		}
		
		protected function titleDocumentTextInput_changeHandler(event:TextOperationEvent):void
		{
			this._labelRetroDocument = titleDocumentTextInput.text;
			_retroDocument.title = this._labelRetroDocument;
			this.needUpdateRetroDocument = true;
			// update title retroRocument
			var updateTitleRetroDocument:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.UPDATE_TITLE_RETRO_DOCUMENT);
			updateTitleRetroDocument.idRetroDocument = _retroDocument.id;
			updateTitleRetroDocument.titleRetrodocument = _retroDocument.title;
			this.dispatchEvent(updateTitleRetroDocument);
		}
		
		private function onChangeRetroSegment(event:RetroDocumentEvent):void
		{
			this.needUpdateRetroDocument = true;
		}
		
		private function getListUserShow(value:Array):Array
		{
			var result:Array = new Array();
			var nbrUser:int = value.length;
			for(var nUser:int= 0; nUser < nbrUser ; nUser++)
			{
				var user:User = value[nUser];
				if(user.id_user != _retroDocument.ownerId)
				{
					// add all admins
					if(user.role > RoleEnum.RESPONSABLE-1)
					{
						result.push(user);
					}else
					{
						// add only users was recording
						var hasUser:Boolean = hasUserInSession(user.id_user, this._listUsersPresentOnTimeLine)
						if(hasUser)
						{
							result.push(user);
						}		
					}
				}
			}
			return result;
			
			function hasUserInSession(id:int, list:Array):Boolean
			{
				var nbrUser:int = list.length;
				for(var nUser:int = 0 ; nUser < nbrUser; nUser++)
				{
					var userId:int = list[nUser];
					if (id == userId)
					{
						return true;
					}
				}
				return false;
			}

		}
		private function onSelectUser(event:UserEvent):void
		{
			this._listUser = event.listUser;
			// update retroDocument
			updateRetroDocument();
		}
		public function updateButtonPlayStop(value:RetroDocumentSegment):void
		{
			var nbrRetroDocumentSegment:int = groupSegment.numElements;
			for(var nRetroDocumentSegment:int = 0; nRetroDocumentSegment < nbrRetroDocumentSegment; nRetroDocumentSegment++)
			{
				var retroDocumentSegment:RetroDocumentSegment = groupSegment.getElementAt(nRetroDocumentSegment) as RetroDocumentSegment;
				var statusPlay:Boolean = false;
				if(value != null && retroDocumentSegment == value)
				{
					// status "pause"
					statusPlay = true;
				}
				// set label play/stop
//				retroDocumentSegment.setLabelPlay(statusPlay);
				// set label time 
				retroDocumentSegment.setBeginEndTime();
			}
		}
	}
}