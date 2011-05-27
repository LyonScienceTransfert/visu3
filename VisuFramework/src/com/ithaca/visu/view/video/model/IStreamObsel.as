package com.ithaca.visu.view.video.model
{
	public interface IStreamObsel
	{
		function set begin(value:Number):void;
		function get begin():Number;
		function set end(value:Number):void;
		function get end():Number;
		function set userId(value:int):void;
		function get userId():int;
		function set pathStream(value:String):void;
		function get pathStream():String;
		function set volume(value:Number):void;
		function get volume():Number;
		function set mute(value:Boolean):void;
		function get mute():Boolean;
	}
}