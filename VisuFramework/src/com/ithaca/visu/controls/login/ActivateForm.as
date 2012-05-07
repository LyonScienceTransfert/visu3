package com.ithaca.visu.controls.login
{
import com.adobe.crypto.MD5;
import com.ithaca.utils.UtilFunction;
import com.ithaca.utils.components.IconButton;
import com.ithaca.visu.controls.login.event.LoginFormEvent;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.UserVO;
import com.ithaca.visu.ui.utils.IconEnum;

import flash.events.Event;
import flash.events.MouseEvent;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.controls.Image;
import mx.events.FlexEvent;
import mx.utils.StringUtil;
import mx.validators.StringValidator;
import mx.validators.Validator;

import spark.components.Button;
import spark.components.Label;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;



public class ActivateForm extends SkinnableComponent
{
    [SkinPart("true")]
    public var labelInfo:Label;
    
    [SkinPart("true")]
    public var passwordText:TextInput;
    
    [SkinPart("false")]
    public var submitButton:Button;
    
    [SkinPart("false")]
    public var imageCheck:Image;
    
    [SkinPart("false")]
    public var labelCheck:Label;
    
    [SkinPart("false")]
    public var lebelErrorActivatedKey:Label;
    
    [SkinPart("false")]
    public var labelWorking:Label;
    
    private var _loggedUser:UserVO;
    private var _activated:Boolean;
    private var _errorActivatedKey:Boolean;
    private var _working:Boolean;
    
    protected var passValidator:StringValidator;
    
    [Bindable]
    private var fxgt:_FxGettext = FxGettext;
    
    
    public function ActivateForm()
    {
        super();
        
        // init internalisation
        fxgt = FxGettext;
        
        passValidator = new StringValidator();
        passValidator.required = true;
        passValidator.tooShortError =  fxgt.gettext("Password is shorter than the minimum allowed length of 6");
        passValidator.minLength = 6;
        passValidator.trigger = submitButton;
        passValidator.triggerEvent = MouseEvent.CLICK;
    }
    
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function set loggedUser(value:UserVO):void
    {
        this._loggedUser = value;
        if(!value)
        {
            errorActivatedKey = true;
        }else
        {
            activated = true;
        }
    }
    public function get loggedUser():UserVO
    {
        return _loggedUser;
    }
       
    public function get activated():Boolean
    {
        return _activated;
    }
    public function set activated(value:Boolean):void
    {
        _activated = value;
        invalidateSkinState();
    }
    public function get errorActivatedKey():Boolean
    {
        return _errorActivatedKey;
    }
    public function set errorActivatedKey(value:Boolean):void
    {
        _errorActivatedKey = value;
        invalidateSkinState();
    }
    public function get working():Boolean
    {
        return _working;
    }
    public function set working(value:Boolean):void
    {
        _working = value;
        invalidateSkinState();
    }
      
        
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        if (instance == labelInfo )
        {
            labelInfo.text = StringUtil.substitute(fxgt.gettext("Hello {0} {1}, please set new password :"), loggedUser.firstname, loggedUser.lastname);
            labelInfo.toolTip = fxgt.gettext("minimum allowed length of 6")
        
        }
        if(instance == imageCheck)
        {
            imageCheck.source = IconEnum.getIconByName('ScreenShot80x60');
        }
        if(instance == labelCheck)
        {
            labelCheck.text = fxgt.gettext('Will check activated key, please wait ...');
        }
        if(instance == lebelErrorActivatedKey)
        {
            lebelErrorActivatedKey.text = fxgt.gettext('Invalid activated key, connect to admin ');
        }
        if(instance == submitButton)
        {
            submitButton.label = fxgt.gettext('submit');
            submitButton.addEventListener(MouseEvent.CLICK, onValidatePassword);
        }
        if(instance == passwordText)
        {
            passValidator.source = passwordText;
            passValidator.property = "text";
            passwordText.addEventListener(FlexEvent.ENTER, onValidatePassword);
        }
        if (instance == labelWorking )
        {
            labelWorking.text = StringUtil.substitute(fxgt.gettext("Thank you {0} , we update you password"), loggedUser.lastname);
        }
    }
    
    override protected function getCurrentSkinState():String
    {
        var result:String = "checkActivatedKey";  
        if(activated)
        {
            result = "activated" ;
        }else 
            if(errorActivatedKey)
            {
                result = "errorActivatedKey" ;
            }else
                if(working)
                {
                    result = "working";
                }
        return result;
    }
    //_____________________________________________________________________
    //
    // Listeners
    //
    //_____________________________________________________________________
    /**
     * 
     * Validate user inputs  
     * and display error message accordingly
     * 
     */
    private function onValidatePassword(event:Event):void
    {
        var result:Array = Validator.validateAll( [passValidator])
        if (result.length == 0)
        {
            var loginFormEvent:LoginFormEvent = new LoginFormEvent(LoginFormEvent.SET_PASSWORD);
            loginFormEvent.userId = this.loggedUser.id_user;
            loginFormEvent.password = UtilFunction.getCryptWord(passwordText.text);
            dispatchEvent( loginFormEvent );
            
            // set skin "working"
            activated = false;
            working = true;
        }
    }
    
}
}