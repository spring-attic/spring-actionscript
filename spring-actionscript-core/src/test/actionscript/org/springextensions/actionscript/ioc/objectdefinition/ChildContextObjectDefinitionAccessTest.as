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
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ChildContextObjectDefinitionAccessTest {

		/**
		 * Creates a new <code>ChildContextObjectDefinitionAccessTest</code> instance.
		 */
		public function ChildContextObjectDefinitionAccessTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalStateError")]
		public function testConstructorError():void {
			new ChildContextObjectDefinitionAccess("none");
		}

		[Test]
		public function testFromValue():void {
			var testMode:ChildContextObjectDefinitionAccess;

			testMode = ChildContextObjectDefinitionAccess.fromValue("none");
			assertStrictlyEquals(ChildContextObjectDefinitionAccess.NONE, testMode);

			testMode = ChildContextObjectDefinitionAccess.fromValue("definition");
			assertStrictlyEquals(ChildContextObjectDefinitionAccess.DEFINITION, testMode);

			testMode = ChildContextObjectDefinitionAccess.fromValue("singleton");
			assertStrictlyEquals(ChildContextObjectDefinitionAccess.SINGLETON, testMode);

			testMode = ChildContextObjectDefinitionAccess.fromValue("full");
			assertStrictlyEquals(ChildContextObjectDefinitionAccess.FULL, testMode);

			testMode = ChildContextObjectDefinitionAccess.fromValue("unknown");
			assertStrictlyEquals(ChildContextObjectDefinitionAccess.FULL, testMode);
		}

	}
}
