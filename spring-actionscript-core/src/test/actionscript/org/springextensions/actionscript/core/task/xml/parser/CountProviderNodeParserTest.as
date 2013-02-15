/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.core.task.xml.parser {

	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class CountProviderNodeParserTest extends TestCase {
		
		private var _testParser:CountProviderNodeParser;
		
		private var _testCountProviderXML:XML = <count-provider count="10" id="testid"><ref>testid</ref></count-provider>;
		private var _testCountProviderWithoutCountXML:XML = <count-provider id="testid"><ref>testid</ref></count-provider>;

		public function CountProviderNodeParserTest(methodName:String=null) {
			super(methodName);
			_testParser = new CountProviderNodeParser();
		}

		public function testParseWithCountProviderXML():void {
			var result:IObjectDefinition = _testParser.parse(_testCountProviderXML, new XMLObjectDefinitionsParser());
			assertNotNull(result);
			assertEquals("org.springextensions.actionscript.core.task.support.CountProvider",result.className);
			assertEquals(1,result.constructorArguments.length);
			assertEquals(10,result.constructorArguments[0]);
		}

		public function testParseWithoutCountXML():void {
			var result:IObjectDefinition = _testParser.parse(_testCountProviderWithoutCountXML, new XMLObjectDefinitionsParser());
			assertNull(result);
		}

	}
}