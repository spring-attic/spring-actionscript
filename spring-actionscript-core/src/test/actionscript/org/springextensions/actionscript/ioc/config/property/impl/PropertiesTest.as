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
package org.springextensions.actionscript.ioc.config.property.impl {
	import org.flexunit.asserts.assertEquals;

	public class PropertiesTest {

		public function PropertiesTest() {
			super();
		}

		[Test]
		public function testCreatePropertiesAndDefaultValues():void {
			var props:Properties = new Properties();
			assertEquals(0, props.length);
			assertEquals(0, props.propertyNames.length);
		}

		[Test]
		public function testSetPropertyWithLengths():void {
			var props:Properties = new Properties();
			props.setProperty("testKey", "testValue");
			assertEquals(1, props.length);
			assertEquals(1, props.propertyNames.length);
		}

		[Test]
		public function testSetPropertyAndGetProperty():void {
			var props:Properties = new Properties();
			props.setProperty("testKey", "testValue");
			assertEquals("testValue", props.getProperty("testKey"));
		}

		[Test]
		public function testSetPropertyWithLengthsAfterOverriding():void {
			var props:Properties = new Properties();
			props.setProperty("testKey", "testValue");
			props.setProperty("testKey", "testValue2");
			props.setProperty("testKey", "testValue3");
			assertEquals(1, props.length);
			assertEquals(1, props.propertyNames.length);
		}

		[Test]
		public function testMerge():void {
			var props:Properties = new Properties();
			var props2:Properties = new Properties();
			props.setProperty("testKey", "testValue");
			props2.setProperty("testKey2", "testValue2");
			props.merge(props2);
			assertEquals(2, props.length);
			assertEquals(2, props.propertyNames.length);
			assertEquals("testValue", props.getProperty("testKey"));
			assertEquals("testValue2", props.getProperty("testKey2"));
		}

		[Test]
		public function testMergeWithoutOverride():void {
			var props:Properties = new Properties();
			var props2:Properties = new Properties();
			props.setProperty("testKey", "testValue");
			props2.setProperty("testKey", "testValue2");
			props.merge(props2);
			assertEquals(1, props.length);
			assertEquals(1, props.propertyNames.length);
			assertEquals("testValue", props.getProperty("testKey"));
		}

		[Test]
		public function testMergeWithOverride():void {
			var props:Properties = new Properties();
			var props2:Properties = new Properties();
			props.setProperty("testKey", "testValue");
			props2.setProperty("testKey", "testValue2");
			props.merge(props2, true);
			assertEquals(1, props.length);
			assertEquals(1, props.propertyNames.length);
			assertEquals("testValue2", props.getProperty("testKey"));
		}
	}
}
