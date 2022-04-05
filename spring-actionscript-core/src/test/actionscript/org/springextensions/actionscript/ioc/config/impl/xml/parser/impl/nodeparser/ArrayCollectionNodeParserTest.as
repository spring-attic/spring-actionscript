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
package org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ArrayCollectionNodeParserTest {

		public static const SIMPLE_XML_TEST:XML = new XML("<array-collection/>");
		public static const XML_WITH_VALUETEST:XML = new XML("<array-collection><value>stringValue</value></array-collection>");

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var xmlParser:IXMLObjectDefinitionsParser;

		/**
		 * Creates a new <code>ArrayCollectionNodeParserTest</code> instance.
		 */
		public function ArrayCollectionNodeParserTest() {
			super();
		}

		[Test]
		public function testParseWithEmptyArrayCollection():void {
			var parser:ArrayCollectionNodeParser = new ArrayCollectionNodeParser(xmlParser);
			var result:* = parser.parse(SIMPLE_XML_TEST);
			assertTrue(result is ArrayCollection);
			var ac:ArrayCollection = result as ArrayCollection;
			assertEquals(0, ac.length);
		}

		[Test]
		public function testParseWithArrayCollectionWithOneItem():void {
			xmlParser = nice(IXMLObjectDefinitionsParser);
			mock(xmlParser).method("parsePropertyValue").args(anything()).returns("stringValue").once();
			var parser:ArrayCollectionNodeParser = new ArrayCollectionNodeParser(xmlParser);
			var result:* = parser.parse(XML_WITH_VALUETEST);
			assertTrue(result is ArrayCollection);
			var ac:ArrayCollection = result as ArrayCollection;
			assertEquals(1, ac.length);
			assertEquals("stringValue", ac[0]);
		}
	}
}
