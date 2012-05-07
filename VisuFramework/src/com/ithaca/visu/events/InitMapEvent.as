package com.ithaca.visu.events
{
import flash.events.Event;

public class InitMapEvent extends Event
{
	// constants
	static public const INIT_MAP_HOME : String = 'initMapHome';
	static public const INIT_MAP_TUTORAT : String = 'initMapTutorat';
	static public const INIT_MAP_SESSION : String = 'initMapSession';
	static public const INIT_MAP_USER : String = 'initMapUser';
	static public const INIT_MAP_RETROSPECTION : String = 'initMapRetrospection';
	static public const INIT_MAP_BILAN : String = 'initMapBilan';
	static public const INIT_MAP_PROFIL : String = 'initMapProfil';

	// properties
	// constructor
	public function InitMapEvent(type : String,
							   bubbles : Boolean = true,
							   cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	
	}
}
}
