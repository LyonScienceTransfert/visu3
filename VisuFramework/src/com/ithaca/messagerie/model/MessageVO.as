package com.ithaca.messagerie.model
{
import com.asfusion.mate.actions.DataCopier;

public class MessageVO
{
    private var _text:String;
    private var _date:Date;
    private var _isLogedUserMessage:Boolean;
    private var _isWatch:Boolean;
    
    public function MessageVO(text:String, date:Date, isLoggedUserMessage:Boolean, isWatch:Boolean = false )
    {
        _text = text;
        _date = date;
        _isLogedUserMessage = isLoggedUserMessage;
        _isWatch = isWatch;
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function get text():String
    {
        return _text;
    }
    public function get date():Date
    {
        return _date;
    }
    public function get isLoggedUserMessage():Boolean
    {
        return _isLogedUserMessage;
    }
    public function get isWatch():Boolean
    {
        return _isWatch;
    }
}
}