package com.ithaca.visu.events
{
import flash.events.Event;

public class MessageEvent extends Event
{
	// constants
	static public const SEND_PRV_MESSAGE : String = 'sendPrivateMessage';
	static public const SEND_PUB_MESSAGE : String = 'sendPublicMessage';
	static public const START_RECORDING : String = 'startRecording';
	static public const STOP_RECORDING : String = 'stopRecording';
	

	// properties
	public var senderUserId:int;
	public var message : String;
	public var resiverUserId:int;
	public var sessionId:int;

	// constructor
	public function MessageEvent(type : String = null,
								 bubbles : Boolean = true,
								 cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

	// methods
	override public  function toString() : String
	{ return "events.MessageEvent"; }
	
	
}
}
