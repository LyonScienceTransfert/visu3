package com.ithaca.messagerie.model
{
import com.ithaca.visu.model.User;

import mx.collections.ArrayCollection;

public class DialogVO
{
    private var _user:User;
    private var _userModule:String;
    private var _listMessageVO:ArrayCollection;
    
    public function DialogVO(user:User, userModule:String, listMessageVO:ArrayCollection)
    {
        _user = user;  
        _userModule = userModule;
        _listMessageVO = listMessageVO;
    }
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function get user():User
    {
        return _user;
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