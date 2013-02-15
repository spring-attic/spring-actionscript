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
package org.springextensions.actionscript.metadata {
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;

	/**
	 * <code>IObjectFactoryPostProcessor</code> implementation that checks if the specified <code>objectFactory</code>
	 * contains a <code>MetadataProcessorObjectPostProcessor</code>, if not it creates an instance and registers it
	 * with the factory.
	 * @author Roland Zwaga
	 * @docref annotations.html
	 * @sampleref metadataprocessor
	 */
	public class MetadataProcessorObjectFactoryPostProcessor implements IObjectFactoryPostProcessor {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = LoggerFactory.getClassLogger(MetadataProcessorObjectFactoryPostProcessor);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>MetadataProcessorObjectFactoryPostProcessor</code> instance.
		 */
		public function MetadataProcessorObjectFactoryPostProcessor() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Registers an <code>ObjectDefinition</code> for a <code>MetadataProcessorObjectPostProcessor</code> instance
		 * with the specified <code>IConfigurableListableObjectFactory</code>.
		 * @param objectFactory The specified <code>IConfigurableListableObjectFactory</code>.
		 */
		public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			Assert.notNull(objectFactory, "objectFactory argument must not be null");

			var noMetadataProcessorObjectPostProcessorRegistered:Boolean = (objectFactory.getObjectNamesForType(IMetaDataProcessorObjectPostProcessor).length == 0);

			if (noMetadataProcessorObjectPostProcessorRegistered) {
				logger.debug("No MetadataProcessorObjectPostProcessor found in the object factory, registering MetadataProcessorObjectPostProcessor");
				objectFactory.addObjectPostProcessor(objectFactory.createInstance(MetadataProcessorObjectPostProcessor));
			}
		}
	}
}