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
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinitionTest {

		private var _definition:ObjectDefinition;

		/**
		 * Creates a new <code>ObjectDefinitionTest</code> instance.
		 */
		public function ObjectDefinitionTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_definition = new ObjectDefinition();
		}

		[Test]
		public function testAddProperty():void {
			assertNull(_definition.properties);
			var propDef:PropertyDefinition = new PropertyDefinition('name', 'value');
			_definition.addPropertyDefinition(propDef);
			assertNotNull(_definition.properties);
			assertEquals(1, _definition.properties.length);
			assertStrictlyEquals(propDef, _definition.properties[0]);
			assertStrictlyEquals(propDef, _definition.getPropertyDefinitionByName('name'));
		}

		[Test]
		public function testAddPropertiesWithSameNameButDifferentNamespace():void {
			assertNull(_definition.properties);
			var propDef:PropertyDefinition = new PropertyDefinition('name', 'value');
			_definition.addPropertyDefinition(propDef);
			var propDef2:PropertyDefinition = new PropertyDefinition('name', 'value', 'http://www.mydomain.com/mynamespace');
			_definition.addPropertyDefinition(propDef2);
			assertNotNull(_definition.properties);
			assertEquals(2, _definition.properties.length);
			assertStrictlyEquals(propDef, _definition.properties[0]);
			assertStrictlyEquals(propDef2, _definition.properties[1]);
			assertStrictlyEquals(propDef, _definition.getPropertyDefinitionByName('name'));
			assertStrictlyEquals(propDef2, _definition.getPropertyDefinitionByName('name', 'http://www.mydomain.com/mynamespace'));
		}

		[Test]
		public function testAddPropertiesWithSameNameAndSameNamespace():void {
			assertNull(_definition.properties);
			var propDef:PropertyDefinition = new PropertyDefinition('name', 'value', 'http://www.mydomain.com/mynamespace');
			_definition.addPropertyDefinition(propDef);
			var propDef2:PropertyDefinition = new PropertyDefinition('name', 'value', 'http://www.mydomain.com/mynamespace');
			_definition.addPropertyDefinition(propDef2);
			assertNotNull(_definition.properties);
			assertEquals(1, _definition.properties.length);
			assertStrictlyEquals(propDef, _definition.properties[0]);
			assertStrictlyEquals(propDef, _definition.getPropertyDefinitionByName('name', 'http://www.mydomain.com/mynamespace'));
		}

		[Test]
		public function testAddMethodInvocation():void {
			assertNull(_definition.methodInvocations);
			var methInvoc:MethodInvocation = new MethodInvocation('name');
			_definition.addMethodInvocation(methInvoc);
			assertNotNull(_definition.methodInvocations);
			assertEquals(1, _definition.methodInvocations.length);
			assertStrictlyEquals(methInvoc, _definition.methodInvocations[0]);
			assertStrictlyEquals(methInvoc, _definition.getMethodInvocationByName('name'));
		}

		[Test]
		public function testAddMethodInvocationsWithSameNameButDifferentNamespace():void {
			assertNull(_definition.properties);
			var methInvoc:MethodInvocation = new MethodInvocation('name');
			_definition.addMethodInvocation(methInvoc);
			var methInvoc2:MethodInvocation = new MethodInvocation('name', null, 'http://www.mydomain.com/mynamespace');
			_definition.addMethodInvocation(methInvoc2);
			assertNotNull(_definition.methodInvocations);
			assertEquals(2, _definition.methodInvocations.length);
			assertStrictlyEquals(methInvoc, _definition.methodInvocations[0]);
			assertStrictlyEquals(methInvoc2, _definition.methodInvocations[1]);
			assertStrictlyEquals(methInvoc, _definition.getMethodInvocationByName('name'));
			assertStrictlyEquals(methInvoc2, _definition.getMethodInvocationByName('name', 'http://www.mydomain.com/mynamespace'));
		}

	}
}
