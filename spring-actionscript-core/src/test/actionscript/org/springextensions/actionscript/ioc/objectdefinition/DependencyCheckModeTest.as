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
package org.springextensions.actionscript.ioc.objectdefinition {
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DependencyCheckModeTest {

		/**
		 * Creates a new <code>DependencyCheckModeTest</code> instance.
		 */
		public function DependencyCheckModeTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalStateError")]
		public function testConstructorError():void {
			new DependencyCheckMode("none");
		}

		[Test]
		public function testFromName():void {
			var testMode:DependencyCheckMode;

			testMode = DependencyCheckMode.fromName("none");
			assertStrictlyEquals(DependencyCheckMode.NONE, testMode);

			testMode = DependencyCheckMode.fromName("simple");
			assertStrictlyEquals(DependencyCheckMode.SIMPLE, testMode);

			testMode = DependencyCheckMode.fromName("objects");
			assertStrictlyEquals(DependencyCheckMode.OBJECTS, testMode);

			testMode = DependencyCheckMode.fromName("all");
			assertStrictlyEquals(DependencyCheckMode.ALL, testMode);

			testMode = DependencyCheckMode.fromName(null);
			assertStrictlyEquals(DependencyCheckMode.NONE, testMode);

			testMode = DependencyCheckMode.fromName("unknown");
			assertStrictlyEquals(DependencyCheckMode.NONE, testMode);
		}

		[Test]
		public function testCheckSimpleProperties():void {
			assertTrue(DependencyCheckMode.ALL.checkSimpleProperties());
			assertTrue(DependencyCheckMode.SIMPLE.checkSimpleProperties());
			assertTrue(DependencyCheckMode.NONE.checkSimpleProperties());
			assertFalse(DependencyCheckMode.OBJECTS.checkSimpleProperties());
		}

		[Test]
		public function testCheckObjectProperties():void {
			assertTrue(DependencyCheckMode.ALL.checkObjectProperties());
			assertTrue(DependencyCheckMode.OBJECTS.checkObjectProperties());
			assertTrue(DependencyCheckMode.NONE.checkObjectProperties());
			assertFalse(DependencyCheckMode.SIMPLE.checkObjectProperties());
		}
	}
}
