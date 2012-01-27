package com.ithaca.messagerie.model
{
import com.asfusion.mate.actions.DataCopier;

public class MessageVO
{
    private var _text:String;
    private var _date:Date;
    private var _isLogedUserMessage:Boolean;
    
    public function MessageVO(text:String, date:Date, isLoggedUserMessage:Boolean)
    {
        _text = text;
        _date = date;
        _isLogedUserMessage = isLoggedUserMessage;
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
}
}