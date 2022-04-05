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
package org.springextensions.actionscript.ioc.factory.impl {
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.test.testtypes.TestFactoryObject;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class GenericFactoryObjectTest {

		/**
		 * Creates a new <code>GenericFactoryObjectTest</code> instance.
		 */
		public function GenericFactoryObjectTest() {
			super();
		}

		[Test]
		public function testCreateAsSingleton():void {
			var test:TestFactoryObject = new TestFactoryObject();
			var factory:GenericFactoryObject = new GenericFactoryObject(test, "createInstance", true);
			var result:* = factory.getObject();
			assertNotNull(result);
			var result2:* = factory.getObject();
			assertStrictlyEquals(result2, result);
		}

		[Test]
		public function testCreateAsPrototype():void {
			var test:TestFactoryObject = new TestFactoryObject();
			var factory:GenericFactoryObject = new GenericFactoryObject(test, "createInstance", false);
			var result:* = factory.getObject();
			assertNotNull(result);
			var result2:* = factory.getObject();
			assertFalse(result2 === result);
		}
	}
}
