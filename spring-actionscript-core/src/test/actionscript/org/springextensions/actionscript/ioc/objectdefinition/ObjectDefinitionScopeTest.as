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
	public class ObjectDefinitionScopeTest {

		/**
		 * Creates a new <code>ObjectDefinitionScopeTest</code> instance.
		 */
		public function ObjectDefinitionScopeTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalStateError")]
		public function testConstructorError():void {
			new ObjectDefinitionScope("test");
		}

		[Test]
		public function testFromName():void {
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName("prototype"));
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName("prototype "));
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName(" prototype "));
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName("PROTOTYPE"));
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName("PROTOTYPE "));
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName(" PROTOTYPE "));

			assertStrictlyEquals(ObjectDefinitionScope.SINGLETON, ObjectDefinitionScope.fromName("singleton"));
			assertStrictlyEquals(ObjectDefinitionScope.STAGE, ObjectDefinitionScope.fromName("stage"));
			assertStrictlyEquals(ObjectDefinitionScope.REMOTE, ObjectDefinitionScope.fromName("remote"));

			assertNull(ObjectDefinitionScope.fromName("test"));
		}

	}
}
