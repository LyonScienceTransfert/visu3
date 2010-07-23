package com.lyon2.visu.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class VisuModel extends EventDispatcher
	{
		public function VisuModel(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}