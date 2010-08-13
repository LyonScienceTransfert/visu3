package com.ithaca.visu.controls.login
{
	import com.ithaca.visu.controls.login.event.LoginEvent;
	import com.lyon2.visu.model.Model;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.validators.EmailValidator;
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	import ws.tink.spark.containers.FormItem;

	[SkinState("pending")]
	[SkinState("normal")]
	[SkinState("disabled")]
	
	[Event(name="onLogin", type="com.ithaca.visu.controls.login.event.LoginEvent")]
	[Event(name="getPassword", type="com.ithaca.visu.controls.login.event.LoginEvent")]
	public class LoginForm extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var loginField:TextInput;
		
		[SkinPart("true")]
		public var passField:TextInput;
		
		[SkinPart("false")]
		public var loginFormItem:FormItem;
		
		[SkinPart("false")]
		public var passFormItem:FormItem;
		
		[SkinPart("true")]
		public var submit:Button;
		
		[SkinPart("false")]
		public var info:TextBase;
		
		[SkinPart("false")]
		public var forgottenButton:Button;
		
		protected var loginValidator:StringValidator;
		protected var passValidator:StringValidator;
		
		
		public function LoginForm()
		{
			loginValidator = new StringValidator();
			loginValidator.required = true;
			
			passValidator = new StringValidator();
			passValidator.required = true;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == loginField )
			{
				loginField.addEventListener(FlexEvent.ENTER, validateLogin);
				loginValidator.source = loginField;
				loginValidator.property = "text";
			}
			else if (instance == loginFormItem )
			{
				loginFormItem.label="login";
			}
			else if (instance == passField)
			{
				passField.displayAsPassword = true;
				passValidator.source = passField;
				passValidator.property = "text";
				passField.addEventListener(FlexEvent.ENTER, validateLogin);
			}
			else if (instance == passFormItem)
			{
				passFormItem.label = "password";
			}
			else if (instance == submit)
			{
				submit.addEventListener(MouseEvent.CLICK, validateLogin);
				submit.label = "Submit";
			}
			else if (instance == forgottenButton)
			{
				forgottenButton.label = "I've forgotten my passord";
				forgottenButton.addEventListener(MouseEvent.CLICK, getPassword);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if (instance == loginField )
			{
				loginField.removeEventListener(FlexEvent.ENTER, validateLogin);
				loginValidator.source = null;
			}
			else if (instance == passField)
			{
				passValidator.source = null;
				passField.removeEventListener(FlexEvent.ENTER, validateLogin);
			}
			else if (instance == submit)
			{
				submit.removeEventListener(MouseEvent.CLICK, validateLogin);
			}
			else if (instance == forgottenButton)
			{
				
			}
		}
		/**
		 * 
		 * Validate user inputs  
		 * and display error message accordingly
		 * 
		 */
		protected function validateLogin(MouseEvent:Event):void
		{
			var result:Array = Validator.validateAll( [loginValidator, passValidator])
			if (result.length==0)
			{
				dispatchEvent( new LoginEvent( LoginEvent.LOGIN ) );
			}
			else
			{
				if (info) 
				{
					var validationResult:ValidationResultEvent = result.shift();
					info.text = validationResult.message;
				}
			}
		}
		/**
		 * 
		 * this function verify user input  
		 * and display error message accordingly
		 * 
		 */
		protected function getPassword(MouseEvent:Event):void
		{
			dispatchEvent( new LoginEvent( LoginEvent.GET_PASSWORD ) );
		}	
	}
}