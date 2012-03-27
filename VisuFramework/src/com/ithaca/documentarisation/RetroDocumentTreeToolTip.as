package com.ithaca.documentarisation
{
	import com.ithaca.documentarisation.model.RetroDocument;
	import com.ithaca.utils.UtilFunction;
	
	import mx.collections.ArrayCollection;
	import mx.core.IToolTip;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class RetroDocumentTreeToolTip extends SkinnableComponent implements IToolTip
	{
		
		[SkinPart("true")]
		public var titleDocument:Label;
		
		[SkinPart("true")]
		public var dateModify:Label;
		
		[SkinPart("true")]
		public var ownerRetroDocument:Label;
		
		[SkinPart("true")]
		public var groupUser:Group;
		
		private var _retroDocumentView:RetroDocumentView;
		private var retroDocumentChange:Boolean;
		
		public function get retroDocument():RetroDocumentView
		{
			return _retroDocumentView;
		}
		public function set retroDocument(value:RetroDocumentView):void
		{
			_retroDocumentView = value;
			retroDocumentChange = true;
			invalidateProperties();
		}
		
		public function RetroDocumentTreeToolTip()
		{
			super();
		}
		
		public function get text():String
		{
			return null;
		}
		
		public function set text(value:String):void
		{
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(retroDocumentChange)
			{
				retroDocumentChange = false;
				
				groupUser.removeAllElements();
				addUsers();
				
				if(titleDocument != null && this._retroDocumentView != null )
				{
					this.titleDocument.text  = this._retroDocumentView.titleDocumentText;
				}
				
				if(dateModify != null && this._retroDocumentView != null)
				{
					this.dateModify.text  = this._retroDocumentView.retroDocument.modifyDate;
/*					var dateString:String = UtilFunction.getLabelDate(this._retroDocument.modifyDate,"-");
					var heureMinString:String = UtilFunction.getHourMinDate(this._retroDocument.modifyDate);
					this.dateModify.text  = dateString + " "+ heureMinString;*/
				}
				
			}
		}
		
		private function addUsers():void
		{
			if(this._retroDocumentView != null)
			{
				var listUser:Array = this._retroDocumentView.listShareUser;
				var nbrUser:int = listUser.length;
				for(var nUser:int = 0; nUser < nbrUser ; nUser++)
				{
					var userId:int = listUser[nUser];
					var userLabel:Label = new Label();
					userLabel.text = userId.toString()+ "xxxxxxxxx";
					userLabel.percentWidth = 100;
					this.groupUser.addElement(userLabel);
				}
			}
			
		}
	}
}