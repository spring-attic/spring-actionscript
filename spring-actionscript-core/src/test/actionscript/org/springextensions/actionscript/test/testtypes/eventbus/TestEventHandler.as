/*
* Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.test.testtypes.eventbus {
	import flash.events.Event;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class TestEventHandler {
		/**
		 * Creates a new <code>EventHandler</code> instance.
		 */
		public function TestEventHandler() {
			super();
		}

		[Ignore]
		[Test]
		public function testDummy():void {

		}

		public function methodHandler(event:Event):void {

		}

		public var topic:String = "testTopicPropertyValue";
	}
}
