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
	static public const STOP_PLAY_AUDIO : String = 'stopPlayAudio';
	
	
	// properties
	public var pathAudio : String;

	// constructor
	public function AudioRecorderEvent(type : String,
		bubbles : Boolean = true,
		cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
}
}
