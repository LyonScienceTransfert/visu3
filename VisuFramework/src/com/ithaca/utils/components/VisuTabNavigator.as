package com.ithaca.utils.components
{
	import flash.events.KeyboardEvent;
	
	import mx.containers.TabNavigator;
	
	public class VisuTabNavigator extends TabNavigator
	{
		public function VisuTabNavigator()
		{
			super();
		}
		
		/**
		 *  @private
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (focusManager != null && focusManager.getFocus() == this)
			{
				// Redispatch the event from the TabBar so that it can handle it. 
				tabBar.dispatchEvent(event);
			}
		}
	}
}