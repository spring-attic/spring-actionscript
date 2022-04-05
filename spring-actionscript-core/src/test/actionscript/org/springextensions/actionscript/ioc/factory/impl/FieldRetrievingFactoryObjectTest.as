/*
 * Copyright 2007-2008 the original author or authors.
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

	import flash.utils.Timer;

	import flexunit.framework.Assert;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.test.testtypes.Person;

	/**
	 * @author Christophe Herreman
	 */
	public class FieldRetrievingFactoryObjectTest {

		private var _factory:FieldRetrievingFactoryObject;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function FieldRetrievingFactoryObjectTest() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Setup
		//
		// --------------------------------------------------------------------

		[Before]
		public function setUp():void {
			_factory = new FieldRetrievingFactoryObject();
		}

		// --------------------------------------------------------------------
		//
		// Tests: getObject()
		//
		// --------------------------------------------------------------------

		[Test]
		public function testGetObjectWithStaticField():void {
			_factory.staticField = "Number.MAX_VALUE";
			_factory.afterPropertiesSet();
			assertEquals(Number.MAX_VALUE, _factory.getObject());
		}

		[Test]
		public function testGetObjectWithTargetClassAndTargetField():void {
			_factory.targetClass = Number;
			_factory.targetField = "MAX_VALUE";
			_factory.afterPropertiesSet();
			assertEquals(Number.MAX_VALUE, _factory.getObject());
		}

		[Test]
		public function testGetObject_shouldReturnFunction():void {
			_factory.targetObject = new Timer(1000);
			_factory.targetField = "reset";
			_factory.afterPropertiesSet();
			var resetMethod:Function = _factory.getObject();
			Assert.assertNotNull(resetMethod);
			Assert.assertTrue(resetMethod is Function);
		}

		// --------------------------------------------------------------------
		//
		// Tests: getObjectType()
		//
		// --------------------------------------------------------------------

		[Test]
		public function testGetObjectType_shouldReturnTypeForExistingProperty():void {
			_factory.targetObject = [1, 2, 3];
			_factory.targetField = "length";
			_factory.afterPropertiesSet();

			var type:Class = _factory.getObjectType();
			assertNotNull(type);
			assertEquals(int, type);
		}

		[Test]
		public function testGetObjectType_shouldReturnTypeIfTargetFieldInstanceIsNull():void {
			var person:Person = new Person();
			person.friends = null;

			_factory.targetObject = person;
			_factory.targetField = "friends";
			_factory.afterPropertiesSet();

			var type:Class = _factory.getObjectType();
			assertNotNull(type);
			assertEquals(Array, type);
		}

	}
}
