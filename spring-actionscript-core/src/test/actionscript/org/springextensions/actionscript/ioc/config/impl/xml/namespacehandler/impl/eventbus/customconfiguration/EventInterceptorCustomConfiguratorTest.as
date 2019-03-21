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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration {
	import flash.events.Event;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.eventbus.IEventInterceptor;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventInterceptorCustomConfiguratorTest {
		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var eventbusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var objectDefinition:IObjectDefinition;
		[Mock]
		public var interceptor:IEventInterceptor;

		/**
		 * Creates a new <code>EventInterceptorCustomConfiguratorTest</code> instance.
		 */
		public function EventInterceptorCustomConfiguratorTest() {
			super();
		}

		[Test]
		public function testExecute():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addInterceptor").args(interceptor).once();
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithTopic():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addInterceptor").args(interceptor, "topic").once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry, null, null, topics);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		/*[Test]
		public function testExecuteWithTopicProperty():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addInterceptor").args(interceptor, "testTopicValue").once();
			mock(interceptor).getter("topic").returns("testTopicValue").once();
			var topicProperties:Vector.<String> = new Vector.<String>();
			topicProperties[topicProperties.length] = "topic";
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry, null, null, null, topicProperties);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}*/

		[Test]
		public function testExecuteWithEventName():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventInterceptor").args("eventName", interceptor).once();
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry, "eventName");
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventNameAndTopic():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventInterceptor").args("eventName", interceptor, "topic").once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry, "eventName", null, topics);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventClass():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassInterceptor").args(Event, interceptor).once();
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry, null, Event);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventClassAndTopic():void {
			interceptor = nice(IEventInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassInterceptor").args(Event, interceptor, "topic").once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventbusUserRegistry, null, Event, topics);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

	}
}
