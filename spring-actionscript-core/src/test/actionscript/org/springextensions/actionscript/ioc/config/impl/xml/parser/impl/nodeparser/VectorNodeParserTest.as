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
	import flash.system.ApplicationDomain;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class VectorNodeParserTest {

		public static const STRING_VECTOR_XML:XML = new XML("<vector type='String'><value>stringValue</value></vector>");
		public static const OBJECT_VECTOR_XML:XML = new XML("<vector type='flash.system.ApplicationDomain'><object id='objectId'/></vector>");

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var xmlParser:IXMLObjectDefinitionsParser;

		/**
		 * Creates a new <code>VectorNodeParserTest</code> instance.
		 */
		public function VectorNodeParserTest() {
			super();
		}

		[Test]
		public function testParser():void {
			xmlParser = nice(IXMLObjectDefinitionsParser);
			mock(xmlParser).method("parsePropertyValue").args(anything()).returns("stringValue").once();
			var parser:VectorNodeParser = new VectorNodeParser(xmlParser, ApplicationDomain.currentDomain);
			var result:* = parser.parse(STRING_VECTOR_XML);
			verify(xmlParser);
			assertTrue(result is Vector.<*>);
			var vector:Vector.<*> = result as Vector.<*>;
			assertEquals(2, vector.length);
			assertStrictlyEquals(Vector.<String>, vector[0]);
			assertEquals("stringValue", vector[1]);
		}

		[Test]
		public function testParserWithObjectDefinitionAsValue():void {
			xmlParser = nice(IXMLObjectDefinitionsParser);
			mock(xmlParser).method("parsePropertyValue").args(anything()).never();
			var parser:VectorNodeParser = new VectorNodeParser(xmlParser, ApplicationDomain.currentDomain);
			var result:* = parser.parse(OBJECT_VECTOR_XML);
			verify(xmlParser);
			assertTrue(result is Vector.<*>);
			var vector:Vector.<*> = result as Vector.<*>;
			assertEquals(2, vector.length);
			assertStrictlyEquals(Vector.<ApplicationDomain>, vector[0]);
			assertTrue(vector[1] is RuntimeObjectReference);
			var ror:RuntimeObjectReference = vector[1];
			assertEquals("objectId", ror.objectName);
		}
	}
}
