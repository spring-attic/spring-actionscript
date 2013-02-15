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
package org.springextensions.actionscript.core.operation {

	import flexunit.framework.TestCase;

	public class OperationHandlerTest extends TestCase {

		private var _operationHandler:OperationHandler;
		private var _dummyStub:Object;

		public function OperationHandlerTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_operationHandler = new OperationHandler(defaultErrorhandler);
			_dummyStub = {};
		}

		public function testHandleOperationWithResultMethod():void {
			var op:IOperation = new MockOperation(null, 500);
			_operationHandler.handleOperation(op, testResult);
			op.addCompleteListener(addAsync(testResult, 1000));
		}

		public function testHandleOperationWithObjectAndProperty():void {
			var op:IOperation = new MockOperation("testvalue", 500);
			_operationHandler.handleOperation(op, null, _dummyStub, "test");
			op.addCompleteListener(addAsync(function(result:*):void {
				assertEquals("testvalue", _dummyStub.test);
			}, 1000));
		}

		public function testHandleOperationWithObjectPropertyAndResultMethod():void {
			var op:IOperation = new MockOperation("testvalue", 500);
			_operationHandler.handleOperation(op, treatResult, _dummyStub, "test");
			op.addCompleteListener(addAsync(function(result:*):void {
				assertEquals("testvalueExtra", _dummyStub.test);
			}, 1000));
		}

		public function testHandleOperationWithDefaultErrorMethod():void {
			var op:IOperation = new MockOperation(null, 500, true);
			_operationHandler.handleOperation(op, testResult);
			op.addErrorListener(addAsync(defaultErrorhandler, 1000));
		}

		public function testHandleOperationWithCustomErrorMethod():void {
			var op:IOperation = new MockOperation(null, 500, true);
			_operationHandler.handleOperation(op, testResult, null, null, customErrorhandler);
			op.addErrorListener(addAsync(customErrorhandler, 1000));
		}

		public function customErrorhandler(result:* = null):void {
			assertTrue(true);
		}

		public function defaultErrorhandler(result:* = null):void {
			assertTrue(true);
		}

		public function treatResult(result:String):String {
			return result + 'Extra';
		}

		public function testResult(result:* = null):void {
			assertTrue(true);
		}
	}
}