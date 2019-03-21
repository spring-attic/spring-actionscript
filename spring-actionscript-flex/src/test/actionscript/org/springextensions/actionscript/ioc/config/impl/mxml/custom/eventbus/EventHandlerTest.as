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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventHandlerCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.test.testtypes.IApplicationContextEventBusRegistryAware;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventHandlerTest {

		private var _eventHandler:EventHandler;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContextEventBusRegistryAware;
		[Mock]
		public var eventBusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;

		/**
		 * Creates a new <code>EventHandlerTest</code> instance.
		 */
		public function EventHandlerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_eventHandler = new EventHandler();
			_eventHandler.childContent = [];
			_eventHandler.instance = "test";
			applicationContext = nice(IApplicationContextEventBusRegistryAware);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			stub(applicationContext).getter("eventBusUserRegistry").returns(eventBusUserRegistry);
			stub(applicationContext).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			stub(objectDefinitionRegistry).method("getCustomConfiguration").returns(new Vector.<Object>);
		}

		[Test]
		public function testExecuteWithOneMethodHandler():void {
			var handler:EventHandlerMethod = new EventHandlerMethod();
			handler.name = "testMethod";
			handler.properties = "property1,property2";
			handler.topics = "topic1, topic2,topic3";
			handler.topicProperties = "topicProperty1 ";
			mock(objectDefinitionRegistry).method("registerCustomConfiguration").args("test", anything()).callsWithArguments(function(... args):void {
				var configurators:Vector.<Object> = args[1];
				assertEquals(1, configurators.length);
				var configurator:EventHandlerCustomConfigurator = configurators[0];
				assertEquals("testMethod", configurator.eventHandlerMethodName);
				assertEquals(2, configurator.properties.length);
				assertEquals("property1", configurator.properties[0]);
				assertEquals("property2", configurator.properties[1]);
				assertEquals(3, configurator.topics.length);
				assertEquals("topic1", configurator.topics[0]);
				assertEquals("topic2", configurator.topics[1]);
				assertEquals("topic3", configurator.topics[2]);
				assertEquals(1, configurator.topicProperties.length);
				assertEquals("topicProperty1", configurator.topicProperties[0]);
			}).once();
			_eventHandler.childContent[_eventHandler.childContent.length] = handler;
			_eventHandler.execute(applicationContext, {});
			verify(objectDefinitionRegistry);
		}

		[Test]
		public function testExecuteWithTwoMethodHandler():void {
			var handler:EventHandlerMethod = new EventHandlerMethod();
			handler.name = "testMethod";
			_eventHandler.childContent[_eventHandler.childContent.length] = handler;
			handler = new EventHandlerMethod();
			handler.name = "testMethod2";
			_eventHandler.childContent[_eventHandler.childContent.length] = handler;
			mock(objectDefinitionRegistry).method("registerCustomConfiguration").args("test", anything()).callsWithArguments(function(... args):void {
				var configurators:Vector.<Object> = args[1];
				assertEquals(2, configurators.length);
				var configurator:EventHandlerCustomConfigurator = configurators[0];
				assertEquals("testMethod", configurator.eventHandlerMethodName);
				configurator = configurators[1];
				assertEquals("testMethod2", configurator.eventHandlerMethodName);
			}).once();
			_eventHandler.execute(applicationContext, {});
			verify(objectDefinitionRegistry);
		}
	}
}
