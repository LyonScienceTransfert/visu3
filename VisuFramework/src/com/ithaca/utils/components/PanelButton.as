package com.ithaca.utils.components
{
	import com.ithaca.visu.events.ImageVolumeEvent;
	import com.ithaca.visu.events.PanelButtonEvent;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.view.video.ImageVolume;
	
	import flash.events.MouseEvent;
	
	import spark.components.Panel;
	
	[Event(name="clickButtonMuteVolume",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonMuteMicro",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonModeZoom",type="com.ithaca.visu.events.PanelButtonEvent")]
	[Event(name="clickButtonModeMax",type="com.ithaca.visu.events.PanelButtonEvent")]
		
	public class PanelButton extends Panel
	{
		
		[SkinPart("true")]
		public var buttonVolume:ImageVolume;
		
		[SkinPart("true")]
		public var buttonMicro:IconButton;

		[SkinPart("true")]
		public var buttonZoom:IconButton;
		[SkinPart("true")]
		public var buttonMax:IconButton;
		
		private var _muteMicro:Boolean;
		private var _buttonMuteMicroVisible:Boolean;
		private var buttonMuteMicroVisibleChange:Boolean;
		private var _buttonModeZoomVisible:Boolean;
		private var buttonModeZoomVisibleChange:Boolean;
		private var _buttonModeMaxVisible:Boolean;
		private var buttonModeMaxVisibleChange:Boolean;
		
		private var _buttonModeZoomEnabled:Boolean;
		private var buttonModeZoomEnabledChange:Boolean;
		private var _buttonModeMaxEnabled:Boolean;
		private var buttonModeMaxEnabledChange:Boolean;

		public function PanelButton()
		{
			super();
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
				buttonVolume.addEventListener(ImageVolumeEvent.CLICK_IMAGE_VOLUME, onClickButtonVolume)
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
					buttonMicro.toolTip = "Desactiver son micro";
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
					buttonZoom.toolTip = "Mode zoom";
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
					buttonMax.toolTip = "Mode max";
				}
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
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
						buttonMicro.toolTip = "Desactiver son micro";
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
						buttonMax.toolTip = "Mode max";
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
						buttonZoom.toolTip = "Mode zoom";
						buttonZoom.addEventListener(MouseEvent.CLICK, onClickButtonZoom);
					}else
					{
						buttonZoom.includeInLayout = false;
						buttonZoom.visible = false;
						buttonZoom.removeEventListener(MouseEvent.CLICK, onClickButtonZoom);
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
		}
		
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
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
			var toolTip:String = "Desactiver son micro";
			if(_muteMicro)
			{
				nameImageMicro = "micOff";
				toolTip = "Activer son micro";
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
	}
}