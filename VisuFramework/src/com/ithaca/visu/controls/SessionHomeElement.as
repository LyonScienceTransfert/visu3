package com.ithaca.visu.controls
{
	import com.ithaca.visu.dataStrutures.UserSwapList;
	import com.ithaca.visu.renderer.ConnectedUserListRenderer;
	import com.ithaca.visu.renderer.ConnectedUserRenderer;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.lyon2.utils.TimeUtils;
	import com.lyon2.visu.model.Session;
	import com.lyon2.visu.model.User;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.controls.Button;
	import mx.core.ClassFactory;
	import mx.events.StateChangeEvent;
	import mx.formatters.DateFormatter;
	import mx.graphics.shaderClasses.HueShader;
	import mx.states.OverrideBase;
	
	import spark.components.DataGroup;
	import spark.components.RichText;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	import spark.utils.TextFlowUtil;
	import com.ithaca.visu.renderer.ConnectedUserWithListRenderer;
	
	[SkinState("normal")]
	[SkinState("open")]
	[SkinState("disabled")]
	
	public class SessionHomeElement extends SkinnableComponent
	{
		[SkinPart("true")]
		public var openButton:ButtonBase;
		
		[SkinPart("true")]
		public var hourDisplay:TextBase;
		
		[SkinPart("true")]
		public var titleDisplay:TextBase;

		[SkinPart("true")]
		public var subDisplay:RichText;
		
		[SkinPart("true")]
		public var users:DataGroup;
		
		[SkinPart("false")]
		public var connectButton:ButtonBase;
		
		[SkinPart("false")]
		public var editButton:ButtonBase;
		
		public var editable:Boolean
		
		protected var open:Boolean;
		
		private var _session:Session;
		private var sessionChanged:Boolean;
		public function get session():Session
		{
			return _session;
		}
		public function set session(value:Session):void
		{
			sessionChanged = true;
			_session = value;
			invalidateProperties();
		}
		
		
		private var _swapItems:IList;
		private var swapItemsChanged:Boolean;
		public function get swapItems():IList
		{
			return _swapItems;
		}
		public function set swapItems(value:IList):void
		{
			swapItemsChanged = true;
			_swapItems = value;
			invalidateProperties();
		}
		
		
		
		private var hourformater:DateFormatter; 
		
		public function SessionHomeElement()
		{
			super();
			hourformater=new DateFormatter();
			hourformater.formatString = "HH:MM";
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{			 
			if (instance==openButton)
			{
				openButton.addEventListener(MouseEvent.CLICK,openView);
			}
			if (instance==users) 
			{
				users.itemRendererFunction = function(item:Object):ClassFactory
				{
					var className:Class = ConnectedUserRenderer;
					var u:UserSwapList = UserSwapList(item);

					
					
					if( editable && u.user.status != ConnectionStatus.CONNECTED ) 
						className = ConnectedUserWithListRenderer;
					return new ClassFactory( className);
				};
				
				var d:IList = new ArrayList();
				for each( var u:User in _session.participants)
				{
					d.addItem( new UserSwapList( u, _swapItems ) );
				}
				users.dataProvider = d;
			}
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance==openButton)
			{
				openButton.removeEventListener(MouseEvent.CLICK,openView);
			}
			if (instance==users) trace("remove listener");
		}
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : open? "open" : "normal";
		}
		 
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (sessionChanged)
			{
				if (session != null)
				{
					hourDisplay.text = hourformater.format(session.date_session);
					titleDisplay.text = session.theme;
				}
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredHeight 
				= titleDisplay.measuredHeight 
				+ subDisplay.measuredHeight;
			if( users  ) 
			{ 
				//measuredHeight += users.getLayoutBoundsHeight();
				measuredHeight += 150;
			}
			measuredMinHeight = measuredHeight;
		}
		
		
		/**
		 * 
		 * Overriding stateChanged in order to update skinPart Content 
		 * 
		 */
		override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
		{
			super.stateChanged(oldState,newState,recursive);
			switch (newState)
			{
				case "open":
					subDisplay.textFlow = TextFlowUtil.importFromString(remaining_time);
					
					break;
				default:
					subDisplay.textFlow = TextFlowUtil.importFromString( participants );	
					break;
			}
		}
		
		
	 	
		
		/**
		 * 
		 * this function executes when the openButton dispatch a MouseEvent.CLICK 
		 * 
		 */
		protected function openView(event:MouseEvent):void
		{
			open=!open;
			currentState=="normal" ? "open": "normal";
			invalidateSkinState();
		}
		
		
		/* Helper functions */
		
		/**
		 * @return string reprensentation of the remaining time before session start.
		 */ 
		protected function get remaining_time():String
		{
			return "<p textAlign='center'  fontSize='10'>la séance demarre <span fontWeight='bold'>"
					+ TimeUtils.relativeTime(_session.date_session,null,true)
					+"</span></p>";
		}
		 
		
		
		/**
		 * return String a textflow markup string representation of the session participants
		 * (tutor are placed in front, in bold, followed by students 
		 */
		protected function get participants():String
		{
			var a:Array=[];
			for each(var user:User in _session.participants)
			{
				
				if( user.role > 32 )
				{
					a.splice(0,0,'<span fontWeight="bold">'+user.prenom+'</span>') ;
				}
				else
				{
					a.push(user.prenom);
				}
			} 
			return a.join(", ");
		}
		
	}
}