package com.ithaca.messagerie.model
{
import com.ithaca.visu.model.User;

import mx.collections.ArrayCollection;

public class DialogVO
{
    private var _sender:User;
    private var _resiver:User;
    private var _userModule:String;
    private var _listMessageVO:ArrayCollection;
    
    public function DialogVO(sender:User, resiver:User, userModule:String, listMessageVO:ArrayCollection)
    {
        _sender = sender;  
        _resiver = resiver;  
        _userModule = userModule;
        _listMessageVO = listMessageVO;
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function get sender():User
    {
        return _sender;
    }
    public function get resiver():User
    {
        return _resiver;
    }
    public function get userModule():String
    {
        return _userModule;
    }
    public function get listMessageVO():ArrayCollection
    {
        return _listMessageVO;
    }
}
}