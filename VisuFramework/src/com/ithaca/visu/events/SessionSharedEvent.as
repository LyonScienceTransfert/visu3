package com.ithaca.visu.events
{

import com.lyon2.visu.model.Session;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SessionSharedEvent extends Event
{
	// constants
	static public const SEND_SHARED_INFO : String = 'sendSharedInfo';
	static public const RECEIVE_SHARED_INFO : String = 'receiveSharedInfo';

	// properties
	public var typeInfo : int;
	public var info : String;
	public var listUsers : Array;
	public var senderUserId : int;
	
	// constructor
	public function SessionSharedEvent(type : String,
								 bubbles : Boolean = true,
								 cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

}
}
