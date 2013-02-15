/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.samples.cafetownsend.command {

	import mx.controls.Alert;
	
	import org.springextensions.actionscript.samples.cafetownsend.control.LoginEmployeeEvent;
	import org.springextensions.actionscript.samples.cafetownsend.model.AppModelLocator;
	import org.springextensions.actionscript.samples.cafetownsend.vo.User;

	[Command(eventType="loginEmployee")]
	public class LoginEmployeeCommand extends CommandBase {

		public function execute(cgEvent:LoginEmployeeEvent):void {
			// after casting, retreive the username & password payload from the incoming event
			var username:String = cgEvent.username;
			var password:String = cgEvent.password;

			// if the auth info is correct
			if (username == "Flex" && password == "SpringMVC") {
				// store the user info in a new user object in the model locator
				model.user = new User(username, password);

				// main viewstack selectedIndex is bound to this model locator value
				// so this now switches the view from the login screen to the employee list
				model.viewing = AppModelLocator.EMPLOYEE_LIST;
			} else {
				// if the auth info was incorrect, prompt with an alert box and remain on the login screen
				Alert.show("We couldn't validate your username & password. Please try again.", "Login Failed");
			}
		}
	}
}