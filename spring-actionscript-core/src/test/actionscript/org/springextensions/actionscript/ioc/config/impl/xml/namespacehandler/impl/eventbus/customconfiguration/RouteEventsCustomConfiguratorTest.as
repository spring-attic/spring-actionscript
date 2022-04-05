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
	import flash.events.IEventDispatcher;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.notNullValue;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class RouteEventsCustomConfiguratorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var eventbusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var objectDefinition:IObjectDefinition;
		[Mock]
		public var eventDispatcher:IEventDispatcher;

		/**
		 * Creates a new <code>RouteEventsCustomConfiguratorTest</code> instance.
		 */
		public function RouteEventsCustomConfiguratorTest() {
			super();
		}

		[Test]
		public function testExecuteWithoutEventNames():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			eventDispatcher = nice(IEventDispatcher);
			mock(eventbusUserRegistry).method("addEventListeners").args(anything()).never();
			var config:RouteEventsCustomConfigurator = new RouteEventsCustomConfigurator(eventbusUserRegistry);
			config.execute(eventDispatcher, objectDefinition);
			verify(eventbusUserRegistry);
			assertTrue(true);
		}

		[Test]
		public function testExecuteWithEventNames():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			eventDispatcher = nice(IEventDispatcher);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "eventName";
			mock(eventbusUserRegistry).method("addEventListeners").args(eventDispatcher, names, null).once();
			var config:RouteEventsCustomConfigurator = new RouteEventsCustomConfigurator(eventbusUserRegistry, names);
			config.execute(eventDispatcher, objectDefinition);
			verify(eventbusUserRegistry);
			assertTrue(true);
		}

		[Test]
		public function testExecuteWithEventNamesAndTopics():void {
			eventbusUserRegistry = nice(IEventBusUserRegistry);
			eventDispatcher = nice(IEventDispatcher);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "eventName";
			var topics:Vector.<String> = new Vector.<String>();
			topics[topics.length] = "topic";
			mock(eventbusUserRegistry).method("addEventListeners").args(eventDispatcher, names, notNullValue()).once();
			var config:RouteEventsCustomConfigurator = new RouteEventsCustomConfigurator(eventbusUserRegistry, names, topics);
			config.execute(eventDispatcher, objectDefinition);
			verify(eventbusUserRegistry);
			assertTrue(true);
		}
	}
}
