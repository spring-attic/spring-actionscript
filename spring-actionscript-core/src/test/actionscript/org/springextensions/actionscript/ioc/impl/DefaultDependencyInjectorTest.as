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
package org.springextensions.actionscript.ioc.impl {

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;
	
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.instanceOf;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.factory.IInitializingObject;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.test.testtypes.AutowiredAnnotatedClass;
	import org.springextensions.actionscript.test.testtypes.IAutowireProcessorAwareObjectFactory;
	import org.springextensions.actionscript.test.testtypes.TestInjectionClass;

	use namespace spring_actionscript_objects;

	public class DefaultDependencyInjectorTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		public function DefaultDependencyInjectorTest() {
			super();
		}

		public var injector:DefaultDependencyInjector;
		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var processor:IObjectPostProcessor;
		[Mock]
		public var resolver:IReferenceResolver;
		[Mock]
		public var factory:IAutowireProcessorAwareObjectFactory;
		[Mock]
		public var initializingObject:IInitializingObject;
		[Mock]
		public var autowireProcessor:IAutowireProcessor;
		[Mock]
		public var registry:IObjectDefinitionRegistry;

		[Before]
		public function setUp():void {
			injector = new DefaultDependencyInjector();
			cache = nice(IInstanceCache);
			processor = nice(IObjectPostProcessor);
			resolver = nice(IReferenceResolver);
			factory = nice(IAutowireProcessorAwareObjectFactory);
			registry = nice(IObjectDefinitionRegistry);
			stub(factory).getter("objectDefinitionRegistry").returns(registry);
		}

		[Test]
		public function testWireWithoutDefinition():void {
			var instance:AutowiredAnnotatedClass = new AutowiredAnnotatedClass();
			var autowire:IAutowireProcessor = nice(IAutowireProcessor);
			stub(autowire).method("autoWire").args(anything());
			mock(factory).getter("autowireProcessor").returns(autowire);
			injector.wire(instance, factory);
			verify(factory);
			verify(autowire);
		}

		[Test]
		public function testWireWithoutDefinitionAndWithObjectPostProcessor():void {
			var instance:AutowiredAnnotatedClass = new AutowiredAnnotatedClass();
			var autowire:IAutowireProcessor = nice(IAutowireProcessor);
			stub(autowire).method("autoWire").args(anything()).once();
			stub(processor).method("postProcessBeforeInitialization").args(anything()).returns(instance).once();
			stub(processor).method("postProcessAfterInitialization").args(anything()).returns(instance).once();
			mock(factory).getter("autowireProcessor").returns(autowire);
			var procs:Vector.<IObjectPostProcessor> = new Vector.<IObjectPostProcessor>();
			procs.push(IObjectPostProcessor(processor));
			mock(factory).getter("objectPostProcessors").returns(procs);

			injector.wire(instance, factory);
			verify(factory);
		}

		[Test]
		public function testWireWithoutDefinitionAndWithInitializingObject():void {
			initializingObject = nice(IInitializingObject);
			mock(initializingObject).method("afterPropertiesSet").once();
			mock(registry).method("getObjectDefinitionNamesForType").args(anything()).returns(null);
			injector.wire(initializingObject, factory);
			verify(initializingObject);
		}

		[Test]
		public function testWithObjectDefinitionWithOnePropertyDefinition():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.scope = ObjectDefinitionScope.PROTOTYPE;
			definition.addPropertyDefinition(new PropertyDefinition("testProperty", "testValue"));
			mock(factory).method("resolveReference").args("testValue").returns("testValue").once();
			var obj:Object = {};
			obj.testProperty = "";
			injector.wire(obj, factory, definition, "testObject");
			verify(factory);
			assertEquals("testValue", obj.testProperty);
		}

		[Test]
		public function testWithObjectDefinitionWithOnePropertyDefinitionWithNameSpace():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.scope = ObjectDefinitionScope.PROTOTYPE;
			definition.addPropertyDefinition(new PropertyDefinition("testProperty", "testValue", spring_actionscript_objects));
			mock(factory).method("resolveReference").args("testValue").returns("testValue").once();
			var obj:TestInjectionClass = new TestInjectionClass();
			var qn:QName = new QName(spring_actionscript_objects, "testProperty");
			injector.wire(obj, factory, definition, "testObject");
			verify(factory);
			assertEquals("testValue", obj[qn]);
		}

		[Test]
		public function testWithObjectDefinitionWithOneStaticPropertyDefinition():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.scope = ObjectDefinitionScope.PROTOTYPE;
			definition.addPropertyDefinition(new PropertyDefinition("testStaticProperty", "testValue", null, true));
			mock(factory).method("resolveReference").args("testValue").returns("testValue").once();
			var obj:TestInjectionClass = new TestInjectionClass();
			injector.wire(obj, factory, definition, "testObject");
			verify(factory);
			assertEquals("testValue", TestInjectionClass.testStaticProperty);
		}

		[Test]
		public function testWithObjectDefinitionWithOneMethodInvocation():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.scope = ObjectDefinitionScope.PROTOTYPE;
			definition.addMethodInvocation(new MethodInvocation("testCounter"));
			var obj:TestInjectionClass = new TestInjectionClass();
			injector.wire(obj, factory, definition, "testObject");
			assertEquals(1, obj.count);
		}

		[Test]
		public function testWithObjectDefinitionWithOneMethodInvocationWithNamespace():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.scope = ObjectDefinitionScope.PROTOTYPE;
			definition.addMethodInvocation(new MethodInvocation("testCounter", null, spring_actionscript_objects));
			var obj:TestInjectionClass = new TestInjectionClass();
			injector.wire(obj, factory, definition, "testObject");
			assertEquals(2, obj.count);
		}

		[Test]
		public function testWithSingletonObjectDefinition():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.scope = ObjectDefinitionScope.SINGLETON;
			var obj:TestInjectionClass = new TestInjectionClass();
			stub(factory).getter("cache").returns(cache);
			stub(cache).method("prepareInstance(").args("testObject", obj).once();
			mock(cache).method("putInstance").args("testObject", obj).once();
			injector.wire(obj, factory, definition, "testObject");
			verify(cache);
		}
	}
}
