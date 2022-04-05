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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser {
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventListenerInterceptorCustomConfigurator;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventListenerInterceptorNodeParserTest extends NodeParserTestBase {
		public static const simpleEventInterceptorXML:XML = new XML('<eventbus:event-listener-interceptor xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:interception-configuration event-name="event1"/>' + //
			'</eventbus:event-listener-interceptor>');

		public static const simpleEventInterceptorWithTopicXML:XML = new XML('<eventbus:event-listener-interceptor xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:interception-configuration event-name="event1" topics="topic"/>' + //
			'</eventbus:event-listener-interceptor>');

		public static const simpleEventInterceptorWithTopicAndPropertiesXML:XML = new XML('<eventbus:event-listener-interceptor xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:interception-configuration  event-name="event1" topics="topic" topic-properties="prop1,prop2"/>' + //
			'</eventbus:event-listener-interceptor>');

		public static const simpleEventInterceptorWithClassAndMultipleMethodHandlersXML:XML = new XML('<eventbus:event-listener-interceptor xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:interception-configuration event-name="event1" topics="topic" topic-properties="prop1, prop2"/>' + //
			'<eventbus:interception-configuration event-class="flash.events.Event" topic-properties="topic" />' + //
			'</eventbus:event-listener-interceptor>');

		/**
		 * Creates a new <code>EventListenerInterceptorNodeParserTest</code> instance.
		 */
		public function EventListenerInterceptorNodeParserTest() {
			super();
		}

		[Test]
		public function testParseWithSimpleXML():void {
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			xmlParser = nice(IXMLObjectDefinitionsParser);
			objectDefinition = nice(IObjectDefinition);

			var configs:Vector.<Object> = new Vector.<Object>();

			mock(objectDefinitionRegistry).method("getCustomConfiguration").args("test").returns(configs).once();
			stub(objectDefinitionRegistry).method("registerCustomConfiguration").args(anything());

			var parser:EventListenerInterceptorNodeParser = new EventListenerInterceptorNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventInterceptorXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is EventListenerInterceptorCustomConfigurator);
			var config:EventListenerInterceptorCustomConfigurator = EventListenerInterceptorCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertNull(config.topics);
			assertNull(config.topicProperties);
			assertNull(config.eventClass);
		}

		[Test]
		public function testParseWithSimpleXMLWithTopic():void {
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			xmlParser = nice(IXMLObjectDefinitionsParser);
			objectDefinition = nice(IObjectDefinition);

			var configs:Vector.<Object> = new Vector.<Object>();

			mock(objectDefinitionRegistry).method("getCustomConfiguration").args("test").returns(configs).once();
			stub(objectDefinitionRegistry).method("registerCustomConfiguration").args(anything());

			var parser:EventListenerInterceptorNodeParser = new EventListenerInterceptorNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventInterceptorWithTopicXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is EventListenerInterceptorCustomConfigurator);
			var config:EventListenerInterceptorCustomConfigurator = EventListenerInterceptorCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertNotNull(config.topics);
			assertEquals(1, config.topics.length);
			assertEquals("topic", config.topics[0]);
			assertNull(config.topicProperties);
			assertNull(config.eventClass);
		}

		[Test]
		public function testParseWithSimpleXMLWithTopicAndProperties():void {
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			xmlParser = nice(IXMLObjectDefinitionsParser);
			objectDefinition = nice(IObjectDefinition);

			var configs:Vector.<Object> = new Vector.<Object>();

			mock(objectDefinitionRegistry).method("getCustomConfiguration").args("test").returns(configs).once();
			stub(objectDefinitionRegistry).method("registerCustomConfiguration").args(anything());

			var parser:EventListenerInterceptorNodeParser = new EventListenerInterceptorNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventInterceptorWithTopicAndPropertiesXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is EventListenerInterceptorCustomConfigurator);
			var config:EventListenerInterceptorCustomConfigurator = EventListenerInterceptorCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertNotNull(config.topics);
			assertEquals(1, config.topics.length);
			assertEquals("topic", config.topics[0]);
			assertNull(config.eventClass);
			assertNotNull(config.topicProperties);
			assertEquals("prop1", config.topicProperties[0]);
			assertEquals("prop2", config.topicProperties[1]);
		}

		[Test]
		public function testParseWithSimpleXMLWithClassNameAndMultipleMethodConfigs():void {
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			xmlParser = nice(IXMLObjectDefinitionsParser);
			objectDefinition = nice(IObjectDefinition);

			var configs:Vector.<Object> = new Vector.<Object>();

			mock(objectDefinitionRegistry).method("getCustomConfiguration").args("test").returns(configs).once();
			stub(objectDefinitionRegistry).method("registerCustomConfiguration").args(anything());

			var parser:EventListenerInterceptorNodeParser = new EventListenerInterceptorNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventInterceptorWithClassAndMultipleMethodHandlersXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(2, configs.length);
			assertTrue(configs[0] is EventListenerInterceptorCustomConfigurator);
			assertTrue(configs[1] is EventListenerInterceptorCustomConfigurator);

			var config:EventListenerInterceptorCustomConfigurator = EventListenerInterceptorCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertNotNull(config.topics);
			assertEquals(1, config.topics.length);
			assertEquals("topic", config.topics[0]);
			assertNull(config.eventClass);
			assertNotNull(config.topicProperties);
			assertEquals(2, config.topicProperties.length);
			assertEquals("prop1", config.topicProperties[0]);
			assertEquals("prop2", config.topicProperties[1]);

			config = EventListenerInterceptorCustomConfigurator(configs[1]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertNull(config.eventName);
			assertNull(config.topics);
			assertNotNull(config.eventClass);
			assertStrictlyEquals(Event, config.eventClass);
			assertNotNull(config.topicProperties);
			assertEquals(1, config.topicProperties.length);
			assertEquals("topic", config.topicProperties[0]);
		}

	}
}
