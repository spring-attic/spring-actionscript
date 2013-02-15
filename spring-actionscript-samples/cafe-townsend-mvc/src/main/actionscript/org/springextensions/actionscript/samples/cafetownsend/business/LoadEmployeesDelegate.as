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
package org.springextensions.actionscript.samples.cafetownsend.business {

	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.springextensions.actionscript.samples.cafetownsend.vo.Employee;

	public class LoadEmployeesDelegate {

		private var command:IResponder;

		public function LoadEmployeesDelegate(command:IResponder) {
			// constructor will store a reference to the service we're going to call
			// and store a reference to the command that created this delegate
			this.command = command;
		}

		public function loadEmployeesService():void {
			// call the service
			var employeeIndex:int = 1;
			var employees:ArrayCollection = new ArrayCollection();
			employees.addItem(new Employee(employeeIndex++, "Sue", "Hove", "shove@cafetownsend.com", new Date(2006, 7, 1)));
			employees.addItem(new Employee(employeeIndex++, "Matt", "Boles", "mboles@cafetownsend.com", new Date(2007, 3, 13)));
			employees.addItem(new Employee(employeeIndex++, "Mike", "Kollen", "mkollen@cafetownsend.com", new Date(2006, 11, 19)));
			employees.addItem(new Employee(employeeIndex++, "Jennifer", "Jaegel", "jjaegel@cafetownsend.com", new Date(2003, 1, 27)));
			command.result(new ResultEvent("result",false, true,employees));
		}
	}
}