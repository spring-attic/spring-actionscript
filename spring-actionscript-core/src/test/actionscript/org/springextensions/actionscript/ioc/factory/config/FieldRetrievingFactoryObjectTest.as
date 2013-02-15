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
package org.springextensions.actionscript.ioc.factory.config {
	
	import flash.utils.Timer;

	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	import mx.core.Application;
	import mx.logging.LogEventLevel;
	
	import org.springextensions.actionscript.ioc.testclasses.Person;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class FieldRetrievingFactoryObjectTest extends TestCase {

		private var _factory:FieldRetrievingFactoryObject;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function FieldRetrievingFactoryObjectTest(methodName:String = null) {
			super(methodName);
		}

		// --------------------------------------------------------------------
		//
		// Setup
		//
		// --------------------------------------------------------------------

		override public function setUp():void {
			_factory = new FieldRetrievingFactoryObject();
		}

		// --------------------------------------------------------------------
		//
		// Tests: getObject()
		//
		// --------------------------------------------------------------------

		public function testGetObjectWithStaticField():void {
			_factory.staticField = "mx.logging.LogEventLevel.DEBUG";
			_factory.afterPropertiesSet();
			assertEquals(LogEventLevel.DEBUG, _factory.getObject());
		}

		public function testGetObjectWithTargetClassAndTargetField():void {
			_factory.targetClass = mx.logging.LogEventLevel;
			_factory.targetField = "DEBUG";
			_factory.afterPropertiesSet();
			assertEquals(LogEventLevel.DEBUG, _factory.getObject());
		}
		
		public function testGetObjectWithTargetClassAndPropertyChain():void {
			_factory.targetClass = mx.core.Application;
			_factory.targetField = "application.systemManager.stage";
			_factory.afterPropertiesSet();
			assertStrictlyEquals(ApplicationUtils.application.systemManager.stage, _factory.getObject());
		}

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

		public function testGetObjectType_shouldReturnTypeForExistingProperty():void {
			_factory.targetObject = [1, 2, 3];
			_factory.targetField = "length";
			_factory.afterPropertiesSet();

			var type:Class = _factory.getObjectType();
			assertNotNull(type);
			assertEquals(int, type);
		}

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
