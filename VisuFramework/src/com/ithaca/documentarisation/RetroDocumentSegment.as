/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.ithaca.documentarisation
{

	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.documentarisation.model.Segment;
	import com.ithaca.traces.Obsel;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.lyon2.controls.utils.TimeUtils;

	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.managers.DragManager;

	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;

    import gnu.as3.gettext.FxGettext;
    import gnu.as3.gettext._FxGettext;

	public class RetroDocumentSegment extends SkinnableComponent
	{
		[SkinState("normal")]
		[SkinState("open")]
		[SkinState("normalEditable")]
		[SkinState("openEditable")]


		private static var logger:ILogger = Log.getLogger("com.ithaca.documentarisation.RetroDocumentSegment");

		[Bindable]
	    private var fxgt: _FxGettext = FxGettext;

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

		private var currentTimeChange:Boolean;

		private var TEXT_TITLE_EMPTY:String = fxgt.gettext("Entrez un titre ici");
		private var DELTA_TIME:Number = 5000;

		private var _title:String = "";
		private var _timeBegin:Number=0;
		private var _timeEnd:Number=0;
		private var _textComment:String= "";
		private var dragSource:DragSource = null;
		private var _startDateSession:Number = 0;
		private var _durationSession:Number;
		private var _segment:Segment;
		private var _currentTime:String = "";

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

		public function set currentTime(value:String):void{
			_currentTime = value;
			currentTimeChange = true;
			this.invalidateProperties();
		};
		public function get currentTime():String{return _currentTime;};
		public function setBeginEndTime():void
		{
			durationChange = true;
			invalidateProperties();
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == segmentVideo)
			{
				segmentVideo.setNewBeginEnd(
					_timeBegin - startDateSession,
					_timeEnd - startDateSession
					);
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
				buttonDeleteSegment.toolTip = fxgt.gettext("Supprimer ce bloc");
			}

			if(instance == buttonPlayStopVideo)
			{
				if(this._timeBegin == 0 )
				{
					buttonPlayStopVideo.enabled = false;
					buttonPlayStopVideo.toolTip = fxgt.gettext("Aucun bloc vidéo associé actuellement");
				}
				else
				{
					buttonPlayStopVideo.toolTip = fxgt.gettext("Jouer la vidéo correspondant à ce segment");
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
				labelStartDuration.setStyle("fontWeight","normal");
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

				this.segmentVideo.setNewBeginEnd(
					this._timeBegin - this._startDateSession,
					this._timeEnd - this._startDateSession
					);
				this.segmentComment.text = this._textComment;
				this.segmentComment.selectAll();
				this.stage.focus = this.segmentComment;
				emptySegmentVideo = false;
				segmentVideo.showDetail(emptySegmentVideo);
				segmentVideo.setEditable(editabled);
				segmentVideo.addEventListener(RetroDocumentEvent.CHANGE_TIME_BEGIN_TIME_END, segmentVideo_changeHandler);
				setEnabledButtonPlayStop();

				logger.debug("RetroDocumentSegment.commitProperties: duration has changed");

				labelStartDuration.text = getLabelStartDuration();
				labelStartDuration.setStyle("fontWeight","normal");
			}

			if(segmentSet)
			{
				segmentSet = false;
				this._textComment = this._segment.comment;
				// check NaN time
				var begin:Number = this._startDateSession;
				if(!isNaN(this._segment.beginTimeVideo))
				{
					begin = this._segment.beginTimeVideo;
				}
				this._timeBegin = begin;
				var end:Number = this._startDateSession;
				if( !isNaN(this._segment.endTimeVideo))
				{
					end = this._segment.endTimeVideo;
				}
				this._timeEnd = end;
				//this._title = this._segment.title;
				// enabled button playStop
				setEnabledButtonPlayStop();
				labelStartDuration.text = getLabelStartDuration();
				labelStartDuration.setStyle("fontWeight","normal");
			}

			if(durationChange)
			{
				logger.debug("RetroDocumentSegment.commitProperties: duration has changed");
				durationChange = false;
				labelStartDuration.text = getLabelStartDuration();
				labelStartDuration.setStyle("fontWeight","normal");
			}

			if(currentTimeChange)
			{
				currentTimeChange = false;

				labelStartDuration.text = this._currentTime;
				labelStartDuration.toolTip = this._currentTime;
				labelStartDuration.setStyle("fontWeight","bold");
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
					Alert.show(fxgt.gettext("Voulez-vous ajouter l'élément au segment ? Cette opération remplace le titre du segment, ajoute le contenu au commentaire et remplace l'extrait vidéo."),
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
			logger.debug("Updating the retrodoc segment [begin:{0},_startDateSession:{1}]", obsel.begin,_startDateSession);

			if(obsel.begin - _startDateSession > DELTA_TIME)
			{
				_timeBegin = obsel.begin - DELTA_TIME ;
			}else
			{
				_timeBegin = _startDateSession;
			}
			// timeEnd  by duration of the session
			_timeEnd = obsel.begin + DELTA_TIME;
			var timeEndSession:Number = this._startDateSession + this._durationSession;
			if(_timeEnd > timeEndSession)
			{
				_timeEnd = timeEndSession ;
			}
			_textComment = _textComment + dragSource.dataForFormat("textObsel") as String;
			// update segment
			logger.debug("_segment.beginTimeVideo = _timeBegin");
			_segment.beginTimeVideo = _timeBegin
			logger.debug("_segment.beginTimeVideo = _timeBegin");
			_segment.endTimeVideo = _timeEnd;
			logger.debug("_segment.endTimeVideo = _timeEnd");
			_segment.comment = _textComment;
			logger.debug("_segment.comment = _textComment;");
			_segment.pathCommentAudio = "voidLink";
			logger.debug("_segment.link = \"voidLink\"");
			//_segment.title = _title;
			logger.debug("_segment.title = _title");
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
			logger.debug("The segment video has been changed [event.beginTime: {0},event.endTime: {1}]. Updating the retro document...", event.beginTime,event.endTime);
			this._timeBegin = event.beginTime + _startDateSession;
			this._timeEnd = event.endTime + _startDateSession;
			_segment.beginTimeVideo = this._timeBegin;
			_segment.endTimeVideo = this._timeEnd;
			durationChange = true;
			this.invalidateProperties();

			notifyUpdateSegment();
		}

		private function getLabelStartDuration():String
		{
			logger.debug("TimeUtils.formatTimeString(timeBegin: {0}, _startDateSession: {1}, (this._timeBegin - _startDateSession)/1000: {3})",
					this._timeBegin,
					_startDateSession,
					Math.floor((this._timeBegin - _startDateSession)/1000));
			var s:String = TimeUtils.formatTimeString(Math.floor((this._timeBegin - _startDateSession)/1000));
			logger.debug("Label start duration: {0}", s);
			return s;

			// Ne pas afficher la durée finalement, car la place manque
			/*
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
			*/
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
			buttonPlayStopVideo.toolTip = fxgt.gettext("Jouer la vidéo correspondant à ce segment");
		}

		public function setLabelPlay(value:Boolean):void
		{
			if(value)
			{
				this.buttonPlayStopVideo.label = fxgt.gettext("Pause");
			}else
			{
				this.buttonPlayStopVideo.label = fxgt.gettext("Jouer");
			}
			// set status segment
			this.statusPlaySegment = value;
		}
	}
}
