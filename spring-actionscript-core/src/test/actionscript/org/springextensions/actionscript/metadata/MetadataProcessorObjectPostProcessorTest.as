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
package org.springextensions.actionscript.metadata {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.test.testtypes.TestClassWithMetadata;


	public class MetadataProcessorObjectPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var objectFactory:IObjectFactory;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;
		[Mock]
		public var metadataProcessor:ISpringMetadaProcessor;

		public function MetadataProcessorObjectPostProcessorTest() {
			super();
		}

		[Test]
		public function testAfterPropertiesSetWithIMetadataProcessorObjectDefinition():void {
			objectFactory = nice(IObjectFactory);
			objectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			metadataProcessor = nice(ISpringMetadaProcessor);

			mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			var vec:Vector.<String> = new Vector.<String>();
			vec.push("name");
			var names:Vector.<String> = new Vector.<String>();
			names.push("Mock");
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessor).returns(vec).once();
			mock(objectFactory).method("getObject").args("name").returns(metadataProcessor);
			mock(metadataProcessor).getter("metadataNames").returns(names);
			mock(metadataProcessor).getter("processBeforeInitialization").returns(true);
			stub(metadataProcessor).method("process").args(anything());

			var processor:MetadataProcessorObjectPostProcessor = new MetadataProcessorObjectPostProcessor();
			processor.objectFactory = objectFactory;

			processor.afterPropertiesSet();

			var test:TestClassWithMetadata = new TestClassWithMetadata();
			processor.postProcessBeforeInitialization(test, null);

			verify(objectFactory);
			verify(objectDefinitionRegistry);
			verify(metadataProcessor);
		}
	}
}
