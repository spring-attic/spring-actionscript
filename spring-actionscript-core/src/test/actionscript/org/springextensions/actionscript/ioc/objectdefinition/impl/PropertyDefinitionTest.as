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
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyDefinitionTest {

		/**
		 * Creates a new <code>PropertyDefinitionTest</code> instance.
		 */
		public function PropertyDefinitionTest() {
			super();
		}

		[Test]
		public function testConstructor():void {
			var pd:PropertyDefinition = new PropertyDefinition("name", "test", "namespace", true);
			assertEquals("name", pd.name);
			assertEquals("test", pd.valueDefinition.value);
			assertEquals("namespace", pd.namespaceURI);
			assertTrue(pd.isStatic);
		}

		[Test]
		public function testClone():void {
			var pd:PropertyDefinition = new PropertyDefinition("name", "test", "namespace", true);
			var clone:PropertyDefinition = pd.clone();
			assertEquals(pd.name, clone.name);
			assertEquals(pd.valueDefinition.value, clone.valueDefinition.value);
			assertEquals(pd.namespaceURI, clone.namespaceURI);
			assertEquals(pd.isStatic, clone.isStatic);
		}
	}
}
