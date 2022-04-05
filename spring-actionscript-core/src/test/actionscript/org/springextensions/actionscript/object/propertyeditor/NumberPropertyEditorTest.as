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
package org.springextensions.actionscript.object.propertyeditor {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	public class NumberPropertyEditorTest {

		private var _editor:NumberPropertyEditor;

		public function NumberPropertyEditorTest() {
			super();
			_editor = new NumberPropertyEditor();
		}

		[Test]
		public function testWithInt():void {
			_editor.text = "100";
			assertEquals(100, _editor.value);
		}

		[Test]
		public function testWithNegativeInt():void {
			_editor.text = "-100";
			assertEquals(-100, _editor.value);
		}

		[Test]
		public function testWithFloat():void {
			_editor.text = "100.11";
			assertEquals(100.11, _editor.value);
		}

		[Test]
		public function testWithNegativeFloat():void {
			_editor.text = "-100.11";
			assertEquals(-100.11, _editor.value);
		}

		[Test]
		public function testWithWrongValue():void {
			_editor.text = "test";
			assertTrue(isNaN(_editor.value));
		}
	}
}
