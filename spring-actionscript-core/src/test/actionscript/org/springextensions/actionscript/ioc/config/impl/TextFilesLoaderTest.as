/*
 * Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl {
	import flash.events.Event;

	import org.as3commons.async.operation.event.OperationEvent;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;

	public class TextFilesLoaderTest {

		private var _textFilesLoader:TextFilesLoader;
		private var _errorDispatched:Boolean;

		public function TextFilesLoaderTest() {
			super();
		}

		[Test(async)]
		public function testLoadSingleFile():void {
			_textFilesLoader = new TextFilesLoader("testLoadSingleFile");
			_textFilesLoader.addCompleteListener(Async.asyncHandler(this, handleSingleFileComplete, 1000));
			_textFilesLoader.addURI("testfile1.txt", false);
		}

		private function handleSingleFileComplete(event:Event, data:Object):void {
			var result:Vector.<String> = _textFilesLoader.result;
			assertNotNull(result);
			assertEquals(1, result.length);
			assertEquals("test1", result[0]);
		}

		[Test(async)]
		public function testLoadMultipleFiles():void {
			_textFilesLoader = new TextFilesLoader("testLoadMultipleFiles");
			_textFilesLoader.addCompleteListener(Async.asyncHandler(this, handleMultipleFileComplete, 1000));
			_textFilesLoader.addURI("testfile1.txt", false);
			_textFilesLoader.addURI("testfile2.txt", false);
			_textFilesLoader.addURI("testfile3.txt", false);
		}

		private function handleMultipleFileComplete(event:Event, data:Object):void {
			var result:Vector.<String> = _textFilesLoader.result;
			assertNotNull(result);
			assertEquals(3, result.length);
			assertTrue(result.indexOf("test1") > -1);
			assertTrue(result.indexOf("test2") > -1);
			assertTrue(result.indexOf("test3") > -1);
		}

		[Test(async)]
		public function testLoadSingleNonExistingRequiredFile():void {
			_errorDispatched = false;
			_textFilesLoader = new TextFilesLoader();
			_textFilesLoader.addErrorListener(loadSingleNonExistingRequiredFileErrorHandler);
			_textFilesLoader.addCompleteListener(Async.asyncHandler(this, loadSingleNonExistingRequiredFileCompleteHandler, 1000));
			_textFilesLoader.addURI("this-file-does-not-exist.txt");
		}

		private function loadSingleNonExistingRequiredFileErrorHandler(event:OperationEvent):void {
			_errorDispatched = true;
		}

		private function loadSingleNonExistingRequiredFileCompleteHandler(event:Event, data:Object):void {
			var result:Vector.<String> = _textFilesLoader.result;
			assertNotNull(result);
			assertEquals(0, result.length);
			assertTrue(_errorDispatched);
		}

		[Test(async)]
		public function testLoadSingleNonExistingNonRequiredFile():void {
			_textFilesLoader = new TextFilesLoader();
			_textFilesLoader.addErrorListener(loadSingleNonExistingNonRequiredFileErrorHandler);
			_textFilesLoader.addCompleteListener(Async.asyncHandler(this, loadSingleNonExistingNonRequiredFileCompleteHandler, 1000));
			_textFilesLoader.addURI("this-file-does-not-exist.txt", true, false);
		}

		private function loadSingleNonExistingNonRequiredFileErrorHandler(event:OperationEvent):void {
			fail("No error event expected when loading optional non-existing file in loadSingleNonExistingNonRequiredFileErrorHandler.");
		}

		private function loadSingleNonExistingNonRequiredFileCompleteHandler(event:Event, data:Object):void {
			var result:Vector.<String> = _textFilesLoader.result;
			assertNotNull(result);
			assertEquals(0, result.length);
		}

		[Test(async)]
		public function testLoadMultipleFilesWithOneNonExistingRequired():void {
			_errorDispatched = false;
			_textFilesLoader = new TextFilesLoader();
			_textFilesLoader.addErrorListener(loadMultipleFilesWithOneFailErrorHandler);
			_textFilesLoader.addCompleteListener(Async.asyncHandler(this, loadMultipleFilesWithOneFailCompleteHandler, 1000));
			_textFilesLoader.addURI("testfile1.txt", true, true);
			_textFilesLoader.addURI("this-file-does-not-exist.txt", true, true);
			_textFilesLoader.addURI("testfile2.txt", true, true);
		}

		private function loadMultipleFilesWithOneFailErrorHandler(event:OperationEvent):void {
			_errorDispatched = true;
		}

		private function loadMultipleFilesWithOneFailCompleteHandler(event:Event, data:Object):void {
			var result:Vector.<String> = _textFilesLoader.result;
			assertNotNull(result);
			assertEquals(2, result.length);
			assertTrue(_errorDispatched);
		}

		[Test(async)]
		public function testLoadMultipleFilesWithOneNonExistingNonRequired():void {
			_textFilesLoader = new TextFilesLoader();
			_textFilesLoader.addErrorListener(loadMultipleFilesWithOneNonExistingNonRequiredErrorHandler);
			_textFilesLoader.addCompleteListener(Async.asyncHandler(this, loadMultipleFilesWithOneNonExistingNonRequiredCompleteHandler, 1000));
			_textFilesLoader.addURI("testfile1.txt", true, true);
			_textFilesLoader.addURI("this-file-does-not-exist.txt", true, false);
			_textFilesLoader.addURI("testfile2.txt", true, true);
		}

		private function loadMultipleFilesWithOneNonExistingNonRequiredErrorHandler(event:OperationEvent):void {
			fail("No error event expected when loading optional non-existing file in testLoadMultipleFilesWithOneNonExistingNonRequired.");
		}

		private function loadMultipleFilesWithOneNonExistingNonRequiredCompleteHandler(event:Event, data:Object):void {
			var result:Vector.<String> = _textFilesLoader.result;
			assertNotNull(result);
			assertEquals(2, result.length);
		}
	}
}
