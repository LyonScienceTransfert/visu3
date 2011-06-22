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
	
	
	public class PanelButton extends Panel
	{
		
		[SkinPart("true")]
		public var buttonVolume:ImageVolume;
		
		[SkinPart("true")]
		public var buttonMicro:IconButton;
		
		private var _muteMicro:Boolean;
		private var _buttonMuteMicroEnabled:Boolean;
		private var buttonMuteMicroEnabledChange:Boolean;
		
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
				buttonMicro.addEventListener(MouseEvent.CLICK, onClickButtonMicro);
				buttonMicro.icon =  IconEnum.getIconByName('micOn');
				buttonMicro.toolTip = "Desactiver son micro";
				_muteMicro = false;
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();	
			if(buttonMuteMicroEnabledChange)
			{
				buttonMuteMicroEnabledChange = false;
				if(buttonMicro != null)
				{
					if(_buttonMuteMicroEnabled)
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
		}
		
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		public function set buttonMuteMicroEnabled(value:Boolean):void
		{
			_buttonMuteMicroEnabled = value;
			buttonMuteMicroEnabledChange = true;
			this.invalidateProperties();
		}
		public function get buttonMuteMicroEnabled():Boolean
		{
			return _buttonMuteMicroEnabled;
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
	}
}