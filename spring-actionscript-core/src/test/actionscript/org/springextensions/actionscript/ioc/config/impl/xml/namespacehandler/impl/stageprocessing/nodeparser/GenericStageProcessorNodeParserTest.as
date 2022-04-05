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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.nodeparser {

	import mockolate.runner.MockolateRule;

	import org.as3commons.lang.ClassUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.stage.GenericStageProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class GenericStageProcessorNodeParserTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var definitionsParser:IXMLObjectDefinitionsParser;

		private var _parser:GenericStageProcessorNodeParser;
		private var _className:String = ClassUtils.getFullyQualifiedName(GenericStageProcessor, true);

		public static const SIMPLE_XML:XML = new XML("<stage:genericstageprocessor target-object='target' object-selector='selector' xmlns:stage='http://www.springactionscript.org/schema/stageprocessing'/>");
		public static const SIMPLE_XML_WITH_TARGET_PROPERTY:XML = new XML("<stage:genericstageprocessor target-object='target' target-property='testProperty' xmlns:stage='http://www.springactionscript.org/schema/stageprocessing'/>");
		public static const SIMPLE_XML_WITH_TARGET_METHOD:XML = new XML("<stage:genericstageprocessor target-object='target' target-method='testMethod' xmlns:stage='http://www.springactionscript.org/schema/stageprocessing'/>");

		/**
		 * Creates a new <code>GenericStageProcessorNodeParserTest</code> instance.
		 */
		public function GenericStageProcessorNodeParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_parser = new GenericStageProcessorNodeParser();
		}

		[Test]
		public function testParseWithSimpleXML():void {
			var definition:IObjectDefinition = _parser.parse(SIMPLE_XML, definitionsParser);
			assertNotNull(definition);
			assertEquals(_className, definition.className);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("targetObject");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.ref);
			var ref:RuntimeObjectReference = propDef.valueDefinition.ref;
			assertEquals('target', ref.objectName);
		}

		[Test]
		public function testParseObjectSelectorWithSimpleXML():void {
			var definition:IObjectDefinition = _parser.parse(SIMPLE_XML, definitionsParser);
			assertNotNull(definition);
			assertEquals('selector', definition.customConfiguration);
		}

		[Test]
		public function testParseWithSimpleXMLWithTargetProperty():void {
			var definition:IObjectDefinition = _parser.parse(SIMPLE_XML_WITH_TARGET_PROPERTY, definitionsParser);
			assertNotNull(definition);
			assertEquals(_className, definition.className);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("targetProperty");
			assertNotNull(propDef);
			assertEquals("testProperty", propDef.valueDefinition.value);
		}

		[Test]
		public function testParseWithSimpleXMLWithTargetMethod():void {
			var definition:IObjectDefinition = _parser.parse(SIMPLE_XML_WITH_TARGET_METHOD, definitionsParser);
			assertNotNull(definition);
			assertEquals(_className, definition.className);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("targetMethod");
			assertNotNull(propDef);
			assertEquals("testMethod", propDef.valueDefinition.value);
		}
	}
}
