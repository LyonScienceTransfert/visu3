package com.ithaca.visu.dataStrutures
{
	import com.lyon2.visu.model.User;
	
	import mx.collections.IList;
	
	[Bindable]
	public class UserSwapList
	{
		public var user:User;
		public var swapList:IList;
		
		public function UserSwapList(u:User, l:IList)
		{
			user = u;
			swapList = l;
		}
	}
}