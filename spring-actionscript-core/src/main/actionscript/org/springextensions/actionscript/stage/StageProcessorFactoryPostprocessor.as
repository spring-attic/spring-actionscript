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
package org.springextensions.actionscript.stage {

	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;

	/**
	 * <p><code>IObjectFactoryPostProcessor</code> implementation that retrieves all the <code>IStageProcessor</code>
	 * from the <code>IConfigurableListableObjectFactory</code> instance and registers them by invoking the
	 * <code>registerStageProcessor()</code> method on the <code>IStageProcessorRegistry</code> instance.</p>
	 * @author Roland Zwaga
	 * @docref container-documentation.html#the_istageprocessor_interface
	 * @sampleref stagewiring
	 */
	public class StageProcessorFactoryPostprocessor implements IObjectFactoryPostProcessor {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>StageProcessorFactoryPostprocessor</code> instance.
		 */
		public function StageProcessorFactoryPostprocessor() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * <p>First checks if the <code>objectFactory</code> argument is an implementation of <code>IStageProcessorRegistry</code>, if not
		 * the objectFactory is checked to see if it contains an object that implements <code>IStageProcessorRegistry</code>.</p>
		 * If an <code>IStageProcessorRegistry</code> instance has been found the <code>objectFactory</code> is used to retrieve all
		 * <code>IStageProcessor</code> instances which all are registered with the specified <code>IStageProcessorRegistry</code>.
		 */
		public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			var stageProcessorRegistry:IStageProcessorRegistry = (objectFactory is IStageProcessorRegistryAware) ? IStageProcessorRegistryAware(objectFactory).stageProcessorRegistry : null;

			if (!stageProcessorRegistry) {
				stageProcessorRegistry = findStageProcessorRegistryInFactory(objectFactory);
			}

			if (stageProcessorRegistry) {
				var document:Object = findCurrentDocument(objectFactory);
				var stageProcessorNames:Array = objectFactory.getObjectNamesForType(IStageProcessor);

				for each (var name:String in stageProcessorNames) {
					registerProcessor(stageProcessorRegistry, name, objectFactory.getObject(name) as IStageProcessor, document);
				}
			}
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Retrieves all objects in the container of the type <code>IStageProcessorRegistry</code> and returns the first instance.
		 * If no objects are found, null is returned.
		 * @param objectFactory The <code>IConfigurableListableObjectFactory</code> that will be searched.
		 * @return An <code>IStageProcessorRegistry</code> or null if none was found.
		 *
		 */
		protected function findStageProcessorRegistryInFactory(objectFactory:IConfigurableListableObjectFactory):IStageProcessorRegistry {
			var stageProcessorRegistryNames:Array = objectFactory.getObjectNamesForType(IStageProcessorRegistry);
			return (stageProcessorRegistryNames.length > 0) ? objectFactory.getObject(stageProcessorRegistryNames[0]) as IStageProcessorRegistry : null;
		}

		/**
		 * Currently the FlashStageProcessorRegistry doesn't support multiple contexts wiring different views, so for
		 * now we just return the <code>objectFactory</code>.
		 * @param objectFactory
		 * @return the objectFactory instance.
		 */
		protected function findCurrentDocument(objectFactory:IConfigurableListableObjectFactory):Object {
			return objectFactory;
		}

		/**
		 * Registers the specified <code>IStageProcessor</code> with the specified <code>IStageProcessorRegistry</code>. If the specified <code>IStageProcessor.document</code>
		 * property is null, it will be assigned with the specified <code>document</code> instance.
		 * @param stageProcessorRegistry The specified <code>IStageProcessorRegistry</code> instance.
		 * @param name The name under which the specified <code>IStageProcessor</code> will be registered.
		 * @param stageProcessor The specified <code>IStageProcessor</code> instance.
		 * @param document The specified <code>document</code> instance.
		 *
		 */
		protected function registerProcessor(stageProcessorRegistry:IStageProcessorRegistry, name:String, stageProcessor:IStageProcessor, document:Object):void {
			var objectSelectorAware:IObjectSelectorAware = (stageProcessor as IObjectSelectorAware);

			if (objectSelectorAware) {
				if (!stageProcessor.document) {
					stageProcessor.document = document;
				}
				stageProcessorRegistry.registerStageProcessor(name, stageProcessor, objectSelectorAware.objectSelector);
			}
		}

	}
}