package com.ithaca.visu.view.video
{
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class NameUser extends SkinnableComponent
{
	[SkinPart("true")]
	public var labelNameUser:Label;
	
	private var _name:String="void";
	private var nameUserChange:Boolean;
	
	public function NameUser()
	{
		super();
	}
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	
	public function set lastFirstNameUser(value:String):void
	{
		_name = value;
		nameUserChange = true;
		invalidateProperties();
	}
	public function get lastFirstNameUser():String
	{
		return this._name;
	}
	

	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________

	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == labelNameUser)
		{
			labelNameUser.text = _name;
		}
		
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(nameUserChange)
		{
			nameUserChange = false;
			if(labelNameUser)
			{
				labelNameUser.text = _name;
			}
		}
	}

}
}