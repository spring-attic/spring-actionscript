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
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class ArrayReferenceResolverTest extends ReferenceResolverTestBase {

		public function ArrayReferenceResolverTest() {
			super();
		}

		[Test]
		public function testCanResolveWithArray():void {
			var resolver:ArrayReferenceResolver = new ArrayReferenceResolver(factory);
			var result:Boolean = resolver.canResolve([]);
			assertTrue(result);
		}

		[Test]
		public function testCanResolveWithObject():void {
			var resolver:ArrayReferenceResolver = new ArrayReferenceResolver(factory);
			var result:Boolean = resolver.canResolve({});
			assertFalse(result);
		}

		[Test]
		public function testResolve():void {
			stub(factory).method("resolveReference").args("testProperty").returns("resolved").once();

			var col:Array = ["testProperty"];
			var resolver:ArrayReferenceResolver = new ArrayReferenceResolver(factory);

			col = resolver.resolve(col) as Array;
			verify(factory);
			assertEquals(1, col.length);
			assertEquals("resolved", col[0]);
		}

	}
}
