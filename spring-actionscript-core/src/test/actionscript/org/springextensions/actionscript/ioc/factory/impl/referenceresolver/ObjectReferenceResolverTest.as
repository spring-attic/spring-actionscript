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
package org.springextensions.actionscript.ioc.factory.impl.referenceresolver {

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.verify;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;

	public class ObjectReferenceResolverTest extends ReferenceResolverTestBase {

		public function ObjectReferenceResolverTest() {
			super();
		}

		[Test]
		public function testCanResolveWithObjectReference():void {
			var resolver:ObjectReferenceResolver = new ObjectReferenceResolver(factory);
			var result:Boolean = resolver.canResolve(new RuntimeObjectReference("test"));
			assertTrue(result);
		}

		[Test]
		public function testCanResolveWithObject():void {
			var resolver:ObjectReferenceResolver = new ObjectReferenceResolver(factory);
			var result:Boolean = resolver.canResolve({});
			assertFalse(result);
		}

		[Test]
		public function testResolveWithSimpleName():void {
			var obj:Object = {};
			mock(factory).method("getObject").args("testName").returns(obj).once();

			var resolver:ObjectReferenceResolver = new ObjectReferenceResolver(factory);
			var result:* = resolver.resolve(new RuntimeObjectReference("testName"));
			verify(factory);
			assertNotNull(result);
			assertStrictlyEquals(obj, result);
		}

		[Test]
		public function testResolveWithCompoundName():void {
			var obj:Object = {};
			var obj2:Object = {};
			obj.myProperty = obj2;
			mock(factory).method("getObject").args("testName").returns(obj).once();

			var resolver:ObjectReferenceResolver = new ObjectReferenceResolver(factory);
			var result:* = resolver.resolve(new RuntimeObjectReference("testName.myProperty"));
			verify(factory);
			assertNotNull(result);
			assertStrictlyEquals(obj2, result);
		}

		[Test]
		public function testResolveWithParentName():void {
			var obj:Object = {};
			var parentFactory:IObjectFactory = nice(IObjectFactory);
			mock(parentFactory).method("resolveReference").args("testName").returns(obj).once();
			mock(factory).getter("parent").returns(parentFactory);

			var resolver:ObjectReferenceResolver = new ObjectReferenceResolver(factory);
			var result:* = resolver.resolve(new RuntimeObjectReference("parent.testName"));
			verify(parentFactory);
			verify(factory);
			assertNotNull(result);
			assertStrictlyEquals(obj, result);
		}

		[Test(expects = "flash.errors.IllegalOperationError")]
		public function testResolveWithParentNameAndInvalidParent():void {
			var resolver:ObjectReferenceResolver = new ObjectReferenceResolver(factory);
			var result:* = resolver.resolve(new RuntimeObjectReference("parent.testName"));
		}
	}
}
