package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.model.ActivityElement;
	
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	public class ActivityElementDetail extends ButtonBase
	{
		protected var _activityElement:ActivityElement;
		
		public function get activityElement():ActivityElement {return _activityElement; }
		public function set activityElement(value:ActivityElement):void
		{
			_activityElement = value;
			if (labelDisplay) labelDisplay.text = _activityElement.data;
		}
		
	}
}