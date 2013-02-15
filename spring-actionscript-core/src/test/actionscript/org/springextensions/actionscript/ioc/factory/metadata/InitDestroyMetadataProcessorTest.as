/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.ioc.factory.metadata {
	import flexunit.framework.TestCase;

	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataContainer;
	import org.as3commons.reflect.Type;
	import testclasses.initdestroy.ClassWithOnePostConstructAndOnePreDestroyMetadata;
	import testclasses.initdestroy.ClassWithOnePostConstructAndOnePreDestroyMetadataOnSameMethod;
	import testclasses.initdestroy.ClassWithOnePostConstructMetadata;
	import testclasses.initdestroy.ClassWithOnePreDestroyMetadata;
	import testclasses.initdestroy.ClassWithThreePostConstructMetadata;
	import testclasses.initdestroy.ClassWithThreePreDestroyMetadata;

	/**
	 * @author Christophe Herreman
	 */
	public class InitDestroyMetadataProcessorTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InitDestroyMetadataProcessorTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// -------------------------------------------------------------------

		public function testNew():void {
			var processor:InitDestroyMetadataProcessor = new InitDestroyMetadataProcessor();
			assertTrue(processor.processBeforeInitialization);
			assertNotNull(processor.metadataNames);
			assertEquals(2, processor.metadataNames.length);
			assertTrue(processor.metadataNames.indexOf(InitDestroyMetadataProcessor.POST_CONSTRUCT_METADATA_NAME) > -1);
			assertTrue(processor.metadataNames.indexOf(InitDestroyMetadataProcessor.PRE_DESTROY_METADATA_NAME) > -1);
		}

		public function testPostConstructMetadata():void {
			assertNumberOfInitAndDestroyMethods(1, 0, ClassWithOnePostConstructMetadata);
			assertNumberOfInitAndDestroyMethods(3, 0, ClassWithThreePostConstructMetadata);
		}

		public function testPreDestroyMetadata():void {
			assertNumberOfInitAndDestroyMethods(0, 1, ClassWithOnePreDestroyMetadata);
			assertNumberOfInitAndDestroyMethods(0, 3, ClassWithThreePreDestroyMetadata);
		}

		public function testPostConstructAndPreDestroyMetadata():void {
			assertNumberOfInitAndDestroyMethods(1, 1, ClassWithOnePostConstructAndOnePreDestroyMetadata);
			assertNumberOfInitAndDestroyMethods(1, 1, ClassWithOnePostConstructAndOnePreDestroyMetadataOnSameMethod);
		}

		public function testOnMultipleObjects():void {
			assertNumberOfInitAndDestroyMethodsOnObjects(4, 0, [ClassWithOnePostConstructMetadata, ClassWithThreePostConstructMetadata]);
		}

		public function testOnObjectsOfSameClass():void {
			assertNumberOfInitAndDestroyMethodsOnObjects(3, 0, [ClassWithOnePostConstructMetadata, ClassWithOnePostConstructMetadata, ClassWithOnePostConstructMetadata]);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function assertNumberOfInitAndDestroyMethods(numExpectedInitMethodExecutions:int, numExpectedDestroyMethodExecutions:int, annotatedClass:Class):void {
			var processor:InitDestroyMetadataProcessor = new InitDestroyMetadataProcessor();
			var object:Object = new annotatedClass();
			var type:Type = Type.forClass(annotatedClass);

			processMetadataKey(type, processor, object);

			assertEquals(numExpectedInitMethodExecutions, object.numInitMethodsExecuted);
			assertEquals(numExpectedDestroyMethodExecutions, object.numDestroyMethodsExecuted);
		}

		private function assertNumberOfInitAndDestroyMethodsOnObjects(numExpectedInitMethodExecutions:int, numExpectedDestroyMethodExecutions:int, annotatedClasses:Array):void {
			var processor:InitDestroyMetadataProcessor = new InitDestroyMetadataProcessor();
			var numInitMethodExecutions:int = 0;
			var numDestroyMethodExecutions:int = 0;

			for each (var annotatedClass:Class in annotatedClasses) {
				var object:Object = new annotatedClass();
				var type:Type = Type.forClass(annotatedClass);

				processMetadataKey(type, processor, object);

				numInitMethodExecutions += object.numInitMethodsExecuted;
				numDestroyMethodExecutions += object.numDestroyMethodsExecuted;
			}

			assertEquals(numExpectedInitMethodExecutions, numInitMethodExecutions);
			assertEquals(numExpectedDestroyMethodExecutions, numDestroyMethodExecutions);
		}

		private function processMetadataKey(type:Type, processor:InitDestroyMetadataProcessor, object:Object):void {
			var postConstructMetadataContainers:Array = type.getMetaDataContainers(InitDestroyMetadataProcessor.POST_CONSTRUCT_METADATA_NAME);
			var preDestroyMetadataContainers:Array = type.getMetaDataContainers(InitDestroyMetadataProcessor.PRE_DESTROY_METADATA_NAME);

			// TODO Type.getMetadataContainers() should return an emtpy array if none are found
			if (!postConstructMetadataContainers) {
				postConstructMetadataContainers = [];
			}

			if (!preDestroyMetadataContainers) {
				preDestroyMetadataContainers = [];
			}

			// merge all metadata containers, but make sure we have no duplicates
			var metadataContainers:Array = postConstructMetadataContainers.concat();
			for each (var preDestroyMetadataContainer:MetaDataContainer in preDestroyMetadataContainers) {
				if (metadataContainers.indexOf(preDestroyMetadataContainer) == -1) {
					metadataContainers.push(preDestroyMetadataContainer);
				}
			}

			var objectName:String = "objectName";

			for each (var metadataContainer:MetaDataContainer in metadataContainers) {
				if (metadataContainer.metaData) {
					for each (var metadata:MetaData in metadataContainer.metaData) {
						var metadataKey:String = metadata.name;
						processor.process(object, metadataContainer, metadataKey, objectName);
					}
				}
			}

			processor.postProcessBeforeInitialization(object, objectName);
			processor.postProcessAfterInitialization(object, objectName);
			processor.postProcessBeforeDestruction(object, objectName);
		}

	}
}