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

	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventListenerInterceptorCustomConfiguratorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var eventbusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var objectDefinition:IObjectDefinition;
		[Mock]
		public var interceptor:IEventListenerInterceptor;

		/**
		 * Creates a new <code>EventListenerInterceptorCustomConfiguratorTest</code> instance.
		 */
		public function EventListenerInterceptorCustomConfiguratorTest() {
			super();
		}

		[Test]
		public function testExecute():void {
			interceptor = nice(IEventListenerInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addListenerInterceptor").args(interceptor).once();
			var config:EventListenerInterceptorCustomConfigurator = new EventListenerInterceptorCustomConfigurator(eventbusUserRegistry);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithTopic():void {
			interceptor = nice(IEventListenerInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addListenerInterceptor").args(interceptor, "topic").once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventListenerInterceptorCustomConfigurator = new EventListenerInterceptorCustomConfigurator(eventbusUserRegistry, null, null, topics);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventName():void {
			interceptor = nice(IEventListenerInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventListenerInterceptor").args("eventName", interceptor).once();
			var config:EventListenerInterceptorCustomConfigurator = new EventListenerInterceptorCustomConfigurator(eventbusUserRegistry, "eventName");
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventNameAndTopic():void {
			interceptor = nice(IEventListenerInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventListenerInterceptor").args("eventName", interceptor, "topic").once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventListenerInterceptorCustomConfigurator = new EventListenerInterceptorCustomConfigurator(eventbusUserRegistry, "eventName", null, topics);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventClass():void {
			interceptor = nice(IEventListenerInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassListenerInterceptor").args(Event, interceptor).once();
			var config:EventListenerInterceptorCustomConfigurator = new EventListenerInterceptorCustomConfigurator(eventbusUserRegistry, null, Event);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}

		[Test]
		public function testExecuteWithEventClassAndTopic():void {
			interceptor = nice(IEventListenerInterceptor);
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			mock(eventbusUserRegistry).method("addEventClassListenerInterceptor").args(Event, interceptor, "topic").once();
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			var config:EventListenerInterceptorCustomConfigurator = new EventListenerInterceptorCustomConfigurator(eventbusUserRegistry, null, Event, topics);
			config.execute(interceptor, objectDefinition);
			verify(eventbusUserRegistry);
		}
	}
}
