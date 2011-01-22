package com.ithaca.traces.view
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.visu.events.ObselEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ObselComment extends SkinnableComponent implements IObselComponenet
	{
		
		[SkinPart("true")]
		public var textContent:Label;
		
		[SkinPart("true")] 
		public var imageObsel:Image;
		
		[SkinPart("true")] 
		public var textEdit:TextArea;
		
		[SkinPart("true")] 
		public var buttonDelete:Button;
		
		[SkinPart("true")] 
		public var buttonOk:Button;
		
		[SkinPart("true")] 
		public var buttonCancel:Button;
		
		private var _begin:Number;
		private var _end:Number;
		
		private var _text:String;
		private var textChange:Boolean;
		private var normal:Boolean;
		
		private var _parentObsel:Obsel;
		private var _order:int;
		private var _backGroundColor:uint;
		
		public function ObselComment()
		{
			super();
			this.buttonMode = true;
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onDobleClickObselComment);
		}
		
		public function set parentObsel(value:Obsel):void{_parentObsel = value;}
		public function get parentObsel():Obsel{return this._parentObsel}
		public function set order(value:int):void{_order = value;}
		public function get order():int{return this._order}
		public function get text():String {return _text; }
		public function set text(value:String):void{_text = value;}
		public function set backGroundColor(value:uint):void{_backGroundColor = value; invalidateProperties();}
		public function get backGroundColor():uint{return this._backGroundColor}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (textChange)
			{
				textChange = false;
				if(normal){
					textContent.text = text;		
					textContent.toolTip = text;		
				}else
				{
					textEdit.text = text;
//					this.stage.focus = textEdit;
					textEdit.selectAll();
				}
			}
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == buttonDelete)
			{
				buttonDelete.addEventListener(MouseEvent.CLICK, onMouseClickButtonDelete);
				buttonDelete.toolTip = "effacer";
			}
			if(instance == buttonOk)
			{
				buttonOk.addEventListener(MouseEvent.CLICK, onMouseClickButtonOk);
				buttonOk.toolTip = "valider";
			}
			if(instance == buttonCancel)
			{
				buttonCancel.addEventListener(MouseEvent.CLICK, onMouseClickButtonCancel);
				buttonCancel.toolTip = "cancel";
			}
			if(instance == textContent)
			{
				textContent.text = text;
				textContent.toolTip = text;
			}
			if(instance == textEdit)
			{
				textEdit.text = text;
			}
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == buttonDelete)
			{
				buttonDelete.removeEventListener(MouseEvent.CLICK, onMouseClickButtonDelete);
				buttonDelete.toolTip = "effacer";
			}
			if(instance == buttonOk)
			{
				buttonOk.removeEventListener(MouseEvent.CLICK, onMouseClickButtonOk);
				buttonOk.toolTip = "valider";
			}
			if(instance == buttonCancel)
			{
				buttonCancel.removeEventListener(MouseEvent.CLICK, onMouseClickButtonCancel);
				buttonCancel.toolTip = "cancel";
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : normal? "editabled" : "normal" ;
		}
		
		public function setEditabled(value:Boolean):void
		{
			normal = value;
			this.invalidateSkinState();
		}
		
// LISTENERS
		private function onMouseClickButtonDelete(event:MouseEvent):void
		{
			setEditabled(false);
			var deleteObsel:ObselEvent = new ObselEvent(ObselEvent.DELETE_OBSEL);
			deleteObsel.obsel = this.parentObsel;		
			deleteObsel.textObsel = text;
			this.dispatchEvent(deleteObsel);
		}
		private function onMouseClickButtonOk(event:MouseEvent):void
		{
			setEditabled(false);
			text = this.textEdit.text;
			textChange = true;
			this.invalidateProperties();
			var updateObsel:ObselEvent = new ObselEvent(ObselEvent.EDIT_OBSEL);
			updateObsel.obsel = this.parentObsel;
			updateObsel.textObsel = text;
			this.dispatchEvent(updateObsel);
		}
		private function onMouseClickButtonCancel(event:MouseEvent):void
		{
			this.textEdit.text = text;
			setEditabled(false);
/*			this.textContent.text = text;
			this.textContent.toolTip = text;*/
			textChange = true;
			this.invalidateProperties();
		}
		
		private function onDobleClickObselComment(event:MouseEvent):void
		{
			// TODO check where you will edit comment
			setEditabled(true);
		}
		
		public function setBegin(value:Number):void
		{
			this._begin = value;
		}
		
		public function getBegin():Number
		{
			return this._begin;
		}
		
		public function setEnd(value:Number):void
		{
			this._end = value;
		}
		
		public function getEnd():Number
		{
			return this._end;
		}
		public function setObselViewVisible(value:Boolean):void
		{
			this.visible = value;
		}
		public function cloneMe():ObselComment
		{
			var result:ObselComment = new ObselComment();
     		result._begin = this._begin;
			result._end = this._end;
			result._parentObsel = this._parentObsel;
			result._backGroundColor = this._backGroundColor;
			result._order = this._order;
			return result;
		}
	}
}