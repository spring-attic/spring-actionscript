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
package org.springextensions.actionscript.context.impl {
	import flash.system.ApplicationDomain;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.IDependencyInjector;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.test.testtypes.IAutowireProcessorAwareObjectFactory;


	public class ApplicationContextTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var objectFactory:IAutowireProcessorAwareObjectFactory;
		[Mock]
		public var objectDefinitionProvider:IObjectDefinitionsProvider;
		[Mock]
		public var objectFactoryPostProcessor:IObjectFactoryPostProcessor;

		public var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;

		private var _context:ApplicationContext;

		public function ApplicationContextTest() {
			super();
		}

		[Before]
		public function setUp():void {
			objectFactory = nice(IAutowireProcessorAwareObjectFactory);
			stub(objectFactory).method("addObjectFactoryPostProcessor").args(anything());
			stub(objectFactory).method("addReferenceResolver").args(anything());
		}

		[Test]
		public function testAddDefinitionProvider():void {
			var context:ApplicationContext = new ApplicationContext(null, objectFactory);
			context.addDefinitionProvider(objectDefinitionProvider);
			assertEquals(1, context.definitionProviders.length);
			verify(objectFactory);
		}

		[Test]
		public function testCompositedMembers():void {
			mock(objectFactory).method("addObjectPostProcessor").args(null).once();
			mock(objectFactory).method("addReferenceResolver").args(null).once();
			mock(objectFactory).getter("applicationDomain").returns(applicationDomain).once();
			mock(objectFactory).setter("applicationDomain").arg(applicationDomain).once();
			mock(objectFactory).getter("cache").returns(null).once();
			mock(objectFactory).getter("dependencyInjector").returns(null).once();
			mock(objectFactory).setter("dependencyInjector").arg(null).once();
			stub(objectFactory).method("getObject").args(anything());
			mock(objectFactory).getter("isReady").returns(true).once();
			mock(objectFactory).getter("objectPostProcessors").returns(null).once();
			mock(objectFactory).getter("parent").returns(null).once();
			mock(objectFactory).getter("propertiesProvider").returns(null).once();
			mock(objectFactory).getter("referenceResolvers").returns(null).once();
			mock(objectFactory).method("resolveReference").args("test").returns(null).once();
			mock(objectFactory).getter("objectDefinitionRegistry").returns(null).once();

			var context:ApplicationContext = new ApplicationContext(null, objectFactory);
			context.addObjectPostProcessor(null);
			context.addReferenceResolver(null);
			var applicationDomain:ApplicationDomain = context.applicationDomain;
			context.applicationDomain = applicationDomain;
			var cache:IInstanceCache = context.cache;
			context.createInstance(String);
			var dependencyInjector:IDependencyInjector = context.dependencyInjector;
			context.dependencyInjector = dependencyInjector;
			context.getObject("testName");
			var b:Boolean = context.isReady;
			var postProcessors:Vector.<IObjectPostProcessor> = context.objectPostProcessors;
			var parent:IObjectFactory = context.parent;
			var propertiesProvider:IPropertiesProvider = context.propertiesProvider;
			var resolvers:Vector.<IReferenceResolver> = context.referenceResolvers;
			context.resolveReference("test");
			var registry:IObjectDefinitionRegistry = context.objectDefinitionRegistry;

			verify(objectFactory);
		}


		[Test]
		public function testAddObjectFactoryPostProcessor():void {
			var context:ApplicationContext = new ApplicationContext(null, objectFactory);
			var processor:IObjectFactoryPostProcessor = nice(IObjectFactoryPostProcessor);
			var originalLength:uint = context.objectFactoryPostProcessors.length;
			context.addObjectFactoryPostProcessor(processor);
			assertEquals((originalLength + 1), context.objectFactoryPostProcessors.length);
		}

	}
}
