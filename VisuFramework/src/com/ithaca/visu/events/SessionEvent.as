package  com.ithaca.visu.events
{
import com.lyon2.visu.model.Session;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SessionEvent extends Event
{
	// constants
	static public const LOAD_LIST_SESSION : String = 'loadListSession';
	static public const LOAD_LIST_DATE_SESSION : String = 'loadListDateSession';
	static public const LOAD_SESSION : String = 'loadSession';
	static public const SHOW_LIST_DATE_SESSION : String = 'showListDateSession';
	static public const SHOW_LIST_SESSION : String = 'showListSession';
	static public const ADDED_SESSION : String = 'addedSession';
	static public const UPDATE_LIST_SESSION : String = 'updateListSession';
	static public const UPDATE_LIST_USER : String = 'updateListUser';
	static public const EDIT_SESSION : String = 'editSession';
	static public const CANCEL_SESSION : String = 'cancelSession';
	static public const JOIN_SESSION : String = 'joinSession';
	static public const OUT_SESSION : String = 'outSession';
	static public const NEW_USER_JOIN_SESSION : String = 'newUserJoinSession';
	static public const OLD_USER_OUT_SESSION : String = 'oldUserOutSession';
	static public const START_RECORDING_SESSION : String = 'startRecordingSession';
	static public const STOP_RECORDING_SESSION : String = 'stopRecordingSession';
	

	// properties
	public var userId : int;
	public var userIdClient : String;
	public var sessionId : int;
	public var sessionDate : String;
	public var session : Session;
	public var listSession : ArrayCollection;
	public var listDate : Array;
	public var status : int;
	

	// constructor
	public function SessionEvent(type : String,
								 bubbles : Boolean = true,
								 cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

	// methods
}
}
