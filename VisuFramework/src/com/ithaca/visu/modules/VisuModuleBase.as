package com.ithaca.visu.modules
{
	import com.ithaca.visu.core.VisuApplication;
	import com.ithaca.visu.events.VisuModuleEvent;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.modules.IModule;
	
	import spark.components.Group;

	[Event(name="configure",type="com.ithaca.visu.events.VisuModuleEvent")]
	
	[Frame(factoryClass="mx.core.FlexModuleFactory")]
	
	public class VisuModuleBase extends Group implements IModule
	{
		private var _application:VisuApplication;
		private var _parameters:Object;
		
		public var moduleName:String;

		public function VisuModuleBase()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(FlexEvent.CREATION_COMPLETE,moduleCreationComplete);

		}

		public function get application():VisuApplication
		{
			return _application;
		}

		protected function onAddedToStage(event:Event):void
		{
			trace("Module "+name+" added to stage");
			_application = VisuApplication(parentApplication);
		}
		protected function onRemovedFromStage(event:Event):void
		{
			trace("Module "+name+" removed from stage");
			_application = null;

		}
		protected function moduleCreationComplete(event:Event):void
		{
			trace("Module "+name+" creationComplete");
			_application = VisuApplication(parentApplication);
		}
		
		public function handle_parameter(params:Object):void
		{
			_parameters=params;
			dispatchEvent( new VisuModuleEvent(VisuModuleEvent.CONFIGURE) );
		}
		public function get parameters():Object
		{
			return _parameters;
		}
		
	}
}