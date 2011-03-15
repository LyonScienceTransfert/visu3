package com.ithaca.visu.controls.sessions
{
	import mx.controls.Image;

	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	[SkinState("normal")]
	[SkinState("vciel")]
	
	public class SharedElementChat extends SkinnableComponent
	{
		[SkinPart("true")]
		public var titleDisplay : TextBase;
		
		[SkinPart("true")]
		public var avatar : Image;
		
		[SkinPart("true")]
		public var imageInfo :Image;
		
		[SkinPart("false")]
		public var nameUser :Label;
		
		
		private var infoChanged:Boolean;
		private var _pathAvatar:String;
		private var _nameSender:String;
		private var _sourceImageInfo;
		private var _info:String;
		private var _backGroundColor:uint;
		
		private var _viewVciel:Boolean = false;
		
		public var defaultColorFullColorGradientExit:uint = 0xD8D8D8;
		
		public function SharedElementChat()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleDisplay)
			{
				//titleDisplay.addEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == titleDisplay)
			{
				//titleDisplay.removeEventListener(MouseEvent.CLICK, titleDisplay_clickHandler);
			}
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (infoChanged)
			{
				infoChanged = false;
				
				avatar.source = _pathAvatar;
				avatar.toolTip = _nameSender;
				titleDisplay.text = _info;
				imageInfo.source = _sourceImageInfo;
				nameUser.text = _nameSender;
				nameUser.toolTip = _nameSender;
				this.percentWidth = 100; 
			}
		}
		public function set statVciel(value:Boolean):void
		{
			this._viewVciel = value;
			this.invalidateSkinState();
		}
		override protected function getCurrentSkinState():String
		{
			if(this._viewVciel)
			{
				return "vciel";
			}
			return "normal";
		}
		
		public function setElementChat(pathAvatar:String, nameSender:String, info:String, sourceImageInfo:*, backGroundColor:uint):void
		{
			infoChanged = true;
			_pathAvatar = pathAvatar;
			_nameSender = nameSender;
			_info = info;
			_sourceImageInfo = sourceImageInfo;
			_backGroundColor = backGroundColor;
			invalidateProperties();
		}
		
		public function get backGroundColor():uint{return this._backGroundColor};
	}
}