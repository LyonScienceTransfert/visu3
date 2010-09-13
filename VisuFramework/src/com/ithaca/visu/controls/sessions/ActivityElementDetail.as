package com.ithaca.visu.controls.sessions
{
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	public class ActivityElementDetail extends SkinnableComponent
	{
		[SkinPart("true")]
		public var textDisplay:TextBase;  
		
		protected var _text:String;
		protected var textChanged : Boolean;
		public function ActivityElementDetail()
		{
			super();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (textChanged)
			{
				textChanged = false;
				textDisplay.text = _text;
			}
		}
		
		public function get text():String { return textDisplay.text };
		public function set text(value:String):void 
		{  
			_text = value; 
			textChanged=true;
			invalidateProperties(); 
		}
	}
}