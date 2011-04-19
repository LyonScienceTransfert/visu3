package com.ithaca.visu.events
{

import flash.events.Event;
import com.ithaca.documentarisation.model.Segment;

public class PlaySegmentVideoEvent extends Event
{
	public var segment : Segment;

	static public const PLAY_SEGMENT_ASKED_EVENT : String = 'PlaySegmentVideoEvent';
	
	// constructor
	public function PlaySegmentVideoEvent( segment : Segment, bubbles : Boolean = true, cancelable : Boolean = false)
	{
		super(PLAY_SEGMENT_ASKED_EVENT, true, true);
		this.segment=segment;
	}
}
}

