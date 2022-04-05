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
package org.springextensions.actionscript.eventbus.impl {
import flash.events.Event;
import flash.events.IEventDispatcher;

import mockolate.mock;
import mockolate.nice;
import mockolate.runner.MockolateRule;
import mockolate.verify;

import org.as3commons.eventbus.IEventBus;
import org.as3commons.eventbus.IEventInterceptor;
import org.as3commons.eventbus.IEventListenerInterceptor;
import org.as3commons.reflect.MethodInvoker;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertStrictlyEquals;

/**
 *
 * @author Roland Zwaga
 * @productionversion SpringActionscript 2.0
 */
public class DefaultEventBusUserRegistryTest {

	private var _registry:DefaultEventBusUserRegistry;

	[Rule]
	public var mockolateRule:MockolateRule = new MockolateRule();

	[Mock(inject="false")]
	public var eventBus:IEventBus;

	[Mock(inject="false")]
	public var eventInterceptor:IEventInterceptor;

	[Mock]
	public var eventListenerInterceptor:IEventListenerInterceptor;
	[Mock]
	public var eventDispatcher:IEventDispatcher;

	/**
	 * Creates a new <code>DefaultEventBusUserRegistryTest</code> instance.
	 */
	public function DefaultEventBusUserRegistryTest() {
		super();
	}

	[Before]
	public function setUp():void {
		eventBus = nice(IEventBus);
		_registry = new DefaultEventBusUserRegistry(eventBus);
		assertStrictlyEquals(eventBus, _registry.eventBus);
	}

	[Test]
	public function testAddEventClassInterceptorWithoutTopic():void {
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventClassInterceptor").args(Event, eventInterceptor, null).once();
		_registry.addEventClassInterceptor(Event, eventInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(1, entry.classEntries.length);
		assertStrictlyEquals(Event, entry.classEntries[0].clazz);
		assertNull(entry.classEntries[0].topic);
	}

	[Test]
	public function testAddEventClassInterceptorWithTopic():void {
		var topic:Object = {};
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventClassInterceptor").args(Event, eventInterceptor, topic).once();
		_registry.addEventClassInterceptor(Event, eventInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(1, entry.classEntries.length);
		assertStrictlyEquals(Event, entry.classEntries[0].clazz);
		assertStrictlyEquals(topic, entry.classEntries[0].topic);
	}

	[Test]
	public function testAddEventClassListenerInterceptorWithoutTopic():void {
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventClassListenerInterceptor").args(Event, eventListenerInterceptor, null).once();
		_registry.addEventClassListenerInterceptor(Event, eventListenerInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(1, entry.classEntries.length);
		assertStrictlyEquals(Event, entry.classEntries[0].clazz);
		assertNull(entry.classEntries[0].topic);
	}

	[Test]
	public function testAddEventClassListenerInterceptorWithTopic():void {
		var topic:Object = {};
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventClassListenerInterceptor").args(Event, eventListenerInterceptor, topic).once();
		_registry.addEventClassListenerInterceptor(Event, eventListenerInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(1, entry.classEntries.length);
		assertStrictlyEquals(Event, entry.classEntries[0].clazz);
		assertStrictlyEquals(topic, entry.classEntries[0].topic);
	}

	[Test]
	public function testAddEventClassListenerProxyWithoutTopic():void {
		var obj:Object = {};
		obj.handler = new Function();
		var proxy:MethodInvoker = new MethodInvoker();
		proxy.target = obj;
		proxy.method = "handler";
		mock(eventBus).method("addEventClassListenerProxy").args(Event, proxy, false, null).once();
		_registry.addEventClassListenerProxy(Event, proxy);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[proxy];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(1, entry.classEntries.length);
		assertStrictlyEquals(Event, entry.classEntries[0].clazz);
		assertNull(entry.classEntries[0].topic);
	}

	[Test]
	public function testAddEventClassListenerProxyWithTopic():void {
		var topic:Object = {};
		var obj:Object = {};
		obj.handler = new Function();
		var proxy:MethodInvoker = new MethodInvoker();
		proxy.target = obj;
		proxy.method = "handler";
		mock(eventBus).method("addEventClassListenerProxy").args(Event, proxy, false, topic).once();
		_registry.addEventClassListenerProxy(Event, proxy, false, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[proxy];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(1, entry.classEntries.length);
		assertStrictlyEquals(Event, entry.classEntries[0].clazz);
		assertStrictlyEquals(topic, entry.classEntries[0].topic);
	}

	[Test]
	public function testAddEventInterceptorWithoutTopic():void {
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventInterceptor").args("testType", eventInterceptor, null).once();
		_registry.addEventInterceptor("testType", eventInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(1, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
		assertEquals("testType", entry.eventTypeEntries[0].eventType);
		assertNull(entry.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddEventInterceptorWithTopic():void {
		var topic:Object = {};
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventInterceptor").args("testType", eventInterceptor, topic).once();
		_registry.addEventInterceptor("testType", eventInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(1, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
		assertEquals("testType", entry.eventTypeEntries[0].eventType);
		assertStrictlyEquals(topic, entry.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddEventListenerInterceptorWithoutTopic():void {
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventListenerInterceptor").args("testType", eventListenerInterceptor, null).once();
		_registry.addEventListenerInterceptor("testType", eventListenerInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(1, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
		assertEquals("testType", entry.eventTypeEntries[0].eventType);
		assertNull(entry.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddEventListenerInterceptorWithTopic():void {
		var topic:Object = {};
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventListenerInterceptor").args("testType", eventListenerInterceptor, topic).once();
		_registry.addEventListenerInterceptor("testType", eventListenerInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(1, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
		assertEquals("testType", entry.eventTypeEntries[0].eventType);
		assertStrictlyEquals(topic, entry.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddEventListenerProxyWithoutTopic():void {
		var obj:Object = {};
		obj.handler = new Function();
		var mi:MethodInvoker = new MethodInvoker();
		mi.target = obj;
		mi.method = "handler";
		mock(eventBus).method("addEventListenerProxy").args("testType", mi, false, null).once();
		_registry.addEventListenerProxy("testType", mi);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[mi];
		assertEquals(1, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
		assertEquals("testType", entry.eventTypeEntries[0].eventType);
		assertNull(entry.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddEventListenerProxyWithTopic():void {
		var topic:Object = {};
		var obj:Object = {};
		obj.handler = new Function();
		var mi:MethodInvoker = new MethodInvoker();
		mi.target = obj;
		mi.method = "handler";
		mock(eventBus).method("addEventListenerProxy").args("testType", mi, false, topic).once();
		_registry.addEventListenerProxy("testType", mi, false, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[mi];
		assertEquals(1, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
		assertEquals("testType", entry.eventTypeEntries[0].eventType);
		assertStrictlyEquals(topic, entry.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddEventListenersWithoutTopics():void {
		var types:Vector.<String> = new Vector.<String>();
		types[types.length] = "type1";
		types[types.length] = "type2";
		eventDispatcher = nice(IEventDispatcher);
		mock(eventDispatcher).method("addEventListener").args("type1", _registry.rerouteToEventBus, false, 0, true).once();
		mock(eventDispatcher).method("addEventListener").args("type2", _registry.rerouteToEventBus, false, 0, true).once();
		_registry.addEventListeners(eventDispatcher, types, []);
		verify(eventDispatcher);
	}

	[Test]
	public function testAddInterceptorWithoutTopic():void {
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addInterceptor").args(eventInterceptor, null).once();
		_registry.addInterceptor(eventInterceptor);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(1, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
		assertNull(registryItem.eventTypeEntries[0].eventType);
		assertNull(registryItem.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddInterceptorWithTopic():void {
		var topic:Object = {};
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addInterceptor").args(eventInterceptor, topic).once();
		_registry.addInterceptor(eventInterceptor, topic);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(1, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
		assertNull(registryItem.eventTypeEntries[0].eventType);
		assertStrictlyEquals(topic, registryItem.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddListenerInterceptorWithoutTopic():void {
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addListenerInterceptor").args(eventListenerInterceptor, null).once();
		_registry.addListenerInterceptor(eventListenerInterceptor);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(1, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
		assertNull(registryItem.eventTypeEntries[0].eventType);
		assertNull(registryItem.eventTypeEntries[0].topic);
	}

	[Test]
	public function testAddListenerInterceptorWithTopic():void {
		var topic:Object = {};
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addListenerInterceptor").args(eventListenerInterceptor, topic).once();
		_registry.addListenerInterceptor(eventListenerInterceptor, topic);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(1, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
		assertNull(registryItem.eventTypeEntries[0].eventType);
		assertStrictlyEquals(topic, registryItem.eventTypeEntries[0].topic);
	}

	[Test]
	public function testRemoveEventClassInterceptorWithoutTopic():void {
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventClassInterceptor").args(Event, eventInterceptor, null).once();
		mock(eventBus).method("removeEventClassInterceptor").args(Event, eventInterceptor, null).once();
		_registry.addEventClassInterceptor(Event, eventInterceptor);
		_registry.removeEventClassInterceptor(Event, eventInterceptor);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(0, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
	}

	[Test]
	public function testRemoveEventClassInterceptorWithTopic():void {
		var topic:Object = {};
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventClassInterceptor").args(Event, eventInterceptor, topic).once();
		mock(eventBus).method("removeEventClassInterceptor").args(Event, eventInterceptor, topic).once();
		_registry.addEventClassInterceptor(Event, eventInterceptor, topic);
		_registry.removeEventClassInterceptor(Event, eventInterceptor, topic);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(0, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
	}

	[Test]
	public function testRemoveEventClassListenerInterceptorWithoutTopic():void {
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventClassListenerInterceptor").args(Event, eventListenerInterceptor, null).once();
		mock(eventBus).method("removeEventClassListenerInterceptor").args(Event, eventListenerInterceptor, null).once();
		_registry.addEventClassListenerInterceptor(Event, eventListenerInterceptor);
		_registry.removeEventClassListenerInterceptor(Event, eventListenerInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventClassListenerInterceptorWithTopic():void {
		var topic:Object = {};
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventClassListenerInterceptor").args(Event, eventListenerInterceptor, topic).once();
		mock(eventBus).method("removeEventClassListenerInterceptor").args(Event, eventListenerInterceptor, topic).once();
		_registry.addEventClassListenerInterceptor(Event, eventListenerInterceptor, topic);
		_registry.removeEventClassListenerInterceptor(Event, eventListenerInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventClassListenerProxyWithoutTopic():void {
		var obj:Object = {};
		obj.handler = new Function();
		var proxy:MethodInvoker = new MethodInvoker();
		proxy.target = obj;
		proxy.method = "handler";
		mock(eventBus).method("addEventClassListenerProxy").args(Event, proxy, false, null).once();
		mock(eventBus).method("removeEventClassListenerProxy").args(Event, proxy, null).once();
		_registry.addEventClassListenerProxy(Event, proxy);
		_registry.removeEventClassListenerProxy(Event, proxy);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[proxy];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventClassListenerProxyWithTopic():void {
		var topic:Object = {};
		var obj:Object = {};
		obj.handler = new Function();
		var proxy:MethodInvoker = new MethodInvoker();
		proxy.target = obj;
		proxy.method = "handler";
		mock(eventBus).method("addEventClassListenerProxy").args(Event, proxy, false, topic).once();
		mock(eventBus).method("removeEventClassListenerProxy").args(Event, proxy, topic).once();
		_registry.addEventClassListenerProxy(Event, proxy, false, topic);
		_registry.removeEventClassListenerProxy(Event, proxy, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[proxy];
		assertNotNull(entry);
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventInterceptorWithoutTopic():void {
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventInterceptor").args("testType", eventInterceptor, null).once();
		mock(eventBus).method("removeEventInterceptor").args("testType", eventInterceptor, null).once();
		_registry.addEventInterceptor("testType", eventInterceptor);
		_registry.removeEventInterceptor("testType", eventInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventInterceptorWithTopic():void {
		var topic:Object = {};
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addEventInterceptor").args("testType", eventInterceptor, topic).once();
		mock(eventBus).method("removeEventInterceptor").args("testType", eventInterceptor, topic).once();
		_registry.addEventInterceptor("testType", eventInterceptor, topic);
		_registry.removeEventInterceptor("testType", eventInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventListenerInterceptorWithoutTopic():void {
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventListenerInterceptor").args("testType", eventListenerInterceptor, null).once();
		mock(eventBus).method("removeEventListenerInterceptor").args("testType", eventListenerInterceptor, null).once();
		_registry.addEventListenerInterceptor("testType", eventListenerInterceptor);
		_registry.removeEventListenerInterceptor("testType", eventListenerInterceptor);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventListenerInterceptorWithTopic():void {
		var topic:Object = {};
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addEventListenerInterceptor").args("testType", eventListenerInterceptor, topic).once();
		mock(eventBus).method("removeEventListenerInterceptor").args("testType", eventListenerInterceptor, topic).once();
		_registry.addEventListenerInterceptor("testType", eventListenerInterceptor, topic);
		_registry.removeEventListenerInterceptor("testType", eventListenerInterceptor, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventListenerProxyWithoutTopic():void {
		var obj:Object = {};
		obj.handler = new Function();
		var mi:MethodInvoker = new MethodInvoker();
		mi.target = obj;
		mi.method = "handler";
		mock(eventBus).method("addEventListenerProxy").args("testType", mi, false, null).once();
		mock(eventBus).method("removeEventListenerProxy").args("testType", mi, null).once();
		_registry.addEventListenerProxy("testType", mi);
		_registry.removeEventListenerProxy("testType", mi);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[mi];
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveEventListenerProxyWithTopic():void {
		var topic:Object = {};
		var obj:Object = {};
		obj.handler = new Function();
		var mi:MethodInvoker = new MethodInvoker();
		mi.target = obj;
		mi.method = "handler";
		mock(eventBus).method("addEventListenerProxy").args("testType", mi, false, topic).once();
		mock(eventBus).method("removeEventListenerProxy").args("testType", mi, topic).once();
		_registry.addEventListenerProxy("testType", mi, false, topic);
		_registry.removeEventListenerProxy("testType", mi, topic);
		verify(eventBus);
		var entry:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[mi];
		assertEquals(0, entry.eventTypeEntries.length);
		assertEquals(0, entry.classEntries.length);
	}

	[Test]
	public function testRemoveInterceptorWithoutTopic():void {
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addInterceptor").args(eventInterceptor, null).once();
		mock(eventBus).method("removeInterceptor").args(eventInterceptor, null).once();
		_registry.addInterceptor(eventInterceptor);
		_registry.removeInterceptor(eventInterceptor);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(0, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);

	}

	[Test]
	public function testRemoveInterceptorWithTopic():void {
		var topic:Object = {};
		eventInterceptor = nice(IEventInterceptor);
		mock(eventBus).method("addInterceptor").args(eventInterceptor, topic).once();
		mock(eventBus).method("removeInterceptor").args(eventInterceptor, topic).once();
		_registry.addInterceptor(eventInterceptor, topic);
		_registry.removeInterceptor(eventInterceptor, topic);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventInterceptor];
		assertEquals(0, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);

	}

	[Test]
	public function testRemoveListenerInterceptorWithoutTopic():void {
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addListenerInterceptor").args(eventListenerInterceptor, null).once();
		mock(eventBus).method("removeListenerInterceptor").args(eventListenerInterceptor, null).once();
		_registry.addListenerInterceptor(eventListenerInterceptor);
		_registry.removeListenerInterceptor(eventListenerInterceptor);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(0, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
	}

	[Test]
	public function testRemoveListenerInterceptorWithTopic():void {
		var topic:Object = {};
		eventListenerInterceptor = nice(IEventListenerInterceptor);
		mock(eventBus).method("addListenerInterceptor").args(eventListenerInterceptor, topic).once();
		mock(eventBus).method("removeListenerInterceptor").args(eventListenerInterceptor, topic).once();
		_registry.addListenerInterceptor(eventListenerInterceptor, topic);
		_registry.removeListenerInterceptor(eventListenerInterceptor, topic);
		verify(eventBus);
		var registryItem:EventBusRegistryEntry = _registry.eventBusRegistryEntryCache[eventListenerInterceptor];
		assertEquals(0, registryItem.eventTypeEntries.length);
		assertEquals(0, registryItem.classEntries.length);
	}

	[Test]
	public function testRemoveListenersWithoutTopic():void {
		var types:Vector.<String> = new Vector.<String>();
		types[types.length] = "type1";
		types[types.length] = "type2";
		eventDispatcher = nice(IEventDispatcher);
		mock(eventDispatcher).method("addEventListener").args("type1", _registry.rerouteToEventBus, false, 0, true).once();
		mock(eventDispatcher).method("addEventListener").args("type2", _registry.rerouteToEventBus, false, 0, true).once();
		mock(eventDispatcher).method("removeEventListener").args("type1", _registry.rerouteToEventBus).once();
		mock(eventDispatcher).method("removeEventListener").args("type2", _registry.rerouteToEventBus).once();
		_registry.addEventListeners(eventDispatcher, types, []);
		_registry.removeEventListeners(eventDispatcher);
		verify(eventDispatcher);
	}

	[Test]
	public function testClearAllProxyRegistrations():void {
		var topic:Object = {};
		var target:Object = {};

		var methodInvoker1:MethodInvoker = createMethodInvokerWithTarget(target, "handler1");
		var methodInvoker2:MethodInvoker = createMethodInvokerWithTarget({}, "handler2");
		var methodInvoker3:MethodInvoker = createMethodInvokerWithTarget({}, "handler3");
		var methodInvoker4:MethodInvoker = createMethodInvokerWithTarget(target, "handler4");
		var methodInvoker5:MethodInvoker = createMethodInvokerWithTarget(target, "handler5");
		var methodInvoker6:MethodInvoker = createMethodInvokerWithTarget({}, "handler6");
		var methodInvoker7:MethodInvoker = createMethodInvokerWithTarget({}, "handler7");
		var methodInvoker8:MethodInvoker = createMethodInvokerWithTarget({}, "handler8");
		var methodInvoker9:MethodInvoker = createMethodInvokerWithTarget({}, "handler9");
		var methodInvoker10:MethodInvoker = createMethodInvokerWithTarget({}, "handler10");
		var methodInvoker11:MethodInvoker = createMethodInvokerWithTarget(target, "handler11");
		var methodInvoker12:MethodInvoker = createMethodInvokerWithTarget(target, "handler12");

		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker1, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker2, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker3, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker4, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker5, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker6, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker7, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker8, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker9, false, topic).once();
		mock(eventBus).method("addEventListenerProxy").args("testType", methodInvoker10, false, topic).once();

		mock(eventBus).method("removeEventListenerProxy").args("testType", methodInvoker1, topic).once();
		mock(eventBus).method("removeEventListenerProxy").args("testType", methodInvoker4, topic).once();
		mock(eventBus).method("removeEventListenerProxy").args("testType", methodInvoker5, topic).once();
		mock(eventBus).method("removeEventListenerProxy").args("testType", methodInvoker11, topic).once();
		mock(eventBus).method("removeEventListenerProxy").args("testType", methodInvoker12, topic).once();

		_registry.addEventListenerProxy("testType", methodInvoker1, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker4, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker5, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker2, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker3, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker6, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker11, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker7, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker8, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker12, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker9, false, topic);
		_registry.addEventListenerProxy("testType", methodInvoker10, false, topic);

		_registry.clearAllProxyRegistrations(target);

		verify(eventBus);
	}

	private function createMethodInvokerWithTarget(target:Object, methodName:String):MethodInvoker {
		target.handler = new Function();

		var result:MethodInvoker = new MethodInvoker();
		result.target = target;
		result.method = methodName;

		return result;
	}
}
}
