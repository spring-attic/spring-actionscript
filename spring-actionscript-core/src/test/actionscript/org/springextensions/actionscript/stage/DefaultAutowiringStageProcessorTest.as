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
	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.objects.testclasses.PropertySetterTestClass;
	import org.springextensions.actionscript.stage.mocks.MockObjectFactoryForPropertySetterTest;

	public class DefaultAutowiringStageProcessorTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function DefaultAutowiringStageProcessorTest(methodName:String = null) {
			super(methodName);
		}

		// --------------------------------------------------------------------
		//
		// Tests - new
		//
		// --------------------------------------------------------------------

		public function testNew_shouldSetFlexStageDefaultObjectSelector():void {
			var processor:DefaultAutowiringStageProcessor = new DefaultAutowiringStageProcessor();
			assertNotNull(processor.objectSelector);
			assertTrue(processor.objectSelector is FlexStageDefaultObjectSelector);
		}

		// --------------------------------------------------------------------
		//
		// Tests - autowireOnce
		//
		// --------------------------------------------------------------------

		public function testAutowireOnce():void {
			var asp:DefaultAutowiringStageProcessor = new DefaultAutowiringStageProcessor(new MockObjectFactoryForPropertySetterTest());

			var test:PropertySetterTestClass = new PropertySetterTestClass();
			asp.process(test);
			assertEquals(1, test.timesPropertySet);
			asp.process(test);
			assertEquals(1, test.timesPropertySet);
		}

		public function testAutowireMultipleTimes():void {
			var asp:DefaultAutowiringStageProcessor = new DefaultAutowiringStageProcessor(new MockObjectFactoryForPropertySetterTest());

			asp.autowireOnce = false;

			var test:PropertySetterTestClass = new PropertySetterTestClass();
			asp.process(test);
			assertEquals(1, test.timesPropertySet);
			asp.process(test);
			assertEquals(2, test.timesPropertySet);
			asp.process(test);
			assertEquals(3, test.timesPropertySet);
		}

	}
}