package com.ithaca.visu.controls.sessions
{
	import mx.controls.Image;
	import mx.controls.Label;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	[SkinState("normal")]
	
	public class SharedElementChat extends SkinnableComponent
	{
		[SkinPart("true")]
		public var titleDisplay : TextBase;
		
		[SkinPart("true")]
		public var avatar : Image;
		
		[SkinPart("true")]
		public var typeInfo :Label;
		
		private var infoChanged:Boolean;
		private var _pathAvatar:String;
		private var _nameSender:String;
		private var _typeInfo:String;
		private var _info:String;
		
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
				typeInfo.text = _typeInfo;
				if (_typeInfo =="")
				{
					titleDisplay.left = typeInfo.left;
				}
				this.percentWidth = 100; 
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return "normal";
		}
		
		public function setElementChat(pathAvatar:String, nameSender:String, info:String, typeInfo:String):void
		{
			infoChanged = true;
			_pathAvatar = pathAvatar;
			_nameSender = nameSender;
			_info = info;
			_typeInfo = typeInfo;
			invalidateProperties();
		}
		
	}
}