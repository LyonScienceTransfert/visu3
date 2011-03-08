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

		[SkinPart("true")]
		public var labelStartDuration:Label;
		
		[SkinPart("true")]
		public var buttonPlayStopVideo:Button;

		private var open:Boolean;
		private var editabled:Boolean;
		private var titleChange:Boolean;
		private var segmentChange:Boolean;
		private var segmentSet:Boolean;
		private var emptySegmentVideo:Boolean = true;
		private var isDroped:Boolean = false;
		private var statusPlaySegment:Boolean = false;
		private var durationChange:Boolean;
		
		private var TEXT_TITLE_EMPTY:String ="Entrez un titre ici";
		private var DELTA_TIME:Number = 5000;
		
		private var _title:String = "";
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
		private var _textComment:String= "";
		private var dragSource:DragSource = null;
		private var _startDateSession:Number;
		private var _durationSession:Number;
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
		
		public function get segmentVideoView():SegmentVideo
		{
			return this.segmentVideo;
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
		public function set durationSession(value:Number):void{_durationSession = value;};
		public function get durationSession():Number{return _durationSession;};

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == segmentVideo)
			{
				segmentVideo.deltaTime = this.DELTA_TIME;
				segmentVideo.startDateSession = _startDateSession;
				segmentVideo.timeBegin = _timeBegin;
				segmentVideo.timeEnd = _timeEnd;			
				segmentVideo.showDetail(emptySegmentVideo);
				segmentVideo.setEditable(editabled);
				segmentVideo.addEventListener(RetroDocumentEvent.CHANGE_TIME_BEGIN_TIME_END, segmentVideo_changeHandler);	
			}
			
			if(instance == segmentComment)
			{
				segmentComment.text  = _textComment;
				segmentComment.addEventListener(TextOperationEvent.CHANGE, segmentCommentTextInput_changeHandler);
			}
			
			if(instance == buttonDeleteSegment)
			{
				buttonDeleteSegment.addEventListener(MouseEvent.CLICK, onDeleteSegment);
				buttonDeleteSegment.toolTip = fxgt.gettext("Supprimer ce segment");
			}	

			if(instance == buttonPlayStopVideo)
			{
				if(this._timeBegin == 0 )
				{
					buttonPlayStopVideo.enabled = false;
					buttonPlayStopVideo.toolTip = "Aucun segment vidéo associé actuellement";
				}
				else
				{
					buttonPlayStopVideo.toolTip = "Joue la vidéo correspondant à ce segment";					
				}
				buttonPlayStopVideo.addEventListener(MouseEvent.CLICK, onPlayStopButtonClick);
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
			
			if(instance == labelStartDuration)
			{
				labelStartDuration.text = getLabelStartDuration();
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
				this.segmentVideo.startDateSession = this._startDateSession;
				this.segmentVideo.timeBegin = this._timeBegin;
				this.segmentVideo.timeEnd = this._timeEnd;
				this.segmentVideo.updateNumStepplers();
				
				this.segmentComment.text = this._textComment;
				this.segmentComment.selectAll();
				this.stage.focus = this.segmentComment;
				emptySegmentVideo = false;
				segmentVideo.showDetail(emptySegmentVideo);
				segmentVideo.setEditable(editabled);
				segmentVideo.addEventListener(RetroDocumentEvent.CHANGE_TIME_BEGIN_TIME_END, segmentVideo_changeHandler);
				setEnabledButtonPlayStop();
				labelStartDuration.text = getLabelStartDuration();
			}
			
			if(segmentSet)
			{
				segmentSet = false;
				this._textComment = this._segment.comment;
				this._timeBegin = this._segment.beginTimeVideo;
				this._timeEnd = this._segment.endTimeVideo;
				this._title = this._segment.title;
				// enabled button playStop
				setEnabledButtonPlayStop();
				labelStartDuration.text = getLabelStartDuration();
			}
			
			if(durationChange)
			{
				durationChange = false;
				labelStartDuration.text = getLabelStartDuration();
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
		
		private function onPlayStopButtonClick(even:MouseEvent):void
		{
			var playRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.PLAY_RETRO_SEGMENT);
			playRetroDocumentEvent.beginTime = this._timeBegin;
			playRetroDocumentEvent.endTime = this._timeEnd;
			playRetroDocumentEvent.statusPlaySegment = this.statusPlaySegment;
			this.dispatchEvent(playRetroDocumentEvent);
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
		public function setCommentAndDurationToolTips(value:Boolean):void
		{
			var toolTipString:String = "";
			if(value)
			{
				toolTipString = this.timeToString() +" "+ this._textComment;
			}
			this.toolTip = toolTipString;
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
			
			if(obsel.begin - _startDateSession > DELTA_TIME)
			{
				_timeBegin = obsel.begin - DELTA_TIME ;
			}else
			{
				_timeBegin = _startDateSession;
			}
			// TODO timeEnd  by duration of the session 
			_timeEnd = obsel.begin + DELTA_TIME;
			_textComment = _textComment + dragSource.dataForFormat("textObsel") as String;
			// update segment
			_segment.beginTimeVideo = _timeBegin
			_segment.endTimeVideo = _timeEnd;
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
			notifyUpdateSegment();
		}
		protected function segmentCommentTextInput_changeHandler(event:TextOperationEvent):void
		{
			this._textComment = this.segmentComment.text;
			_segment.comment = this._textComment;
			notifyUpdateSegment();
		}
		private function notifyUpdateSegment():void
		{
			var notifyUpdateEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.CHANGE_RETRO_SEGMENT);
			this.dispatchEvent(notifyUpdateEvent);
		}
		
		private function segmentVideo_changeHandler(event:RetroDocumentEvent):void
		{
			this._timeBegin = event.beginTime;
			this._timeEnd = event.endTime;
			durationChange = true;
			this.invalidateProperties();
			
			notifyUpdateSegment();
		}
		private function getLabelStartDuration():String
		{
			var timeStart:Number = this._timeBegin - _startDateSession;
			var timeMin:int = timeStart/60000;
			var timeMinString:String = timeMin.toString();
			if(timeMin < 10){timeMinString = "0"+timeMinString;};
			
			var timeSec:int = (timeStart - timeMin*60000)/1000;
			var timeSecString:String = timeSec.toString();
			if(timeSec < 10){timeSecString= "0"+timeSecString;}
			
			var timeFrom:String = timeMinString+":"+timeSecString;
			
			var duration:int = (this._timeEnd - this._timeBegin)/1000;	
			var durationString:String ="("+duration.toString() + " s)";
			
			return timeFrom + " "+durationString;
		}
		
		private function timeToString():String
		{
			var timeStart:Number = this._timeBegin - _startDateSession;
			var timeMin:int = timeStart/60000;
			var timeMinString:String = timeMin.toString();
			if(timeMin < 10){timeMinString = "0"+timeMinString;};
			
			var timeSec:int = (timeStart - timeMin*60000)/1000;
			var timeSecString:String = timeSec.toString();
			if(timeSec < 10){timeSecString= "0"+timeSecString;}
			
			var timeFrom:String = timeMinString+":"+timeSecString;
			
			var timeEnd:Number = this._timeEnd - _startDateSession;
			var timeMinEnd:int = timeEnd/60000;
			var timeMinEndString:String = timeMinEnd.toString();
			if(timeMinEnd < 10){timeMinEndString = "0"+timeMinEndString;};
			
			var timeSecEnd:int = (timeEnd - timeMinEnd*60000)/1000;
			var timeSecStringEnd:String = timeSecEnd.toString();
			if(timeSecEnd < 10){timeSecStringEnd= "0"+timeSecStringEnd;}
			
			var timeTo:String = timeMinEndString+":"+timeSecStringEnd;
			
			return "["+timeFrom+"-"+timeTo+"]";
		}
		
		private function setEnabledButtonPlayStop():void
		{
			buttonPlayStopVideo.enabled = true;
			buttonPlayStopVideo.toolTip = "Joue la vidéo correspondant à ce segment";
		}
		public function setLabelPlay(value:Boolean):void
		{
			if(value)
			{
				this.buttonPlayStopVideo.label = "Pause";
			}else
			{
				this.buttonPlayStopVideo.label = "Play";		
			}
			// set status segment
			this.statusPlaySegment = value;
		}
	}
}