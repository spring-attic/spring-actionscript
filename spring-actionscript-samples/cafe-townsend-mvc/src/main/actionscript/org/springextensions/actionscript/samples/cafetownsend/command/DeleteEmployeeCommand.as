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

	import org.springextensions.actionscript.samples.cafetownsend.control.DeleteEmployeeEvent;
	import org.springextensions.actionscript.samples.cafetownsend.model.AppModelLocator;

	[Command(eventType="deleteEmployee")]
	public class DeleteEmployeeCommand extends CommandBase {

		public function execute( cgEvent : DeleteEmployeeEvent ) : void {
			// loop thru the employee list in the model locator
			for ( var i : uint = 0; i < model.employeeListDP.length; i++ ) {
				// if the emp_id stored in the temp employee matches one of the emp_id's in the employee list
				if ( model.employeeTemp.emp_id == model.employeeListDP[i].emp_id ) {
					// remove that item from the ArrayCollection
					model.employeeListDP.removeItemAt( i );
					}
				}
				
			// clear out the data stored in the temp employee
			model.employeeTemp = null;
			
			// main viewstack selectedIndex is bound to this model locator value
			// so this now switches the view from the detail screen back to the employee list
			// the list should be one array item shorter
			model.viewing = AppModelLocator.EMPLOYEE_LIST;
			}
		}
	}