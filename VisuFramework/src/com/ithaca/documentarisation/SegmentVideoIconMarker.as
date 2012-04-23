package com.ithaca.documentarisation
{
import com.ithaca.traces.Obsel;
import com.ithaca.traces.model.TraceModel;

import mx.containers.Canvas;
import mx.controls.Image;

import spark.components.supportClasses.SkinnableComponent;

public class SegmentVideoIconMarker extends SkinnableComponent
{
    [SkinPart("true")]
    public var icon:Image;
    
    [SkinPart("true")]
    public var coloriage:Canvas;
    
    private var _obsel:Obsel;
    private var obselChange:Boolean;
    
    public function SegmentVideoIconMarker()
    {
        super();
    }
    
    public function set obsel(value:Obsel):void
    {
        _obsel = value;
        obselChange = true;
        invalidateProperties();
    }
    public function get obsel():Obsel
    {
        return _obsel;
    }
    override protected function commitProperties():void
    {
        super.commitProperties();	
        if(obselChange)
        {
            obselChange = false;
            
            var color:String = "";
            var typeShortMarker:String = obsel.props[TraceModel.TYPE_SHORT_MARKER];
            switch (typeShortMarker)
            {
            case  "comp" :
                color = "#DB6E6E";
                break;
            case  "pron" :
                color = "#DFE549";
                break;
            case  "sens" :
                color = "#92DD56";
                break;
            case  "inte" :
                color = "#55B3DE";
                break;
            case  "posi" :
                color = "#92DD56";
                break;
            case  "nega" :
                color = "#DB6E6E";
                break;
            default :
                color = "#000000";
                break;
            }
            // set color
            coloriage.setStyle("backgroundColor", color);
        }
    }
}
}