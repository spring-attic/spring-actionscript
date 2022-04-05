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

	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.test.testtypes.eventbus.TestEventHandler;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventHandlerCustomConfiguratorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var eventbusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var objectDefinition:IObjectDefinition;

		/**
		 * Creates a new <code>EventHandlerCustomConfiguratorTest</code> instance.
		 */
		public function EventHandlerCustomConfiguratorTest() {
			super();
		}

		[Test]
		public function testExecuteWithEventName():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventListenerProxy").args("eventName", anything(), false, null).returns(true).once();
			mock(objectDefinition).getter("clazz").returns(TestEventHandler).once();
			var config:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventbusUserRegistry, "methodHandler", "eventName");
			var handler:TestEventHandler = new TestEventHandler();
			config.execute(handler, objectDefinition);
			verify(eventbusUserRegistry);
			verify(objectDefinition);
		}

		[Test]
		public function testExecuteWithEventNameAndTopic():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventListenerProxy").args("eventName", anything(), false, "topic").returns(true).once();
			mock(objectDefinition).getter("clazz").returns(TestEventHandler).once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventbusUserRegistry, "methodHandler", "eventName", null, null, topics);
			var handler:TestEventHandler = new TestEventHandler();
			config.execute(handler, objectDefinition);
			verify(eventbusUserRegistry);
			verify(objectDefinition);
		}

		[Test]
		public function testExecuteWithEventNameAndTopicProperty():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventListenerProxy").args("eventName", anything(), false, "testTopicPropertyValue").returns(true).once();
			mock(objectDefinition).getter("clazz").returns(TestEventHandler).once();
			var topicProperties:Vector.<String> = new Vector.<String>();
			topicProperties[topicProperties.length] = "topic";
			var config:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventbusUserRegistry, "methodHandler", "eventName", null, null, null, topicProperties);
			var handler:TestEventHandler = new TestEventHandler();
			config.execute(handler, objectDefinition);
			verify(eventbusUserRegistry);
			verify(objectDefinition);
		}

		[Test]
		public function testExecuteWithEventClass():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassListenerProxy").args(Event, anything(), false, null).returns(true).once();
			mock(objectDefinition).getter("clazz").returns(TestEventHandler).once();
			var config:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventbusUserRegistry, "methodHandler", null, Event);
			var handler:TestEventHandler = new TestEventHandler();
			config.execute(handler, objectDefinition);
			verify(eventbusUserRegistry);
			verify(objectDefinition);
		}

		[Test]
		public function testExecuteWithEventClassAndTopic():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassListenerProxy").args(Event, anything(), false, "topic").returns(true).once();
			mock(objectDefinition).getter("clazz").returns(TestEventHandler).once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventbusUserRegistry, "methodHandler", null, Event, null, topics);
			var handler:TestEventHandler = new TestEventHandler();
			config.execute(handler, objectDefinition);
			verify(eventbusUserRegistry);
			verify(objectDefinition);
		}

		[Test]
		public function testExecuteWithEventClassAndTopicProperty():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassListenerProxy").args(Event, anything(), false, "testTopicPropertyValue").returns(true).once();
			mock(objectDefinition).getter("clazz").returns(TestEventHandler).once();
			var topicProperties:Vector.<String> = new Vector.<String>();
			topicProperties[topicProperties.length] = "topic";
			var config:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventbusUserRegistry, "methodHandler", null, Event, null, null, topicProperties);
			var handler:TestEventHandler = new TestEventHandler();
			config.execute(handler, objectDefinition);
			verify(eventbusUserRegistry);
			verify(objectDefinition);
		}
	}
}
