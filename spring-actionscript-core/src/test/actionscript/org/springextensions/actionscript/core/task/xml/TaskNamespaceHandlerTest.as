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
package org.springextensions.actionscript.core.task.xml {

	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;
	import org.springextensions.actionscript.core.task.support.Task;
	import org.springextensions.actionscript.test.SASTestCase;

	public class TaskNamespaceHandlerTest extends SASTestCase {

		private var _context:FlexXMLApplicationContext = null;

		public function TaskNamespaceHandlerTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_context = new FlexXMLApplicationContext("context-with-task.xml");
		}

		override public function tearDown():void {
			super.tearDown();
			_context.dispose();
			_context = null;
		}

		public function testLoadTask():void {
			_context.addConfigLocation("context-with-task.xml");
			_context.addNamespaceHandler(new TaskNamespaceHandler());
			_context.addEventListener(Event.COMPLETE, addAsync(onTestLoadTaskComplete, 1000));
			_context.load();
		}

		public function onTestLoadTaskComplete(event:Event):void {
			var t:Task = _context.getObject("testTask");
			assertNotNull(t);
			t.addCompleteListener(addAsync(onTaskComplete, 10000));
			t.execute();
		}

		public function onTaskComplete(event:Event):void {
			assertTrue(true);
		}

	}
}