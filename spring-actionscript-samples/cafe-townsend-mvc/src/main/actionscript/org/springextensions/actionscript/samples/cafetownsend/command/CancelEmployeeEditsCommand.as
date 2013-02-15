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
	import org.springextensions.actionscript.samples.cafetownsend.control.CancelEmployeeEditsEvent;
	import org.springextensions.actionscript.samples.cafetownsend.model.AppModelLocator;

	[Command(eventType="cancelEmployeeEdits")]
	public class CancelEmployeeEditsCommand extends CommandBase {

		public function execute(cgEvent:CancelEmployeeEditsEvent):void {
			// decided we don't need to store the edited employee details,
			// so null out the temp employee in the model locators
			model.employeeTemp = null;

			// main viewstack selectedIndex is bound to this model locator value
			// so this now switches the view from the detail screen back to the employee list
			model.viewing = AppModelLocator.EMPLOYEE_LIST;
		}
	}
}