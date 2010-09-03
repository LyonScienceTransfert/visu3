package com.lyon2.visu.model
{
	import com.lyon2.visu.vo.ProfileDescriptionVO;

	public class Profile extends ProfileDescriptionVO
	{
		public function testPermission(permission:int):Boolean
		{
			return true;
		}
	}
}