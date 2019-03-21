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
	import flash.system.ApplicationDomain;

	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	public class ClassPropertyEditorTest {

		private var _editor:ClassPropertyEditor;

		public function ClassPropertyEditorTest() {
			super();
			_editor = new ClassPropertyEditor();
		}

		[Test]
		public function testWithExistingClassName():void {
			_editor.text = "flash.system.ApplicationDomain";
			assertStrictlyEquals(ApplicationDomain, _editor.value);
		}

		[Test(expects = "org.as3commons.lang.ClassNotFoundError")]
		public function testWithNonExistingClassName():void {
			_editor.text = "flash.generics.WishfulThinking";
		}
	}
}
