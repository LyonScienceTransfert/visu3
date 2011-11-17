package com.ithaca.visu.ui.utils
{
import mx.core.SoundAsset;


public class SoundEnum
{	
	import com.ithaca.visu.traces.TraceModel;
	
	[Bindable]
	[Embed("images/marqueurBlanc-bas-20px.png")]
	static private var markerIcon:Class;
	
	[Embed("sounds/blubup.mp3")]
	static private var blubup_wav:Class;
	static private var blubup:SoundAsset = new blubup_wav() as SoundAsset;

	public static function getSoundByName(name:String):SoundAsset
	{
		var sound:SoundAsset;
		switch (name)
		{
		case "blubup" : 
			sound = blubup;
			break;
		default :
			break;				
		}
		return sound;
	}
}
}