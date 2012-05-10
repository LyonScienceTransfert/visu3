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
	import com.ithaca.utils.UtilFunction;
	import com.ithaca.visu.controls.login.event.LoginFormEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;

	[SkinState("pending")]
	[SkinState("normal")]
	[SkinState("disabled")]
	[SkinState("visudev")]
	
	[Event(name="onLogin", type="com.ithaca.visu.controls.login.event.LoginFormEvent")]
	[Event(name="getPassword", type="com.ithaca.visu.controls.login.event.LoginFormEvent")]
	public class LoginForm extends SkinnableComponent
	{
		
		[SkinPart("true")]
		public var loginField:TextInput;
		
		[SkinPart("true")]
		public var passField:TextInput;
		
		[SkinPart("false")]
		public var loginLabel:Label;
		
		[SkinPart("false")]
		public var passLabel:Label;
		
		[SkinPart("true")]
		public var submit:Button;
		
		[SkinPart("false")]
		public var info:TextBase;
		
		[SkinPart("false")]
		public var forgottenButton:Button;
		
		protected var loginValidator:StringValidator;
		protected var passValidator:StringValidator;
		
		private var visudev:Boolean;
		
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
			else if (instance == loginLabel )
			{
                loginLabel.text = "login";
			}
			else if (instance == passField)
			{
				passField.displayAsPassword = true;
				passValidator.source = passField;
				passValidator.property = "text";
				passField.addEventListener(FlexEvent.ENTER, validateLogin);
			}
			else if (instance == passLabel)
			{
                passLabel.text = "password";
			}
			else if (instance == submit)
			{
				submit.addEventListener(MouseEvent.CLICK, validateLogin);
				submit.label = "Submit";
			}
			else if (instance == forgottenButton)
			{
				forgottenButton.label = "I've forgotten my password";
				forgottenButton.enabled = false;		
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
		
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disable" : visudev? "visudev" : "normal";
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
				var loginFormEvent:LoginFormEvent = new LoginFormEvent(LoginFormEvent.LOGIN);
                loginFormEvent.username = loginField.text;
                loginFormEvent.password = UtilFunction.getCryptWord(passField.text);
					
				dispatchEvent( loginFormEvent );
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
			var e:LoginFormEvent = new LoginFormEvent(LoginFormEvent.LOGIN);
			e.username = loginField.text;
			dispatchEvent( new LoginFormEvent( LoginFormEvent.GET_PASSWORD ) );
		}	
		
		public function setSkinVisuDev():void
		{
			visudev = true;
			invalidateSkinState();
		}
	}
}