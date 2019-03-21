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

	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;

	public class ReferenceResolverTestBase {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		protected var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		[Mock]
		public var cache:IInstanceCache;
		[Mock]
		public var factory:IObjectFactory;
		[Mock]
		public var objectDefinitions:Object;

		[Before]
		public function setUp():void {
			objectDefinitions = {};
			cache = nice(IInstanceCache);
			factory = nice(IObjectFactory);
			stub(factory).getter("cache").returns(cache);
			stub(factory).getter("objectDefinitions").returns(objectDefinitions);
			stub(factory).getter("applicationDomain").returns(applicationDomain);
		}

		public function ReferenceResolverTestBase() {
			super();
		}
	}
}
