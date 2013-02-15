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
	
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class BlockNodeParserTest extends TestCase {
		
		private var _testParser:BlockNodeParser;
		
		private var _testWhileXML:XML = <while id="whileRef"><condition><ref>conditionRef</ref></condition></while>;
		
		private var _testForXML:XML = <for id="forRef"><count-provider><ref>countProviderRef</ref></count-provider></for>;

		public function BlockNodeParserTest(methodName:String=null) {
			super(methodName);
			_testParser = new BlockNodeParser();
		}
		
		public function testWhileParse():void {
			var result:IObjectDefinition = _testParser.parse(_testWhileXML, new XMLObjectDefinitionsParser());
			assertEquals("org.springextensions.actionscript.core.task.support.WhileBlock", result.className);
			assertEquals(1,result.constructorArguments.length);
			assertEquals(RuntimeObjectReference,ClassUtils.forInstance(result.constructorArguments[0]));
			assertEquals("conditionRef",RuntimeObjectReference(result.constructorArguments[0]).objectName);

		}

		public function testForParse():void {
			var result:IObjectDefinition = _testParser.parse(_testForXML, new XMLObjectDefinitionsParser());
			assertEquals("org.springextensions.actionscript.core.task.support.ForBlock", result.className);
			assertEquals(1,result.constructorArguments.length);
			assertEquals(RuntimeObjectReference,ClassUtils.forInstance(result.constructorArguments[0]));
			assertEquals("countProviderRef",RuntimeObjectReference(result.constructorArguments[0]).objectName);

		}

	}
}