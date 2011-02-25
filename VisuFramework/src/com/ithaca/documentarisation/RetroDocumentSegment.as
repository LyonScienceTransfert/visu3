package com.ithaca.documentarisation
{
	
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.documentarisation.model.Segment;
	import com.ithaca.traces.Obsel;
	import com.ithaca.visu.ui.utils.IconEnum;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;
	
	public class RetroDocumentSegment extends SkinnableComponent
	{
		[SkinState("normal")]
		[SkinState("open")]
		[SkinState("normalEditable")]
		[SkinState("openEditable")]
		
		[SkinPart("true")]
		public var titleSegmentLabel:Label;
		
		[SkinPart("true")]
		public var titleSegmentTextInput:TextInput;
		
		[SkinPart("true")]
		public var buttonDeleteSegment:Button;
		
		[SkinPart("true")]
		public var segmentVideo:SegmentVideo;

		[SkinPart("true")]
		public var segmentComment:TextArea;
		
		private var open:Boolean;
		private var editabled:Boolean;
		private var titleChange:Boolean;
		private var segmentChange:Boolean;
		private var segmentSet:Boolean;
		private var emptySegmentVideo:Boolean = true;
		private var isDroped:Boolean = false;
		
		private var TEXT_TITLE_EMPTY ="Entrez un titre ici";
		
		private var _title:String = "";
		private var _timeBegin:Number=0;
		private var _sourceIcon:Object;
		private var _textComment:String= "";
		private var dragSource:DragSource = null;
		private var _startDateSession:Number;
		private var _segment:Segment;
		
		import gnu.as3.gettext.FxGettext;
		import gnu.as3.gettext._FxGettext;
		
		[Bindable]
		private var fxgt:_FxGettext;
		
		public function RetroDocumentSegment()

		{
			super();
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			fxgt = FxGettext;
		}
		
		public function get segment():Segment
		{
			return _segment;
		}
		
		public function set segment(value:Segment):void
		{
			this._segment = value;
			segmentSet = true;
			this.invalidateProperties();
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			this._title = value;
			titleChange = true;
		}
		public function set startDateSession(value:Number):void{_startDateSession = value;};
		public function get startDateSession():Number{return _startDateSession;};
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == segmentVideo)
			{
				segmentVideo.sourceIcon = this._sourceIcon;
				segmentVideo.startDateSession = _startDateSession
				segmentVideo.timeBegin = _timeBegin;
				
				this.segmentVideo.showDetail(emptySegmentVideo);
			}
			
			if(instance == segmentComment)
			{
				segmentComment.text  = _textComment;
				segmentComment.addEventListener(TextOperationEvent.CHANGE, segmentCommentTextInput_changeHandler);
			}
			
			if(instance == buttonDeleteSegment)
			{
				buttonDeleteSegment.addEventListener(MouseEvent.CLICK, onDeleteSegment);
			}	
			
			if(instance == titleSegmentLabel)
			{
				titleSegmentLabel.text = this._title;
			}	
			
			if(instance == titleSegmentTextInput)
			{
				if(this._title == "")
				{
					setMessageTitleSegmentTextInput();
					titleSegmentTextInput.addEventListener(FocusEvent.FOCUS_OUT, titleSegmentTextInput_focusOutHandler);	
					titleSegmentTextInput.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, titleSegmentTextInput_focusOutHandler);	
					titleSegmentTextInput.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, titleSegmentTextInput_focusOutHandler);	
					titleSegmentTextInput.addEventListener(FocusEvent.FOCUS_IN, titleSegmentTextInput_focusInHandler);
				}else
				{
					titleSegmentTextInput.text = this._title;
				}
				titleSegmentTextInput.addEventListener(TextOperationEvent.CHANGE, titleSegmentTextInput_changeHandler);
				
			}	
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (titleChange)
			{
				titleChange = false;
				
				if(titleSegmentLabel != null)
				{
					this.titleSegmentLabel.text  = this._title;
				}
				if(titleSegmentTextInput != null)
				{
					this.titleSegmentTextInput.text  = this._title;
				}
			}
			if(segmentChange)
			{
				segmentChange = false;
				this.segmentVideo.showDetail(false);
				this.segmentVideo.startDateSession = this._startDateSession;
				this.segmentVideo.timeBegin = this._timeBegin
				this.segmentVideo.sourceIcon = this._sourceIcon;
				
				this.segmentComment.text = this._textComment;
				this.segmentComment.selectAll();
				this.stage.focus = this.segmentComment;
				emptySegmentVideo = false;
				this.segmentVideo.showDetail(emptySegmentVideo);
			}
			
			if(segmentSet)
			{
				segmentSet = false;
				this._sourceIcon = IconEnum.getIconByTypeObsel(this._segment.typeSource);
				this._textComment = this._segment.comment;
				this._timeBegin = this._segment.beginTimeVideo;
				this._title = this._segment.title;
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (!enabled)
			{
				return "disable";
			}else
				if(open){
					if(editabled){
						return "openEditable";
					}else{
						return "open";
					}
				}else
				{
					if(editabled){
						return "normalEditable";
					}else{
						return "normal";
					}
				} 
		}
		public function segment_clickHandler(event:MouseEvent):void
		{
			open = !open;
			invalidateSkinState();
		}
		private function onDeleteSegment(even:MouseEvent):void
		{
			var removeSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PRE_REMOVE_SEGMENT);
			removeSegmentEvent.segment = this._segment;
			this.dispatchEvent(removeSegmentEvent);
		}
		
		public function setEmpty(value:Boolean):void
		{
			emptySegmentVideo = value;		
		}
		public function setOpen(value:Boolean):void
		{
			open = value;
			invalidateSkinState();	
		}
		public function setEditabled(value:Boolean):void
		{
			editabled = value;
			this.invalidateSkinState();
		}	
		
		private function onDragEnter(event:DragEvent):void
		{
			if(event.dragSource.hasFormat("obsel") && editabled)
			{	
				var rds:RetroDocumentSegment = event.currentTarget as RetroDocumentSegment;
				DragManager.acceptDragDrop(rds);
			}	
		}
		
		private function onDragDrop(event:DragEvent):void
		{
			dragSource = event.dragSource;
			isDroped = true;
			if(!open){
				open = true; 
				invalidateSkinState();
				var updateSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.UPDATE_RETRO_SEGMENT);
				this.dispatchEvent(updateSegmentEvent);
			}else
			{
				checkingEmptySegmentVideo();
			}	
		}
		
		public function checkingEmptySegmentVideo():void
		{
			if(isDroped)
			{
				isDroped = false;
				if(!segmentVideo.isEmpty())
				{
					Alert.yesLabel = fxgt.gettext("Oui");
					Alert.noLabel = fxgt.gettext("Non");
					Alert.show(fxgt.gettext("Voulez-vous ajouter l'élément au segment ?     Cette opération remplace le titre du segment, ajoute le contenu au commentaire et remplace l'extrait vidéo ?"),
						fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, updateSegmentConformed); 
				}else
				{
					updateSegment();
				}
			}
		}
		private function updateSegmentConformed(event:CloseEvent):void
		{
			if( event.detail == Alert.YES)
			{
				updateSegment();
			}
		}
		
		private function updateSegment():void
		{
			var obsel:Obsel = dragSource.dataForFormat("obsel") as Obsel;
			_timeBegin = obsel.begin;
			_textComment = _textComment + dragSource.dataForFormat("textObsel") as String;
			// update segment
			_segment.beginTimeVideo = obsel.begin;
			_segment.comment = _textComment;
			_segment.link = "voidLink";
			_segment.title = _title;
			segmentChange = true;
			this.invalidateProperties();
			var updateSegmentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.UPDATE_RETRO_SEGMENT);
			this.dispatchEvent(updateSegmentEvent);
		}
		
		private function setMessageTitleSegmentTextInput():void
		{
			titleSegmentTextInput.text = TEXT_TITLE_EMPTY;
			titleSegmentTextInput.setStyle("fontStyle","italic");
			titleSegmentTextInput.setStyle("color","#000000");
		}
		protected function titleSegmentTextInput_focusOutHandler(event:FocusEvent):void
		{
			if(titleSegmentTextInput.text == "")
			{
				setMessageTitleSegmentTextInput();
			}
		}
		protected function titleSegmentTextInput_focusInHandler(event:FocusEvent):void
		{
			if(titleSegmentTextInput.text == TEXT_TITLE_EMPTY)
			{
				titleSegmentTextInput.text = "";
				titleSegmentTextInput.setStyle("fontStyle","normal");
				titleSegmentTextInput.setStyle("color","#000000");
			}
		}
		
		protected function titleSegmentTextInput_changeHandler(event:TextOperationEvent):void
		{
			this._title = titleSegmentTextInput.text;
			_segment.title = this._title;
			notifyUpdateTextField();
		}
		protected function segmentCommentTextInput_changeHandler(event:TextOperationEvent):void
		{
			this._textComment = this.segmentComment.text;
			_segment.comment = this._textComment;
			notifyUpdateTextField();
		}
		private function notifyUpdateTextField():void
		{
			var notifyUpdateEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_RETRO_SEGMENT);
			this.dispatchEvent(notifyUpdateEvent);
		}
	}
}