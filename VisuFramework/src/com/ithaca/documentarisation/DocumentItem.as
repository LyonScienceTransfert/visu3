package com.ithaca.documentarisation
{
	import mx.controls.Image;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class DocumentItem extends SkinnableComponent
	{
		[SkinState("normal")]
		[SkinState("active")]
		[SkinState("edited")]
		
		[SkinPart("true")]
		public var idLabel:Label;
		
		[SkinPart("true")]
		public var titleLabel:Label;
		
		[SkinPart("true")]
		public var documentTypeIcon:Image;
		
		[SkinPart("true")]
		public var titleText:TextArea;
		
		[SkinPart("true")]
		public var urlText:TextArea;
		
		[SkinPart("true")]
		public var editButton:Button;
		
		[SkinPart("true")]
		public var removeButton:Button;
		
		[SkinPart("true")]
		public var okButton:Button;
		
		[SkinPart("true")]
		public var cancelButton:Button;
		
		public function DocumentItem()
		{
			super();
		}
	}
}