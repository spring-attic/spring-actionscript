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

	import flash.text.TextField;

	import flexunit.framework.TestCase;
	
	import mx.controls.TextArea;
	
	import org.springextensions.actionscript.objects.testclasses.DisplayContact;
	import org.springextensions.actionscript.stage.selectors.ClassBasedObjectSelector;
	
	public class ClassBasedObjectSelectorTest extends TestCase {
		
		public function ClassBasedObjectSelectorTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testApproveClass():void {
			var selector:ClassBasedObjectSelector = new ClassBasedObjectSelector(
														["org.springextensions.*", "othername.*"],
														true);
			var textArea:TextArea = new TextArea();
			var contact:DisplayContact = new DisplayContact();
			assertFalse(selector.approve(textArea));
			assertTrue(selector.approve(contact));
		}
		
		public function testDenyClass():void {
			var selector:ClassBasedObjectSelector = new ClassBasedObjectSelector(["org.springextensions.*"]);
			var textArea:TextArea = new TextArea();
			var contact:DisplayContact = new DisplayContact();
			assertTrue(selector.approve(textArea));
			assertFalse(selector.approve(contact));
		}

		public function testApprove_shouldNotApproveWhenMatchingPartOfName():void {
			var selector:ClassBasedObjectSelector = new ClassBasedObjectSelector(["Fie"]);
			var textField:TextField = new TextField();
			var textArea:TextArea = new TextArea();
			assertFalse(selector.approve(textField));
			assertTrue(selector.approve(textArea));
		}

		public function testApprove_shouldNotApproveWhenMatchingEndOfName():void {
			var selector:ClassBasedObjectSelector = new ClassBasedObjectSelector(["Field$"]);
			var textField:TextField = new TextField();
			var textArea:TextArea = new TextArea();
			assertFalse(selector.approve(textField));
			assertTrue(selector.approve(textArea));
		}

		public function testApprove_shouldNotApproveWhenMatchingBeginOfName():void {
			var selector:ClassBasedObjectSelector = new ClassBasedObjectSelector(["^org.springextensions"]);
			var textArea:TextArea = new TextArea();
			var contact:DisplayContact = new DisplayContact();
			assertTrue(selector.approve(textArea));
			assertFalse(selector.approve(contact));
		}
		
	}
	
}