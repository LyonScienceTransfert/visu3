package com.ithaca.utils.components
{
import com.ithaca.traces.Obsel;

import mx.core.IToolTip;

import spark.components.supportClasses.SkinnableComponent;

public class SegmentVideoOwnerObselDNDToolTip extends SkinnableComponent implements IToolTip
{
    private var _obsel:Obsel;
    private var _timeCreateObsel:Number;
    private var _text:String;
    
    public function set obsel(value:Obsel):void
    {
        _obsel = value;
    }
    public function get obsel():Obsel
    {
        return _obsel;
    }
    public function set timeCreateObsel(value:Number):void
    {
        _timeCreateObsel = value;
    }
    public function get timeCreateObsel():Number
    {
        return _timeCreateObsel;
    }
    public function SegmentVideoOwnerObselDNDToolTip()
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