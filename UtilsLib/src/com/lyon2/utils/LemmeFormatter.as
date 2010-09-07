package com.lyon2.utils
{
	public class LemmeFormatter
	{

		public static function format(str:String) : String 
		{
			var a1:String = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðòóôõöùúûüýÿñ";
			var a2:String = "aaaaaaceeeeiiiiooooouuuuyaaaaaaceeeeiiiioooooouuuuyyn";
						
			for (var i:int = 0; i< a1.length; i++) 
			{ 
    			str = str.replace(a1.charAt(i), a2.charAt(i)); 
			}  
			
			return str;
		}
		
	}
}