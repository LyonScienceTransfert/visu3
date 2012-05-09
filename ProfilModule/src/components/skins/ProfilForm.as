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
package components.skins
{
import com.ithaca.utils.UpdatePasswordTitleWindow;
import com.ithaca.utils.VisuUtils;
import com.ithaca.visu.controls.login.event.LoginFormEvent;
import com.ithaca.visu.model.User;

import flash.events.MouseEvent;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.controls.Image;
import mx.managers.PopUpManager;

import spark.components.Button;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class ProfilForm extends SkinnableComponent
{
    
    [Bindable]
    private var fxgt: _FxGettext = FxGettext;
    
    [SkinPart("true")]
    public var userAvatar:Image;
    [SkinPart("true")]
    public var userFirstName:Label;
    [SkinPart("true")]
    public var userLastName:Label;
    [SkinPart("true")]
    public var userMailLoginInfo:Label;
    [SkinPart("true")]
    public var userPassInfo:Label;
    [SkinPart("true")]
    public var userRoleInfo:Label;
    [SkinPart("true")]
    public var userMailLogin:Label;
    [SkinPart("true")]
    public var userRole:Label;
    [SkinPart("true")]
    public var userPassUpdate:Button;
    
    private var _user:User;
    private var userChange:Boolean;
    //_____________________________________________________________________
    //
    // Setter/getter
    //
    //_____________________________________________________________________
    public function set user(value:User):void
    {
        _user = value;
        userChange = true;
        invalidateProperties();
    }
    public function get user():User
    {
        return _user;
    }
    public function ProfilForm()
    {
        super();
        // init internationalisation
        fxgt = FxGettext;
    }
    //_____________________________________________________________________
    //
    // Overriden Methods
    //
    //_____________________________________________________________________
    
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName,instance);
        
        if(instance == userAvatar)
        {
            userAvatar.source = user.avatar;
        }
        if(instance == userFirstName)
        {
            userFirstName.text = user.firstname;
        }
        if(instance == userLastName)
        {
            userLastName.text = user.lastname;
        }
        if(instance == userMailLoginInfo)
        {
            userMailLoginInfo.text = fxgt.gettext("mail / login :");
        }
        if(instance == userPassInfo)
        {
            userPassInfo.text = fxgt.gettext("mot de passe :");
        }
        if(instance == userRoleInfo)
        {
            userRoleInfo.text = fxgt.gettext("rôle :");
        }
        if(instance == userMailLogin)
        {
            userMailLogin.text = user.mail;
        }
        if(instance == userRole)
        {
            userRole.text = VisuUtils.getRoleLabel(user.role);
        }
        if(instance == userPassUpdate)
        {
            userPassUpdate.label = fxgt.gettext("change mot de pass");
            userPassUpdate.addEventListener(MouseEvent.CLICK, onChangePassword);
        }
    }
    //_____________________________________________________________________
    //
    // Listeners
    //
    //_____________________________________________________________________
    private function onChangePassword(event:MouseEvent):void
    {
        /*var upatePasswordTitleWindow:UpdatePasswordTitleWindow = new UpdatePasswordTitleWindow();
        PopUpManager.addPopUp(upatePasswordTitleWindow, this);*/
        
        var upatePasswordTitleWindow:UpdatePasswordTitleWindow = UpdatePasswordTitleWindow(PopUpManager.createPopUp( 
            this, UpdatePasswordTitleWindow , true) as spark.components.TitleWindow);
        PopUpManager.centerPopUp(upatePasswordTitleWindow);
        upatePasswordTitleWindow.addEventListener(LoginFormEvent.PRE_UPDATE_PASSWORD , onPreUpdatePassword);
    }
    private function onPreUpdatePassword(event:LoginFormEvent):void
    {
        var loginFormEvent:LoginFormEvent = new LoginFormEvent(LoginFormEvent.UPDATE_PASSWORD);
        loginFormEvent.password = event.password; 
        dispatchEvent(loginFormEvent); 
    }
}
}