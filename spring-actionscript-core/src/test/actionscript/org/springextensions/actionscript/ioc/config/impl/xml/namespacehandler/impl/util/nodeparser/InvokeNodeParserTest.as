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

	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	public class InvokeNodeParserTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var xmlParser:IXMLObjectDefinitionsParser;

		private var xml:XML = <util:invoke xmlns:util="http://www.springactionscript.org/schema/util" id="resourceManager" target-class="mx.resources.ResourceManager" target-method="getInstance"/>;

		public function InvokeNodeParserTest() {
			super();
		}

		[Test]
		public function testParse():void {
			var parser:InvokeNodeParser = new InvokeNodeParser();
			var definition:IObjectDefinition = parser.parse(xml, xmlParser);
			assertNotNull(definition);
			assertEquals('org.springextensions.actionscript.ioc.factory.impl.MethodInvokingFactoryObject', definition.className);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("targetClass");
			assertEquals('mx.resources.ResourceManager', propDef.valueDefinition.value);
			propDef = definition.getPropertyDefinitionByName("targetMethod");
			assertEquals('getInstance', propDef.valueDefinition.value);
		}

	}
}
