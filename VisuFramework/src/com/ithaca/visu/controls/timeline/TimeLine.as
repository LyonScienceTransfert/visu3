package com.ithaca.visu.controls.timeline
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import spark.components.SkinnableContainer;
	
	public class TimeLine extends SkinnableContainer
	{
		protected static var log:ILogger = Log.getLogger("com.ithaca.visu.controls.sessions.TimeLine");
		
		/**
		 * @private 
		 * internal list of obsels display by the timeline
		 */
		protected var _obsels:IList;
		
		/**
		 * @private
		 * the timeline timescale based on the session duration in minutes
		 */
		protected var _timescale:int;
		
		public function TimeLine()
		{
			super();
			_obsels = new ArrayCollection();
		}
		
		/**
		 * Add a multiple Obsels on the timeline
		 * 
		 * @param IList The list of obsels to add on the timeline 
		 * 
		 * @return void
		 */
		public function addAllObsels(obsels:IList):void
		{
			log.debug("addAllObsel " + obsels);
			
		}
		/**
		 * Add an Obsel on the timeline
		 * @param Obsel An Obsel to add on the timeline
		 * @return void
		 */
		public function addObsel(obsel:Object):void
		{
			log.debug("addObsel " + obsel);
		}
			
	}
}