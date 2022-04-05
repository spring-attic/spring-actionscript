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
	import flash.system.ApplicationDomain;

	import mockolate.ingredients.Invocation;
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.RouteEventsCustomConfigurator;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;


	public class EventRouterNodeParserTest extends NodeParserTestBase {

		public static const simpleRouteEventXML:XML = new XML('<eventbus:event-router xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:routing-configuration event-names="event1" topics="topic"/>' + //
			'</eventbus:event-router>');

		public static const multipleNamesAndTopicsRouteEventXML:XML = new XML('<eventbus:event-router xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:routing-configuration event-names="event1,event2, event3" topics="topic1, topic2,topic3"/>' + //
			'</eventbus:event-router>');

		public static const multipleConfigurationsRouteEventXML:XML = new XML('<eventbus:event-router xmlns:eventbus="http://www.springactionscript.org/schema/eventbus" instance="test">' + //
			'<eventbus:routing-configuration event-names="event1,event2, event3" topics="topic1, topic2,topic3"/>' + //
			'<eventbus:routing-configuration event-names="event4" topics="topic4"/>' + //
			'<eventbus:routing-configuration event-names="event5" topic-properties="property1"/>' + //
			'</eventbus:event-router>');

		public function EventRouterNodeParserTest() {
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

			var parser:EventRouterNodeParser = new EventRouterNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(simpleRouteEventXML, xmlParser);

			verify(objectDefinitionRegistry);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is RouteEventsCustomConfigurator);
			var configurator:RouteEventsCustomConfigurator = RouteEventsCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, configurator.eventBusUserRegistry);
			assertEquals(1, configurator.eventNames.length);
			assertEquals("event1", configurator.eventNames[0]);
			assertEquals(1, configurator.topics.length);
			assertEquals("topic", configurator.topics[0]);
			assertNull(configurator.topicProperties);
		}

		[Test]
		public function testParseWithMultipleNamesXML():void {
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			xmlParser = nice(IXMLObjectDefinitionsParser);
			objectDefinition = nice(IObjectDefinition);

			var configs:Vector.<Object> = new Vector.<Object>();

			mock(objectDefinitionRegistry).method("getCustomConfiguration").args("test").returns(configs).once();
			stub(objectDefinitionRegistry).method("registerCustomConfiguration").args(anything());

			var parser:EventRouterNodeParser = new EventRouterNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(multipleNamesAndTopicsRouteEventXML, xmlParser);

			verify(objectDefinitionRegistry);
			assertEquals(1, configs.length);
			assertTrue(configs[0] is RouteEventsCustomConfigurator);
			var configurator:RouteEventsCustomConfigurator = RouteEventsCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, configurator.eventBusUserRegistry);
			assertEquals(3, configurator.eventNames.length);
			assertEquals("event1", configurator.eventNames[0]);
			assertEquals("event2", configurator.eventNames[1]);
			assertEquals("event3", configurator.eventNames[2]);
			assertEquals(3, configurator.topics.length);
			assertEquals("topic1", configurator.topics[0]);
			assertEquals("topic2", configurator.topics[1]);
			assertEquals("topic3", configurator.topics[2]);
			assertNull(configurator.topicProperties);
		}

		[Test]
		public function testParseWithMultipleConfigurationsXML():void {
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			eventBusUserRegistry = nice(IEventBusUserRegistry);
			xmlParser = nice(IXMLObjectDefinitionsParser);
			objectDefinition = nice(IObjectDefinition);

			var configs:Vector.<Object> = new Vector.<Object>();

			mock(objectDefinitionRegistry).method("getCustomConfiguration").args("test").returns(configs).once();
			stub(objectDefinitionRegistry).method("registerCustomConfiguration").args(anything());

			var parser:EventRouterNodeParser = new EventRouterNodeParser(objectDefinitionRegistry, eventBusUserRegistry, ApplicationDomain.currentDomain);
			parser.parse(multipleConfigurationsRouteEventXML, xmlParser);

			verify(objectDefinitionRegistry);
			assertEquals(3, configs.length);
			assertTrue(configs[0] is RouteEventsCustomConfigurator);
			assertTrue(configs[1] is RouteEventsCustomConfigurator);
			assertTrue(configs[2] is RouteEventsCustomConfigurator);

			var configurator:RouteEventsCustomConfigurator = RouteEventsCustomConfigurator(configs[0]);
			assertStrictlyEquals(eventBusUserRegistry, configurator.eventBusUserRegistry);
			assertEquals(3, configurator.eventNames.length);
			assertEquals("event1", configurator.eventNames[0]);
			assertEquals("event2", configurator.eventNames[1]);
			assertEquals("event3", configurator.eventNames[2]);
			assertEquals(3, configurator.topics.length);
			assertEquals("topic1", configurator.topics[0]);
			assertEquals("topic2", configurator.topics[1]);
			assertEquals("topic3", configurator.topics[2]);
			assertNull(configurator.topicProperties);

			configurator = RouteEventsCustomConfigurator(configs[1]);
			assertStrictlyEquals(eventBusUserRegistry, configurator.eventBusUserRegistry);
			assertEquals(1, configurator.eventNames.length);
			assertEquals("event4", configurator.eventNames[0]);
			assertEquals(1, configurator.topics.length);
			assertEquals("topic4", configurator.topics[0]);
			assertNull(configurator.topicProperties);

			configurator = RouteEventsCustomConfigurator(configs[2]);
			assertStrictlyEquals(eventBusUserRegistry, configurator.eventBusUserRegistry);
			assertEquals(1, configurator.eventNames.length);
			assertEquals("event5", configurator.eventNames[0]);
			assertNull(configurator.topics);
			assertEquals(1, configurator.topicProperties.length);
			assertEquals("property1", configurator.topicProperties[0]);
		}
	}
}
