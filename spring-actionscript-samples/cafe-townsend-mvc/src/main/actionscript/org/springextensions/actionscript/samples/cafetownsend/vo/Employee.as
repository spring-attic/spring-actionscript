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
package org.springextensions.actionscript.samples.cafetownsend.vo {

	[Bindable]
	public class Employee {

		public var emp_id:uint;
		public var firstname:String;
		public var lastname:String;
		public var email:String;
		public var startdate:Date;

		static public var currentIndex:uint = 1000;

		public function Employee(emp_id:uint = 0, firstname:String = "", lastname:String = "", email:String = "", startdate:Date = null) {
			this.emp_id = (emp_id == 0) ? currentIndex += 1 : emp_id;
			this.firstname = firstname;
			this.lastname = lastname;
			this.email = email;
			this.startdate = (startdate == null) ? new Date() : startdate;
		}
	}
}