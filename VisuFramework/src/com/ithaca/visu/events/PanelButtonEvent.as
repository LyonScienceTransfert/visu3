package com.ithaca.visu.events
{
import com.ithaca.visu.model.User;

import flash.events.Event;

public class PanelButtonEvent extends Event
{
	// constants
	static public const CLICK_BUTTON_MUTE_VOLUME : String = 'clickButtonMuteVolume';
	static public const CLICK_BUTTON_MUTE_MICRO : String = 'clickButtonMuteMicro';
	static public const CLICK_BUTTON_MODE_ZOOM : String = 'clickButtonModeZoom';
	static public const CLICK_BUTTON_MODE_MAX : String = 'clickButtonModeMax';
	static public const CLICK_BUTTON_ADD : String = 'clickButtonAdd';
	static public const CLICK_BUTTON_DELETE : String = 'clickButtonDelete';
	static public const CLICK_BUTTON_SHARE : String = 'clickButtonShare';
	static public const CLICK_BUTTON_RETURN : String = 'clickButtonReturn';
	static public const CLICK_BUTTON_SWITCH : String = 'clickButtonSwitch';
	static public const CLICK_BUTTON_ADVANCED_DATA_GRID : String = 'clickButtonAdvancedDataGrid';
	static public const CLICK_BUTTON_NORMAL_DATA_GRID : String = 'clickButtonNormalDataGrid';
	// properties
	public var mute:Boolean;
	public var modeZoom:Boolean;
	public var modeMax:Boolean;
	// constructor
	public function PanelButtonEvent(type : String,
		bubbles : Boolean = true,
		cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	// methods
}
}
