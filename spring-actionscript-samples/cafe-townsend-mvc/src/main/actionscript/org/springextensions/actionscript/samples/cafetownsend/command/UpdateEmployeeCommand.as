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

	import org.springextensions.actionscript.samples.cafetownsend.control.UpdateEmployeeEvent;
	import org.springextensions.actionscript.samples.cafetownsend.model.AppModelLocator;
	import org.springextensions.actionscript.samples.cafetownsend.vo.Employee;

	[Command(eventType="updateEmployee")]
	public class UpdateEmployeeCommand extends CommandBase {

		public function execute( cgEvent : UpdateEmployeeEvent ) : void {
			// cast the caringorm event so we can get at the selectedItem values sent from the mx:List
			var selectedItem : Object = cgEvent.selectedItem;
			
			// populate a temp employee in the model locator with the details from the selectedItem
			model.employeeTemp = new Employee(	selectedItem.emp_id,
												selectedItem.firstname,
												selectedItem.lastname,
												selectedItem.email,
												new Date(Date.parse(selectedItem.startdate)) );

			// main viewstack selectedIndex is bound to this model locator value
			// so this now switches the view from the employee list to the detail screen
			model.viewing = AppModelLocator.EMPLOYEE_DETAIL;
			}
		}
	}