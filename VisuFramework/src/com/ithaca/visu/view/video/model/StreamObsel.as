package com.ithaca.visu.view.video.model
{
	public class StreamObsel implements IStreamObsel
	{

		private var _begin:Number;
		private var _end:Number;
		private var _userId:int;
		private var _pathStream:String;
		
		public function StreamObsel()
		{
		}
		//_____________________________________________________________________
		//
		// Setter/getter
		//
		//_____________________________________________________________________
		
		public function set begin(value:Number):void
		{
			_begin = value;
		}
		
		public function get begin():Number
		{
			return _begin;
		}
		
		public function set end(value:Number):void
		{
			_end = value;
		}
		
		public function get end():Number
		{
			return _end;
		}
		
		public function set userId(value:int):void
		{
			_userId = value;
		}
		
		public function get userId():int
		{
			return _userId;
		}
		
		public function set pathStream(value:String):void
		{
			_pathStream = value;
		}
		
		public function get pathStream():String
		{
			return _pathStream;
		}
	}
}