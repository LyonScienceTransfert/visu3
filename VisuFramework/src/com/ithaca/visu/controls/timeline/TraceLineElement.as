package com.ithaca.visu.controls.timeline
{
	import com.ithaca.visu.events.TraceLineEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	[Event(name="removeTraceLineElement",type="com.ithaca.visu.events.TraceLineEvent")]
	public class TraceLineElement extends SkinnableContainer
	{
		
		[SkinPart("true")] 
		public var elementGroup:Group;

		[SkinPart("true")] 
		public var elementGroupButtonLabel:Group;

		[SkinPart("true")] 
		public var traceUserElement:Group;
		
		public var tempList:ArrayCollection;
		private var _colorTraceLineElement:uint;
		private var _titleTraceLineElement:String;
		private var _idElement:int;
		
		private var _durationSession:Number;
		private var _startTimeSession:Number;
		
		private var _listElementObsels:ArrayCollection;
		private var _userId:int;
		
		private var listElementObselChange:Boolean = false;
		
		public function TraceLineElement()
		{
			super();
		}
		
		public function set colorTraceLineElement(value:uint):void{this._colorTraceLineElement = value;}
		public function get colorTraceLineElement():uint{return this._colorTraceLineElement};
		public function set titleTraceLineElement(value:String):void{this._titleTraceLineElement = value;}
		public function get titleTraceLineElement():String{return this._titleTraceLineElement};
		public function set idElement(value:int):void{this._idElement = value;}
		public function get idElement():int{return this._idElement};
		public function set idUserElement(value:int):void{this._userId = value;}
		public function get idUserElement():int{return this._userId};
		public function set startTimeSession(value:Number):void{this._startTimeSession = value;}
		public function get startTimeSession():Number{return this._startTimeSession};
		public function set durationSession(value:Number):void{this._durationSession = value;}
		public function get durationSession():Number{return this._durationSession};
		
		public function onRemoveTraceLineElement(event:MouseEvent):void
		{
			var removeTraceLineElementEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.REMOVE_TRACE_LINE_ELEMENT);
			removeTraceLineElementEvent.idElement = _idElement;
			removeTraceLineElementEvent.userId = _userId;
			
			this.dispatchEvent(removeTraceLineElementEvent);
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if (listElementObselChange)
			{
				listElementObselChange = false;
				if(this._listElementObsels != null)
				{
					var nbrObsels:int = this._listElementObsels.length;
					for(var nObsel:int = 0 ; nObsel < nbrObsels ; nObsel++)
					{
						var obsel = this._listElementObsels.getItemAt(nObsel);
						traceUserElement.addElement(obsel);
					}
				}
			}
		}
		
		public function get listElementObsels():ArrayCollection { return this._listElementObsels; }
		public function set listElementObsels(value:ArrayCollection):void
		{
			traceUserElement.removeAllElements();
			// set width group for adding obsels title
			
	//		error here width traceLineElement
			
			traceUserElement.width = this.width - (elementGroupButtonLabel.width + elementGroupButtonLabel.x);
			this._listElementObsels = value;
			listElementObselChange = true;	
			invalidateProperties();
			
			if (this._listElementObsels)
			{
				this._listElementObsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, listElementObsels_ChangeHandler);
			}
		}
		private function listElementObsels_ChangeHandler(event:CollectionEvent):void
		{
			listElementObselChange = true;
			invalidateProperties();
		}

	}
}