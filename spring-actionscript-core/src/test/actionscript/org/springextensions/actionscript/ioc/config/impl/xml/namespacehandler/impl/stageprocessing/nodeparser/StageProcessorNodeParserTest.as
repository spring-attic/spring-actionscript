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
	import flash.errors.IllegalOperationError;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.test.testtypes.Person;
	import org.springextensions.actionscript.test.testtypes.stage.DummyStageProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StageProcessorNodeParserTest {

		public static const SIMPLE_XML:XML = new XML("<stage:stageprocessor xmlns:stage='http://www.springactionscript.org/schema/stageprocessing' class='org.springextensions.actionscript.test.testtypes.stage.DummyStageProcessor' object-selector='selector'/>");
		public static const ILLEGAL_XML:XML = new XML("<stage:stageprocessor xmlns:stage='http://www.springactionscript.org/schema/stageprocessing' class='org.springextensions.actionscript.test.testtypes.Person' object-selector='selector'/>");

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var definitionsParser:IXMLObjectDefinitionsParser;

		private var _parser:StageProcessorNodeParser;

		{
			DummyStageProcessor;
			Person;
		}

		/**
		 * Creates a new <code>StageProcessorNodeParserTest</code> instance.
		 */
		public function StageProcessorNodeParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_parser = new StageProcessorNodeParser();
		}

		[Test]
		public function testParseWithSimpleXML():void {
			definitionsParser = nice(IXMLObjectDefinitionsParser);
			mock(definitionsParser).method("parseConstructorArguments").args(anything(), SIMPLE_XML).once();
			mock(definitionsParser).method("parseMethodInvocations").args(anything(), SIMPLE_XML).once();
			mock(definitionsParser).method("parseProperties").args(anything(), SIMPLE_XML).once();
			var definition:IObjectDefinition = _parser.parse(SIMPLE_XML, definitionsParser);
			assertNotNull(definition);
			assertEquals('org.springextensions.actionscript.test.testtypes.stage.DummyStageProcessor', definition.className);
			assertEquals('selector', definition.customConfiguration);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function testParseWithIllegalXML():void {
			definitionsParser = nice(IXMLObjectDefinitionsParser);
			var definition:IObjectDefinition = _parser.parse(ILLEGAL_XML, definitionsParser);
		}
	}
}
