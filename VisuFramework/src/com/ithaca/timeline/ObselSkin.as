package com.ithaca.timeline
{
	import com.ithaca.timeline.skins.ObselGenericEditDialog;
	import com.ithaca.traces.Obsel;
	import com.ithaca.visu.events.ObselEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[Style(name = "icon", type = "Class", inherit = "no")]
	[Style(name = "backgroundColor", type = "Number", format="Color", inherit = "no")]
	public class ObselSkin extends SkinnableComponent
	{
		[SkinPart]
		public  var leftGrip		: UIComponent;
		[SkinPart]
		public  var rightGrip		: UIComponent;

		public var traceline : TraceLine;
		private var _obsel : Obsel;
		public var editable : Boolean;
		
		private var _dragArea:UIComponent = null;
		private var dragAreaChange:Boolean;
		
		public function ObselSkin( o : Obsel, tl : TraceLine )
		{
			super();			
			editable = false;
			traceline = tl;
			_obsel = o;
			doubleClickEnabled = true;
			toolTip = obsel.toString();

			this.setStyle("dragEnabled", "true");
			this.setStyle("dragMoveEnabled", "true");		
		}
		
		public function get obsel () : Obsel
		{
			return _obsel;
		}
		
		public function editObsel ( event : Event ) : void 
		{
			var editDialog:ObselGenericEditDialog = new ObselGenericEditDialog(  );
			editDialog.obsel = this;
			PopUpManager.addPopUp(editDialog, UIComponent( parentApplication), true);
			PopUpManager.centerPopUp(editDialog);
		};

		// Update the obsel values in the trace
		protected function UpdateObsel () : void {};
		
		/**
		 * set drag area of the obsels
		 */
		public function set dragArea(value:UIComponent):void
		{
			dragAreaChange = true;
			_dragArea = value;
			invalidateProperties();
		}
		public function get dragArea():UIComponent
		{
			return _dragArea;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			// Dispatcher 
			var moveObselEvent:ObselEvent = new ObselEvent(ObselEvent.MOUSE_DOWN_OBSEL);
			moveObselEvent.value = this;
			moveObselEvent.event = event;
			
			this.dispatchEvent(moveObselEvent);
		}
		
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(dragAreaChange)
			{
				dragAreaChange = false;
				if(dragArea)
				{
					dragArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
			}
		}

		
	}
}