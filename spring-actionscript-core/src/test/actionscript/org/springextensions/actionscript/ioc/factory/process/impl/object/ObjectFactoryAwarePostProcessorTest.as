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
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectFactoryAwarePostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var aware:IObjectFactoryAware;
		[Mock]
		public var factory:IObjectFactory;
		private var _processor:ObjectFactoryAwarePostProcessor;

		/**
		 * Creates a new <code>ObjectFactoryAwarePostProcessorTest</code> instance.
		 */
		public function ObjectFactoryAwarePostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			aware = nice(IObjectFactoryAware);
			_processor = new ObjectFactoryAwarePostProcessor(factory);
		}

		[Test]
		public function testProcessBeforeInitialization():void {
			mock(aware).setter("objectFactory").arg(factory).once();
			var result:* = _processor.postProcessBeforeInitialization(aware, "test");
			verify(aware);
			assertStrictlyEquals(result, aware);
		}

		[Test]
		public function testProcessAfterInitialization():void {
			mock(aware).setter("objectFactory").arg(factory).never();
			var result:* = _processor.postProcessAfterInitialization(aware, "test");
			verify(aware);
			assertStrictlyEquals(result, aware);
		}
	}
}
