package com.ithaca.messagerie
{
import spark.components.Button;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;

public class MessagerieView extends SkinnableComponent
{

    [SkinPart("true")]
    public var tabNavigatorMessagerie:TabNavigatorMessagerie;
    [SkinPart("true")]
    public var addUser:Button;
    [SkinPart("true")]
    public var messageToSend:TextInput;
    [SkinPart("true")]
    public var sendMessage:Button;
    
    
    
    public function MessagerieView()
    {
        super();
    }
}
}