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
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MethodInvocationTest {

		/**
		 * Creates a new <code>MethodInvocationTest</code> instance.
		 */
		public function MethodInvocationTest() {
			super();
		}

		[Test]
		public function testConstructor():void {
			var args:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();
			var mi:MethodInvocation = new MethodInvocation("test", args, "namespace");
			assertEquals("test", mi.methodName);
			assertStrictlyEquals(args, mi.arguments);
			assertEquals("namespace", mi.namespaceURI);
			assertTrue(mi.requiresDependencies);
		}

		[Test]
		public function testClone():void {
			var args:Vector.<ArgumentDefinition> = ArgumentDefinition.newInstances(["bla"]);
			var mi:MethodInvocation = new MethodInvocation("test", args, "namespace");
			mi.requiresDependencies = false;
			var clone:MethodInvocation = mi.clone();
			assertEquals(mi.methodName, clone.methodName);
			assertEquals(mi.namespaceURI, clone.namespaceURI);
			assertNotNull(clone.arguments);
			assertEquals(mi.arguments.length, clone.arguments.length);
			assertEquals(mi.arguments[0].value, clone.arguments[0].value);
			assertEquals(mi.requiresDependencies, clone.requiresDependencies);
		}
	}
}
