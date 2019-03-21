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
package org.springextensions.actionscript.ioc.factory.process.impl.object {
	import flash.system.ApplicationDomain;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.lang.IApplicationDomainAware;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.context.IApplicationContext;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ApplicationDomainAwarePostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var aware:IApplicationDomainAware;
		[Mock]
		public var context:IApplicationContext;

		private var _processor:ApplicationDomainAwarePostProcessor;
		private var _appDomain:ApplicationDomain = ApplicationDomain.currentDomain;

		/**
		 * Creates a new <code>ApplicationDomainAwarePostProcessorTest</code> instance.
		 */
		public function ApplicationDomainAwarePostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			context = nice(IApplicationContext);
			aware = nice(IApplicationDomainAware);
			stub(context).getter("applicationDomain").returns(_appDomain);
			_processor = new ApplicationDomainAwarePostProcessor(context);
		}

		[Test]
		public function testProcessBeforeInitialization():void {
			mock(aware).setter("applicationDomain").arg(_appDomain).once();
			var result:* = _processor.postProcessBeforeInitialization(aware, "test");
			verify(aware);
			assertStrictlyEquals(result, aware);
		}

		[Test]
		public function testProcessAfterInitialization():void {
			mock(aware).setter("applicationDomain").arg(_appDomain).never();
			var result:* = _processor.postProcessAfterInitialization(aware, "test");
			verify(aware);
			assertStrictlyEquals(result, aware);
		}
	}
}
