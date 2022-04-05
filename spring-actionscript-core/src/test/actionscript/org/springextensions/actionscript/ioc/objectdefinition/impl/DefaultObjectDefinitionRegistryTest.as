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
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.test.testtypes.Person;
	import org.springextensions.actionscript.test.testtypes.TestClassWithMetadata;

	public class DefaultObjectDefinitionRegistryTest {

		{
			TestClassWithMetadata;
			Person;
		}

		private var _registry:DefaultObjectDefinitionRegistry;

		public function DefaultObjectDefinitionRegistryTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_registry = new DefaultObjectDefinitionRegistry();
			_registry.applicationDomain = Type.currentApplicationDomain;
		}

		[Test]
		public function testRegisterObjectDefinition():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			assertEquals(0, _registry.numObjectDefinitions);
			_registry.registerObjectDefinition("test", objectDefinition);
			assertEquals(1, _registry.numObjectDefinitions);
		}

		[Test]
		public function testRegisterObjectDefinitionWithDefinitionFromOtherRegistry():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";
			objectDefinition.clazz = String;
			objectDefinition.registryId = "testId";

			_registry.registerObjectDefinition("test", objectDefinition);
			assertEquals("testId", objectDefinition.registryId);
		}

		[Test]
		public function testPropertyTypesAreDetermined():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "org.springextensions.actionscript.test.testtypes.Person";
			var property1:PropertyDefinition = new PropertyDefinition("age", 12);
			objectDefinition.addPropertyDefinition(property1);
			var property2:PropertyDefinition = new PropertyDefinition("anObject", {});
			objectDefinition.addPropertyDefinition(property2);

			_registry.registerObjectDefinition("test", objectDefinition);
			assertTrue(property1.isSimple);
			assertFalse(property2.isSimple);
		}

		[Test]
		public function testGetObjectDefinition():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test", objectDefinition);
			assertStrictlyEquals(objectDefinition, _registry.getObjectDefinition("test"));
		}

		[Test]
		public function testContainsDefinition():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			assertFalse(_registry.containsObjectDefinition("test"));
			_registry.registerObjectDefinition("test", objectDefinition);
			assertTrue(_registry.containsObjectDefinition("test"));
		}

		[Test]
		public function testIsSingleton():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";
			objectDefinition.scope = ObjectDefinitionScope.SINGLETON;

			_registry.registerObjectDefinition("test", objectDefinition);
			assertTrue(_registry.isSingleton("test"));
		}

		[Test]
		public function testIsPrototype():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";
			objectDefinition.scope = ObjectDefinitionScope.PROTOTYPE;

			_registry.registerObjectDefinition("test", objectDefinition);
			assertTrue(_registry.isPrototype("test"));
		}

		[Test]
		public function testObjectDefinitionNames():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";
			objectDefinition.scope = ObjectDefinitionScope.PROTOTYPE;
			_registry.registerObjectDefinition("test", objectDefinition);
			assertEquals("test", _registry.objectDefinitionNames[0]);
		}

		[Test]
		public function testGetType():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test", objectDefinition);
			assertStrictlyEquals(String, _registry.getType("test"));
		}

		[Test]
		public function testGetTypeForNonExistingDefinition():void {
			assertNull(String, _registry.getType("test"));
		}

		[Test]
		public function testGetUsedTypes():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test", objectDefinition);

			objectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test2", objectDefinition);

			assertEquals(1, _registry.getUsedTypes().length);
			assertStrictlyEquals(String, _registry.getUsedTypes()[0]);
		}

		[Test]
		public function testGetObjectDefinitionNamesForType():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test", objectDefinition);

			objectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test2", objectDefinition);

			assertEquals(2, _registry.getObjectDefinitionNamesForType(String).length);
			assertStrictlyEquals("test", _registry.getObjectDefinitionNamesForType(String)[0]);
			assertStrictlyEquals("test2", _registry.getObjectDefinitionNamesForType(String)[1]);
		}

		[Test]
		public function testGetObjectDefinitionsForType():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test", objectDefinition);

			var objectDefinition2:IObjectDefinition = new ObjectDefinition();
			objectDefinition2.className = "String";

			_registry.registerObjectDefinition("test2", objectDefinition2);

			assertEquals(2, _registry.getObjectDefinitionsForType(String).length);
			assertStrictlyEquals(objectDefinition, _registry.getObjectDefinitionsForType(String)[0]);
			assertStrictlyEquals(objectDefinition2, _registry.getObjectDefinitionsForType(String)[1]);
		}

		[Test]
		public function testGetObjectDefinitionName():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "String";

			_registry.registerObjectDefinition("test", objectDefinition);

			var objectDefinition2:IObjectDefinition = new ObjectDefinition();
			objectDefinition2.className = "String";

			_registry.registerObjectDefinition("test2", objectDefinition2);

			assertEquals("test", _registry.getObjectDefinitionName(objectDefinition));
			assertEquals("test2", _registry.getObjectDefinitionName(objectDefinition2));
		}

		[Test]
		public function testGetObjectDefinitionsWithMetadata():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "org.springextensions.actionscript.test.testtypes.TestClassWithMetadata";

			_registry.registerObjectDefinition("test", objectDefinition);

			var names:Vector.<String> = new Vector.<String>();
			names.push("Mock");
			var defs:Vector.<IObjectDefinition> = _registry.getObjectDefinitionsWithMetadata(names);
			assertEquals(1, defs.length);
			assertStrictlyEquals(objectDefinition, defs[0]);
		}

		[Test]
		public function testRemoveObjectDefinition():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition();
			objectDefinition.className = "org.springextensions.actionscript.test.testtypes.TestClassWithMetadata";

			_registry.registerObjectDefinition("test", objectDefinition);

			var names:Vector.<String> = new Vector.<String>();
			names.push("Mock");

			_registry.removeObjectDefinition("test");
			assertEquals(0, _registry.objectDefinitionNames.length);
			assertNull(_registry.getObjectDefinitionsForType(TestClassWithMetadata));
			assertEquals(0, _registry.getUsedTypes().length);
			assertNull(_registry.getObjectDefinitionsWithMetadata(names));
		}

		[Test]
		public function testGetDefinitionNamesWithPropertyValueReturnMatching():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("String");
			_registry.registerObjectDefinition("test1", objectDefinition);
			objectDefinition = new ObjectDefinition("Number");
			_registry.registerObjectDefinition("test2", objectDefinition);

			var result:Vector.<String> = _registry.getDefinitionNamesWithPropertyValue("className", "String");
			assertNotNull(result);
			assertEquals(1, result.length);
			assertEquals("test1", result[0]);
		}

		[Test]
		public function testGetDefinitionNamesWithPropertyValueReturnNonMatching():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("String");
			_registry.registerObjectDefinition("test1", objectDefinition);
			objectDefinition = new ObjectDefinition("Number");
			_registry.registerObjectDefinition("test2", objectDefinition);

			var result:Vector.<String> = _registry.getDefinitionNamesWithPropertyValue("className", "String", false);
			assertNotNull(result);
			assertEquals(1, result.length);
			assertEquals("test2", result[0]);
		}

	}
}
