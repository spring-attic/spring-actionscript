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
package integration.eventbus {
	import integration.testtypes.DummyEvent;
	import integration.testtypes.DummyEventInterceptor;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.impl.EventBus;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.impl.DefaultEventBusUserRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventBusUserRegistryIntegrationTest {

		private var _registry:IEventBusUserRegistry;
		private var _eventBus:IEventBus;

		/**
		 * Creates a new <code>EventBusUserRegistryIntegrationTest</code> instance.
		 */
		public function EventBusUserRegistryIntegrationTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_eventBus = new EventBus();
			_registry = new DefaultEventBusUserRegistry(_eventBus);
		}

		[Test]
		public function testAddEventClassInterceptorWithoutTopic():void {
			var eventInterceptor:DummyEventInterceptor = new DummyEventInterceptor();
			_registry.addEventClassInterceptor(DummyEvent, eventInterceptor);
			_eventBus.dispatchEvent(new DummyEvent(DummyEvent.TEST_TYPE));
			assertTrue(eventInterceptor.intercepted);
		}

		[Test]
		public function testAddEventClassInterceptorWithTopic():void {
			var topic:Object = {};
			var eventInterceptor:DummyEventInterceptor = new DummyEventInterceptor();
			_registry.addEventClassInterceptor(DummyEvent, eventInterceptor, topic);
			_eventBus.dispatchEvent(new DummyEvent(DummyEvent.TEST_TYPE));
			assertFalse(eventInterceptor.intercepted);
		}

		[Test]
		public function testAddEventClassInterceptorWithInterceptionTopic():void {
			var topic:Object = {};
			var eventInterceptor:DummyEventInterceptor = new DummyEventInterceptor();
			_registry.addEventClassInterceptor(DummyEvent, eventInterceptor, topic);
			_eventBus.dispatchEvent(new DummyEvent(DummyEvent.TEST_TYPE), topic);
			assertTrue(eventInterceptor.intercepted);
		}
	}
}
