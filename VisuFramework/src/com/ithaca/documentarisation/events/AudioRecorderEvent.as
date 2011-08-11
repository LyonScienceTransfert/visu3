package  com.ithaca.documentarisation.events
{	
import com.ithaca.documentarisation.model.Segment;

import flash.events.Event;

public class AudioRecorderEvent extends Event
{
	// constants
	static public const RECORD_AUDIO : String = 'recordAudio';
	static public const STOP_RECORD_AUDIO : String = 'stopRecordAudio';
	static public const PLAY_AUDIO : String = 'playAudio';
	static public const PLAYING_AUDIO : String = 'playingAudio';
	static public const STOP_PLAY_AUDIO : String = 'stopPlayAudio';
	static public const UPDATE_PATH_COMMENT_AUDIO : String = 'updatePathCommentAudio';
	static public const UPDATE_DURATION_COMMENT_AUDIO : String = 'updateDurationCommentAudio';
	
	
	// properties
	// path stream audio
	public var pathAudio : String ="";
	// current time audion in ms
	public var currentTimeAudio:int;
	// duration comment audio in ms
	public var durationTimeAudio:Number;
	
	// constructor
	public function AudioRecorderEvent(type : String,
		bubbles : Boolean = true,
		cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
}
}
