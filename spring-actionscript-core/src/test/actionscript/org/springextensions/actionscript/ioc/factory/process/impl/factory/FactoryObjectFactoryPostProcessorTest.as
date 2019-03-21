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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {
	import flash.system.ApplicationDomain;

	import flex.lang.reflect.metadata.MetaDataArgument;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.test.testtypes.TestFactoryObject;
	import org.springextensions.actionscript.test.testtypes.TestInvalidFactoryObject;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FactoryObjectFactoryPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var factory:IObjectFactory;
		[Mock]
		public var registry:IObjectDefinitionRegistry;
		[Mock]
		public var definition:IObjectDefinition;
		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var metadata:Metadata;

		private var _processor:FactoryObjectFactoryPostProcessor;

		/**
		 * Creates a new <code>FactoryObjectFactoryPostProcessorTest</code> instance.
		 */
		public function FactoryObjectFactoryPostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			factory = nice(IObjectFactory);
			registry = nice(IObjectDefinitionRegistry);
			cache = nice(IInstanceCache);
			stub(factory).getter("objectDefinitionRegistry").returns(registry);
			stub(factory).getter("applicationDomain").returns(ApplicationDomain.currentDomain);
			stub(factory).getter("cache").returns(cache);
			_processor = new FactoryObjectFactoryPostProcessor();
		}

		[Test]
		public function testProcessObjectDefinitionWithFactoryMetadata():void {
			var factoryObject:TestFactoryObject = new TestFactoryObject();
			definition = nice(IObjectDefinition);
			mock(registry).method("getObjectDefinitionName").args(definition).returns("testName").once();
			mock(factory).method("getObject").args("testName").returns(factoryObject);
			_processor.processObjectDefinitionWithFactoryMetadata(factory, definition);
			verify(registry);
			verify(factory);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function testErrorWhenProcessObjectDefinitionWithoutFactoryMethodArgument():void {
			var factoryObject:TestInvalidFactoryObject = new TestInvalidFactoryObject();
			definition = nice(IObjectDefinition);
			stub(registry).method("getObjectDefinitionName").args(definition).returns("testName").once();
			stub(factory).method("getObject").args("testName").returns(factoryObject);
			_processor.processObjectDefinitionWithFactoryMetadata(factory, definition);
		}

		[Test]
		public function testErrorWhenProcessObjectDefinitionWithoutFactoryMethodArgumentWithThrowErrorSetToFalse():void {
			var factoryObject:TestFactoryObject = new TestFactoryObject();
			definition = nice(IObjectDefinition);
			stub(registry).method("getObjectDefinitionName").args(definition).returns("testName").once();
			stub(factory).method("getObject").args("testName").returns(factoryObject);
			_processor.throwError = false;
			_processor.processObjectDefinitionWithFactoryMetadata(factory, definition);
		}

		[Test]
		public function testReplaceFactoryInstance():void {
			metadata = nice(Metadata);
			var mda:MetadataArgument = new MetadataArgument(FactoryObjectFactoryPostProcessor.FACTORY_METHOD_FIELD_NAME, "methodName");
			mock(metadata).method("getArgument").args(FactoryObjectFactoryPostProcessor.FACTORY_METHOD_FIELD_NAME).returns(mda).once();
			var factoryObject:TestFactoryObject = new TestFactoryObject();
			definition = nice(IObjectDefinition);
			mock(definition).setter("scope").arg(ObjectDefinitionScope.SINGLETON).once();
			mock(cache).method("hasInstance").args("testName").returns(false).once();
			mock(cache).method("putInstance").args("testName", anything()).once();
			_processor.replaceFactoryInstance(definition, metadata, factoryObject, cache, "testName");
			verify(metadata);
			verify(definition);
			verify(cache);
		}
	}
}
