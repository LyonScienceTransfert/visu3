package com.ithaca.visu.controls
{
	import spark.components.List;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	public class FilteredList extends List
	{
		[SkinPart("true")]
		public var search:AdvancedTextInput;
		
		public function FilteredList()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == search)
			{
				search.addEventListener(TextOperationEvent.CHANGE, updateContent);
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == search)
			{
				search.removeEventListener(TextOperationEvent.CHANGE, updateContent);
			}
		}
		
		protected function updateContent(event:TextOperationEvent):void
		{
			
		}
	}
}