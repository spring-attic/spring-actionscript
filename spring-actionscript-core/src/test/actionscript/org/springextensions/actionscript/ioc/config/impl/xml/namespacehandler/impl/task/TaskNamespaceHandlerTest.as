/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task {

	import flash.events.Event;

	import org.as3commons.async.task.impl.Task;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.impl.xml.XMLApplicationContext;

	public class TaskNamespaceHandlerTest {

		private var _context:XMLApplicationContext = null;

		public function TaskNamespaceHandlerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_context = new XMLApplicationContext("context-with-task.xml");
		}

		[After]
		public function tearDown():void {
			_context.dispose();
			_context = null;
		}

		[Test(async, timeout="1000")]
		public function testLoadTask():void {
			_context.addNamespaceHandler(new TaskNamespaceHandler());
			_context.addEventListener(Event.COMPLETE, onTestLoadTaskComplete);
			_context.load();
		}

		public function onTestLoadTaskComplete(event:Event):void {
			var t:Task = _context.getObject("testTask");
			assertNotNull(t);
			t.addCompleteListener(onTaskComplete);
			t.execute();
		}

		public function onTaskComplete(event:Event):void {
			assertTrue(true);
		}

	}
}
