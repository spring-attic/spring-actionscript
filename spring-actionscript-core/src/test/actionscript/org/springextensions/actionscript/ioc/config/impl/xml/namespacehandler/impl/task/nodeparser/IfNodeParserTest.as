/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser {

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	public class IfNodeParserTest {

		private var _testParser:IfNodeParser;

		private var _ifXML:XML = <if id="ifTest"><condition><ref>conditionRef</ref></condition></if>;

		public function IfNodeParserTest() {
			super();
			_testParser = new IfNodeParser();
		}

		[Test]
		public function testParse():void {
			var result:IObjectDefinition = _testParser.parse(_ifXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.IfElseBlock", result.className);
			assertEquals(1, result.constructorArguments.length);
			assertNotNull(result.constructorArguments[0].ref);
			assertEquals("conditionRef", result.constructorArguments[0].ref.objectName);
		}

	}
}
