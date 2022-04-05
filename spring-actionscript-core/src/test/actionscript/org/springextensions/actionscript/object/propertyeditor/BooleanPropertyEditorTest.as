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
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;


	public class BooleanPropertyEditorTest {

		private var _editor:BooleanPropertyEditor;

		public function BooleanPropertyEditorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_editor = new BooleanPropertyEditor();
		}

		[Test]
		public function testWithTrueValue():void {
			_editor.text = "true";
			assertTrue(_editor.value);
		}

		[Test]
		public function testWithUpperCaseTrueValue():void {
			_editor.text = "true";
			assertTrue(_editor.value);
		}

		[Test]
		public function testWithFalseValue():void {
			_editor.text = "false";
			assertFalse(_editor.value);
		}

		[Test]
		public function testWithUpperCaseFalseValue():void {
			_editor.text = "FALSE";
			assertFalse(_editor.value);
		}

		[Test]
		public function testWithWrongValue():void {
			_editor.text = "TEST";
			assertNull(_editor.value);
		}
	}
}
