package com.ithaca.visu.controls.sessions
{
	import com.ithaca.visu.model.Session;
	import com.ithaca.visu.view.session.controls.event.SessionEditEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.RadioButton;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("plan")]
	[SkinState("session")]
	
	public class SessionListView extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var allButton:RadioButton;
		[SkinPart("true")]
		public var pastButton:RadioButton;
		[SkinPart("true")]
		public var comingButton:RadioButton;
		
		[SkinPart("true")]
		public var sharingAllButton:RadioButton;
		[SkinPart("true")]
		public var sharingMineButton:RadioButton;
		[SkinPart("true")]
		public var sharingOtherButton:RadioButton;
		
		[SkinPart("true")]
		public var filterText:TextInput;
		
		[SkinPart("true")]
		public var newPlanButton:Button;
		[SkinPart("true")]
		public var newSessionButton:Button;

		[SkinPart("true")]
		public var planList:List;
		[SkinPart("true")]
		public var sessionList:List;
		
		private var plan:Boolean;

		public function SessionListView()
		{
			super();
		}
		
		public function setPlanView():void
		{
			plan = true;
			this.invalidateSkinState();
		}
		
		public function setSessionView():void
		{
			plan = false;
			this.invalidateSkinState();
		}
		//_____________________________________________________________________
		//
		// Overriden Methods
		//
		//_____________________________________________________________________
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == newSessionButton)
			{
				newSessionButton.addEventListener(MouseEvent.CLICK, onAddNewSession);
			}
			if (instance == newPlanButton)
			{
				newPlanButton.enabled = false;
			}
		}
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disable" : plan? "plan" : "session";
		}
		//_____________________________________________________________________
		//
		// Listeners
		//
		//_____________________________________________________________________

		public function onAddNewSession(event:MouseEvent):void
		{
			Alert.yesLabel = "Oui";
			Alert.noLabel = "Non";
			Alert.show("Voulez-vous créer une nouvelle séance ?",
				"Confirmation", Alert.YES|Alert.NO, null, createEmptySessionConformed); 
		}
		
		private function createEmptySessionConformed(event:CloseEvent):void
		{
			if( event.detail == Alert.YES)
			{
				var sessionAddEvent:SessionEditEvent = new SessionEditEvent(SessionEditEvent.ADD_EMPTY_SESSION);
				sessionAddEvent.isModel = false;
				this.dispatchEvent(sessionAddEvent);
			}
		}
	}
}