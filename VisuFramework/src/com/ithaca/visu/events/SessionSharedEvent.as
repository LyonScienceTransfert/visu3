package com.ithaca.visu.events
{

import com.ithaca.traces.model.vo.SGBDObsel;
import com.ithaca.visu.model.Session;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SessionSharedEvent extends Event
{
	// constants
	static public const SEND_SHARED_INFO : String = 'sendSharedInfo';
	static public const RECEIVE_SHARED_INFO : String = 'receiveSharedInfo';
	static public const SEND_EDITED_MARKER : String = 'sendEditedMarker';

	// properties
	public var typeInfo : int;
	public var info : String;
	public var listUsers : Array;
	public var senderUserId : int;
	public var url : String;
	public var status : int;	
	public var obselVO:SGBDObsel;
	public var timeStamp:Number;
	public var idDocument:Number = 0;
	public var currentTimeVideoPlayer:Number = 0;
	public var action:String = "";
	public var idUserFor:int = 0;

	public var beginTime:String = "void";
	public var endTime:String = "void";
	public var typeShortMarker:String = "void";
	
	
	
	// constructor
	public function SessionSharedEvent(type : String,
								 bubbles : Boolean = true,
								 cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

}
}
