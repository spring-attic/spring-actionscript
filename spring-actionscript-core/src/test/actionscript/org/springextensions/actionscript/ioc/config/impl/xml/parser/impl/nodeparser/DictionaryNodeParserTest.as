/*
 * Copyright 2007-2008 the original author or authors.
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

	import flash.utils.Dictionary;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.ApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;

	/**
	 * @author Christophe Herreman
	 */
	public class DictionaryNodeParserTest {

		private var _context:IApplicationContext;
		private var _parser:DictionaryNodeParser;

		public function DictionaryNodeParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_context = new ApplicationContext(null, new DefaultObjectFactory());
			_parser = new DictionaryNodeParser(new XMLObjectDefinitionsParser(_context));
		}

		[Test]
		public function testParse_shouldHaveKeysAsStrings():void {
			var result:Dictionary = _parser.parse(<dictionary>
					<entry>
						<key>a key</key>
						<value>a</value>
					</entry>
					<entry>
						<key>another key</key>
						<value>1</value>
					</entry>
				</dictionary>) as Dictionary;
			assertNotNull(result);
			//assertDictionaryKeysOfType(result, String);
			assertEquals("a", result["a key"]);
			assertEquals(1, result["another key"]);
		}

		[Test]
		public function testParse_shouldHaveKeysAsArrays():void {
			var result:Dictionary = _parser.parse(<dictionary>
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
				</dictionary>) as Dictionary;

			assertNotNull(result);
			//assertDictionaryKeysOfType(result, Array);
		}

		[Test]
		public function testParse_shouldAllowInlineAttributes():void {
			var result:Dictionary = _parser.parse(<dictionary>
					<entry key="a key" value="a" />
					<entry key="b key" value="b" />
				</dictionary>) as Dictionary;

			assertNotNull(result);
			assertEquals("a", result["a key"]);
			assertEquals("b", result["b key"]);
		}

		[Test]
		public function testParse_shouldHaveMixedKeysAndValues():void {
			var result:Dictionary = _parser.parse(<dictionary>
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
				</dictionary>) as Dictionary;

			assertNotNull(result);
			assertEquals("b", result["a"]);
			assertEquals(2, result[true].length);
		}

		[Test]
		public function testParse_shouldAllowInlineAttributesAndSubNodes():void {
			var result:Dictionary = _parser.parse(<dictionary>
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
				</dictionary>) as Dictionary;

			assertNotNull(result);
			assertEquals("a", result["a key"]);
			assertEquals("b", result["b key"]);
			assertEquals("c", result["c key"]);
			assertEquals("d", result["d key"]);
		}

		[Test]
		public function testParse_shouldAllowMapAsAlias():void {
			var result:Dictionary = _parser.parse(<map>
					<entry>
						<key>test key</key>
						<value>test value</value>
					</entry>
				</map>) as Dictionary;

			assertNotNull(result);
			assertEquals("test value", result["test key"]);
		}

	}
}
