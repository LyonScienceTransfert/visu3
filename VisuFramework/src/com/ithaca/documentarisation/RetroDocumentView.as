package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.documentarisation.model.Segment;
	import com.ithaca.documentarisation.renderer.SegmentCommentAudioRenderer;
	import com.ithaca.documentarisation.renderer.SegmentTitleRenderer;
	import com.ithaca.documentarisation.renderer.SegmentVideoRenderer;
	import com.ithaca.utils.ShareUserTitleWindow;
	import com.ithaca.utils.components.IconButton;
	import com.ithaca.visu.events.UserEvent;
	import com.ithaca.visu.model.User;
	import com.ithaca.visu.model.vo.RetroDocumentVO;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.ui.utils.RoleEnum;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import gnu.as3.gettext.FxGettext;
	import gnu.as3.gettext._FxGettext;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Menu;
	import mx.controls.PopUpButton;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Label;
	import spark.components.List;
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
		public var buttonSwitch:Button;
		
		[SkinPart("true")]
		public var removeButton:Button;
		
		[SkinPart("true")]
		public var addPopUpButton:PopUpButton;
		
		[SkinPart("true")]
		public var buttonMenuAddSegment:IconButton;
		
		[SkinPart("true")]
		public var groupSegment:List;
		
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
		private var DELTA_X_MENU_ADD_SEGMENT:Number = -150;
		private var DELTA_Y_MENU_ADD_SEGMENT:Number = 22;
		
		private var _currentTime:Number;
		
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
			listSegment = new ArrayCollection();
			
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
		public function set currentTime(value:Number):void
		{
			_currentTime = value;
		};
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == buttonSwitch)
			{
				buttonSwitch.addEventListener(MouseEvent.CLICK, onClickButtonSwitch);	
				buttonSwitch.toolTip = fxgt.gettext("Visualiser ce bilan");
			}
			if(instance == removeButton)
			{
				removeButton.addEventListener(MouseEvent.CLICK, onRemoveDocument);	
				removeButton.toolTip = fxgt.gettext("Supprimer ce bilan");
				removeButton.includeInLayout = removeButton.visible = false;
			}
			if(instance == addPopUpButton)
			{
				addPopUpButton.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteAddSegmentPopUpButton);
				addPopUpButton.toolTip = fxgt.gettext("Ajouter un nouveau segment");
				addPopUpButton.addEventListener(MouseEvent.CLICK, onClickButtonAddSegment);
			}
			if(instance == buttonMenuAddSegment)
			{
				buttonMenuAddSegment.addEventListener(MouseEvent.CLICK, onClickButtonMenuAddSegment);
				buttonMenuAddSegment.toolTip = fxgt.gettext("Ajouter un nouveau block");
			}
			
			if(instance == titleDocument)
			{
				titleDocument.text = _labelRetroDocument;
			}
			
			if(instance == titleDocumentTextInput)
			{
				titleDocumentTextInput.text = _labelRetroDocument;
				titleDocumentTextInput.addEventListener(TextOperationEvent.CHANGE, titleDocumentTextInput_changeHandler);
				titleDocumentTextInput.addEventListener(FlexEvent.CREATION_COMPLETE, onCreatioCompleteTextInput);
			}	
			if(instance == groupSegment)
			{
				groupSegment.dataProvider = listSegment;
				groupSegment.itemRendererFunction = function(item:Object):ClassFactory
				{
					var className:Class = SegmentTitleRenderer;
							
					if(item.typeSource == RetroDocumentConst.COMMENT_AUDIO_SEGMENT)
					{
						className = SegmentCommentAudioRenderer;
					}else
						if(item.typeSource == RetroDocumentConst.VIDEO_SEGMENT)
						{
							className = SegmentVideoRenderer;
						}
					return new ClassFactory( className);
				};
				
				groupSegment.addEventListener(RetroDocumentEvent.CHANGE_RETRO_SEGMENT, onChangeRetroSegment, true);
				groupSegment.addEventListener(RetroDocumentEvent.PRE_REMOVE_SEGMENT, onRmoveSegment, true);
				
				groupSegment.addEventListener(RetroDocumentEvent.READY_TO_DRAG_DROP_SEGMENT, onReadyToDragSegment, true);
				groupSegment.addEventListener(DragEvent.DRAG_COMPLETE, onDragCompleteSegment);
				
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
				
				parseRetroDocument();
				
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
		
		private function parseRetroDocument():void
		{
			_labelRetroDocument = this._retroDocument.title;
			var nbrSegment:int = this._retroDocument.listSegment.length;
			for(var nSegment:int = 0; nSegment < nbrSegment; nSegment++ )
			{
				var segment:Segment = this._retroDocument.listSegment.getItemAt(nSegment) as Segment;
				this.listSegment.addItem(segment);
			}	
			
			groupSegment.dataProvider = listSegment;
		}

		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________	
		private function onClickButtonSwitch(event:MouseEvent):void
		{	
			var clickButtonSwitchEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CLICK_BUTTON_SWITCH);
			clickButtonSwitchEvent.idRetroDocument = retroDocument.id;
			clickButtonSwitchEvent.sessionId = retroDocument.sessionId;
			dispatchEvent(clickButtonSwitchEvent);
		}
		
		private function onRemoveDocument(event:MouseEvent):void
		{
			Alert.yesLabel = fxgt.gettext("Oui");
			Alert.noLabel = fxgt.gettext("Non");
			Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le bilan intitulé "+'"'+this.retroDocument.title+'"'+" ?"),
				fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeRetroDocumentConformed); 
		}
		
		private function onClickButtonMenuAddSegment(event:MouseEvent):void
		{
			var dp:Object = [{label: fxgt.gettext(" Bloc titre "), typeSegment: "TitleSegment",  iconName : "iconLettre_T_16x16"}, 
				{label: fxgt.gettext("Bloc texte"), typeSegment: "TexteSegment" , iconName : "iconLettre_t_16x16"}, 
				{label: fxgt.gettext("Bloc vidéo + texte"), typeSegment: "VideoSegment", iconName : "iconVideo_16x16"},        
				{label: fxgt.gettext("Bloc commentaire audio"), typeSegment: "AudioSegment", iconName: "iconAudio_16x16"}];  
			var str:String = '<root><menuitem label="Bloc titre" iconName="iconLettre_T_16x16" typeSegment="TitleSegment"/><menuitem label="Bloc texte" iconName="iconLettre_t_16x16" typeSegment="TexteSegment"/><menuitem label="Bloc vidéo + texte" iconName="iconVideo_16x16" typeSegment="VideoSegment"/><menuitem label="Bloc commentaire audio" iconName="iconAudio_16x16" typeSegment="AudioSegment"/></root>'
			var xml:XML = new XML(str);
			
			var menuAddSegment:Menu = Menu.createMenu(null, xml, false);
			menuAddSegment.iconFunction = setIconMenuAddSegmentFunction;
			menuAddSegment.labelFunction= setLabelMenuAddSegmentFunction;
			menuAddSegment.addEventListener(MenuEvent.ITEM_CLICK, onClickMenuAddSegment);
			var iconButton:IconButton = event.target as IconButton;
			var pt:Point = new Point(iconButton.x, iconButton.y);
			pt = iconButton.localToGlobal(pt);
			var pointShowMenu:Point = new Point(pt.x - iconButton.x, pt.y - iconButton.y);
			menuAddSegment.show(pointShowMenu.x + DELTA_X_MENU_ADD_SEGMENT, pointShowMenu.y + DELTA_Y_MENU_ADD_SEGMENT);
		}
		
		/**
		 * init Pop-up button add segment
		 */
		private function onCreationCompleteAddSegmentPopUpButton(event:FlexEvent):void
		{
			var menuAddSegment:Menu = new Menu();
			var dp:Object = [{label: fxgt.gettext(" Bloc titre "), typeSegment: "TitleSegment",  iconName : "iconLettre_T_16x16"}, 
				{label: fxgt.gettext("Bloc texte"), typeSegment: "TexteSegment" , iconName : "iconLettre_t_16x16"}, 
				{label: fxgt.gettext("Bloc vidéo + texte"), typeSegment: "VideoSegment", iconName : "iconVideo_16x16"},        
				{label: fxgt.gettext("Bloc commentaire audio"), typeSegment: "AudioSegment", iconName: "iconAudio_16x16"}];        
			menuAddSegment.dataProvider = dp;
			menuAddSegment.selectedIndex = 0;
			menuAddSegment.iconFunction = setIconMenuAddSegmentFunction;
			menuAddSegment.addEventListener(MenuEvent.ITEM_CLICK, onClickMenuAddSegment);
			addPopUpButton.popUp = menuAddSegment;
		}
		private function setIconMenuAddSegmentFunction(item:Object):Class
		{
			var iconName:String = item.@iconName;
			return IconEnum.getIconByName(iconName);
		}
		private function setLabelMenuAddSegmentFunction(item:Object):String
		{
			var label:String = "        "+ item.@label;
			return label;
		}
		/**
		 *  listener the PopUp button
		 */
		private function onClickMenuAddSegment(event:MenuEvent):void
		{
			var segment:Segment;
			var typeSegment:String = event.item.@typeSegment;
			switch (typeSegment)
			{
			case "TitleSegment" :
				segment = new Segment(this._retroDocument);
				segment.order = 2;
				segment.comment = "";
				segment.typeSource = RetroDocumentConst.TITLE_SEGMENT;
				break;
			case "TexteSegment" :
				segment = new Segment(this._retroDocument);
				segment.order = 2;
				segment.comment = "";
				segment.typeSource = RetroDocumentConst.TEXT_SEGMENT;
				break;
			case "AudioSegment" :
				segment = new Segment(this._retroDocument);
				segment.order = 1;
				segment.typeSource = RetroDocumentConst.COMMENT_AUDIO_SEGMENT;
				segment.comment = "";
				segment.durationCommentAudio = 0;
				break;
			case "VideoSegment" :
				segment = new Segment(this._retroDocument);
				segment.order = 3;
				segment.typeSource = RetroDocumentConst.VIDEO_SEGMENT;
				segment.comment = "";
				
				segment.beginTimeVideo = this._startDateSession + _currentTime;
				segment.endTimeVideo = this._startDateSession + _currentTime + 10000;
				break;
			}
			// add segment
			addSegment(segment);
		}
		
		// by default add text segment
		private function onClickButtonAddSegment(event:MouseEvent):void
		{
			var segment:Segment = new Segment(this._retroDocument);
			segment.order = 2;
			segment.comment = "";
			segment.typeSource = RetroDocumentConst.TEXT_SEGMENT;
			// add segment
			addSegment(segment);
		}
		
		private function addSegment(value:Segment):void
		{
			listSegment.addItem(value);
			// set updated listSegment
			_retroDocument.listSegment = listSegment;
			
			groupSegment.dataProvider = listSegment;
			
			// update retroDocument
			updateRetroDocument();
			// notify change list segment 
			notifyChangeListSegment();
			// get index added segment
			//var indexAddedSegment:int = listSegment.length - 1;
			//groupSegment.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateGroupeSegmentComplete);
			//groupSegment.selectedItem = segment;
		}
		private function notifyChangeListSegment():void
		{
			var xml:String = _retroDocument.getRetroDocumentXMLtoSTRING();
			var updateListSegmentRetroDocument:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_LIST_RETRO_SEGMENT);
			updateListSegmentRetroDocument.xmlRetrodocument = xml;
			dispatchEvent(updateListSegmentRetroDocument);
		}
		
		private function onUpdateGroupeSegmentComplete(event:FlexEvent):void
		{
			// get index added segment
			var indexAddedSegment:int = listSegment.length - 1;
			groupSegment.selectedIndex = indexAddedSegment;
		}
		private function onRmoveSegment(event:RetroDocumentEvent):void
		{
			removingSegment = event.segment;
			
			Alert.yesLabel = fxgt.gettext("Oui");
			Alert.noLabel = fxgt.gettext("Non");
/*			Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le segment intitulé "+'"'+removingSegment.title+'"'+"?"),
				fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeSegmentConformed); */
			Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer ce segment ?"),
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
					if(segment == removingSegment)
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
					// update the retroDocument
					this.updateRetroDocument();
					// notify change list segment
					notifyChangeListSegment();
				}
			}
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
		private function onCreatioCompleteTextInput(event:FlexEvent):void
		{
			// set focus and select title retroDocument
			this.titleDocumentTextInput.selectAll();
			this.stage.focus = this.titleDocumentTextInput;
		}
		
		private function onChangeRetroSegment(event:RetroDocumentEvent):void
		{
			this.needUpdateRetroDocument = true;
		}
		
		private function onReadyToDragSegment(event:RetroDocumentEvent):void
		{
			setDragDropEnabled(true);
		}
		
		private function onDragCompleteSegment(event:DragEvent):void
		{
			setDragDropEnabled(false);
			// set updated listSegment
			listSegment = this.groupSegment.dataProvider;
			_retroDocument.listSegment = listSegment;
			needUpdateRetroDocument = true;
		}
		//_____________________________________________________________________
		//
		//  Dispatchers
		//
		//_____________________________________________________________________	
		// update retroDocument
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
		// remove retroDocument
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

		//_____________________________________________________________________
		//
		//  Utils
		//
		//_____________________________________________________________________	
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
		
		private function setDragDropEnabled(value:Boolean):void
		{
			groupSegment.dragEnabled = value;
			groupSegment.dragMoveEnabled = value;
			groupSegment.dropEnabled = value;
		}
	}
}