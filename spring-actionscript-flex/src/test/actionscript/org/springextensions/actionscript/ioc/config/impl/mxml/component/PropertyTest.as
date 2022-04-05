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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyTest {
		private var _property:Property;

		public function PropertyTest() {
			super()
		}

		[Before]
		public function setUp():void {
			_property = new Property();
		}

		[Test]
		public function testName():void {
			_property.name = "testName";
			var propertyDefiniton:PropertyDefinition = _property.toPropertyDefinition();
			assertEquals("testName", propertyDefiniton.name);
		}

		[Test]
		public function testNamespaceURI():void {
			_property.namespaceURI = "testNamespace";
			var propertyDefiniton:PropertyDefinition = _property.toPropertyDefinition();
			assertEquals("testNamespace", propertyDefiniton.namespaceURI);
		}

		[Test]
		public function testValue():void {
			_property.value = "testValue";
			var propertyDefiniton:PropertyDefinition = _property.toPropertyDefinition();
			assertEquals("testValue", propertyDefiniton.valueDefinition.value);
		}

	}
}
