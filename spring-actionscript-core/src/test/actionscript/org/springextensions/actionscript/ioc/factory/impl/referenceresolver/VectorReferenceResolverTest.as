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
	import flash.system.ApplicationDomain;

	import mockolate.mock;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;

	public class VectorReferenceResolverTest extends ReferenceResolverTestBase {

		public function VectorReferenceResolverTest() {
			super();
		}

		[Test]
		public function testCanCreateWithVector():void {
			var resolver:VectorReferenceResolver = new VectorReferenceResolver(factory);
			var result:Boolean = resolver.canResolve(new Vector.<String>());
			assertTrue(result);
		}

		[Test]
		public function testCanCreateWithArray():void {
			var resolver:VectorReferenceResolver = new VectorReferenceResolver(factory);
			var result:Boolean = resolver.canResolve([]);
			assertFalse(result);
		}

		[Test]
		public function testResolve():void {
			mock(factory).method("resolveReference").args("testProperty").returns("resolved");

			var col:Vector.<*> = new <*>[Vector.<String>, "testProperty"];
			var resolver:VectorReferenceResolver = new VectorReferenceResolver(factory);

			var vec:Vector.<String> = resolver.resolve(col) as Vector.<String>;
			verify(factory);
			assertNotNull(vec);
			assertEquals(1, vec.length);
			assertEquals("resolved", vec[0]);
		}

		[Test]
		public function testResolveWithRuntimeObjectReferences():void {
			mock(factory).method("resolveReference").args(anything()).never();
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			mock(factory).method("getObject").args("testId").returns(appDomain).once();

			var col:Vector.<*> = new <*>[Vector.<ApplicationDomain>, new RuntimeObjectReference("testId")];
			var resolver:VectorReferenceResolver = new VectorReferenceResolver(factory);

			var vec:Vector.<ApplicationDomain> = resolver.resolve(col) as Vector.<ApplicationDomain>;
			verify(factory);
			assertNotNull(vec);
			assertEquals(1, vec.length);
			assertStrictlyEquals(appDomain, vec[0]);
		}
	}
}
