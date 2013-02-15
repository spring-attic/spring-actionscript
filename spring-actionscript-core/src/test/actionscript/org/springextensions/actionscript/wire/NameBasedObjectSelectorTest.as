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
package org.springextensions.actionscript.wire {

	import flexunit.framework.TestCase;
	
	import mx.controls.TextArea;
	
	import org.springextensions.actionscript.stage.selectors.NameBasedObjectSelector;
	
	public class NameBasedObjectSelectorTest extends TestCase {
		
		public function NameBasedObjectSelectorTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testApproveName():void {
			var selector:NameBasedObjectSelector = new NameBasedObjectSelector(["approve.*", "othername.*"]);
			var textArea:TextArea = new TextArea();
			textArea.name = "approveThis";
			var textArea2:TextArea = new TextArea();
			textArea2.name = "denyThis";
			assertTrue(selector.approve(textArea));
			assertFalse(selector.approve(textArea2));
		}

		public function testCustomNameProp():void {
			var selector:NameBasedObjectSelector = new NameBasedObjectSelector(
														["approve.*", "othername.*"],
														"text");
			var textArea:TextArea = new TextArea();
			textArea.text = "approveThis";
			var textArea2:TextArea = new TextArea();
			textArea2.text = "denyThis";
			assertTrue(selector.approve(textArea));
			assertFalse(selector.approve(textArea2));
		}
		
		public function testDenyName():void {
			var selector:NameBasedObjectSelector = new NameBasedObjectSelector(
														["deny.*", "othername.*"],
														"name", true);
			var textArea:TextArea = new TextArea();
			textArea.name = "approveThis";
			var textArea2:TextArea = new TextArea();
			textArea2.name = "denyThis";
			assertTrue(selector.approve(textArea));
			assertFalse(selector.approve(textArea2));
		}
		
	}
	
}