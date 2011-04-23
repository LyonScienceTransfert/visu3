package com.ithaca.visu.events
{

import flash.events.Event;


public class SelectionEvent extends Event
{
	
	public var selectedId : String;
	

	// constructor
	public function SelectionEvent(id : String, bubbles : Boolean = true, cancelable : Boolean = false)
	{
		super("SelectionEvent", bubbles, cancelable);
		this.selectedId = id;
	}
}
}

