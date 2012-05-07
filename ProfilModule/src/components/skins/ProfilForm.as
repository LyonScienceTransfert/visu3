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