package  com.ithaca.visu.events
{
import com.ithaca.visu.model.Session;
import com.ithaca.visu.model.vo.ActivityElementVO;
import com.ithaca.visu.model.vo.ActivityVO;
import com.ithaca.visu.model.vo.SessionVO;
import com.ithaca.visu.model.vo.SessionWithoutListUserVO;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SessionEvent extends Event
{
	// constants
	static public const LOAD_LIST_SESSION : String = 'loadListSession';
	static public const LOAD_LIST_DATE_SESSION : String = 'loadListDateSession';
	static public const LOAD_SESSION : String = 'loadSession';
	static public const LOAD_SESSION_SALON_RETROSPECTION : String = 'loadSessionSalonRetrospection';
	static public const LOAD_DURATION_SESSION: String = 'loadDurationSession';
	static public const SHOW_LIST_DATE_SESSION : String = 'showListDateSession';
	static public const SHOW_CLONED_PLAN : String = 'showClonedPlan';
	static public const SHOW_LIST_SESSION : String = 'showListSession';
	static public const SHOW_UPDATED_SESSION : String = 'showUpdatedSession';
	static public const ADDED_SESSION : String = 'addedSession';
	static public const ADD_SESSION : String = 'addSession';
	static public const ADD_EMPTY_SESSION : String = 'addEmptySession';
	static public const ADD_CLONED_SESSION : String = 'addClonedSession';
	static public const ADD_ACTIVITY : String = 'addActivity';
	static public const ADD_CLONED_ACTIVITY : String = 'addClonedActivity';
	static public const ADD_ACTIVITY_ELEMENT : String = 'addActivityElement';
	static public const ADD_CLONED_ACTIVITY_ELEMENT : String = 'addClonedActivityElement';
	static public const DELETE_SESSION : String = 'deleteSession';
	static public const DELETE_ACTIVITY : String = 'deleteActivity';
	static public const DELETE_ACTIVITY_ELEMENT : String = 'deleteActivityElement';
	static public const UPDATE_LIST_SESSION : String = 'updateListSession';
	static public const UPDATE_LIST_USER : String = 'updateListUser';
	static public const UPDATE_LIST_VIEW_TRACELINE : String = 'updateListViewTraceline';
	static public const UPDATE_DELETED_SESSION : String = 'updateDeletedSession';
	static public const UPDATE_SESSION : String = 'updateSession';
	static public const UPDATE_ACTIVITY : String = 'updateActivity';
	static public const UPDATE_ACTIVITY_ELEMENT : String = 'updateActivityElement';
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
	static public const GET_SESSION_SALON_RETRO : String = 'getSessionSalonRetro';
	static public const LOAD_LIST_OBSEL_RETRO : String = 'loadListObselRetro';
	static public const LOAD_LIST_RETRODOCUMENT_SESSION : String = 'loadListRetrodocumentSession';
	static public const LOAD_LIST_CLOSED_SESSION_SALON_RETROSPECTION : String = 'loadListClosedSessionSalonRetrospection';
	static public const GET_LIST_OBSEL : String = 'getListObsel';
	static public const GET_LIST_SESSION : String = 'getListSession';
	static public const GET_LIST_CLOSED_SESSION : String = 'getListClosedSession';
	static public const GET_LIST_CLOSED_SESSION_ALL : String = 'getListClosedSessionAll';
	static public const GET_LIST_OBSEL_CLOSED_SESSION : String = 'getListObselClosedSession';
	static public const LOAD_LIST_USERS_PLATEFORME : String = 'loadListUsersPlateforme';
	static public const GO_RETROSPECTION_MODULE : String = 'goRetrospectionModule';
	static public const GO_BILAN_MODULE : String = 'goBilanModule';
	static public const GO_HOME_MODULE : String = 'goHomeModule';

	// properties
	public var userId : int;
	public var userIdClient : String;
	public var sessionId : int;
	public var sessionDate : String;
	public var session : Session;
	public var sessionVO :SessionVO;
	public var sessionWitOutListUserVO :SessionWithoutListUserVO;
	public var activityVO :ActivityVO;
	public var activityId :int;
	public var activityElementVO :ActivityElementVO;
	public var listSession : ArrayCollection;
	public var listDate : Array;
	public var status : int;
	public var timeStartStop : Number;
	public var durationSessionRetro : Number;
	public var traceId : String;
	public var dateStartRecording : Date;
	public var nbrRetroDocumentOwner:int;
	public var nbrRetroDocumentShare:int;
	public var clonedSession:Boolean;

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
