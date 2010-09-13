package com.lyon2.visu.model
{
	import com.lyon2.visu.vo.ActivityVO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	public class Activity 
	{
		private var _listActivityElement:ArrayCollection = new ArrayCollection();
		
		public var id_activity:int;
		public var id_session:int;
		public var duration:int;
		public var title:String;
		public var ind:int;

		public function Activity(activity:Object)
		{
			
			this.id_activity = activity.id_activity;
			this.id_session = activity.id_session;
			this.duration = activity.duration;
			this.title = activity.title;
			this.ind = activity.ind;
		}
		
		public function getListActivityElement():ArrayCollection
		{
			return _listActivityElement;
		}
		
		public function setListActivityElement(arrActivityElement:Array):void
		{
			var nbrActivityElement:uint = arrActivityElement.length;
			for(var nActivityElement:uint = 0; nActivityElement < nbrActivityElement;nActivityElement++ )
			{
				var value:Object = arrActivityElement[nActivityElement];
				var activityElement:ActivityElement = new ActivityElement(value);
				this._listActivityElement.addItem(activityElement);
			}
		}
		

	}
}