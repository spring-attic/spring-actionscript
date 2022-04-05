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
	import flash.events.Event;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinitionBuilderTest {

		/**
		 * Creates a new <code>ObjectDefinitionBuilderTest</code> instance.
		 */
		public function ObjectDefinitionBuilderTest() {
			super();
		}

		[Test]
		public function testObjectDefinitionBuilder():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionBuilder();
			assertNotNull(builder);
			assertNotNull(builder.objectDefinition);
		}

		[Test]
		public function testObjectDefinitionBuilderForClass():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(Event);
			assertNotNull(builder);
			assertNotNull(builder.objectDefinition);
			assertEquals("flash.events.Event", builder.objectDefinition.className);
		}

		[Test]
		public function testObjectDefinitionBuilderForClassName():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClassName("flash.events.Event");
			assertNotNull(builder);
			assertNotNull(builder.objectDefinition);
			assertEquals("flash.events.Event", builder.objectDefinition.className);
		}

		[Test]
		public function testAddConstructorArgValue():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionBuilder();
			builder.addConstructorArgValue("test");
			assertNotNull(builder.objectDefinition.constructorArguments);
			assertEquals(1, builder.objectDefinition.constructorArguments.length);
			assertEquals("test", builder.objectDefinition.constructorArguments[0].value);
		}

		[Test]
		public function testAddConstructorArgReference():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionBuilder();
			builder.addConstructorArgReference("test");
			assertNotNull(builder.objectDefinition.constructorArguments);
			assertEquals(1, builder.objectDefinition.constructorArguments.length);
			assertNotNull(builder.objectDefinition.constructorArguments[0].ref);
			assertEquals("test", builder.objectDefinition.constructorArguments[0].ref.objectName);
		}

		[Test]
		public function testAddPropertyValue():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionBuilder();
			builder.addPropertyValue("test", "value", "namespace", true);
			assertNotNull(builder.objectDefinition.properties);
			assertEquals(1, builder.objectDefinition.properties.length);
			var propDef:PropertyDefinition = builder.objectDefinition.properties[0];
			assertEquals("test", propDef.name);
			assertEquals("value", propDef.valueDefinition.value);
			assertEquals("namespace", propDef.namespaceURI);
			assertTrue(propDef.isStatic);
		}

		[Test]
		public function testAddPropertyReference():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionBuilder();
			builder.addPropertyReference("test", "testName", "namespace", true);
			assertNotNull(builder.objectDefinition.properties);
			assertEquals(1, builder.objectDefinition.properties.length);
			var propDef:PropertyDefinition = builder.objectDefinition.properties[0];
			assertEquals("test", propDef.name);
			assertNotNull(propDef.valueDefinition.ref);
			assertEquals("testName", propDef.valueDefinition.ref.objectName);
			assertEquals("namespace", propDef.namespaceURI);
			assertTrue(propDef.isStatic);
		}

		[Test]
		public function testAddMethodInvocation():void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionBuilder();
			var args:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();
			builder.addMethodInvocation("test", null, "namespace", args);
			assertNotNull(builder.objectDefinition.methodInvocations);
			assertEquals(1, builder.objectDefinition.methodInvocations.length);
			assertEquals("test", builder.objectDefinition.methodInvocations[0].methodName);
			assertEquals("namespace", builder.objectDefinition.methodInvocations[0].namespaceURI);
			assertStrictlyEquals(args, builder.objectDefinition.methodInvocations[0].arguments);
		}
	}
}
