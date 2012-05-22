/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009-2012)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
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