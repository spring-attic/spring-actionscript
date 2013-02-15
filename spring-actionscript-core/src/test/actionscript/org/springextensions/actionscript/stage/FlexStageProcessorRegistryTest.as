/*
 * Copyright 2007-2010 the original author or authors.
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
	import flash.errors.IllegalOperationError;

	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.modules.Module;

	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.stage.mocks.MockApprovingSelector;
	import org.springextensions.actionscript.stage.mocks.MockStageProcessor;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	public class FlexStageProcessorRegistryTest extends FlexUnitTestCase {

		public function FlexStageProcessorRegistryTest(methodName:String = null) {
			super(methodName);
		}

		public function testDirectInstantiationError():void {
			var fspr:FlexStageProcessorRegistry = null;
			try {
				fspr = new FlexStageProcessorRegistry({});
				fail("FlexStageProcessorRegistry should not be able to be instantiated directly");
			} catch (e:IllegalOperationError) {
				assertNull(fspr);
			}
		}

		public function testGetInstance():void {
			var fspr:FlexStageProcessorRegistry = FlexStageProcessorRegistry.getInstance();
			assertNotNull(fspr);
			var fspr2:FlexStageProcessorRegistry = FlexStageProcessorRegistry.getInstance();
			assertNotNull(fspr2);
			assertStrictlyEquals(fspr2, fspr);
		}

		public function testClear():void {
			var fspr:FlexStageProcessorRegistry = FlexStageProcessorRegistry.getInstance();
			fspr.clear();
			assertEquals(0, fspr.numRegistrations);
			var sp:MockStageProcessor = new MockStageProcessor();
			fspr.registerStageProcessor("test", sp, sp.objectSelector);
			assertEquals(1, fspr.numRegistrations);
			fspr.clear();
			assertEquals(0, fspr.numRegistrations);
		}

		public function testGetObjectSelectorForStageProcessor():void {
			var fspr:FlexStageProcessorRegistry = FlexStageProcessorRegistry.getInstance();
			fspr.clear();
			var document:Object = {};

			var sp1:MockStageProcessor = new MockStageProcessor();
			sp1.document = document;
			fspr.registerStageProcessor("test1", sp1, sp1.objectSelector);

			var result:IObjectSelector = fspr.getObjectSelectorForStageProcessor(sp1);

			assertStrictlyEquals(result, sp1.objectSelector);
		}
	}
}