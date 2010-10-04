package com.ithaca.utils
{
	/**
	 * Get from http://flexscript.wordpress.com/2008/08/18/flex-image-tooltip-component/
	 */
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import mx.containers.*;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.core.*;
	import mx.events.FlexEvent;
	
	public class ExtendToolTip extends VBox implements IToolTip
	{
		private var image:Bitmap = new Bitmap();
		private var lbl:Label;
		private var imageHolder:SWFLoader;
		private var tipText:String;
		private var _sizeImage:int;
		
		[Bindable]
		public function set ImageTip(img:*):void{
			if(img is Class){
				imageHolder.source = new img().bitmapData;
			}
			if(img as String){
				imageHolder.load(img);
			}
		}
		public function setSizeImage(value:int):void{
			_sizeImage = value;
		}

		[Bindable]
		public function set TipText(txt:String):void{
			lbl.text = txt;
		}
		public function get TipText():String{
			return tipText;
		}
		public function ExtendToolTip()
		{
			mouseEnabled = false;
			mouseChildren = false;
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			setStyle("paddingLeft",10);
			setStyle("paddingRight",10);
			setStyle("paddingTop",10);
			setStyle("paddingBottom",10);
			setStyle("backgroundAlpha",0.8);
			setStyle("backgroundColor",0xffffff);
			imageHolder = new 	SWFLoader();
			imageHolder.addEventListener(Event.COMPLETE, onLoaded);
			lbl  = new  Label();
			lbl.visible = false;
			imageHolder.source = image;
			addChild(lbl);
			addChild(imageHolder);
		}
		private function onLoaded(event:Event):void{
			var swfLoader:SWFLoader = event.currentTarget as SWFLoader;
			var ratio:Number = swfLoader.contentWidth/swfLoader.contentHeight;
			swfLoader.width = _sizeImage;
			this.width = _sizeImage+20;
			this.height = _sizeImage/ratio+40;
            this.lbl.width = _sizeImage;
			this.lbl.visible = true;
			this.visible = true;
		}

		public function get text():String
		{
			return null;
		}
		[Bindable]
		public function set text(value:String):void    {
			tipText = value;
		}
	}
}
