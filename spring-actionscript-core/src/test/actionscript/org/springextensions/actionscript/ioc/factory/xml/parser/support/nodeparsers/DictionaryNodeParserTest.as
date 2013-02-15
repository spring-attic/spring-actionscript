/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers {

	import flash.utils.Dictionary;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class DictionaryNodeParserTest extends FlexUnitTestCase {

		private var _context:IApplicationContext;
		private var _parser:DictionaryNodeParser;

		public function DictionaryNodeParserTest(methodName:String=null) {
			super(methodName);
		}


		override public function setUp():void {
			super.setUp();

			_context = new AbstractApplicationContext();
			_parser = new DictionaryNodeParser(new XMLObjectDefinitionsParser(_context));
		}

		public function testParse_shouldHaveKeysAsStrings():void {
			var result:Dictionary = _parser.parse(
				<dictionary>
				<entry>
					<key>a key</key>
					<value>a</value>
				</entry>
				<entry>
					<key>another key</key>
					<value>1</value>
				</entry>
				</dictionary>
			) as Dictionary;
			assertNotNull(result);
			assertDictionaryKeysOfType(result, String);
			assertEquals("a", result["a key"]);
			assertEquals(1, result["another key"]);
		}
	
		public function testParse_shouldHaveKeysAsArrays():void {
			var result:Dictionary = _parser.parse(
				<dictionary>
				<entry>
					<key>
					<array>
						<value>a</value>
					</array>
					</key>
					<value>a</value>
				</entry>
				<entry>
					<key>
					<array>
						<value>b</value>
						<value>c</value>
					</array>
					</key>
					<value>1</value>
				</entry>
				</dictionary>
			) as Dictionary;
		
			assertNotNull(result);
			assertDictionaryKeysOfType(result, Array);
		}
	
		public function testParse_shouldAllowInlineAttributes():void {
			var result:Dictionary = _parser.parse(
				<dictionary>
					<entry key="a key" value="a" />
					<entry key="b key" value="b" />
				</dictionary>
			) as Dictionary;
		
			assertNotNull(result);
			assertEquals("a", result["a key"]);
			assertEquals("b", result["b key"]);
		}
	
		public function testParse_shouldHaveMixedKeysAndValues():void {
			var result:Dictionary = _parser.parse(
				<dictionary>
				<entry>
					<key>a</key>
					<value>b</value>
				</entry>
				<entry>
					<key>true</key>
					<value>
					<array>
						<value>b</value>
						<value>c</value>
					</array>
					</value>
				</entry>
				</dictionary>
			) as Dictionary;
		
			assertNotNull(result);
			assertEquals("b", result["a"]);
			assertEquals(2, result[true].length);
		}
		
		public function testParse_shouldAllowInlineAttributesAndSubNodes():void {
			var result:Dictionary = _parser.parse(
				<dictionary>
					<entry key="a key" value="a" />
					<entry>
						<key>b key</key>
						<value>b</value>
					</entry>
					<entry value="c" key="c key"/>
					<entry>
						<value>d</value>
						<key>d key</key>
					</entry>
				</dictionary>
			) as Dictionary;
		
			assertNotNull(result);
			assertEquals("a", result["a key"]);
			assertEquals("b", result["b key"]);
			assertEquals("c", result["c key"]);
			assertEquals("d", result["d key"]);
		}
		
		public function testParse_shouldAllowMapAsAlias():void {
			var result:Dictionary = _parser.parse(
				<map>
					<entry>
						<key>test key</key>
						<value>test value</value>
					</entry>
				</map>
			) as Dictionary;
			
			assertNotNull(result);
			assertEquals("test value", result["test key"]);
		}
	
	}
}
