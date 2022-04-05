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
	import mockolate.verify;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	public class MetadataProcessorObjectFactoryPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var objectFactory:IObjectFactory;
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;
		[Mock]
		public var metadataProcessorObjectPostProcessor:MetadataProcessorObjectPostProcessor;

		public function MetadataProcessorObjectFactoryPostProcessorTest() {
			super();
		}

		[Test]
		public function testPostProcessObjectFactoryWithoutPostProcessorAndWithoutMetdataProcessors():void {
			var objectFactory:IObjectFactory = nice(IObjectFactory);
			var objectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessorObjectPostProcessor).returns(null).once();
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessor).returns(null).once();
			mock(objectFactory).method("addObjectPostProcessor").never();
			mock(objectFactory).method("createInstance").never();

			var processor:MetadataProcessorObjectFactoryPostProcessor = new MetadataProcessorObjectFactoryPostProcessor();
			processor.postProcessObjectFactory(objectFactory);

			verify(objectFactory);
			verify(objectDefinitionRegistry);

		}

		[Test]
		public function testPostProcessObjectFactoryWithPostProcessorButWithoutMetdataProcessors():void {
			var objectFactory:IObjectFactory = nice(IObjectFactory);
			var objectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			var vec:Vector.<String> = new Vector.<String>();
			vec.push("name");
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessorObjectPostProcessor).returns(vec).once();
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessor).returns(null).once();
			mock(objectFactory).method("addObjectPostProcessor").never();
			mock(objectFactory).method("createInstance").never();

			var processor:MetadataProcessorObjectFactoryPostProcessor = new MetadataProcessorObjectFactoryPostProcessor();
			processor.postProcessObjectFactory(objectFactory);

			verify(objectFactory);
			verify(objectDefinitionRegistry);

		}

		[Test]
		public function testPostProcessObjectFactoryWithPostProcessorAndWithMetdataProcessors():void {
			var objectFactory:IObjectFactory = nice(IObjectFactory);
			var objectDefinitionRegistry:IObjectDefinitionRegistry = nice(IObjectDefinitionRegistry);
			var metadataProcessorObjectPostProcessor:MetadataProcessorObjectPostProcessor = nice(MetadataProcessorObjectPostProcessor);
			mock(objectFactory).getter("objectDefinitionRegistry").returns(objectDefinitionRegistry);
			var vec:Vector.<String> = new Vector.<String>();
			vec.push("name");
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessorObjectPostProcessor).returns(null);
			mock(objectDefinitionRegistry).method("getObjectDefinitionNamesForType").args(IMetadataProcessor).returns(vec);
			mock(objectFactory).method("addObjectPostProcessor").args(anything()).once();
			mock(objectFactory).method("createInstance").args(MetadataProcessorObjectPostProcessor).returns(metadataProcessorObjectPostProcessor).once();

			var processor:MetadataProcessorObjectFactoryPostProcessor = new MetadataProcessorObjectFactoryPostProcessor();
			processor.postProcessObjectFactory(objectFactory);

			verify(objectFactory);
			verify(objectDefinitionRegistry);

		}
	}
}
