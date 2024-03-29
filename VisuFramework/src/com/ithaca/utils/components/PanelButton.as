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
package com.ithaca.utils.components
{
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.visu.events.ImageVolumeEvent;
	import com.ithaca.visu.events.PanelButtonEvent;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.view.video.ImageVolume;

	import flash.events.MouseEvent;

	import mx.controls.Image;
	import mx.controls.Spacer;
	import mx.events.ToolTipEvent;
	import mx.managers.ToolTipManager;

	import spark.components.Panel;

    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;

	[Event(name="clickButtonMuteVolume",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonMuteMicro",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonModeZoom",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonModeMax",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonDelete",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonAdd",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonShare",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonReturn",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonSwitch",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonAdvancedDataGrid",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonNormalDataGrid",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonAutoBilan",type="com.ithaca.visu.events.PanelButtonEvent")]

	public class PanelButton extends Panel
	{
        [Bindable]
	    private var fxgt: _FxGettext = FxGettext;

		[SkinPart("true")]
		public var buttonVolume:ImageVolume;

		[SkinPart("true")]
		public var buttonMicro:IconButton;
		[SkinPart("true")]
		public var buttonZoom:IconButton;
		[SkinPart("true")]
		public var buttonMax:IconButton;
		[SkinPart("true")]
		public var buttonAdd:IconButton;
		[SkinPart("true")]
		public var buttonDelete:IconButton;
		[SkinPart("true")]
		public var buttonShare:IconButton;
		[SkinPart("true")]
		public var buttonReturn:IconButton;
		[SkinPart("true")]
		public var buttonSwitch:IconButton;
		[SkinPart("true")]
		public var imageInfo:Image;
		[SkinPart("true")]
		public var spicerBeforeTitle:Spacer;
		[SkinPart("true")]
		public var buttonAdvancedDataGrid:IconButton;
		[SkinPart("true")]
		public var buttonNormalDataGrid:IconButton;
		[SkinPart("true")]
		public var buttonAutoBilan:IconButton;
        
		private var _muteMicro:Boolean;
		private var _buttonMuteMicroVisible:Boolean;
		private var buttonMuteMicroVisibleChange:Boolean;
		private var _buttonModeZoomVisible:Boolean;
		private var buttonModeZoomVisibleChange:Boolean;
		private var _buttonModeMaxVisible:Boolean;
		private var buttonModeMaxVisibleChange:Boolean;
		private var _buttonAddVisible:Boolean;
		private var buttonAddVisibleChange:Boolean;
		private var _buttonDeleteVisible:Boolean;
		private var buttonDeleteVisibleChange:Boolean;
		private var _buttonShareVisible:Boolean;
		private var buttonShareVisibleChange:Boolean;
		private var _buttonVolumeVisible:Boolean;
		private var buttonVolumeVisibleChange:Boolean;
		private var _buttonReturnVisible:Boolean;
		private var buttonReturnVisibleChange:Boolean;
		private var _buttonSwitchVisible:Boolean;
		private var buttonSwitchVisibleChange:Boolean;
		private var _imageInfoVisible:Boolean;
		private var imageInfoVisibleChange:Boolean;
		private var _buttonAdvancedDataGridVisible:Boolean;
		private var buttonAdvancedDataGridVisibleChange:Boolean;
		private var _buttonNormalDataGridVisible:Boolean;
		private var buttonNormalDataGridVisibleChange:Boolean;
		private var _buttonAutoBilanVisible:Boolean;
		private var buttonAutoBilanVisibleChange:Boolean;

		private var _buttonModeZoomEnabled:Boolean;
		private var buttonModeZoomEnabledChange:Boolean;
		private var _buttonModeMaxEnabled:Boolean;
		private var buttonModeMaxEnabledChange:Boolean;
		private var _buttonDeleteEnabled:Boolean;
		private var buttonDeleteEnabledChange:Boolean;
		private var _buttonShareEnabled:Boolean;
		private var buttonShareEnabledChange:Boolean;
		private var _buttonReturnEnabled:Boolean;
		private var buttonReturnEnabledChange:Boolean;
		private var _buttonSwitchEnabled:Boolean;
		private var buttonSwitchEnabledChange:Boolean;
		private var _buttonAdvancedDataGridEnabled:Boolean;
		private var buttonAdvancedDataGridEnabledChange:Boolean;
		private var _buttonNormalDataGridEnabled:Boolean;
		private var buttonNormalDataGridEnabledChange:Boolean;
		private var _buttonAutoBilanEnabled:Boolean;
		private var buttonAutoBilanEnabledChange:Boolean;

		private var _retroDocument:RetroDocument;

		public function PanelButton()
		{
			super();
            fxgt = FxGettext;
		}

		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == buttonVolume)
			{
				if(!_buttonVolumeVisible)
				{
					buttonVolume.includeInLayout = false;
					buttonVolume.visible = false;
				}else
				{
					buttonVolume.addEventListener(ImageVolumeEvent.CLICK_IMAGE_VOLUME, onClickButtonVolume)
					buttonVolume.toolTip = fxgt.gettext("Mute");
				}
			}
			if (instance == buttonMicro)
			{
				if(!_buttonMuteMicroVisible)
				{
					buttonMicro.includeInLayout = false;
					buttonMicro.visible = false;
				}else
				{
					buttonMicro.addEventListener(MouseEvent.CLICK, onClickButtonMicro);
					buttonMicro.icon =  IconEnum.getIconByName('micOn');
					buttonMicro.toolTip = fxgt.gettext("Désactiver le micro");
					_muteMicro = false;
				}
			}

			if (instance == buttonZoom)
			{
				if(!_buttonModeZoomVisible)
				{
					buttonZoom.includeInLayout = false;
					buttonZoom.visible = false;
				}else
				{
					buttonZoom.addEventListener(MouseEvent.CLICK, onClickButtonZoom);
					buttonZoom.icon =  IconEnum.getIconByName('zoom');
					buttonZoom.toolTip = fxgt.gettext("Mode zoom");
				}
			}

			if (instance == buttonMax)
			{
				buttonMax.enabled = _buttonModeMaxEnabled;

				if(!_buttonModeMaxVisible)
				{
					buttonMax.includeInLayout = false;
					buttonMax.visible = false;
				}else
				{
					buttonMax.addEventListener(MouseEvent.CLICK, onClickButtonMax);
					buttonMax.icon =  IconEnum.getIconByName('max');
					buttonMax.toolTip = fxgt.gettext("Mode max");
				}
			}
			if (instance == buttonAdd)
			{
				if(!_buttonAddVisible)
				{
					buttonAdd.includeInLayout = false;
					buttonAdd.visible = false;
				}else
				{
					buttonAdd.addEventListener(MouseEvent.CLICK, onClickButtonAdd);
					buttonAdd.icon =  IconEnum.getIconByName('retroDocumentAdd');
					buttonAdd.toolTip = fxgt.gettext("Créer un nouveau bilan pour cette séance");
				}
			}
			if (instance == buttonShare)
			{
				buttonShare.enabled = _buttonShareEnabled;

				if(!_buttonShareVisible)
				{
					buttonShare.includeInLayout = false;
					buttonShare.visible = false;
				}else
				{
					buttonShare.addEventListener(MouseEvent.CLICK, onClickButtonShare);
					buttonShare.icon =  IconEnum.getIconByName('retroDocumentShared');
					buttonShare.toolTip = fxgt.gettext("Partager ce bilan");
				}
			}
			if (instance == buttonDelete)
			{
				buttonDelete.enabled = _buttonDeleteEnabled;

				if(!_buttonDeleteVisible)
				{
					buttonDelete.includeInLayout = false;
					buttonDelete.visible = false;
				}else
				{
					buttonDelete.addEventListener(MouseEvent.CLICK, onClickButtonDelete);
					buttonDelete.icon =  IconEnum.getIconByName('delete');
					buttonDelete.toolTip = fxgt.gettext("Supprimer ce bilan");
				}
			}
			if (instance == buttonReturn)
			{
				buttonReturn.enabled = _buttonReturnEnabled;

				if(!_buttonReturnVisible)
				{
					buttonReturn.includeInLayout = false;
					buttonReturn.visible = false;
				}else
				{
					buttonReturn.addEventListener(MouseEvent.CLICK, onClickButtonReturn);
					buttonReturn.icon =  IconEnum.getIconByName('iconReturnLeft_16x16');
					buttonReturn.toolTip = fxgt.gettext("Retour à la liste des bilans");
				}
			}
			if (instance == buttonSwitch)
			{
				buttonSwitch.enabled = _buttonSwitchEnabled;

				if(!_buttonSwitchVisible)
				{
					buttonSwitch.includeInLayout = false;
					buttonSwitch.visible = false;
				}else
				{
					buttonSwitch.addEventListener(MouseEvent.CLICK, onClickButtonSwitch);
					buttonSwitch.icon =  IconEnum.getIconByName('ico_edit_bilan');
					buttonSwitch.toolTip = fxgt.gettext("Éditer ce bilan");
					if(spicerBeforeTitle)
					{
						spicerBeforeTitle.includeInLayout = true;
						spicerBeforeTitle.visible = true;
					}
				}
			}
			if (instance == imageInfo)
			{

				if(!_imageInfoVisible)
				{
					imageInfo.includeInLayout = false;
					imageInfo.visible = false;
				}else
				{
					imageInfo.source =  IconEnum.getIconByName('iconInfo_16x16');
					imageInfo.toolTip = fxgt.gettext("En construction");
					imageInfo.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, onCreateToolTipBilanInfo);
					imageInfo.addEventListener(ToolTipEvent.TOOL_TIP_SHOW, onShowToolTipBilanInfo);
				}
			}
            if (instance == buttonAdvancedDataGrid)
            {
                buttonAdvancedDataGrid.enabled = _buttonAdvancedDataGridEnabled;
                
                if(!_buttonAdvancedDataGridVisible)
                {
                    buttonAdvancedDataGrid.includeInLayout = false;
                    buttonAdvancedDataGrid.visible = false;
                }else
                {
                    buttonAdvancedDataGrid.addEventListener(MouseEvent.CLICK, onClickButtonAdvancedDataGrid);
                    buttonAdvancedDataGrid.icon =  IconEnum.getIconByName('iconOption_16x16');
                    buttonAdvancedDataGrid.toolTip = fxgt.gettext("Export de bilan");
                }
            }
            if (instance == buttonNormalDataGrid)
            {
                buttonNormalDataGrid.enabled = _buttonNormalDataGridEnabled;
                
                if(!_buttonNormalDataGridVisible)
                {
                    buttonNormalDataGrid.includeInLayout = false;
                    buttonNormalDataGrid.visible = false;
                }else
                {
                    buttonNormalDataGrid.addEventListener(MouseEvent.CLICK, onClickButtonNormalDataGrid);
                    buttonNormalDataGrid.icon =  IconEnum.getIconByName('iconVideo_16x16');
                    buttonNormalDataGrid.toolTip = fxgt.gettext("Ajouter bloc vidéo")
                }
            }
            if (instance == buttonAutoBilan)
            {
				buttonAutoBilan.enabled = _buttonAutoBilanEnabled;
                
                if(!_buttonAutoBilanVisible)
                {
					buttonAutoBilan.includeInLayout = false;
					buttonAutoBilan.visible = false;
                }else
                {
					buttonAutoBilan.addEventListener(MouseEvent.CLICK, onClickButtonAutoBilan);
					buttonAutoBilan.icon =  IconEnum.getIconByName('auto_bilan');
					buttonAutoBilan.toolTip = fxgt.gettext("Créate auto bilan")
                }
            }
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(buttonVolumeVisibleChange)
			{
				buttonVolumeVisibleChange = false;
				if(buttonVolume != null)
				{
					if(_buttonVolumeVisible)
					{
						buttonVolume.includeInLayout = true;
						buttonVolume.visible = true;
						buttonVolume.addEventListener(ImageVolumeEvent.CLICK_IMAGE_VOLUME, onClickButtonVolume);
						buttonVolume.toolTip = fxgt.gettext("Mute");
					}else
					{
						buttonVolume.includeInLayout = false;
						buttonVolume.visible = false;
						buttonVolume.removeEventListener(ImageVolumeEvent.CLICK_IMAGE_VOLUME, onClickButtonVolume);
					}
				}
			}
			if(buttonMuteMicroVisibleChange)
			{
				buttonMuteMicroVisibleChange = false;
				if(buttonMicro != null)
				{
					if(_buttonMuteMicroVisible)
					{
						buttonMicro.includeInLayout = true;
						buttonMicro.visible = true;
						buttonMicro.addEventListener(MouseEvent.CLICK, onClickButtonMicro);
						buttonMicro.icon =  IconEnum.getIconByName('micOn');
						buttonMicro.toolTip = fxgt.gettext("Désactiver le micro");
						_muteMicro = false;
					}else
					{
						buttonMicro.includeInLayout = false;
						buttonMicro.visible = false;
						buttonMicro.removeEventListener(MouseEvent.CLICK, onClickButtonMicro);
					}
				}
			}

			if(buttonModeMaxVisibleChange)
			{
				buttonModeMaxVisibleChange = false;
				if(buttonMax != null)
				{
					if(_buttonModeMaxVisible)
					{
						buttonMax.includeInLayout = true;
						buttonMax.visible = true;
						buttonMax.toolTip = fxgt.gettext("Mode max");
						buttonMax.addEventListener(MouseEvent.CLICK, onClickButtonMax);
					}else
					{
						buttonMax.includeInLayout = false;
						buttonMax.visible = false;
						buttonMax.removeEventListener(MouseEvent.CLICK, onClickButtonMax);
					}
				}
			}

			if(buttonModeZoomVisibleChange)
			{
				buttonModeZoomVisibleChange = false;
				if(buttonZoom != null)
				{
					if(_buttonModeZoomVisible)
					{
						buttonZoom.includeInLayout = true;
						buttonZoom.visible = true;
						buttonZoom.toolTip = fxgt.gettext("Mode zoom");
						buttonZoom.addEventListener(MouseEvent.CLICK, onClickButtonZoom);
					}else
					{
						buttonZoom.includeInLayout = false;
						buttonZoom.visible = false;
						buttonZoom.removeEventListener(MouseEvent.CLICK, onClickButtonZoom);
					}
				}
			}

			if(buttonAddVisibleChange)
			{
				buttonAddVisibleChange = false;
				if(buttonAdd != null)
				{
					if(_buttonAddVisible)
					{
						buttonAdd.includeInLayout = true;
						buttonAdd.visible = true;
						buttonAdd.toolTip = fxgt.gettext("Créer un nouveau bilan pour cette séance");
						buttonAdd.addEventListener(MouseEvent.CLICK, onClickButtonAdd);
					}else
					{
						buttonAdd.includeInLayout = false;
						buttonAdd.visible = false;
						buttonAdd.removeEventListener(MouseEvent.CLICK, onClickButtonAdd);
					}
				}
			}
			if(buttonShareVisibleChange)
			{
				buttonShareVisibleChange = false;
				if(buttonShare != null)
				{
					if(_buttonShareVisible)
					{
						buttonShare.includeInLayout = true;
						buttonShare.visible = true;
						buttonShare.toolTip = fxgt.gettext("Partager ce bilan");
						buttonShare.addEventListener(MouseEvent.CLICK, onClickButtonShare);
					}else
					{
						buttonShare.includeInLayout = false;
						buttonShare.visible = false;
						buttonShare.removeEventListener(MouseEvent.CLICK, onClickButtonShare);
					}
				}
			}
			if(buttonDeleteVisibleChange)
			{
				buttonDeleteVisibleChange = false;
				if(buttonDelete != null)
				{
					if(_buttonDeleteVisible)
					{
						buttonDelete.includeInLayout = true;
						buttonDelete.visible = true;
						buttonDelete.toolTip = fxgt.gettext("Supprimer ce bilan");
						buttonDelete.addEventListener(MouseEvent.CLICK, onClickButtonDelete);
					}else
					{
						buttonDelete.includeInLayout = false;
						buttonDelete.visible = false;
						buttonDelete.removeEventListener(MouseEvent.CLICK, onClickButtonDelete);
					}
				}
			}
			if(buttonReturnVisibleChange)
			{
				buttonReturnVisibleChange = false;
				if(buttonReturn != null)
				{
					if(_buttonReturnVisible)
					{
						buttonReturn.includeInLayout = true;
						buttonReturn.visible = true;
						buttonReturn.toolTip = fxgt.gettext("Retour à la liste des bilans");
						buttonReturn.addEventListener(MouseEvent.CLICK, onClickButtonReturn);
					}else
					{
						buttonReturn.includeInLayout = false;
						buttonReturn.visible = false;
						buttonReturn.removeEventListener(MouseEvent.CLICK, onClickButtonReturn);
					}
				}
			}
			if(buttonSwitchVisibleChange)
			{
				buttonSwitchVisibleChange = false;
				if(buttonSwitch != null)
				{
					if(_buttonSwitchVisible)
					{
						buttonSwitch.includeInLayout = true;
						buttonSwitch.visible = true;
						buttonSwitch.toolTip = fxgt.gettext("Éditer ce bilan");
						buttonSwitch.addEventListener(MouseEvent.CLICK, onClickButtonSwitch);
					}else
					{
						buttonSwitch.includeInLayout = false;
						buttonSwitch.visible = false;
						buttonSwitch.removeEventListener(MouseEvent.CLICK, onClickButtonSwitch);
						if(spicerBeforeTitle)
						{
							spicerBeforeTitle.includeInLayout = true;
							spicerBeforeTitle.visible = true;
						}
					}
				}
			}
			if(imageInfoVisibleChange)
			{
				imageInfoVisibleChange = false;
				if(imageInfo != null)
				{
					if(_imageInfoVisible)
					{
						imageInfo.includeInLayout = true;
						imageInfo.visible = true;
						imageInfo.toolTip = fxgt.gettext("En construction");
					}else
					{
						imageInfo.includeInLayout = false;
						imageInfo.visible = false;
					}
				}
			}

			if(buttonAdvancedDataGridVisibleChange)
			{
                buttonAdvancedDataGridVisibleChange = false;
				if(buttonAdvancedDataGrid != null)
				{
					if(_buttonAdvancedDataGridVisible)
					{
                        buttonAdvancedDataGrid.includeInLayout = true;
                        buttonAdvancedDataGrid.visible = true;
                        buttonAdvancedDataGrid.toolTip = fxgt.gettext("Export de bilan");
                        buttonAdvancedDataGrid.icon =  IconEnum.getIconByName('iconOption_16x16');
                        buttonAdvancedDataGrid.addEventListener(MouseEvent.CLICK, onClickButtonAdvancedDataGrid);
					}else
					{
                        buttonAdvancedDataGrid.includeInLayout = false;
                        buttonAdvancedDataGrid.visible = false;
                        buttonAdvancedDataGrid.removeEventListener(MouseEvent.CLICK, onClickButtonAdvancedDataGrid);
					}
				}
			}
            
			if(buttonNormalDataGridVisibleChange)
			{
                buttonNormalDataGridVisibleChange = false;
				if(buttonNormalDataGrid != null)
				{
					if(_buttonNormalDataGridVisible)
					{
                        buttonNormalDataGrid.includeInLayout = true;
                        buttonNormalDataGrid.visible = true;
                        buttonNormalDataGrid.icon =  IconEnum.getIconByName('iconVideo_16x16');
                        buttonNormalDataGrid.toolTip = fxgt.gettext("Ajouter bloc vidéo")
                        buttonNormalDataGrid.addEventListener(MouseEvent.CLICK, onClickButtonNormalDataGrid);
					}else
					{
                        buttonNormalDataGrid.includeInLayout = false;
                        buttonNormalDataGrid.visible = false;
                        buttonNormalDataGrid.removeEventListener(MouseEvent.CLICK, onClickButtonNormalDataGrid);
					}
				}
			}
			
			if(buttonAutoBilanVisibleChange)
			{
				buttonAutoBilanVisibleChange = false;
				if(buttonAutoBilan != null)
				{
					if(_buttonAutoBilanVisible)
					{
						buttonAutoBilan.includeInLayout = true;
						buttonAutoBilan.visible = true;
						buttonAutoBilan.icon =  IconEnum.getIconByName('auto_bilan');
						buttonAutoBilan.toolTip = fxgt.gettext("Créate auto bilan")
						buttonAutoBilan.addEventListener(MouseEvent.CLICK, onClickButtonAutoBilan);
					}else
					{
						buttonAutoBilan.includeInLayout = false;
						buttonAutoBilan.visible = false;
						buttonAutoBilan.removeEventListener(MouseEvent.CLICK, onClickButtonAutoBilan);
					}
				}
			}
            
			if(buttonModeMaxEnabledChange)
			{
				buttonModeMaxEnabledChange = false;
				if(buttonMax != null)
				{
					buttonMax.enabled = _buttonModeMaxEnabled
				}
			}

			if(buttonModeZoomEnabledChange)
			{
				buttonModeZoomEnabledChange = false;
				if(buttonZoom != null)
				{
					buttonZoom.enabled = _buttonModeZoomEnabled
				}
			}

			if(buttonShareEnabledChange)
			{
				buttonShareEnabledChange = false;
				if(buttonShare != null)
				{
					buttonShare.enabled = _buttonShareEnabled
				}
			}
			if(buttonDeleteEnabledChange)
			{
				buttonDeleteEnabledChange = false;
				if(buttonDelete != null)
				{
					buttonDelete.enabled = _buttonDeleteEnabled
				}
			}
			if(buttonReturnEnabledChange)
			{
				buttonReturnEnabledChange = false;
				if(buttonReturn != null)
				{
					buttonReturn.enabled = _buttonReturnEnabled
				}
			}
			if(buttonSwitchEnabledChange)
			{
				buttonSwitchEnabledChange = false;
				if(buttonSwitch != null)
				{
					buttonSwitch.enabled = _buttonSwitchEnabled
				}
			}
			if(buttonAdvancedDataGridEnabledChange)
			{
                buttonAdvancedDataGridEnabledChange = false;
				if(buttonAdvancedDataGrid != null)
				{
                    buttonAdvancedDataGrid.enabled = _buttonAdvancedDataGridEnabled
				}
			}
			if(buttonNormalDataGridEnabledChange)
			{
                buttonNormalDataGridEnabledChange = false;
				if(buttonNormalDataGrid != null)
				{
                    buttonNormalDataGrid.enabled = _buttonNormalDataGridEnabled
				}
			}
			if(buttonAutoBilanEnabledChange)
			{
				buttonAutoBilanEnabledChange = false;
				if(buttonAutoBilan != null)
				{
                    buttonAutoBilan.enabled = _buttonAutoBilanEnabled
				}
			}
		}

		override public function set title(value:String):void
		{
			if (titleDisplay)
			{
				titleDisplay.text = value;
                // TODO : find other solution , havn't toolTip for SDK 4.5
				// titleDisplay.toolTip = value;
			}
		}

		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		public function set buttonVolumeVisible(value:Boolean):void
		{
			_buttonVolumeVisible = value;
			buttonVolumeVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonVolumeVisible():Boolean
		{
			return _buttonVolumeVisible;
		}
		public function set buttonMuteMicroVisible(value:Boolean):void
		{
			_buttonMuteMicroVisible = value;
			buttonMuteMicroVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonMuteMicroVisible():Boolean
		{
			return _buttonMuteMicroVisible;
		}
		public function set buttonModeMaxVisible(value:Boolean):void
		{
			_buttonModeMaxVisible = value;
			buttonModeMaxVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonModeMaxVisible():Boolean
		{
			return _buttonModeMaxVisible;
		}
		public function set buttonModeZoomVisible(value:Boolean):void
		{
			_buttonModeZoomVisible = value;
			buttonModeZoomVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonModeZoomVisible():Boolean
		{
			return _buttonModeZoomVisible;
		}
		public function set buttonAddVisible(value:Boolean):void
		{
			_buttonAddVisible = value;
			buttonAddVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonAddVisible():Boolean
		{
			return _buttonAddVisible;
		}
		public function set buttonShareVisible(value:Boolean):void
		{
			_buttonShareVisible = value;
			buttonShareVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonShareVisible():Boolean
		{
			return _buttonShareVisible;
		}
		public function set buttonDeleteVisible(value:Boolean):void
		{
			_buttonDeleteVisible = value;
			buttonDeleteVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonDeleteVisible():Boolean
		{
			return _buttonDeleteVisible;
		}
		public function set buttonReturnVisible(value:Boolean):void
		{
			_buttonReturnVisible = value;
			buttonReturnVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonReturnVisible():Boolean
		{
			return _buttonReturnVisible;
		}
		public function set buttonSwitchVisible(value:Boolean):void
		{
			_buttonSwitchVisible = value;
			buttonSwitchVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonSwitchVisible():Boolean
		{
			return _buttonSwitchVisible;
		}
		public function set buttonNormalDataGridVisible(value:Boolean):void
		{
			_buttonNormalDataGridVisible = value;
            buttonNormalDataGridVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonNormalDataGridVisible():Boolean
		{
			return _buttonNormalDataGridVisible;
		}
		public function set buttonAdvancedDataGridVisible(value:Boolean):void
		{
			_buttonAdvancedDataGridVisible = value;
            buttonAdvancedDataGridVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonAdvancedDataGridVisible():Boolean
		{
			return _buttonAdvancedDataGridVisible;
		}
		public function set buttonAutoBilanVisible(value:Boolean):void
		{
			_buttonAutoBilanVisible = value;
			buttonAutoBilanVisibleChange = true;
			this.invalidateProperties();
		}
		public function get buttonAutoBilanVisible():Boolean
		{
			return _buttonAutoBilanVisible;
		}
		public function set imageInfoVisible(value:Boolean):void
		{
			_imageInfoVisible = value;
			imageInfoVisibleChange = true;
			this.invalidateProperties();
		}
		public function get imageInfoVisible():Boolean
		{
			return _imageInfoVisible;
		}


		public function set buttonModeMaxEnabled(value:Boolean):void
		{
			_buttonModeMaxEnabled = value;
			buttonModeMaxEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonModeMaxEnabled():Boolean
		{
			return _buttonModeMaxEnabled;
		}
		public function set buttonModeZoomEnabled(value:Boolean):void
		{
			_buttonModeZoomEnabled = value;
			buttonModeZoomEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonModeZoomEnabled():Boolean
		{
			return _buttonModeZoomEnabled;
		}
		public function set buttonShareEnabled(value:Boolean):void
		{
			_buttonShareEnabled = value;
			buttonShareEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonShareEnabled():Boolean
		{
			return _buttonShareEnabled;
		}
		public function set buttonDeleteEnabled(value:Boolean):void
		{
			_buttonDeleteEnabled = value;
			buttonDeleteEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonDeleteEnabled():Boolean
		{
			return _buttonDeleteEnabled;
		}
		public function set buttonReturnEnabled(value:Boolean):void
		{
			_buttonReturnEnabled = value;
			buttonReturnEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonReturnEnabled():Boolean
		{
			return _buttonReturnEnabled;
		}
		public function set buttonSwitchEnabled(value:Boolean):void
		{
			_buttonSwitchEnabled = value;
			buttonSwitchEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonSwitchEnabled():Boolean
		{
			return _buttonSwitchEnabled;
		}
		public function set buttonNormalDataGridEnabled(value:Boolean):void
		{
			_buttonNormalDataGridEnabled = value;
            buttonNormalDataGridEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonNormalDataGridEnabled():Boolean
		{
			return _buttonNormalDataGridEnabled;
		}
		public function set buttonAdvancedDataGridEnabled(value:Boolean):void
		{
			_buttonAdvancedDataGridEnabled = value;
            buttonAdvancedDataGridEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonAdvancedDataGridEnabled():Boolean
		{
			return _buttonAdvancedDataGridEnabled;
		}
		public function set buttonAutoBilanEnabled(value:Boolean):void
		{
			_buttonAutoBilanEnabled = value;
			buttonAutoBilanEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonAutoBilanEnabled():Boolean
		{
			return _buttonAutoBilanEnabled;
		}

		public function set retroDocument(value:RetroDocument):void
		{
			_retroDocument = value;
		}

		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________
		private function onClickButtonVolume(event:ImageVolumeEvent):void
		{
			var mute:Boolean = event.mute;
			var clickButtonMuteVolume:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_MUTE_VOLUME);
			clickButtonMuteVolume.mute = mute;
			dispatchEvent(clickButtonMuteVolume);
		}

		private function onClickButtonMicro(event:MouseEvent):void
		{
			// set muteMicro
			_muteMicro = !_muteMicro;
			var nameImageMicro:String = "micOn";
			var toolTip:String = fxgt.gettext("Désactiver le micro");
			if(_muteMicro)
			{
				nameImageMicro = "micOff";
				toolTip = fxgt.gettext("Activer le micro");
			}
			// set new icon of the micro
			buttonMicro.icon =  IconEnum.getIconByName(nameImageMicro);
			// set tooltip
			buttonMicro.toolTip = toolTip;

			var clickButtonMuteMicro:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_MUTE_MICRO);
			clickButtonMuteMicro.mute = _muteMicro;
			dispatchEvent(clickButtonMuteMicro);
		}

		private function onClickButtonZoom(event:MouseEvent):void
		{
			var clickButtonModeZoom:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_MODE_ZOOM);
			clickButtonModeZoom.modeZoom = true;
			dispatchEvent(clickButtonModeZoom);
		}
		private function onClickButtonMax(event:MouseEvent):void
		{
			var clickButtonModeMax:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_MODE_MAX);
			clickButtonModeMax.modeMax = true;
			dispatchEvent(clickButtonModeMax);
		}
		private function onClickButtonAdd(event:MouseEvent):void
		{
			var clickButtonAdd:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_ADD);
			dispatchEvent(clickButtonAdd);
		}
		private function onClickButtonDelete(event:MouseEvent):void
		{
			var clickButtonDelete:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_DELETE);
			dispatchEvent(clickButtonDelete);
		}
		private function onClickButtonShare(event:MouseEvent):void
		{
			var clickButtonShare:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_SHARE);
			dispatchEvent(clickButtonShare);
		}
		private function onClickButtonReturn(event:MouseEvent):void
		{
			var clickButtonReturn:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_RETURN);
			dispatchEvent(clickButtonReturn);
		}
		private function onClickButtonSwitch(event:MouseEvent):void
		{
			var clickButtonSwitch:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_SWITCH);
			dispatchEvent(clickButtonSwitch);
		}
		private function onClickButtonAdvancedDataGrid(event:MouseEvent):void
		{
			var clickButtonAdvancedDataGrid:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_ADVANCED_DATA_GRID);
			dispatchEvent(clickButtonAdvancedDataGrid);
		}
		private function onClickButtonNormalDataGrid(event:MouseEvent):void
		{
			var clickButtonNormalDataGrid:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_NORMAL_DATA_GRID);
			dispatchEvent(clickButtonNormalDataGrid);
		}
		private function onClickButtonAutoBilan(event:MouseEvent):void
		{
			var clickButtonAutoBilan:PanelButtonEvent = new PanelButtonEvent(PanelButtonEvent.CLICK_BUTTON_AUTO_BILAN);
			dispatchEvent(clickButtonAutoBilan);
		}

		private function onCreateToolTipBilanInfo(event:ToolTipEvent):void
		{
			var toolTip:BilanSummaryToolTip = new BilanSummaryToolTip();
			toolTip.retroDocument = _retroDocument;
			event.toolTip = toolTip;
		}
		private function onShowToolTipBilanInfo(event:ToolTipEvent):void
		{
			var toolTip:BilanSummaryToolTip = event.toolTip as BilanSummaryToolTip;
			toolTip.x = this.width  - toolTip.width - 50;
		}
	}
}
