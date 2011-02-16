package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.events.RetroDocumentEvent;
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.documentarisation.model.Segment;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.INavigatorContent;
	import mx.events.CloseEvent;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class RetroDocumentView extends SkinnableComponent
	{
		[SkinState("normal")]
		[SkinState("edited")]
		
		
		[SkinPart("true")]
		public var titleDocument:Label;
		
		[SkinPart("true")]
		public var titleDocumentTextInput:TextInput;
		
		[SkinPart("true")]
		public var shareButton:Button;
		
		[SkinPart("true")]
		public var removeButton:Button;
		
		[SkinPart("true")]
		public var addButton:Button;
		
		[SkinPart("true")]
		public var groupSegment:Group;
		
		private var _labelRetroDocument:String;
		private var normal:Boolean = true;
		private var retroDocumentChange:Boolean = false; 
		private var titleChange:Boolean = false; 
		private var listSegment:IList;
		private var _retroDocument:RetroDocument;
		
		private var removingSegment:Segment;
		private var removingSegementView:RetroDocumentSegment;
		
		public function RetroDocumentView()
		{
			super();
			listSegment = new ArrayCollection();
		}
		public function get retroDocument():RetroDocument
		{
			return _retroDocument;
		}
		
		public function set retroDocument(value:RetroDocument):void
		{
//			if( _retroDocument == value) return;
			_retroDocument = value;
			retroDocumentChange = true;
			invalidateProperties();
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == groupSegment)
			{
/*				if (listSegment.length > 0) 
					addSegment();*/
			}
			if(instance == shareButton)
			{
				shareButton.addEventListener(MouseEvent.CLICK, onSharedDocument);	
			}
			if(instance == removeButton)
			{
				removeButton.addEventListener(MouseEvent.CLICK, onRemoveDocument);	
			}
			if(instance == addButton)
			{
				addButton.addEventListener(MouseEvent.CLICK, onAddSegment);	
			}
			
			if(instance == titleDocument)
			{
				titleDocument.text = _labelRetroDocument;
			}
			
			if(instance == titleDocumentTextInput)
			{
				titleDocumentTextInput.text = _labelRetroDocument;
			}
			
			
		}
		
		public function setEditabled(value:Boolean):void
		{
			normal = !value;
			this.invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : normal? "normal" : "edited";
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(retroDocumentChange)
			{
				retroDocumentChange = false;
				
				groupSegment.removeAllElements();
				perseRetroDocument();
				addSegment();	
				
				if(titleDocument != null)
				{
					this.titleDocument.text  = this._labelRetroDocument;
				}
				if(titleDocumentTextInput != null)
				{
					this.titleDocumentTextInput.text  = this._labelRetroDocument;
				}
			}
/*			if(sergmentChange)
			{
				sergmentChange = false;
				this.segmentVideo.timeBigin = this._timeBegin;
				this.segmentVideo.sourceIcon = this._sourceIcon;
				this.segmentVideo.showDetail();
				this.segmentComment.text = this._textComment;
				this.segmentComment.selectAll();
				this.stage.focus = this.segmentComment;
			}*/
		}
		private function perseRetroDocument():void
		{
			_labelRetroDocument = this._retroDocument.title;
			var nbrSegment:int = this._retroDocument.listSegment.length;
			for(var nSegment:int = 0; nSegment < nbrSegment; nSegment++ )
			{
				var segment:Segment = this._retroDocument.listSegment.getItemAt(nSegment) as Segment;
				this.listSegment.addItem(segment);
			}	
			
		}
		protected function addSegment():void
		{
			for each( var segment:Segment in this.listSegment)
			{
				var segmentView:RetroDocumentSegment = new RetroDocumentSegment();
				segmentView.percentWidth = 100;
			//	segmentView.title = segment.title;
				segmentView.setEmpty(false);
				segmentView.setEditabled(!normal);
				segmentView.segment = segment;
				segmentView.addEventListener(RetroDocumentEvent.PRE_REMOVE_SEGMENT, onRmoveSegment);
/*				segmentView.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateStatementActivityElement);
*/				groupSegment.addElement(segmentView);
			}
		}
		private function onSharedDocument(event:MouseEvent):void
		{
			
		}
		private function onRemoveDocument(event:MouseEvent):void
		{
			
		}
		private function onAddSegment(event:MouseEvent):void
		{
//			var order:int = (this._retroDocument.listSegment.getItemAt(this._retroDocument.listSegment.length -1) as Segment).order + 1;
			var segment:Segment = new Segment();
			segment.title = "";
			this.listSegment.addItem(segment);
			var segmentView:RetroDocumentSegment = new RetroDocumentSegment();
			segmentView.percentWidth = 100;
			segmentView.setEmpty(true);
			segmentView.setEditabled(true);
			segmentView.setOpen(true);
			segmentView.segment = segment;
			segmentView.addEventListener(RetroDocumentEvent.PRE_REMOVE_SEGMENT, onRmoveSegment);

			/*segmentView.addEventListener(SessionEditEvent.PRE_DELETE_ACTIVITY_ELEMENT, onDeleteStatementActivityElement);
			segmentView.addEventListener(SessionEditEvent.PRE_UPDATE_ACTIVITY_ELEMENT, onUpdateStatementActivityElement);
			*/				
			groupSegment.addElement(segmentView);
			
		}
		
		private function onRmoveSegment(event:RetroDocumentEvent):void
		{
			removingSegment = event.segment;
			removingSegementView =event.currentTarget as RetroDocumentSegment;
			
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous supprimer ..... ?",
				"Confirmation", Alert.YES|Alert.NO, null, removeSegmentConformed); 
		}
		private function removeSegmentConformed(event:CloseEvent):void
		{
			if( event.detail == Alert.YES)
			{
				var indexSegment:int = -1;
				var listSegment:ArrayCollection = this.listSegment as ArrayCollection;
				var nbrSegment:int = listSegment.length;
				for(var nSegment:int = 0 ; nSegment < nbrSegment ; nSegment++)
				{
					var segment:Segment = listSegment.getItemAt(nSegment) as Segment;
					if(segment == this.removingSegment)
					{
						indexSegment = nSegment;
					}
				}
				if(indexSegment < 0)
				{
					Alert.show("you havn't segment for delete","bug message...");
				}else
				{
					listSegment.removeItemAt(indexSegment);
					groupSegment.removeElementAt(indexSegment);
				}
			}
			//TODO update retroDocument
		}
	}
}