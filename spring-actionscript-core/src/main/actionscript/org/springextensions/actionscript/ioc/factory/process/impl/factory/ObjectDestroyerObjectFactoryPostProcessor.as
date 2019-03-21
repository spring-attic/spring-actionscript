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

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.metadata.IMetadataDestroyer;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDestroyerObjectFactoryPostProcessor implements IObjectFactoryPostProcessor {

		private static var logger:ILogger = getClassLogger(ObjectDestroyerObjectFactoryPostProcessor);

		/**
		 * Creates a new <code>ObjectDestroyerObjectFactoryPostProcessor</code> instance.
		 */
		public function ObjectDestroyerObjectFactoryPostProcessor() {
			super();
		}

		/**
		 *
		 * @param objectFactory
		 * @return
		 */
		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			var objectNames:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IMetadataDestroyer);
			for each (var name:String in objectNames) {
				if ((objectFactory.objectDestroyer != null) && (objectFactory.objectDestroyer.metadataProcessorRegistry != null)) {
					logger.debug("Registering IMetadataDestroyer implementation '{0}' with the object destroyer", [name]);
					objectFactory.objectDestroyer.metadataProcessorRegistry.addProcessor(objectFactory.getObject(name));
				}
			}
			return null;
		}
	}
}
