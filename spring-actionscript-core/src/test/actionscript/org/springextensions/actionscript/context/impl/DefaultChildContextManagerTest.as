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
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.eventbus.IEventBus;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.context.ContextShareSettings;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.eventbus.EventBusShareKind;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.test.testtypes.IAutowireProcessorAwareObjectFactory;
	import org.springextensions.actionscript.test.testtypes.eventbus.IEventBusAndListener;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultChildContextManagerTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContext;
		[Mock]
		public var eventBus:IEventBus;
		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var normalObjectFactory:IObjectFactory;
		[Mock]
		public var eventBusAndListener:IEventBusAndListener;
		[Mock]
		public var propertiesProvider:IPropertiesProvider;
		[Mock]
		public var objectDefinitionsRegistry:IObjectDefinitionRegistry;

		private var _childContextManager:DefaultChildContextManager;

		/**
		 * Creates a new <code>DefaultChildContextManagerTest</code> instance.
		 */
		public function DefaultChildContextManagerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_childContextManager = new DefaultChildContextManager();
		}

		[Test]
		public function testDummy():void {

		}

	/*[Test]
	public function testAddChildContextWithoutAnySharing():void {

		mock(propertiesProvider).method("merge").args(anything()).once();
		var childContext:IApplicationContext = nice(IApplicationContext);
		var parentContext:IApplicationContext = nice(IApplicationContext);
		var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
		var parentEventBus = nice(IEventBus);
		var childEventBus:IEventBus = nice(IEventBus);
		mock(parentContext).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
		mock(childContext).getter("cache").returns(cache);
		mock(childContext).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
		mock(childContext).getter("eventBus").returns(childEventBus);
		mock(parentContext).getter("eventBus").returns(parentEventBus);

		mock(objectDefinitionsRegistry).getter("objectDefinitionNames").never();
		mock(cache).getter("getCachedNames").never();
		mock(parentEventBus).method("addListener").never();

		var settings:ContextShareSettings = new ContextShareSettings();
		settings.shareDefinitions = false;
		settings.shareSingletons = false;
		settings.shareProperties = false;
		settings.eventBusShareSettings.shareKind = EventBusShareKind.NONE;
		_childContextManager.addChildContext(parentContext, childContext, settings);

		verify(objectDefinitionsRegistry);
		verify(childObjectDefinitionRegistry);
		verify(propertiesProvider);
		verify(cache);
		verify(parentEventBus);
		verify(childEventBus);
		verify(parentContext);
		verify(childContext);
	}

[Test]
public function testAddChildContextWithDefinitionSharing():void {
	var childObjectFactory:IObjectFactory = nice(IObjectFactory);
	var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
	mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
	mock(objectFactory).getter("cache").returns(cache);
	mock(childObjectFactory).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
	var context:ApplicationContext = new ApplicationContext(null, objectFactory);
	var childContext:ApplicationContext = new ApplicationContext(null, childObjectFactory);
	eventBus = nice(IEventBus);
	var childEventBus:IEventBus = nice(IEventBus);

	context.eventBus = eventBus;
	childContext.eventBus = childEventBus;

	mock(objectDefinitionsRegistry).getter("objectDefinitionNames").returns(null).once();
	mock(cache).getter("getCachedNames").never();
	mock(eventBus).method("addListener").never();
	mock(childEventBus).method("addListener").never();

	var settings:ContextShareSettings = new ContextShareSettings();
	settings.shareDefinitions = true;
	settings.shareSingletons = false;
	settings.shareProperties = false;
	settings.eventBusShareSettings.shareKind = EventBusShareKind.NONE;
	context.addChildContext(childContext, settings);

	verify(objectDefinitionProvider);
	verify(cache);
	verify(eventBus);
	verify(childEventBus);
	assertEquals(1, context.childContexts.length);
}

[Test]
public function testAddChildContextWithSingletonSharing():void {
	var childObjectFactory:IObjectFactory = nice(IObjectFactory);
	var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
	mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
	mock(objectFactory).getter("cache").returns(cache);
	mock(childObjectFactory).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
	var context:ApplicationContext = new ApplicationContext(null, objectFactory);
	var childContext:ApplicationContext = new ApplicationContext(null, childObjectFactory);
	eventBus = nice(IEventBus);
	var childEventBus:IEventBus = nice(IEventBus);

	context.eventBus = eventBus;
	childContext.eventBus = childEventBus;

	mock(objectDefinitionsRegistry).getter("objectDefinitionNames").never();
	mock(cache).method("getCachedNames").returns(null).once();
	mock(eventBus).method("addListener").never();
	mock(childEventBus).method("addListener").never();

	var settings:ContextShareSettings = new ContextShareSettings();
	settings.shareDefinitions = false;
	settings.shareSingletons = true;
	settings.shareProperties = false;
	settings.eventBusShareSettings.shareKind = EventBusShareKind.NONE;
	context.addChildContext(childContext, settings);

	verify(objectDefinitionProvider);
	verify(cache);
	verify(eventBus);
	verify(childEventBus);
	assertEquals(1, context.childContexts.length);
}

[Test]
public function testAddChildContextWithPropertySharing():void {
	propertiesProvider = nice(IPropertiesProvider);
	var childPropertiesProvider:IPropertiesProvider = nice(IPropertiesProvider);
	var childObjectFactory:IObjectFactory = nice(IObjectFactory);
	var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
	mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
	mock(objectFactory).getter("cache").returns(cache);
	mock(objectFactory).getter("propertiesProvider").returns(propertiesProvider);
	mock(childObjectFactory).getter("propertiesProvider").returns(childPropertiesProvider);
	mock(childObjectFactory).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
	var context:ApplicationContext = new ApplicationContext(null, objectFactory);
	var childContext:ApplicationContext = new ApplicationContext(null, childObjectFactory);
	eventBus = nice(IEventBus);
	var childEventBus:IEventBus = nice(IEventBus);

	context.eventBus = eventBus;
	childContext.eventBus = childEventBus;

	mock(objectDefinitionsRegistry).getter("objectDefinitionNames").never();
	mock(cache).method("getCachedNames").returns(null).never();
	mock(eventBus).method("addListener").never();
	mock(childEventBus).method("addListener").never();

	var settings:ContextShareSettings = new ContextShareSettings();
	settings.shareDefinitions = false;
	settings.shareSingletons = false;
	settings.shareProperties = true;
	settings.eventBusShareSettings.shareKind = EventBusShareKind.NONE;
	context.addChildContext(childContext, settings);

	verify(objectDefinitionProvider);
	verify(cache);
	verify(eventBus);
	verify(childEventBus);
	verify(propertiesProvider);
	assertEquals(1, context.childContexts.length);
}

[Test]
public function testAddChildContextWithParentListensToChildEventBusSharing():void {
	var childObjectFactory:IObjectFactory = nice(IObjectFactory);
	var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
	mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
	mock(objectFactory).getter("cache").returns(cache);
	mock(childObjectFactory).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
	var context:ApplicationContext = new ApplicationContext(null, objectFactory);
	var childContext:ApplicationContext = new ApplicationContext(null, childObjectFactory);
	eventBus = nice(IEventBusAndListener);
	var childEventBus:IEventBusAndListener = nice(IEventBusAndListener);

	context.eventBus = eventBus;
	childContext.eventBus = childEventBus;

	mock(objectDefinitionsRegistry).getter("objectDefinitionNames").never();
	mock(cache).method("getCachedNames").never();
	mock(eventBus).method("addListener").never();
	mock(childEventBus).method("addListener").args(eventBus).once();

	var settings:ContextShareSettings = new ContextShareSettings();
	settings.shareDefinitions = false;
	settings.shareSingletons = false;
	settings.shareProperties = false;
	settings.eventBusShareSettings.shareKind = EventBusShareKind.PARENT_LISTENS_TO_CHILD;
	context.addChildContext(childContext, settings);

	verify(objectDefinitionProvider);
	verify(cache);
	verify(eventBus);
	verify(childEventBus);
	assertEquals(1, context.childContexts.length);
}

[Test]
public function testAddChildContextWithChildListensToParentEventBusSharing():void {
	var childObjectFactory:IObjectFactory = nice(IObjectFactory);
	var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
	mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
	mock(objectFactory).getter("cache").returns(cache);
	mock(childObjectFactory).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
	var context:ApplicationContext = new ApplicationContext(null, objectFactory);
	var childContext:ApplicationContext = new ApplicationContext(null, childObjectFactory);
	eventBus = nice(IEventBusAndListener);
	var childEventBus:IEventBusAndListener = nice(IEventBusAndListener);

	context.eventBus = eventBus;
	childContext.eventBus = childEventBus;

	mock(objectDefinitionsRegistry).getter("objectDefinitionNames").never();
	mock(cache).method("getCachedNames").never();
	mock(eventBus).method("addListener").args(childEventBus).once();
	mock(childEventBus).method("addListener").never();

	var settings:ContextShareSettings = new ContextShareSettings();
	settings.shareDefinitions = false;
	settings.shareSingletons = false;
	settings.shareProperties = false;
	settings.eventBusShareSettings.shareKind = EventBusShareKind.CHILD_LISTENS_TO_PARENT;
	context.addChildContext(childContext, settings);

	verify(objectDefinitionProvider);
	verify(cache);
	verify(eventBus);
	verify(childEventBus);
	assertEquals(1, context.childContexts.length);
}

[Test]
public function testAddChildContextWithBothWaysEventBusSharing():void {
	var childObjectFactory:IObjectFactory = nice(IObjectFactory);
	var childObjectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
	mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionsRegistry);
	mock(objectFactory).getter("cache").returns(cache);
	mock(childObjectFactory).getter("objectDefinitionRegistry").returns(childObjectDefinitionRegistry);
	var context:ApplicationContext = new ApplicationContext(null, objectFactory);
	var childContext:ApplicationContext = new ApplicationContext(null, childObjectFactory);
	eventBus = nice(IEventBusAndListener);
	var childEventBus:IEventBusAndListener = nice(IEventBusAndListener);

	context.eventBus = eventBus;
	childContext.eventBus = childEventBus;

	mock(objectDefinitionsRegistry).getter("objectDefinitionNames").never();
	mock(cache).method("getCachedNames").never();
	mock(eventBus).method("addListener").args(childEventBus).once();
	mock(childEventBus).method("addListener").args(eventBus).once();

	var settings:ContextShareSettings = new ContextShareSettings();
	settings.shareDefinitions = false;
	settings.shareSingletons = false;
	settings.shareProperties = false;
	settings.eventBusShareSettings.shareKind = EventBusShareKind.BOTH_WAYS;
	context.addChildContext(childContext, settings);

	verify(objectDefinitionProvider);
	verify(cache);
	verify(eventBus);
	verify(childEventBus);
	assertEquals(1, context.childContexts.length);
}*/

	}
}
