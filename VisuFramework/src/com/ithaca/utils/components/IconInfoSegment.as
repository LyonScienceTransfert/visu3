package com.ithaca.utils.components
{
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.BitmapImage;
import spark.primitives.Ellipse;

public class IconInfoSegment extends SkinnableComponent
{
	[SkinPart("true")]
	public var elipseInfo:Ellipse;
	[SkinPart("true")]
	public var labelNbrElement:Label;
	[SkinPart("true")]
	public var iconInfo:BitmapImage;
	
	private var _nbrElement:int;
	private var nbrElementChange:Boolean;
	
	private var _sourceIcon:Object;
	private var sourceIconChange:Boolean;
	
	public function IconInfoSegment()
	{
		super();
	}
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set nbrElement(value:int):void
	{
		_nbrElement = value;
		nbrElementChange = true;
		invalidateProperties();
	}
	public function get nbrElement():int
	{
		return _nbrElement;
	}
	public function set sourceIcon(value:Object):void
	{
		_sourceIcon = value;
		sourceIconChange = true;
		invalidateProperties();
	}
	public function get sourceIcon():Object
	{
		return _sourceIcon;
	}
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == elipseInfo)
		{
			if(nbrElement > 9)
			{
				// TODO resize elipse, x for labelNbrElement 
			}
		}
		if (instance == labelNbrElement)
		{
			labelNbrElement.text = nbrElement.toString();
		}
		if (instance == iconInfo)
		{
			iconInfo.source = sourceIcon;
		}
	}
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		
	}
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(nbrElementChange)
		{
			nbrElementChange = false;
			
			if(labelNbrElement)
			{
				var deltaXlabelNbrElement:int = 7;
				if(nbrElement > 9)
				{
					deltaXlabelNbrElement = 3;
				}
				
				labelNbrElement.x = deltaXlabelNbrElement;
				labelNbrElement.text = nbrElement.toString();
			}
		}	
		if(sourceIconChange)
		{
			sourceIconChange = false;
			
			if(iconInfo)
			{
				iconInfo.source = sourceIcon;
			}
		}	
	}
}
}