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
	import flash.errors.IllegalOperationError;

	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLObjectDefinitionTest {

		public function MXMLObjectDefinitionTest() {
			super();
			_ignoredFields = new Vector.<String>();
			_ignoredFields[_ignoredFields.length] = "customConfiguration";
			_ignoredFields[_ignoredFields.length] = "properties";
			_ignoredFields[_ignoredFields.length] = "parentName";
			_ignoredFields[_ignoredFields.length] = "methodInvocations";
			_ignoredFields[_ignoredFields.length] = "registryId";
			_ignoredFields[_ignoredFields.length] = "isInterface";
			_ignoredFields[_ignoredFields.length] = "parent";
			_ignoredFields[_ignoredFields.length] = "constructorArguments";
			_ignoredFields[_ignoredFields.length] = "isSingleton";
			_ignoredFields[_ignoredFields.length] = "needsLazyPropertyResolving";
		}

		private var _definition:MXMLObjectDefinition;
		private var _ignoredFields:Vector.<String>;

		[Before]
		public function setUp():void {
			_definition = new MXMLObjectDefinition();
		}

		[Test]
		public function testHasMXMLDefinitionSamePropertiesAsObjectDefinition():void {
			var type:Type = Type.forClass(ObjectDefinition);
			var fields:Array = type.fields;
			for each (var field:Field in fields) {
				if ((field.declaringType.fullName != "Object") && (field.declaringType.fullName != "Class") && (isRequiredField(field.name))) {
					if (!_definition.hasOwnProperty(field.name)) {
						throw new IllegalOperationError("MXMLObjectDefinition does not have a property called " + field.name);
					}
				}
			}
		}

		protected function isRequiredField(name:String):Boolean {
			return (_ignoredFields.indexOf(name) < 0);
		}

		[Test]
		public function testAutoWireMode():void {
			_definition.autoWireMode = AutowireMode.BYTYPE.name;
			_definition.initializeComponent(null, null);
			assertStrictlyEquals(AutowireMode.BYTYPE, _definition.definition.autoWireMode);
		}

		[Test]
		public function testChildContextAccess():void {
			_definition.childContextAccess = ChildContextObjectDefinitionAccess.SINGLETON.value;
			_definition.initializeComponent(null, null);
			assertStrictlyEquals(ChildContextObjectDefinitionAccess.SINGLETON, _definition.definition.childContextAccess);
		}

		[Test]
		public function testClassName():void {
			_definition.className = "org.springextensions.actionscript.ioc.autowire.AutowireMode";
			_definition.initializeComponent(null, null);
			assertEquals("org.springextensions.actionscript.ioc.autowire.AutowireMode", _definition.definition.className);
			assertStrictlyEquals(AutowireMode, _definition.definition.clazz);
		}

		[Test]
		public function testClazz():void {
			_definition.clazz = AutowireMode;
			_definition.initializeComponent(null, null);
			assertStrictlyEquals(AutowireMode, _definition.definition.clazz);
			assertEquals("org.springextensions.actionscript.ioc.autowire.AutowireMode", _definition.definition.className);
		}

		[Test]
		public function testDependencyCheck():void {
			_definition.dependencyCheck = DependencyCheckMode.OBJECTS.name;
			_definition.initializeComponent(null, null);
			assertStrictlyEquals(DependencyCheckMode.OBJECTS, _definition.definition.dependencyCheck);
		}

		[Test]
		public function testDependsOn():void {
			var mod:MXMLObjectDefinition = new MXMLObjectDefinition();
			mod.id = "test";
			var vec:Array = [];
			vec[vec.length] = mod;
			vec[vec.length] = "test2";
			_definition.dependsOn = vec;
			_definition.initializeComponent(null, null);
			assertNotNull(_definition.definition.dependsOn);
			assertEquals(2, _definition.definition.dependsOn.length);
			assertEquals("test", _definition.definition.dependsOn[0]);
			assertEquals("test2", _definition.definition.dependsOn[1]);
		}

		[Test]
		public function testDestroyMethod():void {
			_definition.destroyMethod = "dispose";
			_definition.initializeComponent(null, null);
			assertEquals("dispose", _definition.definition.destroyMethod);
		}

		[Test]
		public function testFactoryMethod():void {
			_definition.factoryMethod = "newInstance";
			_definition.initializeComponent(null, null);
			assertEquals("newInstance", _definition.definition.factoryMethod);
		}

		[Test]
		public function testFactoryObjectName():void {
			_definition.factoryObjectName = "factoryName";
			_definition.initializeComponent(null, null);
			assertEquals("factoryName", _definition.definition.factoryObjectName);
		}

		[Test]
		public function testInitMethod():void {
			_definition.initMethod = "init";
			_definition.initializeComponent(null, null);
			assertEquals("init", _definition.definition.initMethod);
		}

		[Test]
		public function testIsAbstract():void {
			_definition.isAbstract = true;
			_definition.initializeComponent(null, null);
			assertEquals(true, _definition.definition.isAbstract);
		}

		[Test]
		public function testIsAutoWireCandidate():void {
			_definition.isAutoWireCandidate = false;
			_definition.initializeComponent(null, null);
			assertEquals(false, _definition.definition.isAutoWireCandidate);
		}

		[Test]
		public function testIsLazyInit():void {
			_definition.isLazyInit = true;
			_definition.initializeComponent(null, null);
			assertEquals(true, _definition.definition.isLazyInit);
		}

		[Test]
		public function testIsSingleton():void {
			_definition.scope = ObjectDefinitionScope.PROTOTYPE.name;
			_definition.initializeComponent(null, null);
			assertEquals(false, _definition.definition.isSingleton);
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, _definition.definition.scope);
		}

		[Test]
		public function testParent():void {
			var mod:MXMLObjectDefinition = new MXMLObjectDefinition();
			mod.id = "test";
			_definition.parentObject = mod;
			_definition.initializeComponent(null, null);
			assertStrictlyEquals(mod.definition, _definition.definition.parent);
			assertStrictlyEquals(mod.id, _definition.definition.parentName);
		}

		[Test]
		public function testPrimary():void {
			_definition.primary = true;
			_definition.initializeComponent(null, null);
			assertEquals(true, _definition.definition.primary);
		}

		[Test]
		public function testScope():void {
			_definition.scope = ObjectDefinitionScope.PROTOTYPE.name;
			_definition.initializeComponent(null, null);
			assertStrictlyEquals(ObjectDefinitionScope.PROTOTYPE, _definition.definition.scope);
		}

		[Test]
		public function testSkipMetadata():void {
			_definition.skipMetadata = true;
			_definition.initializeComponent(null, null);
			assertEquals(true, _definition.definition.skipMetadata);
		}

		[Test]
		public function testSkipPostProcessors():void {
			_definition.skipPostProcessors = true;
			_definition.initializeComponent(null, null);
			assertEquals(true, _definition.definition.skipPostProcessors);
		}
	}
}
