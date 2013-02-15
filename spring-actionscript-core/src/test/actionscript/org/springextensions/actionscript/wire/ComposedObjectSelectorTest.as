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
	
	import org.springextensions.actionscript.objects.testclasses.DisplayContact;
	import org.springextensions.actionscript.stage.selectors.ClassBasedObjectSelector;
	import org.springextensions.actionscript.stage.selectors.ComposedObjectSelector;
	import org.springextensions.actionscript.stage.selectors.NameBasedObjectSelector;
	
	public class ComposedObjectSelectorTest extends TestCase {
		
		public function ComposedObjectSelectorTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testORApproval():void {
			
			var selector1:ClassBasedObjectSelector = new ClassBasedObjectSelector(
														["org.springextensions.*", "othername.*"],
														 true);
			var selector2:NameBasedObjectSelector = new NameBasedObjectSelector(
														["approve.*", "othername.*"]);
			var selectors:Array = [selector1, selector2];			
			var selector:ComposedObjectSelector = new ComposedObjectSelector(selectors, false);
			var textArea:TextArea = new TextArea();
			textArea.name = "approve";
			var contact:DisplayContact = new DisplayContact();
			contact.name = "whatever";
			assertTrue(selector.approve(textArea));
			assertTrue(selector.approve(contact));
		}
		
		public function testANDApproval():void {
			var selector1:ClassBasedObjectSelector = new ClassBasedObjectSelector(
														["org.springextensions.*", "othername.*"],
														 true);
			var selector2:NameBasedObjectSelector = new NameBasedObjectSelector(
														["approve.*", "othername.*"]);
			var selectors:Array = [selector1, selector2];			
			var selector:ComposedObjectSelector = new ComposedObjectSelector(selectors, true);
			var textArea:TextArea = new TextArea();
			textArea.name = "approve";
			var contact:DisplayContact = new DisplayContact();
			contact.name = "whatever";
			var contact2:DisplayContact = new DisplayContact();
			contact2.name = "approveThis";
			assertFalse(selector.approve(textArea));
			assertFalse(selector.approve(contact));
			assertTrue(selector.approve(contact2));
		}
		
	}
	
}