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
package org.springextensions.actionscript.ioc.config.property.impl {
	import flash.events.Event;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;

	public class KeyValuePropertiesParserTest {

		private static const _hashCommentLine:String = "#this is a comment";
		private static const _hashCommentLineWithLeadingSpaces:String = "  #this is a comment";
		private static const _exclamationCommentLine:String = "!this is a comment";
		private static const _exclamationCommentLineWithLeadingSpaces:String = "  !this is a comment";
		private static const _testLinesWithEqualSign:Array = ['#this is a comment', 'property1=value1', 'property2=value2'];
		private static const _testLinesWithColon:Array = ['#this is a comment', 'property1:value1', 'property2:value2'];
		private static const _testLinesWithTab:Array = ['#this is a comment', 'property1	value1', 'property2	value2'];
		private static const _testLinesWithEqualSignAndCommentWithLeadingSpaces:Array = ['  #this is a comment', 'property1=value1', 'property2=value2'];
		private static const _testLinesWithEqualSignAndCommentWithTrailingBackSlashes:Array = ['  #this is a comment', 'property1=value1 \\\nvalue3', 'property2=value2'];

		private var _parser:KeyValuePropertiesParser;

		public function KeyValuePropertiesParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_parser = new KeyValuePropertiesParser();
		}

		[Test]
		public function testIsPropertyLineWithHashComment():void {
			assertFalse(_parser.isPropertyLine(_hashCommentLine));
		}

		[Test]
		public function testIsPropertyLineWithExclamationMarkComment():void {
			assertFalse(_parser.isPropertyLine(_exclamationCommentLine));
		}

		[Test]
		public function testParsePropertiesWithEqualsSignSeparator():void {
			var result:IPropertiesProvider = new Properties();
			_parser.parseProperties(_testLinesWithEqualSign.join("\n"), result);
			assertNotNull(result);
			assertTrue(result is Properties);
			assertEquals(2, result.length);
			assertEquals("value1", result.getProperty("property1"));
			assertEquals("value2", result.getProperty("property2"));
		}

		[Test]
		public function testParsePropertiesWithEqualsSignSeparatorAndCommentWithLeadingSpaces():void {
			var result:IPropertiesProvider = new Properties();
			_parser.parseProperties(_testLinesWithEqualSignAndCommentWithLeadingSpaces.join("\n"), result);
			assertNotNull(result);
			assertTrue(result is Properties);
			assertEquals(2, result.length);
			assertEquals("value1", result.getProperty("property1"));
			assertEquals("value2", result.getProperty("property2"));
		}

		[Test]
		public function testParsePropertiesWithColonSeparator():void {
			var result:IPropertiesProvider = new Properties();
			_parser.parseProperties(_testLinesWithColon.join("\n"), result);
			assertNotNull(result);
			assertTrue(result is Properties);
			assertEquals(2, result.length);
			assertEquals("value1", result.getProperty("property1"));
			assertEquals("value2", result.getProperty("property2"));
		}

		[Test]
		public function testParsePropertiesWithTabSeparator():void {
			var result:IPropertiesProvider = new Properties();
			_parser.parseProperties(_testLinesWithTab.join("\n"), result);
			assertNotNull(result);
			assertTrue(result is Properties);
			assertEquals(2, result.length);
			assertEquals("value1", result.getProperty("property1"));
			assertEquals("value2", result.getProperty("property2"));
		}

		[Test]
		public function testParsePropertiesWithEqualsSeparatorAndLineWithTrailingBackslahes():void {
			var result:IPropertiesProvider = new Properties();
			_parser.parseProperties(_testLinesWithEqualSignAndCommentWithTrailingBackSlashes.join("\n"), result);
			assertNotNull(result);
			assertTrue(result is Properties);
			assertEquals(2, result.length);
			assertEquals("value1 value3", result.getProperty("property1"));
			assertEquals("value2", result.getProperty("property2"));
		}
	}
}
