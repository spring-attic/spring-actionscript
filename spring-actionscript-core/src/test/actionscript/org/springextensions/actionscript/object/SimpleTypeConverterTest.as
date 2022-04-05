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
package org.springextensions.actionscript.object {
	import flash.system.ApplicationDomain;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	public class SimpleTypeConverterTest {

		private var _converter:SimpleTypeConverter;

		public function SimpleTypeConverterTest() {
			super();
			_converter = new SimpleTypeConverter(ApplicationDomain.currentDomain);
		}

		[Test]
		public function testConvertIfNecessaryForTrueValueLowerCase():void {
			var result:* = _converter.convertIfNecessary("true");
			assertTrue(result);
		}

		[Test]
		public function testConvertIfNecessaryForTrueValueUpperCase():void {
			var result:* = _converter.convertIfNecessary("TRUE");
			assertTrue(result);
		}


		[Test]
		public function testConvertIfNecessaryForFalseValueLowerCase():void {
			var result:* = _converter.convertIfNecessary("false");
			assertFalse(result);
		}

		[Test]
		public function testConvertIfNecessaryForFalseValueUpperCase():void {
			var result:* = _converter.convertIfNecessary("FALSE");
			assertFalse(result);
		}

		[Test]
		public function testConvertIfNecessaryForNumber():void {
			var result:* = _converter.convertIfNecessary("100");
			assertTrue(result is Number);
			assertEquals(100, result);
		}

		[Test]
		public function testConvertIfNecessaryForNegativeNumber():void {
			var result:* = _converter.convertIfNecessary("-100");
			assertTrue(result is Number);
			assertEquals(-100, result);
		}

		[Test]
		public function testConvertIfNecessaryForFloat():void {
			var result:* = _converter.convertIfNecessary("100.11");
			assertTrue(result is Number);
			assertEquals(100.11, result);
		}

		[Test]
		public function testConvertIfNecessaryForNegativeFloat():void {
			var result:* = _converter.convertIfNecessary("-100.11");
			assertTrue(result is Number);
			assertEquals(-100.11, result);
		}


		[Test]
		public function testConvertIfNecessaryForString():void {
			var result:* = _converter.convertIfNecessary("test");
			assertTrue(result is String);
			assertEquals("test", result);
		}

		[Test]
		public function testConvertIfNecessaryForStringTatStartsWithInts():void {
			var result:* = _converter.convertIfNecessary("123test", String);
			assertTrue(result is String);
			assertEquals("123test", result);
		}

		[Test]
		public function testConvertIfNecessaryForClass():void {
			var result:* = _converter.convertIfNecessary("flash.system.ApplicationDomain", Class);
			assertTrue(result is Class);
			assertStrictlyEquals(ApplicationDomain, result);
		}
	}
}
