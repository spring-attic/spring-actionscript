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
package org.springextensions.actionscript.ioc.impl {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.hamcrest.object.instanceOf;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.event.ObjectFactoryEvent;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.event.ObjectDefinitionEvent;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.test.testtypes.Person;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultLazyDependencyManagerTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var factory:IObjectFactory;
		[Mock]
		public var registry:IObjectDefinitionRegistry;
		[Mock]
		public var definition:IObjectDefinition;
		private var _manager:DefaultLazyDependencyManager;

		/**
		 * Creates a new <code>DefaultLazyDependencyManagerTest</code> instance.
		 */
		public function DefaultLazyDependencyManagerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			factory = nice(IObjectFactory);
			_manager = new DefaultLazyDependencyManager(factory);
		}

		[Test]
		public function testConstructor():void {
			mock(factory).method("addEventListener").args(ObjectFactoryEvent.OBJECT_WIRED, instanceOf(Function), false, 0, true).once();
			_manager = new DefaultLazyDependencyManager(factory);
			verify(factory);
		}

		[Test]
		public function testUpdateInjections():void {
			registry = nice(IObjectDefinitionRegistry);
			definition = nice(IObjectDefinition);

			mock(factory).getter("objectDefinitionRegistry").returns(registry);
			mock(registry).method("getObjectDefinition").args("test").returns(definition);
			mock(definition).method("dispatchEvent").args(instanceOf(ObjectDefinitionEvent));

			var instance:Person = new Person();
			var arrayInstance:Array = [];
			assertNull(instance.anArray);
			var property:PropertyDefinition = new PropertyDefinition("anArray", new RuntimeObjectReference("arrayDep"), null, false, true);
			_manager.registerLazyInjection("test", property, instance);

			_manager.updateInjections("arrayDep", arrayInstance);

			assertStrictlyEquals(instance.anArray, arrayInstance);
			verify(registry);
			verify(definition);
			verify(factory);
		}

		[Test]
		public function testUpdateInjectionsMultipleInstances():void {
			registry = nice(IObjectDefinitionRegistry);
			definition = nice(IObjectDefinition);

			mock(factory).getter("objectDefinitionRegistry").returns(registry);
			mock(registry).method("getObjectDefinition").args("test").returns(definition);
			mock(definition).method("dispatchEvent").args(instanceOf(ObjectDefinitionEvent));

			var instance1:Person = new Person();
			var instance2:Person = new Person();
			var arrayInstance:Array = [];
			assertNull(instance1.anArray);
			assertNull(instance2.anArray);
			var property:PropertyDefinition = new PropertyDefinition("anArray", new RuntimeObjectReference("arrayDep"), null, false, true);
			_manager.registerLazyInjection("test", property, instance1);
			_manager.registerLazyInjection("test", property, instance2);

			_manager.updateInjections("arrayDep", arrayInstance);

			assertStrictlyEquals(instance1.anArray, arrayInstance);
			assertStrictlyEquals(instance2.anArray, arrayInstance);
			verify(registry);
			verify(definition);
			verify(factory);
		}

		[Test]
		public function testUpdateInjectionsMultipleDefinitions():void {
			registry = nice(IObjectDefinitionRegistry);
			definition = nice(IObjectDefinition);
			var definition2:IObjectDefinition = nice(IObjectDefinition);

			mock(factory).getter("objectDefinitionRegistry").returns(registry);
			mock(registry).method("getObjectDefinition").args("test").returns(definition);
			mock(registry).method("getObjectDefinition").args("test2").returns(definition2);
			mock(definition).method("dispatchEvent").args(instanceOf(ObjectDefinitionEvent));
			mock(definition2).method("dispatchEvent").args(instanceOf(ObjectDefinitionEvent));

			var instance1:Person = new Person();
			var instance2:Person = new Person();
			var arrayInstance:Array = [];
			assertNull(instance1.anArray);
			assertNull(instance2.anArray);

			var property1:PropertyDefinition = new PropertyDefinition("anArray", new RuntimeObjectReference("arrayDep"), null, false, true);
			var property2:PropertyDefinition = new PropertyDefinition("anArray", new RuntimeObjectReference("arrayDep"), null, false, true);
			_manager.registerLazyInjection("test", property1, instance1);
			_manager.registerLazyInjection("test2", property2, instance2);

			_manager.updateInjections("arrayDep", arrayInstance);

			assertStrictlyEquals(instance1.anArray, arrayInstance);
			assertStrictlyEquals(instance2.anArray, arrayInstance);
			verify(registry);
			verify(definition);
			verify(definition2);
			verify(factory);
		}

	}
}
