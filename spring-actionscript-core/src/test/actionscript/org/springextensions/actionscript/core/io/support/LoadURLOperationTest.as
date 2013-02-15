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
package org.springextensions.actionscript.core.io.support {
	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.core.operation.IOperation;

	public class LoadURLOperationTest extends TestCase {

		public function LoadURLOperationTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testNew_shouldDispatchErrorForUnexistingURL():void {
			var operation:IOperation = new LoadURLOperation("no such URL");
			operation.addErrorListener(addAsync(errorHandler, 1000));
		}

		private function errorHandler(event:Event=null):void {
			assertTrue(true);
		}

	}
}
