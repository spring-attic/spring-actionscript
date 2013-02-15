/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.core.command {

	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.core.operation.OperationEvent;

	/**
	 * @author Roland Zwaga
	 * @author Christophe Herreman
	 */
	public class CompositeCommandTest extends TestCase {

		public static var asyncCounter:uint = 0;

		public function CompositeCommandTest() {
			super();
		}

		override public function setUp():void {
			asyncCounter = 0;
		}

		public function testAddCommand():void {
			var cc:CompositeCommand = new CompositeCommand();
			assertEquals(0, cc.numCommands);
			cc.addCommand(new MockAsyncCommand());
			assertEquals(1, cc.numCommands);
		}

		public function testExecuteSingleCommand():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockCommand());
			cc.execute();
			assertEquals(1, asyncCounter);
		}

		public function testExecuteMultipleCommands():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockCommand());
			cc.addCommand(createMockCommand());
			cc.addCommand(createMockCommand());
			cc.execute();
			assertEquals(3, asyncCounter);
		}

		public function testExecuteSingleAsyncCommand():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockAsyncCommand());
			executeAndAssertNumberOfExecutedCommandsEquals(cc, 1);
		}

		public function testExecuteMultipleAsyncCommands():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockAsyncCommand());
			cc.addCommand(createMockAsyncCommand());
			cc.addCommand(createMockAsyncCommand());
			executeAndAssertNumberOfExecutedCommandsEquals(cc, 3);
		}

		public function testExecuteMixedCommands():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockAsyncCommand());
			cc.addCommand(createMockCommand());
			cc.addCommand(createMockAsyncCommand());
			executeAndAssertNumberOfExecutedCommandsEquals(cc, 3);
		}

		public function testExecuteCommandEvent():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addProgressListener(compositeCommand_progressHandler, false, 0, true);

			cc.addCommand(createMockCommand());
			cc.addCommand(createMockCommand());
			cc.addCommand(createMockCommand());

			executeAndAssertNumberOfExecutedCommandsEquals(cc, 6);
		}

		public function testCompleteEvent():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockCommand());
			cc.addCommand(createMockCommand());
			cc.addCommand(createMockCommand());

			var onCompositeCommandComplete:Function = function(event:OperationEvent):void {
				assertEquals(3, asyncCounter);
				assertEquals(OperationEvent.COMPLETE, event.type);
			};

			cc.addCompleteListener(addAsync(onCompositeCommandComplete, 1000), false, 0, true);
			cc.execute();
		}

		public function testErrorEvent():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockAsyncCommand(true));

			var onCompositeCommandError:Function = function(event:OperationEvent):void {
				assertEquals(0, asyncCounter);
				assertEquals(OperationEvent.ERROR, event.type);
			};

			cc.addErrorListener(addAsync(onCompositeCommandError, 1000), false, 0, true);
			cc.execute();
		}

		public function testFailOnFaultFalse():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.addCommand(createMockAsyncCommand());
			cc.addCommand(createMockAsyncCommand(true));
			cc.addCommand(createMockAsyncCommand());
			executeAndAssertNumberOfExecutedCommandsEquals(cc, 2);
		}

		public function testFailOnFaultTrue():void {
			var cc:CompositeCommand = new CompositeCommand();
			cc.failOnFault = true;
			cc.addCommand(createMockAsyncCommand());
			cc.addCommand(createMockAsyncCommand(true));
			cc.addCommand(createMockAsyncCommand());

			var errorHandler:Function = function(event:Event, numExpectedExecutions:uint):void {
				assertEquals(numExpectedExecutions, asyncCounter);
			};
			cc.addErrorListener(addAsync(errorHandler, 1000, 1), false, 0, true);
			cc.execute();
		}

		// --------------------------------------------------------------------
		//
		// Assertions
		//
		// --------------------------------------------------------------------

		private function executeAndAssertNumberOfExecutedCommandsEquals(command:ICompositeCommand, numExpectedExecutions:uint):void {
			var completeHandler:Function = function(event:Event, numExpectedExecutions:uint):void {
				assertEquals(numExpectedExecutions, asyncCounter);
			};
			command.addCompleteListener(addAsync(completeHandler, 1000, numExpectedExecutions), false, 0, true);
			command.execute();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function createMockCommand():ICommand {
			return new MockCommand();
		}

		private function createMockAsyncCommand(fail:Boolean = false):ICommand {
			var command:MockAsyncCommand = new MockAsyncCommand(fail);
			command.addCompleteListener(compositeCommand_completeHandler);
			command.addErrorListener(compositeCommand_errorHandler);
			return command;
		}

		private function compositeCommand_completeHandler(event:OperationEvent):void {
			asyncCounter++;
		}

		private function compositeCommand_errorHandler(event:OperationEvent):void {

		}

		private function compositeCommand_progressHandler(event:OperationEvent):void {
			asyncCounter++;
		}

	}
}

import org.springextensions.actionscript.core.command.CompositeCommandTest;
import org.springextensions.actionscript.core.command.ICommand;

class MockCommand implements ICommand {

	private var _result:uint = 0;
	public function get result():uint {
		return _result;
	}

	public function MockCommand() {
		super();
	}

	public function execute():* {
		_result = 1;
		CompositeCommandTest.asyncCounter++;
	}

}
