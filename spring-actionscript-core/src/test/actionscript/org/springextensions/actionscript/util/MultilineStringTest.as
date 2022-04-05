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
package org.springextensions.actionscript.util {
	import org.flexunit.asserts.assertEquals;

	public class MultilineStringTest {

		public function MultilineStringTest() {
			super();
		}

		[Test]
		public function testWithSingleLine():void {
			var oneLine:String = "This is one line";
			var ms:MultilineString = new MultilineString(oneLine);
			assertEquals(1, ms.numLines);
			assertEquals(oneLine, ms.originalString);
			assertEquals(oneLine, ms.getLine(0));
		}

		[Test]
		public function testWithMultipleLinesWithWinBreak():void {
			var lines:String = "This is one line" + MultilineString.WIN_BREAK + "This is second line" + MultilineString.WIN_BREAK + "This is third line";
			var ms:MultilineString = new MultilineString(lines);
			assertEquals(3, ms.numLines);
			assertEquals(lines, ms.originalString);
			assertEquals("This is one line", ms.getLine(0));
			assertEquals("This is second line", ms.getLine(1));
			assertEquals("This is third line", ms.getLine(2));
		}

		[Test]
		public function testWithMultipleLinesWithMacBreak():void {
			var lines:String = "This is one line" + MultilineString.MAC_BREAK + "This is second line" + MultilineString.MAC_BREAK + "This is third line";
			var ms:MultilineString = new MultilineString(lines);
			assertEquals(3, ms.numLines);
			assertEquals(lines, ms.originalString);
			assertEquals("This is one line", ms.getLine(0));
			assertEquals("This is second line", ms.getLine(1));
			assertEquals("This is third line", ms.getLine(2));
		}

		[Test]
		public function testWithMultipleLinesWithMacAndWinBreakMixed():void {
			var lines:String = "This is one line" + MultilineString.WIN_BREAK + "This is second line" + MultilineString.MAC_BREAK + "This is third line";
			var ms:MultilineString = new MultilineString(lines);
			assertEquals(3, ms.numLines);
			assertEquals(lines, ms.originalString);
			assertEquals("This is one line", ms.getLine(0));
			assertEquals("This is second line", ms.getLine(1));
			assertEquals("This is third line", ms.getLine(2));
		}
	}
}
