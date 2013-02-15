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

	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	import org.springextensions.actionscript.samples.cafetownsend.business.LoadEmployeesDelegate;
	import org.springextensions.actionscript.samples.cafetownsend.control.LoadEmployeesEvent;

	[Command(eventType="loadEmployees")]
	public class LoadEmployeesCommand extends CommandBase implements IResponder {

		public function execute(cgEvent:LoadEmployeesEvent):void {
			// create a worker who will go get some data
			// pass it a reference to this command so the delegate knows where to return the data
			var delegate:LoadEmployeesDelegate = new LoadEmployeesDelegate(this);
			// make the delegate do some work
			delegate.loadEmployeesService();
		}

		// this is called when the delegate receives a result from the service
		public function result(rpcEvent:Object):void {
			// populate the employee list in the model locator with the results from the service call
			model.employeeListDP = ArrayCollection(rpcEvent.result);
		}

		// this is called when the delegate receives a fault from the service
		public function fault(rpcEvent:Object):void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			model.errorStatus = "Fault occured in LoadEmployeesCommand.";
		}
	}
}