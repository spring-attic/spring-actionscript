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
package org.springextensions.actionscript.core.task {
	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.core.command.MockAsyncCommand;
	import org.springextensions.actionscript.core.operation.MockOperation;
	import org.springextensions.actionscript.core.task.event.TaskEvent;
	import org.springextensions.actionscript.core.task.support.CountProvider;
	import org.springextensions.actionscript.core.task.support.FunctionConditionProvider;
	import org.springextensions.actionscript.core.task.support.FunctionCountProvider;
	import org.springextensions.actionscript.core.task.support.Task;

	public class TaskTest extends TestCase {

		private var _counter:uint = 0;

		public function TaskTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_counter = 0;
		}

		private function incCounter():void {
			_counter++;
		}

		public function testAnd():void {
			var task:Task = new Task();
			task.and(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 1));
			task.execute();
		}

		public function testMultipleAnd():void {
			var task:Task = new Task();
			task.and(new MockAsyncCommand(false, 1, incCounter)).and(new MockAsyncCommand(false, 1, incCounter)).and(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 3));
			task.execute();
		}

		public function testNext():void {
			var task:Task = new Task();
			task.next(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 1));
			task.execute();
		}

		public function testMultipleNext():void {
			var task:Task = new Task();
			task.next(new MockAsyncCommand(false, 1, incCounter)).next(new MockAsyncCommand(false, 1, incCounter)).next(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 3));
			task.execute();
		}

		public function testAndWithOperation():void {
			var task:Task = new Task();
			task.and(MockOperation, null, 1, false, incCounter);
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 1));
			task.execute();
		}

		public function testMultipleNextAnd():void {
			var task:Task = new Task();
			task.next(new MockAsyncCommand(false, 1, incCounter)).next(new MockAsyncCommand(false, 1, incCounter)).and(new MockAsyncCommand(false, 1, incCounter)).and(new MockAsyncCommand(false, 1, incCounter)).next(new MockAsyncCommand(false, 1, incCounter)).next(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 6));
			task.execute();
		}

		public function testIfWithFalse():void {
			var task:Task = new Task();
			task.next(new MockAsyncCommand(false, 1, incCounter)).if_(new FunctionConditionProvider(function():Boolean {
				return false;
			})).next(new MockAsyncCommand(false, 1, incCounter)).end().next(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 2));
			task.execute();
		}

		public function testIfWithTrue():void {
			var task:Task = new Task();
			task.next(new MockAsyncCommand(false, 1, incCounter)).if_(new FunctionConditionProvider(function():Boolean {
				return true;
			})).next(new MockAsyncCommand(false, 1, incCounter)).end().next(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 3));
			task.execute();
		}

		public function countCounter():Boolean {
			return (_counter < 5);
		}

		public function testWhile():void {
			var task:Task = new Task();
			task.while_(new FunctionConditionProvider(countCounter)).next(new MockAsyncCommand(false, 1, incCounter)).end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 5));
			task.execute();
		}

		public function testFor():void {
			var task:Task = new Task();
			task.for_(5).next(new MockAsyncCommand(false, 1, incCounter)).end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 5));
			task.execute();
		}

		public function testForWithCountProvider():void {
			var task:Task = new Task();
			task.for_(0, new CountProvider(5)).next(new MockAsyncCommand(false, 1, incCounter)).end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(onTaskComplete, 1000, 5));
			task.execute();
		}

		private function onTaskComplete(event:Event, counterValue:int):void {
			assertEquals(counterValue, _counter);
		}

	}
}