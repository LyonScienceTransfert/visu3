package com.ithaca.utils.components
{
import com.ithaca.documentarisation.model.RetroDocument;

import mx.core.IToolTip;

import spark.components.supportClasses.SkinnableComponent;

public class BilanSummaryToolTip extends SkinnableComponent implements IToolTip
{
	private var _retroDocument:RetroDocument;
	
	public function set retroDocument(value:RetroDocument):void
	{
		_retroDocument = value;
	}
	public function get retroDocument():RetroDocument
	{
		return _retroDocument;
	}
	public function BilanSummaryToolTip()
	{
		super();
	}
	public function get text():String
	{
		return null;
	}
	
	public function set text(value:String):void
	{
	}
}
}