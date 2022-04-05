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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.async.operation.IOperation;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ApplicationDomainAwarePostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;


	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class RegisterObjectPostProcessorsFactoryPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContext;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;
		[Mock]
		public var objectPostProcessor:IObjectPostProcessor;

		public function RegisterObjectPostProcessorsFactoryPostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			applicationContext = nice(IApplicationContext);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
		}

		[Test]
		public function testPostProcessObjectFactory():void {
			var processor1:IObjectPostProcessor = nice(IObjectPostProcessor);
			var processor2:IObjectPostProcessor = nice(IObjectPostProcessor);
			var processor3:IObjectPostProcessor = nice(IObjectPostProcessor);

			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "processor1";
			names[names.length] = "processor2";
			names[names.length] = "processor3";

			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(anything()).returns(names).atLeast(1);
			mock(applicationContext).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			mock(applicationContext).method("getObject").args("processor1").returns(processor1).atLeast(1);
			mock(applicationContext).method("getObject").args("processor2").returns(processor2).atLeast(1);
			mock(applicationContext).method("getObject").args("processor3").returns(processor3).atLeast(1);

			var processor:RegisterObjectPostProcessorsFactoryPostProcessor = new RegisterObjectPostProcessorsFactoryPostProcessor(0);
			processor.postProcessObjectFactory(applicationContext);
			verify(applicationContext);
			verify(objectDefinitionRegistry);
		}
	}
}
