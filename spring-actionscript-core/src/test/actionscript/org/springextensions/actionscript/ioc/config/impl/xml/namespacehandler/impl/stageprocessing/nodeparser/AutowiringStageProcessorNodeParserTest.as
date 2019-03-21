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

	import flash.utils.getQualifiedClassName;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.lang.ClassUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.stage.DefaultAutowiringStageProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AutowiringStageProcessorNodeParserTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var definitionsParser:IXMLObjectDefinitionsParser;

		public static const SIMPLE_XML:XML = new XML("<stage:autowiringstageprocessor xmlns:stage='http://www.springactionscript.org/schema/stageprocessing'/>");
		public static const XMLWithObjectSelectorName:XML = new XML("<stage:autowiringstageprocessor xmlns:stage='http://www.springactionscript.org/schema/stageprocessing' object-selector='testName'/>");

		private var _parser:AutowiringStageProcessorNodeParser;
		private var _className:String = ClassUtils.getFullyQualifiedName(DefaultAutowiringStageProcessor, true);

		/**
		 * Creates a new <code>AutowiringStageProcessorNodeParserTest</code> instance.
		 */
		public function AutowiringStageProcessorNodeParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_parser = new AutowiringStageProcessorNodeParser();
		}

		[Test]
		public function testParseWithSimpleXML():void {
			definitionsParser = nice(IXMLObjectDefinitionsParser);
			mock(definitionsParser).method("parseConstructorArguments").args(anything(), SIMPLE_XML).once();
			mock(definitionsParser).method("parseMethodInvocations").args(anything(), SIMPLE_XML).once();
			mock(definitionsParser).method("parseProperties").args(anything(), SIMPLE_XML).once();
			var definition:IObjectDefinition = _parser.parse(SIMPLE_XML, definitionsParser);
			assertEquals(_className, definition.className);
			assertNull(definition.customConfiguration);
			verify(definitionsParser);
		}

		[Test]
		public function testParseWithXMLWithObjectSelectorName():void {
			definitionsParser = nice(IXMLObjectDefinitionsParser);
			mock(definitionsParser).method("parseConstructorArguments").args(anything(), XMLWithObjectSelectorName).once();
			mock(definitionsParser).method("parseMethodInvocations").args(anything(), XMLWithObjectSelectorName).once();
			mock(definitionsParser).method("parseProperties").args(anything(), XMLWithObjectSelectorName).once();
			var definition:IObjectDefinition = _parser.parse(XMLWithObjectSelectorName, definitionsParser);
			assertEquals(_className, definition.className);
			assertEquals('testName', definition.customConfiguration);
			verify(definitionsParser);
		}
	}
}
