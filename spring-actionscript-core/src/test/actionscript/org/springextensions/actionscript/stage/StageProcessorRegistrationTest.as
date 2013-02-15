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
package org.springextensions.actionscript.stage {
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.stage.mocks.MockStageProcessor;

	public class StageProcessorRegistrationTest extends FlexUnitTestCase {

		public function StageProcessorRegistrationTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testConstructorWithoutArguments():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			assertEquals(sr.names.length,0);
		}

		public function testConstructorWithArguments():void {
			var sp:MockStageProcessor = new MockStageProcessor();
			var sr:StageProcessorRegistration = new StageProcessorRegistration("testName",sp,sp.objectSelector);
			assertEquals(sr.names.length,1);
			assertEquals(sr.names[0],"testname");
		}

		public function testAddStageProcessor():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var sp:MockStageProcessor = new MockStageProcessor();
			sr.addStageProcessor("testName1",sp,sp.objectSelector);
			sp = new MockStageProcessor();
			sr.addStageProcessor("testName2",sp,sp.objectSelector);
			assertEquals(sr.names.length,2);
			assertEquals(sr.names[0],"testname1");
			assertEquals(sr.names[1],"testname2");
		}
		
		public function testGetStageProcessorsByType():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var sp:MockStageProcessor = new MockStageProcessor();
			sr.addStageProcessor("testName1",sp,sp.objectSelector);
			sp = new MockStageProcessor();
			sr.addStageProcessor("testName2",sp,sp.objectSelector);
			var arr:Array = sr.getProcessorsByType(MockStageProcessor);
			assertEquals(2,arr.length);
		}

		public function testAddStageProcessorReplaceProcessorWithSameName():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var mi1:MockStageProcessor = new MockStageProcessor();
			sr.addStageProcessor("testName",mi1,mi1.objectSelector);
			assertEquals(sr.names.length,1);
			assertEquals(sr.names[0],"testname");
			assertEquals(sr.processors["testname"][0],mi1);

			var mi2:MockStageProcessor = new MockStageProcessor();
			sr.addStageProcessor("testName",mi2,mi2.objectSelector);
			assertEquals(sr.names.length,1);
			assertEquals(sr.names[0],"testname");
			assertEquals(sr.processors["testname"][0],mi2);
		}
		
		public function testHasProcessorWithName():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var mi1:MockStageProcessor = new MockStageProcessor();
			var document:Object = {};
			mi1.document = document;
			sr.addStageProcessor("testName",mi1,mi1.objectSelector);
			var result:Boolean = sr.hasProcessorWithName("testName",mi1);
			assertTrue(result);
			result = sr.hasProcessorWithName("testName",new MockStageProcessor());
			assertFalse(result);
		}
		
		public function testContainsProcessor():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var mi1:MockStageProcessor = new MockStageProcessor();
			sr.addStageProcessor("testName",mi1,mi1.objectSelector);

			var result:Boolean = sr.containsProcessor(mi1);
			
			assertTrue(result);
			
			result = sr.containsProcessor(new MockStageProcessor());
			
			assertFalse(result);
		}
		
		public function testGetProcessorsByDocument():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var mi1:MockStageProcessor = new MockStageProcessor();
			var document:Object = {};
			mi1.document = document;
			sr.addStageProcessor("testName",mi1,mi1.objectSelector);

			var result:Array = sr.getProcessorsByDocument(document);
			
			assertLength("result should have length of 1",1,result);
			assertArrayContains("result does not contain the required IStageProcessor",mi1,result);
			
			result = sr.getProcessorsByDocument({});
			assertNull(result);
		}
		
		public function testGetProcessorsByName():void {
			var sr:StageProcessorRegistration = new StageProcessorRegistration();
			var mi1:MockStageProcessor = new MockStageProcessor();
			var document:Object = {};
			mi1.document = document;
			sr.addStageProcessor("testName",mi1,mi1.objectSelector);

			var result:Array = sr.getProcessorsByName("testName");
			
			assertLength("result should have length of 1",1,result);
			assertArrayContains("result does not contain the required IStageProcessor",mi1,result);
			
			result = sr.getProcessorsByName("non-existant");
			assertNull(result);
		}
	}
}