package com.ithaca.visu.test
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.visu.model.User;
	
	import flash.events.KeyboardEvent;
	
	import mx.collections.ICollectionView;
	
	import spark.components.DropDownList;
	import com.ithaca.visu.controls.ConnectionLight;
	
	
	public class ConnectedUser extends DropDownList
	{
		
		[SkinPart("true")]
		public var statusIcon:ConnectionLight;
	
		private var userChanged:Boolean;
		private var _user:User = null;
		
		public function ConnectedUser()
		{
			super();
			labelField = "prenom";
			dataProvider
		}
		
		private var _editable:Boolean=false;
		public function get editable():Boolean
		{
			return _editable;
		}
		public function set editable(value:Boolean):void
		{
			_editable = value; 
		}

		
		/**
		 *  @private
		 */		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if( instance == labelDisplay )
			{
				if(  _user != null ) labelDisplay.text = _user.prenom;
			}
			
		}
		
		/**
		 *  @private
		 */		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{ 
			return !enabled ? "disabled" : isDropDownOpen && _user.status != ConnectionStatus.CONNECTED ? "open" : _editable  && _user.status != ConnectionStatus.CONNECTED ? "normal" : "simple" ;
		}
		
		/**
		 *  @private
		 */ 
		override public function set selectedItem(value:*):void
		{
			super.selectedItem = value; 
			if( _user != value as User )
			{
				_user = User(value);
				userChanged = true;
			}
		}
		
		/**
		 *  @private
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
			if( userChanged )
			{ 
				userChanged = false;
				if( _user.role > 32) 
					labelDisplay.setStyle("fontWeight","bold");
				else
					labelDisplay.setStyle("fontWeight","normal");
				statusIcon.status = _user.status;
			}
		}
		/**
		 *  @private
		 */ 
		override protected function keyDownHandler(event:KeyboardEvent) : void
		{
			if ( _user.status == ConnectionStatus.CONNECTED) return; 
			super.keyDownHandler(event);			
		}
		
		/**
		 *  @private
		 */ 
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var retVal:Boolean = super.commitSelection(dispatchChangedEvents);
			_user = selectedItem as User;
			invalidateProperties();
			return retVal; 
		}
	}
}