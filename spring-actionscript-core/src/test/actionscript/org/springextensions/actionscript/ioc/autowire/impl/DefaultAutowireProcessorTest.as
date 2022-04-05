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
package org.springextensions.actionscript.ioc.autowire.impl {
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.test.testtypes.AutowiredAnnotatedClass;
	import org.springextensions.actionscript.test.testtypes.AutowiredExternalPropertyAnnotatedClass;

	public final class DefaultAutowireProcessorTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		public var applicationDomain:ApplicationDomain = Type.currentApplicationDomain;

		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var factory:IObjectFactory;
		[Mock]
		public var propertiesProvider:IPropertiesProvider;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;

		protected var objectDefinitionNames:Vector.<String>;

		{
			DefaultObjectFactory;
			UnsatisfiedDependencyError;
		}

		public function DefaultAutowireProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			cache = nice(IInstanceCache);
			factory = nice(IObjectFactory);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);

			stub(factory).getter("cache").returns(cache);
			stub(factory).getter("applicationDomain").returns(applicationDomain);
			stub(factory).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			objectDefinitionNames = new Vector.<String>();
			stub(objectDefinitionRegistry).getter("objectDefinitionNames").returns(objectDefinitionNames);
		}

		[Test(expects="org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError")]
		public function testPreprocessObjectDefinitionWithAutoDetectAndUnsatisfiedDependencyAndObjectsCheck():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.autoWireMode = AutowireMode.AUTODETECT;
			definition.dependencyCheck = DependencyCheckMode.OBJECTS;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.preprocessObjectDefinition(definition);
			verify(objectDefinitionRegistry);
		}

		[Test(expects="org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError")]
		public function testPreprocessObjectDefinitionWithAutoDetectAndUnsatisfiedDependency():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.autoWireMode = AutowireMode.AUTODETECT;
			definition.dependencyCheck = DependencyCheckMode.ALL;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.preprocessObjectDefinition(definition);
			verify(objectDefinitionRegistry);
		}

		[Test(expects="org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError")]
		public function testAutowireWithCandidateSetToFalse():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "String";
			definition.clazz = String;
			definition.isAutoWireCandidate = false;
			definition.dependencyCheck = DependencyCheckMode.NONE;
			mock(factory).method("getObjectDefinition").args("testName").returns(definition);

			stub(factory).method("getObject").args("testName").returns("testValue");

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var instance:AutowiredAnnotatedClass = new AutowiredAnnotatedClass();
			processor.autoWire(instance);
			verify(objectDefinitionRegistry);
		}

		[Test]
		public function testFindAutowireCandidateName():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "flash.events.Event";
			definition.clazz = Event;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);
			objectDefinitionNames[objectDefinitionNames.length] = "testName";
			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "testName";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var name:String = processor.findAutowireCandidateName(Event);
			assertEquals("testName", name);
			verify(factory);
			verify(objectDefinitionRegistry);
		}

		[Test]
		public function testFindAutowireCandidateNameWithNonExistingCandidate():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "flash.events.Event";
			definition.clazz = Event;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);
			objectDefinitionNames[objectDefinitionNames.length] = "testName";
			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "testName";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var name:String = processor.findAutowireCandidateName(String);
			assertNull(name);
			verify(factory);
			verify(objectDefinitionRegistry);
		}

		[Test]
		public function testPreprocessObjectDefinitionWithAutoDetectAndClassWithoutConstructorArgs():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "Function";
			definition.autoWireMode = AutowireMode.AUTODETECT;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.preprocessObjectDefinition(definition);
			assertStrictlyEquals(AutowireMode.BYTYPE, definition.autoWireMode);
		}

		[Test]
		public function testPreprocessObjectDefinitionWithAutoDetectAndClassWithConstructorArgs():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.clazz = DefaultAutowireProcessor;
			definition.autoWireMode = AutowireMode.AUTODETECT;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			var definition2:IObjectDefinition = new ObjectDefinition();
			definition2.className = "org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory";
			definition2.clazz = DefaultObjectFactory;
			definition2.autoWireMode = AutowireMode.NO;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("objectFactory").returns(definition2);
			objectDefinitionNames[objectDefinitionNames.length] = "testName";
			objectDefinitionNames[objectDefinitionNames.length] = "objectFactory";

			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "objectFactory";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.preprocessObjectDefinition(definition);
			assertStrictlyEquals(AutowireMode.CONSTRUCTOR, definition.autoWireMode);
			assertEquals(1, definition.constructorArguments.length);
			assertEquals("objectFactory", definition.constructorArguments[0].ref.objectName);
			verify(factory);
		}

		[Test]
		public function testPreprocessObjectDefinitionWithAutoDetectAndIgnoredUnsatisfiedDependency():void {

			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.autoWireMode = AutowireMode.AUTODETECT;
			definition.dependencyCheck = DependencyCheckMode.SIMPLE;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);


			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.preprocessObjectDefinition(definition);
			assertStrictlyEquals(AutowireMode.CONSTRUCTOR, definition.autoWireMode);
			assertEquals(1, definition.constructorArguments.length);
			assertNull(definition.constructorArguments[0].value);
		}

		[Test]
		public function testPreprocessObjectDefinitionWithAutoDetectAndWithoutDependencyCheck():void {

			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.autoWireMode = AutowireMode.AUTODETECT;
			definition.dependencyCheck = DependencyCheckMode.NONE;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);


			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.preprocessObjectDefinition(definition);
			assertStrictlyEquals(AutowireMode.CONSTRUCTOR, definition.autoWireMode);
			assertEquals(1, definition.constructorArguments.length);
			assertNull(definition.constructorArguments[0].value);
		}

		[Test]
		public function testFindAutowireCandidate():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.clazz = DefaultAutowireProcessor;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);
			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "testName";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();
			objectDefinitionNames[objectDefinitionNames.length] = "testName";

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var result:String = processor.findAutowireCandidateName(DefaultAutowireProcessor);
			assertEquals("testName", result);
			verify(factory);
		}

		[Test]
		public function testFindAutowireCandidateWithAutowireCandidateSetToFalse():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.isAutoWireCandidate = false;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);


			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var result:String = processor.findAutowireCandidateName(DefaultAutowireProcessor);
			assertNull(result);
		}

		[Test]
		public function testFindAutowireCandidateWithTwoCandidates():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			definition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName2").returns(definition);


			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var result:String = processor.findAutowireCandidateName(DefaultAutowireProcessor);
			assertNull(result);
		}

		[Test]
		public function testFindAutowireCandidateWithTwoCandidatesAndOneIsPrimary():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.clazz = DefaultAutowireProcessor;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			definition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.primary = true;
			definition.clazz = DefaultAutowireProcessor;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName2").returns(definition);

			objectDefinitionNames[objectDefinitionNames.length] = "testName";
			objectDefinitionNames[objectDefinitionNames.length] = "testName2";

			mock(objectDefinitionRegistry).method("containsObjectDefinition").args("testName").returns(true);
			mock(objectDefinitionRegistry).method("containsObjectDefinition").args("testName2").returns(true);

			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "testName";
			vec[vec.length] = "testName2";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var result:String = processor.findAutowireCandidateName(DefaultAutowireProcessor);
			assertEquals("testName2", result);
			verify(factory);
			verify(objectDefinitionRegistry);
		}

		[Test(expects="org.springextensions.actionscript.ioc.autowire.impl.AutowireError")]
		public function testFindAutowireCandidateWithTwoCandidatesAndBothArePrimary():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.clazz = DefaultAutowireProcessor;
			definition.primary = true;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			definition = new ObjectDefinition();
			definition.className = "org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor";
			definition.clazz = DefaultAutowireProcessor;
			definition.primary = true;
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName2").returns(definition);

			objectDefinitionNames[objectDefinitionNames.length] = "testName";
			objectDefinitionNames[objectDefinitionNames.length] = "testName2";

			mock(objectDefinitionRegistry).method("containsObjectDefinition").args("testName").returns(true);
			mock(objectDefinitionRegistry).method("containsObjectDefinition").args("testName2").returns(true);

			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "testName";
			vec[vec.length] = "testName2";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			var result:String = processor.findAutowireCandidateName(DefaultAutowireProcessor);
		}

		[Test]
		public function testAutowire():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "String";
			definition.clazz = String;
			objectDefinitionNames[objectDefinitionNames.length] = "testName";

			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);
			mock(factory).method("getObject").args("testName").returns("testValue");

			var vec:Vector.<String> = new Vector.<String>();
			vec[vec.length] = "testName";
			mock(objectDefinitionRegistry).method("getDefinitionNamesWithPropertyValue").args(anything(), anything()).returns(vec).once();

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);

			var instance:AutowiredAnnotatedClass = new AutowiredAnnotatedClass();
			processor.autoWire(instance);
			verify(factory);
			assertEquals("testValue", instance.autowiredProperty);
		}

		[Test]
		public function testAutowireWithCheckForOnlyInjectMetadata():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.className = "String";
			mock(objectDefinitionRegistry).method("getObjectDefinition").args("testName").returns(definition);

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.autowireMetadataNames = new Vector.<String>();
			processor.autowireMetadataNames[processor.autowireMetadataNames.length] = DefaultAutowireProcessor.INJECT_ANNOTATION;

			var instance:AutowiredAnnotatedClass = new AutowiredAnnotatedClass();
			processor.autoWire(instance);
			assertNull(instance.autowiredProperty);
		}

		[Test]
		public function testAutowireWithExternalProperty():void {
			propertiesProvider = nice(IPropertiesProvider);
			mock(propertiesProvider).method("hasProperty").args("testProperty").returns(true);
			mock(propertiesProvider).method("getProperty").args("testProperty").returns("testExternalPropertyValue");
			stub(factory).getter("propertiesProvider").returns(propertiesProvider);

			var processor:DefaultAutowireProcessor = new DefaultAutowireProcessor(factory);
			processor.autowireMetadataNames = new Vector.<String>();
			processor.autowireMetadataNames[processor.autowireMetadataNames.length] = DefaultAutowireProcessor.AUTOWIRED_ANNOTATION;

			var instance:AutowiredExternalPropertyAnnotatedClass = new AutowiredExternalPropertyAnnotatedClass();
			processor.autoWire(instance);
			verify(propertiesProvider);
			assertEquals("testExternalPropertyValue", instance.injectedExternalProperty);
		}

	}
}
