/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.documentarisation.model.RetroDocument;
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.components.IconButton;
import com.ithaca.utils.components.PanelButton;
import com.ithaca.visu.events.PanelButtonEvent;
import com.ithaca.visu.model.Session;
import com.ithaca.visu.model.vo.RetroDocumentVO;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

import spark.components.List;
import spark.components.supportClasses.SkinnableComponent;

[Event(name="addRetroDocument", type="com.ithaca.documentarisation.events.RetroDocumentEvent")]

public class Documentarisation extends SkinnableComponent
{
	[Bindable]
	private var fxgt: _FxGettext = FxGettext;

	[SkinPart("true")]
	public var panelListRetroDocument:PanelButton;
	[SkinPart("true")]
	public var listRetroDocument:List;

	[SkinPart("true")]
	public var panelEditRetroDocument:PanelButton;
    
	public var retroDocumentView:RetroDocumentView;

	private var edit:Boolean;
	private var addRetroDocument:Boolean;

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

    private var _listAllUsers:Array;
    private var listAllUsersChange:Boolean;

	private var _dragOwnerObject:Object;

    private var _idUpdatedRetroDocument:int = -1;
    private var idUpdatedRetrodocumentChange:Boolean;

	public function Documentarisation()
	{
		super();
		_listRetroDocumentVO = new ArrayCollection();
        fxgt = FxGettext;
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
	public function updateIdRetroDocument(value:RetroDocumentVO):void
	{

        listRetroDocument.dataProvider.addItem(value);
        listRetroDocument.selectedItem = value;
        var retroDocument:RetroDocument = new RetroDocument(value);
        retroDocument.setRetroDocumentXML(value.xml);
        setRetroDocument(retroDocument, new Array(), Model.getInstance().getCurrentSessionRetroModule()); 

        // tracage add retrodocument
        var retroDocumentTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
        retroDocumentTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_CREATE;
        retroDocumentTracageEvent.retroDocumentId = value.documentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentTracageEvent);
	}
    /**
    * 
    */
    public function updateViewRetroDocument():void
    {
        edit = true;
        addRetroDocument = false;
        invalidateSkinState();
        
        onAddedOnStagePanelEditRetroDocument();  
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

	public function setRetroDocument(retroDocument : RetroDocument, listUser: Array, session:Session):void
	{
		this.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateCompete);
		_retroDocument = retroDocument;
        // set current session retroDocument
        _retroDocument.session = session;
		_listUser = listUser ;

		edit = true;
		this.invalidateSkinState();
	}

    /**
    * Add bloc vidéo in retroDocument
    */
    public function addBlocVideoCurrentRetroDocument():void
    {
        this.retroDocumentView.addSegmentVideo();
    }
    
	public function set currentTime(value:Number):void
	{
		_currentTime = value;
		currentTimeChange = true;
		invalidateProperties();
	};

	public function set dragOwnerObject(value:Object):void
	{
		_dragOwnerObject = value;
	}

	public function get dragOwnerObject():Object
	{
		return _dragOwnerObject;
	}

    public function set listAllUsers(value:Array):void
    {
        _listAllUsers = value;
        listAllUsersChange = true;
        this.invalidateProperties();
    }

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
			panelEditRetroDocument.addEventListener(Event.ADDED_TO_STAGE, onAddedOnStagePanelEditRetroDocument)
            
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
                if(listAllUsersChange)
                {
                    listAllUsersChange = false;
                    retroDocumentView.allUsers = _listAllUsers;
                }
                // add listener when change list blocs
                retroDocumentView.addEventListener(RetroDocumentEvent.CHANGE_LIST_RETRO_SEGMENT, onChangeListRetroSegment);
            }
        }

        if(listAllUsersChange)
        {
            listAllUsersChange = false;
            retroDocumentView.allUsers = _listAllUsers;
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

    // update list blocs by xml
    private function onChangeListRetroSegment(event:RetroDocumentEvent):void
    {
       var idRetrodocument:int = event.idRetroDocument;
       var xml:String = event.xmlRetrodocument;
       // list retroDocumentVO from component "list"
       var listRetroDocumentVO:ArrayCollection = this.listRetroDocument.dataProvider as ArrayCollection;
       var nbrRetroDocumentVO:int = listRetroDocumentVO.length;
       for(var nRetrodocumentVO:int = 0; nRetrodocumentVO < nbrRetroDocumentVO; nRetrodocumentVO++)
       {
            var retroDocumentVO:RetroDocumentVO = listRetroDocumentVO.getItemAt(nRetrodocumentVO) as RetroDocumentVO;
            if(retroDocumentVO.documentId == idRetrodocument)
            {
                retroDocumentVO.xml = xml;
            }
       }
    }
    /**
    * Add bloc to retroDocument
    */
    private function onAddSegment(event:RetroDocumentEvent):void
    {
        // TODO label 
        onReturnPanelListRetroDocument();
    }
    /**
    * Remove bloc from retroDocument
    */
    private function onRemoveSegment(event:RetroDocumentEvent):void
    {
        // TODO label
        onReturnPanelListRetroDocument();
    }
    
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
			if(id == "buttonDelete"  || id == "buttonSwitch" )
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

		edit = false;
		invalidateSkinState();
        
        // dispatch event remove retroDocument from Stage
        var retroDocumentAddOnStage:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.REMOVE_FROM_STAGE_RETRO_DOCUMENT);
        this.dispatchEvent(retroDocumentAddOnStage);
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
		panelListRetroDocument.title = fxgt.gettext("Liste des bilans");
	}
	private function onCreationCompletePanelEditRetroDocument(event:FlexEvent):void
	{
		panelEditRetroDocument.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletePanelEditRetroDocument);
		panelEditRetroDocument.title = fxgt.gettext("Édition de bilan");
        
        // update id retrodocument
        if(idUpdatedRetrodocumentChange)
        {
            idUpdatedRetrodocumentChange = false;
            retroDocumentView.updateIdRetroDocument(_idUpdatedRetroDocument);
        }
	}
    /**
    * Add on stage retroDocumentView
    */  
    private function onAddedOnStagePanelEditRetroDocument(event:Event = null):void
    {
        retroDocumentView = new RetroDocumentView();
        retroDocumentView.percentHeight =100;
        retroDocumentView.percentWidth = 100;
        
        retroDocumentView.setEditabled(true);
        retroDocumentView.retroDocument = _retroDocument;
        retroDocumentView.startDateSession = _dateRecordingSession.time;
        retroDocumentView.durationSession = _durationSession;
        retroDocumentView.profiles = _listProfil;
        retroDocumentView.listShareUser = _listUser;
        retroDocumentView.listUsersPresentOnTimeLine = _listUserPresentsOnTimeLine;
        retroDocumentView.addEventListener(RetroDocumentEvent.UPDATE_TITLE_RETRO_DOCUMENT, onUpdateTitreRetroDocument);
        retroDocumentView.dragOwnerObject = dragOwnerObject;
        retroDocumentView.addEventListener(RetroDocumentEvent.ADD_RETRO_SEGMENT, onAddSegment);
        retroDocumentView.addEventListener(RetroDocumentEvent.REMOVE_RETRO_SEGMENT, onRemoveSegment);
        
        panelEditRetroDocument.addElement(retroDocumentView);
        
        // dispatch event add retroDocument on Stage
        var retroDocumentAddOnStage:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.ADD_ON_STAGE_RETRO_DOCUMENT);
        this.dispatchEvent(retroDocumentAddOnStage);
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
		if(value)
		{
			loadRetroDocument.idRetroDocument = value.documentId;;
			loadRetroDocument.editabled = true;
			dispatchEvent(loadRetroDocument);

		}
	}
}
}