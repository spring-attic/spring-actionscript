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

	public class PauseCommandNodeParserTest extends TestCase {

		private var _testPauseXML:XML = <pause-command duration="100" id="testid"/>;
		
		private var _testParser:PauseCommandNodeParser;

		public function PauseCommandNodeParserTest(methodName:String=null) {
			super(methodName);
			_testParser = new PauseCommandNodeParser();
		}
		
		public function testParseWithPauseCommandXML():void {
			var result:IObjectDefinition = _testParser.parse(_testPauseXML, new XMLObjectDefinitionsParser());
			assertNotNull(result);
			assertEquals("org.springextensions.actionscript.core.task.command.PauseCommand",result.className);
			assertEquals(1,result.constructorArguments.length);
			assertEquals(100,result.constructorArguments[0]);
		}

	}
}