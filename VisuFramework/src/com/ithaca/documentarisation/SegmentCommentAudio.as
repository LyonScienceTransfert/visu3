package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.model.Segment;

import flash.net.NetConnection;

import mx.events.FlexEvent;

import spark.components.supportClasses.SkinnableComponent;

public class SegmentCommentAudio extends SkinnableComponent
{
	
	[SkinPart("true")]
	public var labelSegmentTitle:SegmentTitle;
	[SkinPart("true")]
	public var audioRecorder:AudioRecorder;
	
	private var _text:String;
	private var textChange:Boolean;
	private var _streamId:String;
	private var streamIdChange:Boolean;
	private var _connection:NetConnection;
	private var connectionChange:Boolean; 
	
	private var _segment:Segment;
	private var segmentChange:Boolean;
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set text(value:String):void
	{
		_text = value;
		textChange = true;
		invalidateProperties();
	}
	public function get text():String
	{
		return _text;
	}
	public function set editabled(value:Boolean):void
	{
		labelSegmentTitle.editabled = value;
	}
	public function set connection(value:NetConnection):void
	{
		_connection = value;
		connectionChange = true;
		invalidateProperties();
	}
	public function get connection():NetConnection
	{
		return _connection;
	}
	public function set streamId(value:String):void
	{
		_streamId = value;
		streamIdChange = true;
		invalidateProperties();
	}
	public function get streamId():String
	{
		return _streamId;
	}
	public function set segment(value:Segment):void
	{
		if(value && value != segment)
		{
			_segment = value;
			segmentChange = true;
			invalidateProperties();
		}
	}
	public function get segment():Segment
	{
		return _segment;
	}
	public function SegmentCommentAudio()
	{
		super();
	}
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if(instance == audioRecorder)
		{
			audioRecorder.connection = connection;
			audioRecorder.streamId = streamId;
		}
		if(instance == labelSegmentTitle)
		{
			labelSegmentTitle.text = text;
		}
	}	
	override protected function commitProperties():void
	{
		super.commitProperties();
		if(connectionChange)
		{
			connectionChange = false;
			if(audioRecorder)
			{
				audioRecorder.connection = connection;
			}
		}
		if(streamIdChange)
		{
			streamIdChange = false;
			if(audioRecorder)
			{
				audioRecorder.streamId = streamId;
			}
		}
		if(textChange)
		{
			textChange = false;
			if(labelSegmentTitle)
			{
				labelSegmentTitle.text = text;
			}
		}
		if(segmentChange)
		{
			segmentChange = false;
			labelSegmentTitle.segment = segment;
			_text = segment.comment;
			if(labelSegmentTitle)
			{
				labelSegmentTitle.text = text;
			}
		}
	}
}
}