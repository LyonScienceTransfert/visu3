package com.ithaca.visu.bootstrap
{

import com.ithaca.visu.events.AuthenticationEvent;
import com.ithaca.visu.modules.ModuleInfo;
import com.ithaca.visu.model.Model;
import com.ithaca.visu.model.ServerInfo;
import com.ithaca.visu.model.User;
import com.ithaca.visu.model.vo.ProfileDescriptionVO;
import com.ithaca.visu.model.vo.UserVO;

import flash.events.IEventDispatcher;

import mx.core.FlexGlobals;
import mx.logging.ILogger;
import mx.logging.Log;

public class BootStrapManager
{
	protected static var log:ILogger = Log.getLogger("com.ithaca.visu.bootstrap.BootStrapManager");
	protected var dispatcher:IEventDispatcher;
	protected var serverInfo:ServerInfo;
	
	[Bindable] public var user:User;
	
	[Bindable] public var model:Model;
	
	public function BootStrapManager(dispatcher:IEventDispatcher)
	{
		this.dispatcher = dispatcher;
		serverInfo = new ServerInfo(FlexGlobals.topLevelApplication.url) ;
	}
	 
	public function onSetLoggedUser(uservo:UserVO, listModules:Array, listSessionToday:Array, profiles:Array):void
	{
		user = new User(uservo);
		log.info('onLogin [ \nuser:' + user +"\nmodules:"+listModules+"\nsession:"+listSessionToday+"\nprofiles:"+profiles+'\n]');
		model.setLoggedUser(uservo);
		model.profiles = profiles;
	}
	
	 
	public function getAmfGateway():String
	{
		return serverInfo.amfGateway;
	}
	public function getRtmpServer():String
	{
		return serverInfo.rtmpServer;
	}
	
	
}
}
