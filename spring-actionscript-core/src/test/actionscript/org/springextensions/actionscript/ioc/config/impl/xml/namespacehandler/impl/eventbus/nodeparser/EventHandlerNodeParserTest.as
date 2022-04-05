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
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventHandlerCustomConfigurator;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;


	public class EventHandlerNodeParserTest extends NodeParserTestBase {

		public static const simpleEventHandlerXML:XML = new XML('<eventbus:event-handler xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:event-handler-method event-name="event1" method-name="eventHandler"/>' + //
			'</eventbus:event-handler>');

		public static const simpleEventHandlerWithTopicXML:XML = new XML('<eventbus:event-handler xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:event-handler-method event-name="event1" method-name="eventHandler" topics="topic"/>' + //
			'</eventbus:event-handler>');

		public static const simpleEventHandlerWithTopicAndPropertiesXML:XML = new XML('<eventbus:event-handler xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:event-handler-method event-name="event1" method-name="eventHandler" topics="topic" properties="prop1, prop2"/>' + //
			'</eventbus:event-handler>');

		public static const simpleEventHandlerWithClassAndMultipleMethodHandlersXML:XML = new XML('<eventbus:event-handler xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:event-handler-method event-name="event1" method-name="eventHandler" topics="topic" properties="prop1, prop2"/>' + //
			'<eventbus:event-handler-method event-class="flash.events.Event" method-name="eventHandler" topic-properties="topic" />' + //
			'</eventbus:event-handler>');

		public function EventHandlerNodeParserTest() {
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

			var parser:EventHandlerNodeParser = new EventHandlerNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventHandlerXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is EventHandlerCustomConfigurator);
			var config:EventHandlerCustomConfigurator = EventHandlerCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertEquals("eventHandler", config.eventHandlerMethodName);
			assertNull(config.topics);
			assertNull(config.topicProperties);
			assertNull(config.properties);
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

			var parser:EventHandlerNodeParser = new EventHandlerNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventHandlerWithTopicXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is EventHandlerCustomConfigurator);
			var config:EventHandlerCustomConfigurator = EventHandlerCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertEquals("eventHandler", config.eventHandlerMethodName);
			assertNotNull(config.topics);
			assertEquals(1, config.topics.length);
			assertEquals("topic", config.topics[0]);
			assertNull(config.topicProperties);
			assertNull(config.properties);
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

			var parser:EventHandlerNodeParser = new EventHandlerNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventHandlerWithTopicAndPropertiesXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is EventHandlerCustomConfigurator);
			var config:EventHandlerCustomConfigurator = EventHandlerCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertEquals("eventHandler", config.eventHandlerMethodName);
			assertNotNull(config.topics);
			assertEquals(1, config.topics.length);
			assertEquals("topic", config.topics[0]);
			assertNull(config.topicProperties);
			assertNull(config.eventClass);
			assertNotNull(config.properties);
			assertEquals(2, config.properties.length);
			assertEquals("prop1", config.properties[0]);
			assertEquals("prop2", config.properties[1]);
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

			var parser:EventHandlerNodeParser = new EventHandlerNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleEventHandlerWithClassAndMultipleMethodHandlersXML, xmlParser);

			verify(objectDefinitionRegistry);
			verify(objectDefinition);
			assertEquals(2, configs.length);
			assertTrue(configs[0] is EventHandlerCustomConfigurator);
			assertTrue(configs[1] is EventHandlerCustomConfigurator);

			var config:EventHandlerCustomConfigurator = EventHandlerCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertEquals("event1", config.eventName);
			assertEquals("eventHandler", config.eventHandlerMethodName);
			assertNotNull(config.topics);
			assertEquals(1, config.topics.length);
			assertEquals("topic", config.topics[0]);
			assertNull(config.topicProperties);
			assertNull(config.eventClass);
			assertNotNull(config.properties);
			assertEquals(2, config.properties.length);
			assertEquals("prop1", config.properties[0]);
			assertEquals("prop2", config.properties[1]);

			config = EventHandlerCustomConfigurator(configs[1]);
			assertStrictlyEquals(eventBusUserRegistry, config.eventBusUserRegistry);
			assertNull(config.eventName);
			assertEquals("eventHandler", config.eventHandlerMethodName);
			assertNull(config.topics);
			assertNotNull(config.eventClass);
			assertStrictlyEquals(Event, config.eventClass);
			assertNull(config.properties);
			assertNotNull(config.topicProperties);
			assertEquals(1, config.topicProperties.length);
			assertEquals("topic", config.topicProperties[0]);
		}

	}
}
