package com.ithaca.visu.controls.timeline
{
	import com.ithaca.visu.events.ObselEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.events.CollectionEvent;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class TraceLineComment extends SkinnableComponent
	{
		[SkinPart("true")]
		public var textTitre:Label;
		
		[SkinPart("true")]
		public var buttonAddComment:Image;
		
		[SkinPart("true")]
		public var traceTitleLoggedUser:Group;
		
		[SkinPart("true")] 
		public var timeLayoutTitle:TimeLayout;
		
		private var _listTitleObsels:ArrayCollection;
		private var listObselChange:Boolean;
		
		private var _startTimeSession:Number;
		private var _durationSession:Number;
		private var _userId:int;
		
		private var durationChanged:Boolean;
		private var startSessionChanged:Boolean;
		private var _backGroundColor:uint;
		
		public function TraceLineComment()
		{
			super();
			// TODO icon cursor for double click
		}
		
		public function set startTimeSession(value:Number):void
		{
			this._startTimeSession = value;
			startSessionChanged = true;
			invalidateProperties();
		}
		public function get startTimeSession():Number{return this._startTimeSession};
		public function set durationSession(value:Number):void
		{
			this._durationSession = value;
			durationChanged = true;
			invalidateProperties();
		}
		public function get durationSession():Number{return this._durationSession};
		public function set idUserTraceLine(value:int):void{this._userId = value;}
		public function get idUserTraceLine():int{return this._userId};
		public function set backGroundColor(value:uint):void{_backGroundColor = value; invalidateProperties();}
		public function get backGroundColor():uint{return this._backGroundColor}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == buttonAddComment)
			{
				buttonAddComment.addEventListener(MouseEvent.CLICK, onMouseClickAddComment);
				buttonAddComment.useHandCursor = true;
				buttonAddComment.buttonMode = true;
				buttonAddComment.toolTip = "Poser";
			}
			if(instance == traceTitleLoggedUser)
			{
				traceTitleLoggedUser.doubleClickEnabled = true;
				traceTitleLoggedUser.buttonMode = true;
				traceTitleLoggedUser.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseClicktraceTitleLoggedUser);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == buttonAddComment)
			{
				buttonAddComment.removeEventListener(MouseEvent.CLICK, onMouseClickAddComment);
			}
		}
		public function get listTitleObsels():ArrayCollection { return this._listTitleObsels; }
		public function set listTitleObsels(value:ArrayCollection):void
		{
			traceTitleLoggedUser.removeAllElements();
			this._listTitleObsels = value;
			listObselChange = true;	
			invalidateProperties();
			
			if (this._listTitleObsels)
			{
				this._listTitleObsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, listTitleObsels_ChangeHandler);
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (listObselChange)
			{
				listObselChange = false;
				
				if(this._listTitleObsels != null)
				{
					if(traceTitleLoggedUser != null)
					{
						traceTitleLoggedUser.removeAllElements();
					}
					var nbrObsels:int = this._listTitleObsels.length;
					for(var nObsel:int = 0 ; nObsel < nbrObsels ; nObsel++)
					{
						var obsel = this._listTitleObsels.getItemAt(nObsel);
						obsel.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickObsel);
						//obsel.setStyle("verticalCenter","0");
						traceTitleLoggedUser.addElement(obsel);
					}
				}
			}
			
			if(startSessionChanged)
			{
				startSessionChanged = false;			
				timeLayoutTitle.startTime = this._startTimeSession;
			}
			
			if(durationChanged)
			{
				durationChanged = false;			
				timeLayoutTitle.durationSession = this._durationSession
			}
		}
			
		protected function listTitleObsels_ChangeHandler(event:CollectionEvent):void
		{
			traceTitleLoggedUser.removeAllElements();
			listObselChange = true;
			invalidateProperties();
		}
		
		
		private function onMouseClicktraceTitleLoggedUser(event:MouseEvent):void
		{
			if(event.target is Group && event.target.id == "traceTitleLoggedUser")
			{
				var obselEvent:ObselEvent = new ObselEvent(ObselEvent.ADD_OBSEL);
				obselEvent.clickOnButtonAdd = false;
				obselEvent.clickLocalX = event.localX;
				this.dispatchEvent(obselEvent);				
			}
		}
		
		private function onMouseClickAddComment(event:MouseEvent):void
		{
			var obselEvent:ObselEvent = new ObselEvent(ObselEvent.ADD_OBSEL);
			obselEvent.clickOnButtonAdd = true;
			this.dispatchEvent(obselEvent);
		}
		
		private function onDoubleClickObsel(event:MouseEvent):void
		{
			var obselEvent:ObselEvent = new ObselEvent(ObselEvent.EDIT_OBSEL);
			this.dispatchEvent(obselEvent);
		}
	}
}