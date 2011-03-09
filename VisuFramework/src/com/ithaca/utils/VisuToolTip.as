package com.ithaca.utils
{
	import mx.core.IToolTip;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class VisuToolTip extends SkinnableComponent implements IToolTip
	{
		
		[SkinPart("true")]
		public var labelVersionLocale:Label;
		
		[SkinPart("true")]
		public var labelVersionRemote:Label;
		
		[SkinPart("true")]
		public var labelLastCompilationVisuClient:Label;
		
		[SkinPart("true")]
		public var labelLastCompilationVisuServeur:Label;
		
		private var _localVersionGit:String;
		private var _remoteVersionGit:String;
		
		public function VisuToolTip()
		{
			super();
		}
		
		public function get text():String
		{
			return null;
		}
		
		public function set text(value:String):void
		{
		}
		
		public function set localVersionGit(value:String):void{ this._localVersionGit = value;}
		public function set remoteVersionGit(value:String):void{ this._remoteVersionGit = value;}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == labelVersionLocale)
			{
				labelVersionLocale.text = this._localVersionGit
			}
			if (instance == labelVersionRemote)
			{
				labelVersionRemote.text =  this._remoteVersionGit;
			}
		}			
	}
}