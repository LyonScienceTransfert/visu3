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
import com.ithaca.traces.model.RetroTraceModel;
import com.ithaca.utils.components.IconButton;
import com.ithaca.utils.components.IconInfoSegment;
import com.ithaca.visu.model.vo.RetroDocumentVO;
import com.ithaca.visu.traces.TracageEventDispatcherFactory;
import com.ithaca.visu.traces.events.TracageEvent;
import com.ithaca.visu.ui.utils.IconEnum;

import flash.events.MouseEvent;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.controls.Alert;
import mx.controls.Menu;
import mx.events.CloseEvent;
import mx.utils.StringUtil;

import spark.components.Button;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class RetroDocumentListItemSimple extends SkinnableComponent
{
	[SkinPart("true")]
	public var labelRetroDocument:Label;
	[SkinPart("true")]
	public var iconInfoVideo:IconInfoSegment;
	[SkinPart("true")]
	public var iconInfoAudio:IconInfoSegment;
	[SkinPart("true")]
	public var buttonDelete:IconButton;
	[SkinPart("true")]
	public var buttonShare:IconButton;
	[SkinPart("true")]
	public var buttonSwitch:IconButton;
	
	private var _retroDocumentVO:RetroDocumentVO;
	private var retroDocumentVOChange:Boolean;
	
	private var menuAction:Menu;
	
	private var nbrAudioSegment:int;
	private var nbrVideoSegment:int;
	
	private var over:Boolean;
    
    private var blocString:String;
	
	[Bindable]
	private var fxgt: _FxGettext = FxGettext;
	
	public function RetroDocumentListItemSimple()
	{
		super();
		fxgt = FxGettext;
	}
	
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set retroDocumentVO(value:RetroDocumentVO):void
	{
		_retroDocumentVO = value;
		parseRetroDocument();
		retroDocumentVOChange = true;
	}
	public function get retroDocumentVO():RetroDocumentVO
	{
		return _retroDocumentVO;
	}
	public function rendererNormal():void
	{
		over = false;
		invalidateSkinState();
	}
	public function rendererOver():void
	{
		over = true;
		invalidateSkinState();
	}
	
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == labelRetroDocument)
		{
			if(retroDocumentVO)
			{
				labelRetroDocument.text = retroDocumentVO.title;
			}
		}
		if (instance == iconInfoVideo)
		{
			var iconInfoVideoVisible:Boolean = true;
			if(nbrVideoSegment == 0)
			{
				iconInfoVideoVisible = false;
			}
			iconInfoVideo.visible = iconInfoVideoVisible;
			iconInfoVideo.nbrElement = nbrVideoSegment;
			iconInfoVideo.sourceIcon = IconEnum.getIconByName('iconVideo_16x16');
            iconInfoVideo.toolTip = StringUtil.substitute(fxgt.gettext("Il y a {0} bloc(s) vidéo dans le bilan"),
                                                          nbrVideoSegment.toString());
		}
		if (instance == iconInfoAudio)
		{
			var iconInfoAudioVisible:Boolean = true;
			if(nbrAudioSegment == 0)
			{
				iconInfoAudioVisible = false;
			}
			iconInfoAudio.visible = iconInfoAudioVisible;
			iconInfoAudio.nbrElement = nbrAudioSegment;
			iconInfoAudio.sourceIcon = IconEnum.getIconByName('iconAudio_16x16');
            iconInfoAudio.toolTip = StringUtil.substitute(fxgt.gettext("Il y a {0} bloc(s) audio dans le bilan"),
                                                          nbrAudioSegment.toString());
		}
		if (instance == buttonDelete)
		{
			buttonDelete.addEventListener(MouseEvent.CLICK, onClickButtonDelete);
			buttonDelete.icon =  IconEnum.getIconByName('delete');
			buttonDelete.toolTip = fxgt.gettext("Supprimer ce bilan");
		}
		if (instance == buttonShare)
		{
			buttonShare.addEventListener(MouseEvent.CLICK, onClickButtonShare);
			buttonShare.icon =  IconEnum.getIconByName('retroDocumentShared');
			buttonShare.toolTip = fxgt.gettext("Partager ce bilan");
		}
		if (instance == buttonSwitch)
		{
            buttonSwitch.addEventListener(MouseEvent.CLICK, onClickButtonSwitch);
            buttonSwitch.icon =  IconEnum.getIconByName('iconEye_16x16');
            buttonSwitch.toolTip = fxgt.gettext("Visualiser ce bilan");
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		
	}
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(retroDocumentVOChange)
		{
			retroDocumentVOChange = false;
			
			if(labelRetroDocument)
			{
				labelRetroDocument.text = retroDocumentVO.title;
			}
			if(iconInfoVideo)
			{
                /* FIXME: duplicated code here (see above). It should be factorized */
				var iconInfoVideoVisible:Boolean = true;
				if(nbrVideoSegment == 0)
				{
					iconInfoVideoVisible = false;
				}
				iconInfoVideo.visible = iconInfoVideoVisible;
				iconInfoVideo.nbrElement = nbrVideoSegment;
                iconInfoVideo.toolTip = StringUtil.substitute(fxgt.gettext("Vous avez {0} bloc(s) vidéo dans le bilan"),
                                                              nbrVideoSegment.toString());
			}
			if(iconInfoAudio)
			{			
				var iconInfoAudioVisible:Boolean = true;
				if(nbrAudioSegment == 0)
				{
					iconInfoAudioVisible = false;
				}
				iconInfoAudio.visible = iconInfoAudioVisible;
				iconInfoAudio.nbrElement = nbrAudioSegment;
                iconInfoAudio.toolTip = StringUtil.substitute(fxgt.gettext("Il y a {0} bloc(s) audio dans le bilan"),
                                                              nbrAudioSegment.toString());
			}
			
		}	
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(over)
		{
			skinName = "over";
		}else
		{
			skinName = "normal"
		}
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	private function onClickButtonDelete(event:MouseEvent):void
	{
		Alert.yesLabel = fxgt.gettext("Oui");
		Alert.noLabel = fxgt.gettext("Non");
		Alert.show(StringUtil.substitute(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le bilan intitulé {0} ?"), retroDocumentVO.title),
			       fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeRetroDocumentConformed); 
	}
	private function onClickButtonShare(event:MouseEvent):void
	{
		var loadListUsers:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOAD_LIST_USERS);
		this.dispatchEvent(loadListUsers);
	}
	private function onClickButtonSwitch(event:MouseEvent):void
	{
        var clickButtonSwitchEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CLICK_BUTTON_SWITCH);
        clickButtonSwitchEvent.idRetroDocument = retroDocumentVO.documentId;
        clickButtonSwitchEvent.sessionId = retroDocumentVO.sessionId;
        dispatchEvent(clickButtonSwitchEvent);
       
        // FIXME : add property click on button switch on retroDocumentlist ?
        // tracage view retrodocument
        var retroDocumentViewTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
        retroDocumentViewTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_VIEW;
        retroDocumentViewTracageEvent.retroDocumentId = retroDocumentVO.documentId;
        TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentViewTracageEvent);
	}
	// remove retroDocument
	private function removeRetroDocumentConformed(event:CloseEvent):void
	{
		if( event.detail == Alert.YES)
		{
            // tracage delete retrodocument
            var retroDocumentDeleteTracageEvent:TracageEvent = new TracageEvent(TracageEvent.ACTIVITY_RETRO_DOCUMENT);
            retroDocumentDeleteTracageEvent.typeActivity = RetroTraceModel.RETRO_DOCUMENT_DELETE;
            retroDocumentDeleteTracageEvent.retroDocumentId = retroDocumentVO.documentId;
            TracageEventDispatcherFactory.getEventDispatcher().dispatchEvent(retroDocumentDeleteTracageEvent);
            
			var removeRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.DELETE_RETRO_DOCUMENT);
			removeRetroDocumentEvent.idRetroDocument = retroDocumentVO.documentId;
			removeRetroDocumentEvent.sessionId = retroDocumentVO.sessionId;
			this.dispatchEvent(removeRetroDocumentEvent);
            
		}
	}
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________
	
	private function parseRetroDocument():void
	{
		nbrAudioSegment = 0;
		nbrVideoSegment = 0;
		var xml:XML = new XML(_retroDocumentVO.xml);
		var listNodeTypeSource:XMLList = xml.child(RetroDocumentConst.TAG_SEGMENT);
		var nbrNodeSegment:int = listNodeTypeSource.length();
		for(var nNodeSegment:int = 0; nNodeSegment < nbrNodeSegment; nNodeSegment++)
		{
			var nodeTypeSource:XML = listNodeTypeSource[nNodeSegment] as XML;
			var typeNodeSegment:String =  nodeTypeSource.child(RetroDocumentConst.TAG_TYPE_SOURCE).toString();
			switch (typeNodeSegment)
			{
				case RetroDocumentConst.VIDEO_SEGMENT :
					nbrVideoSegment ++;
					break;
				case RetroDocumentConst.COMMENT_AUDIO_SEGMENT :
					nbrAudioSegment ++;
					break;
			}
		}
		
		invalidateProperties();
	}
	
	
}
}
