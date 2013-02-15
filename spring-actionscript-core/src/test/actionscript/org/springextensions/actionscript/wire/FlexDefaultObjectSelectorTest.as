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

	import flash.display.Bitmap;
	
	import flexunit.framework.TestCase;
	
	import mx.controls.TextArea;
	
	import org.springextensions.actionscript.stage.FlexStageDefaultObjectSelector;
	import org.springextensions.actionscript.objects.testclasses.DisplayContact;
	import org.springextensions.actionscript.objects.testclasses.MyBitmap;
	
	public class FlexDefaultObjectSelectorTest extends TestCase {
		
		public function FlexDefaultObjectSelectorTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testMxComponent():void {
			var selector:FlexStageDefaultObjectSelector = new FlexStageDefaultObjectSelector();
			assertFalse(selector.approve(new TextArea()));
		}

		public function testFlashComponent():void {
			var selector:FlexStageDefaultObjectSelector = new FlexStageDefaultObjectSelector();
			assertFalse(selector.approve(new Bitmap()));
		}
		
		public function testCustomNonUIComponent():void {
			var selector:FlexStageDefaultObjectSelector = new FlexStageDefaultObjectSelector();
			assertFalse(selector.approve(new MyBitmap()));
		}
		
		public function testCustomUIComponent():void {
			var selector:FlexStageDefaultObjectSelector = new FlexStageDefaultObjectSelector();
			assertTrue(selector.approve(new DisplayContact()));
		}

	}
	
}