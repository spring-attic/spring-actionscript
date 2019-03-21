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

	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.IObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;

	public class ThisReferenceResolverTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		protected var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var context:IApplicationContext;
		[Mock]
		public var objectDefinitions:Object;

		[Before]
		public function setUp():void {
			objectDefinitions = {};
			cache = nice(IInstanceCache);
			context = nice(IApplicationContext);
			stub(context).getter("cache").returns(cache);
			stub(context).getter("objectDefinitions").returns(objectDefinitions);
			stub(context).getter("applicationDomain").returns(applicationDomain);
		}

		public function ThisReferenceResolverTest() {
			super();
		}

		[Test]
		public function testCanCreateWithThisString():void {
			var resolver:ThisReferenceResolver = new ThisReferenceResolver(context);
			var result:Boolean = resolver.canResolve("this");
			assertFalse(result);
		}

		[Test]
		public function testCanCreateWithThisObjectReference():void {
			var resolver:ThisReferenceResolver = new ThisReferenceResolver(context);
			var result:Boolean = resolver.canResolve(new RuntimeObjectReference("this"));
			assertTrue(result);
		}

		[Test]
		public function testCanCreateWithThisObjectReferenceAndCompoundName():void {
			var resolver:ThisReferenceResolver = new ThisReferenceResolver(context);
			var result:Boolean = resolver.canResolve(new RuntimeObjectReference("this.applicationDomain"));
			assertTrue(result);
		}

		[Test]
		public function testResolve():void {
			var ref:IObjectReference = new RuntimeObjectReference("this");
			var resolver:ThisReferenceResolver = new ThisReferenceResolver(context);
			var result:Object = resolver.resolve(ref);
			assertTrue(result is IApplicationContext);
			assertStrictlyEquals(context, result);
		}

		[Test]
		public function testResolveWithCompoundName():void {
			var ref:IObjectReference = new RuntimeObjectReference("this.applicationDomain");
			var resolver:ThisReferenceResolver = new ThisReferenceResolver(context);
			var result:Object = resolver.resolve(ref);
			assertTrue(result is ApplicationDomain);
			assertStrictlyEquals(applicationDomain, result);
		}

	}
}
