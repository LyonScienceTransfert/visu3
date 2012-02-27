package com.ithaca.messagerie.model
{
import com.asfusion.mate.actions.DataCopier;
import com.ithaca.visu.model.vo.UserVO;

public class MessageVO
{
    private var _text:String;
    private var _date:Date;
    private var _senderVO:UserVO;
    private var _resiverVO:UserVO;
    private var _isWatch:Boolean;
    
    public function MessageVO(text:String, date:Date, sender:UserVO, resiver:UserVO, isWatch:Boolean = false )
    {
        _text = text;
        _date = date;
        _senderVO = sender;
        _resiverVO = resiver;
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
    public function get senderVO():UserVO
    {
        return _senderVO;
    }
    public function get resiverVO():UserVO
    {
        return _resiverVO;
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