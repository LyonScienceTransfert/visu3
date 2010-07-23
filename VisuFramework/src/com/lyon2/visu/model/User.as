package com.lyon2.visu.model
{
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	
	[RemoteClass(alias="com.lyon2.visu.domain.model.User")]
	[Bindable]
	public class User
	{
		public var nom:String;
		public var prenom:String;
		public var mail:String;
		public var role:int;
		
		[Transient]
		public var status:ConnectionStatus;
		
		public function toString():String
		{
			return nom+" "+prenom;	
		}
	}
}