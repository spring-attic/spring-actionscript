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

	import org.springextensions.actionscript.samples.cafetownsend.control.SaveEmployeeEditsEvent;
	import org.springextensions.actionscript.samples.cafetownsend.model.AppModelLocator;

	[Command(eventType="saveEmployeeEdits")]
	public class SaveEmployeeEditsCommand extends CommandBase {

		public function execute(cgEvent:SaveEmployeeEditsEvent):void {
			model.employeeTemp.emp_id = cgEvent.emp_id;
			model.employeeTemp.firstname = cgEvent.firstname;
			model.employeeTemp.lastname = cgEvent.lastname;
			model.employeeTemp.startdate = cgEvent.startdate;
			model.employeeTemp.email = cgEvent.email;

			// assume the edited fields are not an existing employee, but a new employee
			// and set the ArrayCollection index to -1, which means this employee is not in our existing
			// employee list anywhere
			var dpIndex:int = -1;

			// loop thru the employee list
			for (var i:uint = 0; i < model.employeeListDP.length; i++) {
				// if the emp_id of the incoming employee matches an employee already in the list
				if (model.employeeListDP[i].emp_id == model.employeeTemp.emp_id) {
					// set our ArrayCollection index to that employee position
					dpIndex = i;
				}
			}

			// if it was an existing employee already in the ArrayCollection
			if (dpIndex >= 0) {
				// update that employee's values
				model.employeeListDP.setItemAt(model.employeeTemp, dpIndex);
			}
			// otherwise, if it didn't match any existing employees
			else {
				// add the temp employee to the ArrayCollection
				model.employeeListDP.addItem(model.employeeTemp);
			}

			// now that we've trasferred the temp employee to the array we can clear out the temp employee
			model.employeeTemp = null;

			// main viewstack selectedIndex is bound to this model locator value
			// so this now switches the view from the detail screen back to the employee list
			// the employee list should now contain one more item
			model.viewing = AppModelLocator.EMPLOYEE_LIST;
		}
	}
}