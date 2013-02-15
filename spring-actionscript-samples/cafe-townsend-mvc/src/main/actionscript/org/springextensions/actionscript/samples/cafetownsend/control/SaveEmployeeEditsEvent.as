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
package org.springextensions.actionscript.samples.cafetownsend.control {

	import flash.events.Event;

	public class SaveEmployeeEditsEvent extends Event {

		public static const SAVE_EMPLOYEE_EDITS_EVENT:String = "saveEmployeeEdits";
		
		public var emp_id:Number;
		public var firstname:String;
		public var lastname:String;
		public var startdate:Date;
		public var email:String;

		public function SaveEmployeeEditsEvent(emp_id:Number, firstname:String, lastname:String, startdate:Date, email:String) {
			super(SAVE_EMPLOYEE_EDITS_EVENT);
			this.emp_id = emp_id;
			this.firstname = firstname;
			this.lastname = lastname;
			this.startdate = startdate;
			this.email = email;
		}
	}
}