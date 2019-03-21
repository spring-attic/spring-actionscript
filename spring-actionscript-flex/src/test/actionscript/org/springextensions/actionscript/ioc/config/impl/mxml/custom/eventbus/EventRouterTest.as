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
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.RouteEventsCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.test.testtypes.IApplicationContextEventBusRegistryAware;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventRouterTest {

		private var _router:EventRouter;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var applicationContext:IApplicationContextEventBusRegistryAware;
		[Mock]
		public var eventBusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;

		/**
		 * Creates a new <code>EventRouterTest</code> instance.
		 */
		public function EventRouterTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_router = new EventRouter();
			_router.childContent = [];
			_router.instance = "test";
			applicationContext = nice(IApplicationContextEventBusRegistryAware);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			stub(applicationContext).getter("eventBusUserRegistry").returns(eventBusUserRegistry);
			stub(applicationContext).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			stub(objectDefinitionRegistry).method("getCustomConfiguration").returns(new Vector.<Object>);
		}

		[Test]
		public function testExecuteWithOneRouting():void {
			var routingConfig:EventRouterConfiguration = new EventRouterConfiguration();
			routingConfig.eventNames = "complete,busy";
			routingConfig.topics = "topic1, topic2,topic3";
			routingConfig.topicProperties = "topicProperty1 ";
			mock(objectDefinitionRegistry).method("registerCustomConfiguration").args("test", anything()).callsWithArguments(function(... args):void {
				var configurators:Vector.<Object> = args[1];
				assertEquals(1, configurators.length);
				var configurator:RouteEventsCustomConfigurator = configurators[0];
				assertEquals(2, configurator.eventNames.length);
				assertEquals("complete", configurator.eventNames[0]);
				assertEquals("busy", configurator.eventNames[1]);
				assertEquals(3, configurator.topics.length);
				assertEquals("topic1", configurator.topics[0]);
				assertEquals("topic2", configurator.topics[1]);
				assertEquals("topic3", configurator.topics[2]);
				assertEquals(1, configurator.topicProperties.length);
				assertEquals("topicProperty1", configurator.topicProperties[0]);
			}).once();
			_router.childContent[_router.childContent.length] = routingConfig;
			_router.execute(applicationContext, {});
			verify(objectDefinitionRegistry);
		}

		[Test]
		public function testExecuteWithTwoRoutings():void {
			var routingConfig:EventRouterConfiguration = new EventRouterConfiguration();
			routingConfig.eventNames = "complete,busy";
			routingConfig.topics = "topic1, topic2,topic3";
			routingConfig.topicProperties = "topicProperty1 ";
			_router.childContent[_router.childContent.length] = routingConfig;

			routingConfig = new EventRouterConfiguration();
			routingConfig.eventNames = "start";
			routingConfig.topics = " topic4";
			_router.childContent[_router.childContent.length] = routingConfig;

			mock(objectDefinitionRegistry).method("registerCustomConfiguration").args("test", anything()).callsWithArguments(function(... args):void {
				var configurators:Vector.<Object> = args[1];
				assertEquals(2, configurators.length);
				var configurator:RouteEventsCustomConfigurator = configurators[0];
				assertEquals(2, configurator.eventNames.length);
				assertEquals("complete", configurator.eventNames[0]);
				assertEquals("busy", configurator.eventNames[1]);
				assertEquals(3, configurator.topics.length);
				assertEquals("topic1", configurator.topics[0]);
				assertEquals("topic2", configurator.topics[1]);
				assertEquals("topic3", configurator.topics[2]);
				assertEquals(1, configurator.topicProperties.length);
				assertEquals("topicProperty1", configurator.topicProperties[0]);

				configurator = configurators[1];
				assertEquals(1, configurator.eventNames.length);
				assertEquals("start", configurator.eventNames[0]);
				assertEquals(1, configurator.topics.length);
				assertEquals("topic4", configurator.topics[0]);
			}).once();
			_router.execute(applicationContext, {});
			verify(objectDefinitionRegistry);
		}

	}
}
