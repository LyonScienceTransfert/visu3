package com.ithaca.visu.controls.users
{
	import com.ithaca.visu.controls.users.event.UserFilterEvent;
	import com.lyon2.visu.vo.ProfileDescriptionVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	[Event(name="viewUngroup",type="com.ithaca.visu.controls.users.event.UserFilterEvent")]
	[Event(name="viewAll",type="com.ithaca.visu.controls.users.event.UserFilterEvent")]
	[Event(name="viewProfile",type="com.ithaca.visu.controls.users.event.UserFilterEvent")]
	
	public class UserFilters extends SkinnableComponent
	{
		[SkinPart("true")]
		public var list:List;
		
		protected var filterElements:ArrayList;
		
		protected static var log:ILogger = Log.getLogger("components.FilterPanel");
		
		public function UserFilters()
		{
			super();
			populateDefaultFilter();
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			list.dataProvider = filterElements;
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if( instance == list)
			{
				list.addEventListener(IndexChangeEvent.CHANGE, onSelectFilter);
			}		
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if( instance == list)
			{
				list.removeEventListener(IndexChangeEvent.CHANGE, onSelectFilter);
			}
		}
		
		
		/**
		 * @private 
		 */
		public function populateDefaultFilter():void
		{
			filterElements = new ArrayList();
			filterElements.addItem( {label:"ALL_USERS", value:"all", style:"bold"} );
			// Not implemented yet
			//filterElements.addItem( {label:"UNGROUP_USERS", value:"ungroup", style:"bold"} );
		}
		
		//_____________________________________________________________________
		//
		// Event Handlers
		//
		//_____________________________________________________________________

		
		protected function onSelectFilter(event:IndexChangeEvent):void
		{		
			var o:Object = filterElements.getItemAt(event.newIndex);
			
			var e:UserFilterEvent;
			
			switch(o.value)
			{
				case "ungroup":
					e = new UserFilterEvent(UserFilterEvent.VIEW_UNGROUP);		
					break;
				case "profile":
					e = new UserFilterEvent(UserFilterEvent.VIEW_PROFILE);
					e.profile_max = o.profile;
					if (event.newIndex == 0)
						e.profile_min = 0
					else
						e.profile_min = filterElements.getItemAt(event.newIndex-1).profile;
					break;
				default://all
					e = new UserFilterEvent(UserFilterEvent.VIEW_ALL);
					break;
			}
			dispatchEvent(e);
				
		}
		
		
		//_____________________________________________________________________
		//
		// Methods
		//
		//_____________________________________________________________________

		/**
		 * Add Dynamic filter based on user profile
		 * @param profile : Array 
		 */
		
		private var _profiles:Array = [];
		
		[Bindable("update")]
		public function get profiles():Array {return _profiles;}
		public function set profiles(value:Array):void
		{
			if( value != _profiles )
			{
				_profiles = value;
				for each( var p:ProfileDescriptionVO in value)
				{
					filterElements.addItem({label:p.short_description,value:"profile",profile:p.profile})
				}
				dispatchEvent( new Event("update") );
			}
		} 		
	}
}