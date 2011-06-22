package com.ithaca.visu.events
{
import flash.events.Event;

public class ImageVolumeEvent extends Event
{
	// constants
	static public const CLICK_IMAGE_VOLUME : String = 'clickImageVolume';
	// properties
	public var mute:Boolean;
	// constructor
	public function ImageVolumeEvent(type : String,
		bubbles : Boolean = true,
		cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	// methods
}
}
