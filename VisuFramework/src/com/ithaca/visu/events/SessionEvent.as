package  com.ithaca.visu.events
{
import com.ithaca.visu.model.Session;

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
	static public const UPDATE_LIST_VIEW_TRACELINE : String = 'updateListViewTraceline';
	static public const EDIT_SESSION : String = 'editSession';
	static public const CANCEL_SESSION : String = 'cancelSession';
	static public const JOIN_SESSION : String = 'joinSession';
	static public const OUT_SESSION : String = 'outSession';
	static public const NEW_USER_JOIN_SESSION : String = 'newUserJoinSession';
	static public const OLD_USER_OUT_SESSION : String = 'oldUserOutSession';
	static public const START_RECORDING_SESSION : String = 'startRecordingSession';
	static public const STOP_RECORDING_SESSION : String = 'stopRecordingSession';
	static public const CLOSE_SESSION : String = 'closeSession';
	static public const LOAD_LIST_OBSEL : String = 'loadListObsel';
	static public const LOAD_LIST_SESSION_SALON_RETROSPECTION : String = 'loadListSessionSalonRetrospection';
	static public const GET_SESSION : String = 'getSession';
	static public const LOAD_LIST_OBSEL_RETRO : String = 'loadListObselRetro';
	static public const LOAD_LIST_CLOSED_SESSION_SALON_RETROSPECTION : String = 'loadListClosedSessionSalonRetrospection';
	static public const GET_LIST_OBSEL : String = 'getListObsel';
	static public const GET_LIST_SESSION : String = 'getListSession';
	static public const GET_LIST_CLOSED_SESSION : String = 'getListClosedSession';
	static public const GET_LIST_CLOSED_SESSION_ALL : String = 'getListClosedSessionAll';
	static public const GET_LIST_OBSEL_CLOSED_SESSION : String = 'getListObselClosedSession';
	

	// properties
	public var userId : int;
	public var userIdClient : String;
	public var sessionId : int;
	public var sessionDate : String;
	public var session : Session;
	public var listSession : ArrayCollection;
	public var listDate : Array;
	public var status : int;
	public var timeStartStop : Number;
	public var durationSessionRetro : Number;
	public var traceId : String;
	public var dateStartRecording : Date;
	

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
