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

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;

	/**
	 * <code>IObjectFactoryPostProcessor</code> implementation that checks if the specified <code>objectFactory</code>
	 * contains a <code>MetadataProcessorObjectPostProcessor</code>, if not it creates an instance and registers it
	 * with the factory.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MetadataProcessorObjectFactoryPostProcessor implements IObjectFactoryPostProcessor {

		private static const LOGGER:ILogger = getClassLogger(MetadataProcessorObjectFactoryPostProcessor);

		/**
		 * Creates a new <code>MetadataProcessorObjectFactoryPostProcessor</code> instance.
		 */
		public function MetadataProcessorObjectFactoryPostProcessor() {
			super();
		}

		/**
		 * Registers an <code>ObjectDefinition</code> for a <code>MetadataProcessorObjectPostProcessor</code> instance
		 * with the specified <code>IObjectFactory</code>.
		 * @param objectFactory The specified <code>IConfigurableListableObjectFactory</code>.
		 */
		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			Assert.notNull(objectFactory, "objectFactory argument must not be null");

			var names:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IMetadataProcessorObjectPostProcessor);
			var noMetadataProcessorObjectPostProcessorRegistered:Boolean = (names == null);
			names = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IMetadataProcessor);
			var metadataProcessorsRegistered:Boolean = (names != null);

			if ((noMetadataProcessorObjectPostProcessorRegistered) && (metadataProcessorsRegistered == true)) {
				LOGGER.debug("No MetadataProcessorObjectPostProcessor found in the object factory, registering default MetadataProcessorObjectPostProcessor");
				objectFactory.addObjectPostProcessor(objectFactory.createInstance(MetadataProcessorObjectPostProcessor));
			}
			return null;
		}
	}
}
