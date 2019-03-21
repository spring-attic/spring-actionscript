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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser {
	import flash.system.ApplicationDomain;

	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.customconfiguration.FactoryObjectCustomConfigurator;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FactoryNodeParserTest {

		private static const TEST_XML:XML = new XML("<util:factory xmlns:util='http://www.springactionscript.org/schema/util' class='Object' factory-method='myMethod'/>");

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;
		[Mock]
		public var applicationContext:IApplicationContext;

		/**
		 * Creates a new <code>FactoryNodeParserTest</code> instance.
		 */
		public function FactoryNodeParserTest() {
			super();
		}

		[Test]
		public function testParse():void {
			var parser:FactoryNodeParser = new FactoryNodeParser(objectDefinitionRegistry, ApplicationDomain.currentDomain);
			var definition:IObjectDefinition = parser.parse(TEST_XML, new XMLObjectDefinitionsParser(applicationContext));
			assertNotNull(definition.customConfiguration);
			assertTrue(definition.customConfiguration is FactoryObjectCustomConfigurator);
			var cf:FactoryObjectCustomConfigurator = FactoryObjectCustomConfigurator(definition.customConfiguration);
			assertEquals("myMethod", cf.factoryMethod);
		}
	}
}
