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
	import flash.utils.Dictionary;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.factory.IInitializingObject;
	import org.springextensions.actionscript.ioc.factory.IListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;
	import org.springextensions.actionscript.utils.OrderedUtils;
	import org.springextensions.actionscript.utils.TypeUtils;

	/**
	 * Default implementation of the <code>IMetaDataProcessorObjectPostProcessor</code> which acts as the main
	 * registry for <code>IMetaDataProcessor</code> definitions that are found in the specified <code>IObjectFactory</code>.
	 * @author Roland Zwaga
	 * @docref annotations.html
	 * @sampleref metadataprocessor
	 */
	public class MetadataProcessorObjectPostProcessor implements IMetaDataProcessorObjectPostProcessor, IInitializingObject, IObjectFactoryAware {

		private static var LOGGER:ILogger = LoggerFactory.getClassLogger(MetadataProcessorObjectPostProcessor);

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _procs:Dictionary;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>MetadataProcessorObjectPostProcessor</code> instance.
		 */
		public function MetadataProcessorObjectPostProcessor() {
			super();
			_procs = new Dictionary();
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		private var _objectFactory:IObjectFactory;

		/**
		 * @private
		 */
		public function set objectFactory(objectFactory:IObjectFactory):void {
			_objectFactory = objectFactory;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Invokes processObject() with all registered <code>IMetadataProcessor</code> that have their
		 * <code>processBeforeInitialization</code> property set to <code>true</code>.
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			if (!(object is IMetadataProcessor)) {
				return processObject(_procs[true], object, objectName);
			}
			return object;
		}

		/**
		 * Invokes processObject() with all registered <code>IMetadataProcessor</code> that have their
		 * <code>processBeforeInitialization</code> property set to <code>false</code>.
		 * <p>If the specified <code>object</code> is an <code>IMetadataProcessor</code> implementation
		 * it will register it with the current <code>MetadataProcessorObjectPostProcessor</code>.</p>
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
			if (object is IMetadataProcessor) {
				var metaDataProcessor:IMetadataProcessor = IMetadataProcessor(object);
				for each (var metaDataName:String in metaDataProcessor.metadataNames) {
					addProcessor(metaDataName, metaDataProcessor);
				}
				return object;
			}

			return processObject(_procs[false], object, objectName);
		}

		/**
		 * Checks if the associated <code>IApplicationContext</code> contains any <code>IMetadataProcessor</code> instances
		 * and registers them.
		 */
		public function afterPropertiesSet():void {
			addMetadataProcessorsFromObjectPostProcessors();
			addMetadataProcessorsFromObjectDefinitions();
		}

		/**
		 * @inheritDoc
		 */
		public function addProcessor(metaDataName:String, metaDataProcessor:IMetadataProcessor):void {
			var processorLookup:Dictionary = _procs[metaDataProcessor.processBeforeInitialization];
			if (processorLookup == null) {
				processorLookup = new Dictionary();
				_procs[metaDataProcessor.processBeforeInitialization] = processorLookup;
			}
			var processorArray:Array = processorLookup[metaDataName];
			if (processorArray == null) {
				processorArray = [];
				processorLookup[metaDataName] = processorArray;
			}
			processorArray[processorArray.length] = metaDataProcessor;
			processorArray = OrderedUtils.sortOrderedArray(processorArray);
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function processObject(names:Dictionary, object:*, objectName:String):* {
			if (names == null) {
				return;
			}
			var type:Type = Type.forInstance(object, _objectFactory.applicationDomain);
			if (TypeUtils.isSimpleProperty(type)) {
				return object;
			}
			for (var name:String in names) {
				//LOGGER.debug("Invoking IMetadataProcessors for {0} metadata", name);
				var processors:Array = names[name] as Array;
				var containers:Array = [];
				if (type.hasMetaData(name)) {
					containers[containers.length] = type;
				}
				var otherContainers:Array = type.getMetaDataContainers(name);
				if (otherContainers != null) {
					containers = containers.concat(otherContainers);
				}
				for each (var container:IMetaDataContainer in containers) {
					for each (var proc:IMetadataProcessor in processors) {
						proc.process(object, container, name, objectName);
					}
				}
			}
			return object;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function addMetadataProcessorsFromObjectPostProcessors():void {
			if (_objectFactory is IConfigurableObjectFactory) {
				var metadataProcessors:Array = getMetadataProcessors(IConfigurableObjectFactory(_objectFactory).objectPostProcessors);
				var numMetadataProcessors:int = metadataProcessors.length;

				if (numMetadataProcessors > 0) {
					LOGGER.debug("{0} IMetadataProcessor found in object post processors, adding them to the current MetadataProcessorObjectPostProcessor.", numMetadataProcessors);

					for each (var metadataProcessor:IMetadataProcessor in metadataProcessors) {
						registerMetadataProcessor(metadataProcessor);
					}
				}
			}
		}

		private function addMetadataProcessorsFromObjectDefinitions():void {
			if (_objectFactory is IListableObjectFactory) {
				var processors:Array = IListableObjectFactory(_objectFactory).getObjectNamesForType(IMetadataProcessor);

				if (processors.length > 0) {
					LOGGER.debug("{0} IMetadataProcessor found in object definitions, adding them to the current MetadataProcessorObjectPostProcessor.", processors.length);
					for each (var name:String in processors) {
						var metaDataProcessor:IMetadataProcessor = _objectFactory.getObject(name);
						registerMetadataProcessor(metaDataProcessor);
					}
				}
			}
		}

		private function getMetadataProcessors(objectPostProcessors:Array):Array {
			var result:Array = [];

			for each (var objectPostProcessor:IObjectPostProcessor in objectPostProcessors) {
				if (objectPostProcessor is IMetadataProcessor) {
					result.push(objectPostProcessor);
				}
			}

			return result;
		}

		private function registerMetadataProcessor(metadataProcessor:IMetadataProcessor):void {
			for each (var metaDataName:String in metadataProcessor.metadataNames) {
				LOGGER.debug("Registered metadata '[{0}]' with processor '{1}'", metaDataName, metadataProcessor);
				_objectFactory.wire(metadataProcessor);
				addProcessor(metaDataName, metadataProcessor);
			}
		}

	}
}