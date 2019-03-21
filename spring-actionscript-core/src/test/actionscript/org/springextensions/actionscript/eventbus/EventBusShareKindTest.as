/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.eventbus {
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventBusShareKindTest {

		/**
		 * Creates a new <code>EventBusShareKindTest</code> instance.
		 */
		public function EventBusShareKindTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalStateError")]
		public function testConstructorError():void {
			new EventBusShareKind("test");
		}

		[Test]
		public function testFromValue():void {
			var testKind:EventBusShareKind;

			testKind = EventBusShareKind.fromValue("AssignParentEventus");
			assertStrictlyEquals(EventBusShareKind.ASSIGN_PARENT_EVENTBUS, testKind);

			testKind = EventBusShareKind.fromValue("ListenBothWays");
			assertStrictlyEquals(EventBusShareKind.BOTH_WAYS, testKind);

			testKind = EventBusShareKind.fromValue("ChildListensToParent");
			assertStrictlyEquals(EventBusShareKind.CHILD_LISTENS_TO_PARENT, testKind);

			testKind = EventBusShareKind.fromValue("ShareNothing");
			assertStrictlyEquals(EventBusShareKind.NONE, testKind);

			testKind = EventBusShareKind.fromValue("ParentListensToChild");
			assertStrictlyEquals(EventBusShareKind.PARENT_LISTENS_TO_CHILD, testKind);

			testKind = EventBusShareKind.fromValue("Unknown");
			assertNull(testKind);
		}
	}
}
