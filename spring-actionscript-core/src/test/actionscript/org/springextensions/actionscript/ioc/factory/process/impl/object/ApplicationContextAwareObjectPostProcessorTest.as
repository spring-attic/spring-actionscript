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
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ApplicationContextAwareObjectPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var aware:IApplicationContextAware;
		[Mock]
		public var context:IApplicationContext;

		private var _processor:ApplicationContextAwareObjectPostProcessor;

		/**
		 * Creates a new <code>ApplicationContextAwareObjectPostProcessorTest</code> instance.
		 */
		public function ApplicationContextAwareObjectPostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_processor = new ApplicationContextAwareObjectPostProcessor(context);
		}

		[Test]
		public function testProcessBeforeInitliazation():void {
			aware = nice(IApplicationContextAware);
			mock(aware).setter("applicationContext").arg(context).once();
			var result:* = _processor.postProcessBeforeInitialization(aware, "test");
			verify(aware);
			assertStrictlyEquals(result, aware);
		}

		[Test]
		public function testProcessAfterInitliazation():void {
			aware = nice(IApplicationContextAware);
			mock(aware).setter("applicationContext").arg(context).never();
			var result:* = _processor.postProcessAfterInitialization(aware, "test");
			verify(aware);
			assertStrictlyEquals(result, aware);
		}
	}
}
