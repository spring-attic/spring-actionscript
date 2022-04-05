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
	import flash.events.Event;
	import flash.utils.setTimeout;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.async.Async;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.ITextFilesLoader;
	import org.springextensions.actionscript.ioc.config.impl.AsyncObjectDefinitionProviderResultOperation;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultApplicationContextInitializerTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContext;
		[Mock]
		public var objectDefinitionProvider:IObjectDefinitionsProvider;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;
		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var textFileLoader:ITextFilesLoader;

		/**
		 * Creates a new <code>DefaultApplicationContextInitializerTest</code> instance.
		 */
		public function DefaultApplicationContextInitializerTest() {
			super();
		}

		[Test]
		public function testLoadWithSynchronousProvider():void {
			applicationContext = nice(IApplicationContext);
			objectDefinitionProvider = nice(IObjectDefinitionsProvider);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			cache = nice(IInstanceCache);
			var definitions:Object = {};
			definitions["testName"] = new ObjectDefinition("String");
			var vec:Vector.<IObjectDefinitionsProvider> = new <IObjectDefinitionsProvider>[objectDefinitionProvider];
			mock(applicationContext).getter("definitionProviders").returns(vec).atLeast(1);
			mock(applicationContext).getter("cache").returns(cache).atLeast(1);
			mock(applicationContext).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry).atLeast(1);
			mock(objectDefinitionProvider).method("createDefinitions").returns(null).once();
			mock(objectDefinitionProvider).getter("objectDefinitions").returns(definitions).once();
			mock(objectDefinitionRegistry).method("registerObjectDefinition").args("testName", definitions["testName"]).once();
			mock(objectDefinitionRegistry).method("getSingletons").returns(new <String>["testName"]).atLeast(1);
			mock(cache).method("hasInstance").args("testName").returns(false).once();
			mock(applicationContext).method("getObject").args("testName").returns(null).once();

			var initializer:DefaultApplicationContextInitializer = new DefaultApplicationContextInitializer();
			initializer.initialize(applicationContext);
			verify(applicationContext);
			verify(objectDefinitionProvider);
			verify(objectDefinitionRegistry);
			verify(cache);
		}

		[Test]
		public function testLoadWithSynchronousProviderThatReturnsPropertyURLS():void {
			applicationContext = nice(IApplicationContext);
			objectDefinitionProvider = nice(IObjectDefinitionsProvider);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			textFileLoader = nice(ITextFilesLoader);
			cache = nice(IInstanceCache);
			var definitions:Object = {};
			definitions["testName"] = new ObjectDefinition("String");
			var uris:Vector.<TextFileURI> = new <TextFileURI>[new TextFileURI("url", true)];
			var vec:Vector.<IObjectDefinitionsProvider> = new <IObjectDefinitionsProvider>[objectDefinitionProvider];
			mock(applicationContext).getter("definitionProviders").returns(vec).atLeast(1);
			mock(applicationContext).getter("cache").returns(cache).atLeast(1);
			mock(applicationContext).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry).atLeast(1);
			mock(objectDefinitionProvider).method("createDefinitions").returns(null).once();
			mock(objectDefinitionProvider).getter("objectDefinitions").returns(definitions).once();
			mock(objectDefinitionRegistry).method("registerObjectDefinition").args("testName", definitions["testName"]).once();
			mock(objectDefinitionRegistry).method("getSingletons").returns(new <String>["testName"]).atLeast(1);
			mock(cache).method("hasInstance").args("testName").returns(false).once();
			mock(applicationContext).method("getObject").args("testName").returns(null).once();
			mock(objectDefinitionProvider).getter("propertyURIs").returns(uris).atLeast(1);
			mock(textFileLoader).method("addURIs").args(uris).once();

			var initializer:DefaultApplicationContextInitializer = new DefaultApplicationContextInitializer();
			initializer.textFilesLoader = textFileLoader;
			initializer.initialize(applicationContext);
			verify(applicationContext);
			verify(objectDefinitionProvider);
			verify(objectDefinitionRegistry);
			verify(cache);
			verify(textFileLoader);
		}

		[Test(async, timeout="1000")]
		public function testLoadWithASynchronousProvider():void {

			var mockOperation:AsyncObjectDefinitionProviderResultOperation = new AsyncObjectDefinitionProviderResultOperation();
			applicationContext = nice(IApplicationContext);
			objectDefinitionProvider = nice(IObjectDefinitionsProvider);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			cache = nice(IInstanceCache);
			var definitions:Object = {};
			definitions["testName"] = new ObjectDefinition("String");
			var vec:Vector.<IObjectDefinitionsProvider> = new <IObjectDefinitionsProvider>[objectDefinitionProvider];
			mock(applicationContext).getter("definitionProviders").returns(vec).atLeast(1);
			mock(applicationContext).getter("cache").returns(cache).atLeast(1);
			mock(applicationContext).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry).atLeast(1);
			mock(objectDefinitionProvider).method("createDefinitions").returns(mockOperation).once();
			mock(objectDefinitionProvider).getter("objectDefinitions").returns(definitions).once();
			mock(objectDefinitionRegistry).method("registerObjectDefinition").args("testName", definitions["testName"]).once();
			mock(objectDefinitionRegistry).method("getSingletons").returns(new <String>["testName"]).atLeast(1);
			mock(cache).method("hasInstance").args("testName").returns(false).once();
			mock(applicationContext).method("getObject").args("testName").returns(null).once();

			var initializer:DefaultApplicationContextInitializer = new DefaultApplicationContextInitializer();
			initializer.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleAsyncProvider, 500, null, handleAsyncProviderTimeOut), false, 0, true);
			initializer.initialize(applicationContext);
			setTimeout(function():void {
				mockOperation.dispatchCompleteEvent(objectDefinitionProvider);
			}, 5);
		}

		protected function handleAsyncProvider(event:Event, passThroughData:Object):void {
			verify(applicationContext);
			verify(objectDefinitionProvider);
			verify(objectDefinitionRegistry);
			verify(cache);
		}

		protected function handleAsyncProviderTimeOut(passThroughData:Object):void {
			verify(applicationContext);
			verify(objectDefinitionProvider);
			verify(objectDefinitionRegistry);
			verify(cache);
		}


	}
}
