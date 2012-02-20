package com.ithaca.messagerie.model
{
import com.asfusion.mate.actions.DataCopier;
import com.ithaca.visu.model.vo.UserVO;

public class MessageVO
{
    private var _text:String;
    private var _date:Date;
    private var _userVO:UserVO;
    private var _isWatch:Boolean;
    
    public function MessageVO(text:String, date:Date, userVO:UserVO, isWatch:Boolean = false )
    {
        _text = text;
        _date = date;
        _userVO = userVO;
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
    public function get userVO():UserVO
    {
        return _userVO;
    }
    public function get isWatch():Boolean
    {
        return _isWatch;
    }
    public function set isWatch(value:Boolean):void
    {
        _isWatch = value;
    }
}
}