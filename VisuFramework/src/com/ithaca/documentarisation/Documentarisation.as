package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.RetroDocument;
import com.ithaca.utils.components.IconButton;
import com.ithaca.utils.components.PanelButton;
import com.ithaca.visu.events.PanelButtonEvent;
import com.ithaca.visu.model.vo.RetroDocumentVO;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.managers.CursorManager;

import spark.components.List;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.IndexChangeEvent;

[Event(name="addRetroDocument", type="com.ithaca.documentarisation.events.RetroDocumentEvent")]

public class Documentarisation extends SkinnableComponent
{
	[SkinPart("true")]
	public var panelListRetroDocument:PanelButton;
	[SkinPart("true")]
	public var listRetroDocument:List;
	
	[SkinPart("true")]
	public var panelEditRetroDocument:PanelButton;
	[SkinPart("true")]
	public var retroDocumentView:RetroDocumentView;
	
	private var edit:Boolean;
	
	private var _listRetroDocumentVO:ArrayCollection;
	private var listRetroDocumentVOChange:Boolean;
	
	private var _retroDocument:RetroDocument; 
	private var _dateRecordingSession:Date = new Date(); 
	private var _durationSession:Number;
	private var _listProfil:Array;
	private var _listUser:Array;
	private var _listUserPresentsOnTimeLine:Array;
	private var retroDocumentChange:Boolean;
	
	private var _currentTime:Number;
	private var currentTimeChange:Boolean;
	
	public function Documentarisation()
	{
		super();
		_listRetroDocumentVO = new ArrayCollection();
	}
	//_____________________________________________________________________
	//
	// Setter/Getter 
	//
	//_____________________________________________________________________
	public function set listRetroDocumentVO(value:ArrayCollection):void
	{
		_listRetroDocumentVO = value;
		listRetroDocumentVOChange = true;
		invalidateProperties();
	}
	public function get listRetroDocumentVO():ArrayCollection
	{
		return _listRetroDocumentVO;
	}
	public function updateIdRetroDocument(value:int):void
	{
		// update id retroDocument 
		if(retroDocumentView)
		{
			retroDocumentView.retroDocument.id = value;
		}
		var nbrRetroDocumentVO:int = listRetroDocumentVO.length;
		for(var nRetroDocumentVO:int = 0; nRetroDocumentVO < nbrRetroDocumentVO; nRetroDocumentVO++)
		{
			var retroDocumentVO:RetroDocumentVO = listRetroDocumentVO.getItemAt(nRetroDocumentVO) as RetroDocumentVO;
			if(retroDocumentVO.documentId == 0)
			{
				retroDocumentVO.documentId = value;
				break;
			}
		}
	}
	public function updateListSegment(value:String):void
	{
		var index:int = listRetroDocument.selectedIndex;
		var retroDocumentVO:RetroDocumentVO = listRetroDocumentVO.getItemAt(index) as RetroDocumentVO;
		retroDocumentVO.xml = value;
		retroDocumentView.retroDocument.setRetroDocumentXML(value);
	}
	public function selectedRetroDocument(value:int):void
	{	
		var nbrRetroDocument:int = listRetroDocumentVO.length;
		for(var nRetroDocument:int = 0; nRetroDocument < nbrRetroDocument; nRetroDocument++ )
		{
			var retrodocumentVO:RetroDocumentVO = listRetroDocumentVO.getItemAt(nRetroDocument) as RetroDocumentVO;
			if(retrodocumentVO.documentId == value)
			{
				listRetroDocument.selectedIndex = nRetroDocument;
				// load retroDocument
				dispatchLoadRetroDocument(retrodocumentVO);
				break;
			}
		}
	}
	
	public function initDataRetroDocument(dateRecordingSession: Date, durationSession: Number, listProfil: Array, listUserPresentsOnTimeLine: Array):void
	{
		_dateRecordingSession = dateRecordingSession; 
		_durationSession = durationSession;
		_listProfil = listProfil;
		_listUserPresentsOnTimeLine = listUserPresentsOnTimeLine;
	}
	
	public function setRetroDocument(retroDocument : RetroDocument, listUser: Array):void
	{
		this.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateCompete);
		_retroDocument = retroDocument; 
		_listUser = listUser ;
		
		edit = true;
		this.invalidateSkinState();
	}
	
	public function set currentTime(value:Number):void
	{
		_currentTime = value;
		currentTimeChange = true;
		invalidateProperties();
	};
	
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if(instance == listRetroDocument)
		{
			listRetroDocument.addEventListener(MouseEvent.CLICK, onChangeRetroDocument);
			if(listRetroDocumentVO.length == 0)
			{
				// TODO : Message "hasn't retroDocuments"
			}else
			{
				listRetroDocument.dataProvider = listRetroDocumentVO;
			}
			listRetroDocument.addEventListener(RetroDocumentEvent.DELETE_RETRO_DOCUMENT, onDeleteRetroDocumen);
		}
		if(instance == panelListRetroDocument)
		{
			panelListRetroDocument.addEventListener(PanelButtonEvent.CLICK_BUTTON_ADD, onAddRetroDocument);
			panelListRetroDocument.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletePanelListRetrodocument);
		}
		if(instance == panelEditRetroDocument)
		{
			panelEditRetroDocument.addEventListener(PanelButtonEvent.CLICK_BUTTON_RETURN, onReturnPanelListRetroDocument);
			panelEditRetroDocument.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletePanelEditRetroDocument);
		}
		if(instance == retroDocumentView)
		{
			retroDocumentView.setEditabled(true);
			retroDocumentView.retroDocument = _retroDocument;
			retroDocumentView.startDateSession = _dateRecordingSession.time;
			retroDocumentView.durationSession = _durationSession;
			retroDocumentView.profiles = _listProfil;
			retroDocumentView.listShareUser = _listUser;
			retroDocumentView.listUsersPresentOnTimeLine = _listUserPresentsOnTimeLine; 
			retroDocumentView.addEventListener(RetroDocumentEvent.UPDATE_TITLE_RETRO_DOCUMENT, onUpdateTitreRetroDocument);
		}
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(listRetroDocumentVOChange)
		{
			listRetroDocumentVOChange = false;
			if(listRetroDocumentVO.length == 0)
			{
				// TODO : Message "hasn't retroDocuments"
			}else
			{
				// TODO : remove Message
			}
			listRetroDocument.dataProvider = listRetroDocumentVO;
		}
		
		if(retroDocumentChange)
		{
			retroDocumentChange = false;
			if(retroDocumentView)
			{
				retroDocumentView.setEditabled(true);
				retroDocumentView.retroDocument = _retroDocument;
				retroDocumentView.startDateSession = _dateRecordingSession.time;
				retroDocumentView.durationSession = _durationSession;
				retroDocumentView.profiles = _listProfil;
				retroDocumentView.listShareUser = _listUser;
				retroDocumentView.listUsersPresentOnTimeLine = _listUserPresentsOnTimeLine;
			}
		}
		
		if(currentTimeChange)
		{
			currentTimeChange = true;
			if(retroDocumentView)
			{
				retroDocumentView.currentTime = _currentTime;
			}
		}
		
	}
	
	override protected function getCurrentSkinState():String
	{
		return !enabled? "disabled" : edit? "editRetroDocument" : "listRetroDocument";
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________	
	private function onUpdateCompete(event:FlexEvent):void
	{
		this.removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateCompete);
		
		retroDocumentChange = true;
		this.invalidateProperties();
	}
	private function onChangeRetroDocument(event:MouseEvent):void
	{
		if((event.target as IconButton))
		{
			var iconButton:IconButton = event.target as IconButton;
			var id:String = iconButton.id;
			if(id == "buttonDelete")
			{
				return;
			}
		}
			var retroDocumentVO:RetroDocumentVO = listRetroDocument.selectedItem as RetroDocumentVO;
			dispatchLoadRetroDocument(retroDocumentVO);
	//		CursorManager.setBusyCursor();

	}
	private function onReturnPanelListRetroDocument(event:PanelButtonEvent):void
	{
		retroDocumentView.groupSegment.dataProvider.removeAll();
		retroDocumentView.groupSegment.dataProvider = null;
		
		edit = false;		
		invalidateSkinState();
	}
	private function onAddRetroDocument(event:PanelButtonEvent):void
	{
		edit = true;
		invalidateSkinState();
		
		var addRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.ADD_RETRO_DOCUMENT);
		dispatchEvent(addRetroDocumentEvent);
	}
	private function onCreationCompletePanelListRetrodocument(event:FlexEvent):void
	{
		panelListRetroDocument.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletePanelListRetrodocument);
		panelListRetroDocument.title = "Liste des bilans";
	}
	private function onCreationCompletePanelEditRetroDocument(event:FlexEvent):void
	{
		panelEditRetroDocument.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletePanelEditRetroDocument);
		panelEditRetroDocument.title = "Edition de bilan";
	}
	private function onDeleteRetroDocumen(event:RetroDocumentEvent):void
	{
		var nbrRetroDocument:int = listRetroDocumentVO.length;
		for( var nRetroDocument:int = 0; nRetroDocument < nbrRetroDocument; nRetroDocument++)
		{
			var retroDocumentVO:RetroDocumentVO = listRetroDocumentVO.getItemAt(nRetroDocument) as RetroDocumentVO;
			if(event.idRetroDocument == retroDocumentVO.documentId)
			{
				listRetroDocumentVO.removeItemAt(nRetroDocument);
				break;
			}
		}
		
		// TODO : Message if any retroDocuments
		
	}
	private function onUpdateTitreRetroDocument(event:RetroDocumentEvent):void
	{
		var retroDocumentVO:RetroDocumentVO = listRetroDocument.selectedItem as RetroDocumentVO;
		retroDocumentVO.title = event.titleRetrodocument;
	}
	
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________	
	
	// load retroDocument
	private function dispatchLoadRetroDocument(value:RetroDocumentVO):void
	{
		var loadRetroDocument:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOAD_RETRO_DOCUMENT);
		loadRetroDocument.idRetroDocument =  value.documentId;
		loadRetroDocument.editabled = true;				
		dispatchEvent(loadRetroDocument);
	}
}
}