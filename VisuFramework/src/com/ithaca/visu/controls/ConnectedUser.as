package com.ithaca.visu.controls
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.visu.model.User;
	
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.events.IndexChangedEvent;
	
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	import spark.events.IndexChangeEvent;
	
	use namespace mx_internal;
	
	[SkinState("normal")]
	[SkinState("editable")]
	[SkinState("disabled")]
	
	
	[Event(name="change", type="spark.events.IndexChangeEvent")]
	
	public class ConnectedUser extends SkinnableComponent
	{
		[SkinPart("false")]
		public var statusIcon:ConnectionLight;
		
		[SkinPart("false")]
		public var userLabel:TextBase;
	
		[SkinPart("false")]
		public var users:DropDownList;
		
		private var _user:User;
		private var userChanged:Boolean;
		
		public function get user():User
		{
			return _user;
		}		
		public function set user(value:User):void
		{
			userChanged=true;
			_user = value;
			invalidateProperties();
		}
		
		private var _dataProvider:IList
		private var dataProviderChanged:Boolean;
		public function get dataProvider():IList
		{
			return _dataProvider;
		}	
		public function set dataProvider(value:IList):void
		{
			dataProviderChanged=true;
			_dataProvider = value;
			invalidateProperties();
		}
		
		private var _editable:Boolean=false;
		public function get editable():Boolean
		{
			return _editable;
		}
		public function set editable(value:Boolean):void
		{
			_editable = value;			
			invalidateSkinState();
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == userLabel)
			{
				if (_user != null) userLabel.text = _user.prenom; 
			}
			if (instance == users)
			{
				users.labelField = "prenom";
				users.addEventListener(IndexChangeEvent.CHANGE, updateSelectedUser);
				
				if (_dataProvider != null) users.dataProvider = _dataProvider ; 
				if (_user != null)
				{					
					for each (var u:User in _dataProvider)
					{
						if( u.mail == _user.mail) users.selectedItem = u;
					}
				}
			}
			 
		}

		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if( instance == users)
			{
				users.removeEventListener(IndexChangeEvent.CHANGE, updateSelectedUser);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			return !enabled ? "disabled" : _editable  && _user.status != ConnectionStatus.CONNECTED ? "editable" : "normal" ;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (userChanged)
			{
				userChanged = false;
				statusIcon.status = _user.status; 
			}
			if (dataProviderChanged)
			{
				dataProviderChanged = false;
				if (users) users.dataProvider = _dataProvider;
			}
		}
		
		protected function updateSelectedUser(event:IndexChangeEvent):void
		{
			user = User(dataProvider.getItemAt( event.newIndex ));
			dispatchEvent( event.clone() );
		}
			
	}
}