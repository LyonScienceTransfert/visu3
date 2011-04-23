package com.ithaca.events
{

import flash.events.Event;


public class SelectionEvent extends Event
{
	
	public var selectedId : String;
	

	// constructor
	public function SelectionEvent(id : String = null, bubbles : Boolean = true, cancelable : Boolean = false)
	{
		super("SelectionEvent", bubbles, cancelable);
		this.selectedId = id;
	}
	
	public function isEmpty():Boolean {
		return selectedId == null;
	}
}
}

