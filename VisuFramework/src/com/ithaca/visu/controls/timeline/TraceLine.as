package com.ithaca.visu.controls.timeline
{
	import com.ithaca.traces.view.IObselComponenet;
	import com.ithaca.visu.events.TraceLineEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.INavigatorContent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.primitives.Path;
	
	[SkinState("normal")]
	[SkinState("open")]
	
	[Event(name="addTraceLineElement",type="com.ithaca.visu.events.TraceLineEvent")]
	[Event(name="removeTraceLineElement",type="com.ithaca.visu.events.TraceLineEvent")]
	public class TraceLine extends SkinnableContainer
	{
		[SkinPart("true")] 
		public var titleGroup:Group;
		
		[SkinPart("false")] 
		public var elementGroup:Group;
		
		[SkinPart("true")] 
		public var titleGroupLabelImageButton:Group;
		
	/*	[SkinPart("true")] 
		public var parentTitleGroup:Group;*/
		
		[SkinPart("true")] 
		public var traceLoggedUser:Group;
		
		[SkinPart("false")] 
		public var partOpenTraceLineElements:Path;
		
		public var tempList:ArrayCollection;
		public var tempListElement:IList;
		
		private var _nameUserTraceLine:String;
		private var _sourceImageUserTraceLine:String;
		private var _colorUserTraceLine:uint;
		
		private var _elementsTraceLine:IList;
		private var _listTitleObsels:ArrayCollection;
		private var elementsTraceLineChange:Boolean = false;
		private var listObselChange:Boolean = false;
		
		private var _startTimeSession:Number;
		private var _durationSession:Number;
		private var _userId:int;
		
		
		private var open:Boolean;
/*		private var resized:Boolean;*/
		
		
		public function TraceLine()
		{
			super();
			this._elementsTraceLine = new ArrayList();
		}
		
		public function set nameUserTraceLine(value:String):void{this._nameUserTraceLine = value;}
		public function get nameUserTraceLine():String{return this._nameUserTraceLine};
		public function set idUserTraceLine(value:int):void{this._userId = value;}
		public function get idUserTraceLine():int{return this._userId};
		public function set sourceImageUserTraceLine(value:String):void{this._sourceImageUserTraceLine = value;}
		public function get sourceImageUserTraceLine():String{return this._sourceImageUserTraceLine};
		public function set colorUserTraceLine(value:uint):void{this._colorUserTraceLine = value;}
		public function get colorUserTraceLine():uint{return this._colorUserTraceLine};
		public function set startTimeSession(value:Number):void{this._startTimeSession = value;}
		public function get startTimeSession():Number{return this._startTimeSession};
		public function set durationSession(value:Number):void{this._durationSession = value;}
		public function get durationSession():Number{return this._durationSession};
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == titleGroup)
			{
				titleGroup.addEventListener(MouseEvent.CLICK, onClickTitleGroup);
			}
			
			
			
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == titleGroup)
			{
				titleGroup.addEventListener(MouseEvent.CLICK, onClickTitleGroup);
			}
		}
		
		private function onClickTitleGroup(event:MouseEvent):void
		{
		//	var target:Group = event.target as Group;
			if(event.target is Group && event.target.id == "titleGroupLabelImageButton")
			{
		     	var ind:int= 	event.target.getElementIndex(partOpenTraceLineElements);
			    var part:Path = event.target.getElementAt(ind) as Path;
				var deltaXPath:Number = part.x +part.width;
				var xLocal:Number = event.localX;
				if(xLocal < deltaXPath)
				{
					open = !open;
					invalidateSkinState();
				}
			}
			
			
		}
		public function onClickAddTraceLine(event:Event):void
		{		
			var addTraceLineElementEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.ADD_TRACE_LINE_ELEMENT);
			addTraceLineElementEvent.userId = _userId;
			this.dispatchEvent(addTraceLineElementEvent);

			open = true;
			invalidateSkinState();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var nbrElm:int = countVisibleElementTraceLine();
			if( nbrElm > 0 )
			{partOpenTraceLineElements.visible = true}
			else
			{partOpenTraceLineElements.visible = false};				
			
			if (elementsTraceLineChange)
			{
				elementsTraceLineChange = false;
				elementGroup.removeAllElements();
				var nbrElements:int = this._elementsTraceLine.length;
				for(var nElement:int = 0; nElement < nbrElements ; nElement++ )
				{
					var element:Object = this._elementsTraceLine.getItemAt(nElement) as Object;
					if(element.visible)
					{
						var elementTraceLine:TraceLineElement = new TraceLineElement();
						elementTraceLine.percentWidth = 100;
						elementTraceLine.height = 30;
						elementTraceLine.titleTraceLineElement = element.titleTraceLine;
						elementTraceLine.colorTraceLineElement = this._colorUserTraceLine;
						elementTraceLine.idElement = element.id;	
						elementTraceLine.durationSession = this._durationSession;
						elementTraceLine.startTimeSession = this._startTimeSession;
						elementTraceLine.tempList = element.listObsel;	
						elementTraceLine.idUserElement = this._userId;
						elementTraceLine.addEventListener(TraceLineEvent.REMOVE_TRACE_LINE_ELEMENT, onRemoveTraceLineElement);
						elementTraceLine.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletElementTraceLine);
						elementGroup.addElement(elementTraceLine);	
					}
				}
			}
			
			if (listObselChange)
			{
				listObselChange = false;
				
				if(this._listTitleObsels != null)
				{
					var nbrObsels:int = this._listTitleObsels.length;
					for(var nObsel:int = 0 ; nObsel < nbrObsels ; nObsel++)
					{
						var obsel = this._listTitleObsels.getItemAt(nObsel);
						traceLoggedUser.addElement(obsel);
					}
				}
			}
			/*if(resized)
			{
				resized = false;
				traceLoggedUser.width = this.parentTitleGroup.width - this.titleGroupLabelImageButton.width;
				var t:uint= 1;
				
			}*/
		}
		private function onCreationCompletElementTraceLine(event:Event):void
		{
			var elementTraceLine:TraceLineElement = event.currentTarget as TraceLineElement;
			elementTraceLine.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompletElementTraceLine);
			elementTraceLine.listElementObsels = elementTraceLine.tempList;
		}
		public function get listTitleObsels():ArrayCollection { return this._listTitleObsels; }
		public function set listTitleObsels(value:ArrayCollection):void
		{
			traceLoggedUser.removeAllElements();
			// set width group for adding obsels title
			traceLoggedUser.width = this.width - titleGroupLabelImageButton.width;
			this._listTitleObsels = value;
			listObselChange = true;	
			invalidateProperties();
			
			if (this._listTitleObsels)
			{
				this._listTitleObsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, listTitleObsels_ChangeHandler);
			}
		}

		public function get elementsTraceLines():IList { return this._elementsTraceLine; }
		public function set elementsTraceLines(value:IList):void 
		{
			
			this._elementsTraceLine = value;
			elementsTraceLineChange = true;
			invalidateProperties();
			
			if (this._elementsTraceLine)
			{
				_elementsTraceLine.addEventListener(CollectionEvent.COLLECTION_CHANGE, elementsTraceLine_ChangeHandler);
			}
			
		}
		
		
		protected function elementsTraceLine_ChangeHandler(event:CollectionEvent):void
		{
			elementsTraceLineChange = true;
			invalidateProperties();
		}
		
		protected function listTitleObsels_ChangeHandler(event:CollectionEvent):void
		{
			listObselChange = true;
			invalidateProperties();
		}	
		
		private function onRemoveTraceLineElement(event:TraceLineEvent):void
		{
			var elementTraceLine:TraceLineElement = event.currentTarget as TraceLineElement;
			elementGroup.removeElement(elementTraceLine);
			// FIXME find other solution
			if(countVisibleElementTraceLine() == 1)
			{
				partOpenTraceLineElements.visible = false;
				open = false;
				invalidateSkinState();
			}
		}
		
		private function countVisibleElementTraceLine():int
		{
			var result:int = 0;
/*			if(this._elementsTraceLine == null)
			{
				return result;
			}*/
			var nbrElements:int = this._elementsTraceLine.length;
			for(var nElement:int = 0 ; nElement < nbrElements; nElement++)
			{
				var element:Object = this._elementsTraceLine.getItemAt(nElement) as Object;
				if(element.visible)
				{
					result++;
				}	
			}
			return result;
		}
		
		override protected function getCurrentSkinState():String
		{
			var result:String = !enabled? "disable" : open? "open" : "normal"
			return result ;
		}
		/*public function resizeMe():void
		{
			resized = true;
			invalidateProperties();
		}*/
	}
}