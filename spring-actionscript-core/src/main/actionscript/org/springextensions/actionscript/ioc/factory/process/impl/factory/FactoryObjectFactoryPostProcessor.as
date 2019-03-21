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

	import flash.errors.IllegalOperationError;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.GenericFactoryObject;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FactoryObjectFactoryPostProcessor implements IObjectFactoryPostProcessor {

		private static var logger:ILogger = getClassLogger(FactoryObjectFactoryPostProcessor);

		public static const FACTORY_METADATA_NAME:String = "Factory";
		public static const FACTORY_METHOD_FIELD_NAME:String = "factoryMethod";

		private var _throwError:Boolean = true;

		/**
		 * Creates a new <code>FactoryObjectFactoryPostProcessor</code> instance.
		 */
		public function FactoryObjectFactoryPostProcessor() {
			super();
		}

		public function get throwError():Boolean {
			return _throwError;
		}

		public function set throwError(value:Boolean):void {
			_throwError = value;
		}

		/**
		 *
		 * @param objectFactory
		 * @return
		 */
		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = FACTORY_METADATA_NAME;
			var definitions:Vector.<IObjectDefinition> = objectFactory.objectDefinitionRegistry.getObjectDefinitionsWithMetadata(names);
			logger.debug("Found {0} definitions for classes with [Factory] metadata", [(definitions != null) ? definitions.length : 0]);
			for each (var definition:IObjectDefinition in definitions) {
				processObjectDefinitionWithFactoryMetadata(objectFactory, definition);
			}
			return null;
		}

		/**
		 *
		 * @param objectFactory
		 * @param definition
		 */
		public function processObjectDefinitionWithFactoryMetadata(objectFactory:IObjectFactory, definition:IObjectDefinition):void {
			var name:String = objectFactory.objectDefinitionRegistry.getObjectDefinitionName(definition);
			var instance:Object = objectFactory.getObject(name);
			var type:Type = Type.forInstance(instance, objectFactory.applicationDomain);
			var md:Metadata = type.getMetadata(FACTORY_METADATA_NAME)[0];
			if (md.hasArgumentWithKey(FACTORY_METHOD_FIELD_NAME)) {
				replaceFactoryInstance(definition, md, instance, objectFactory.cache, name);
				logger.debug("Processed factory definition {0}", [name]);
			} else {
				if (_throwError) {
					throw new IllegalOperationError(StringUtils.substitute("Class {0} contains [Factory] metadata but no factoryMethod argument", definition.clazz));
				}
			}
		}

		/**
		 *
		 * @param definition
		 * @param metadata
		 * @param instance
		 * @param objectFactory
		 * @param objectName
		 */
		public function replaceFactoryInstance(definition:IObjectDefinition, metadata:Metadata, instance:Object, cache:IInstanceCache, objectName:String):void {
			var methodName:String = metadata.getArgument(FACTORY_METHOD_FIELD_NAME).value;
			var genericFactory:GenericFactoryObject = new GenericFactoryObject(instance, methodName, definition.isSingleton);
			definition.scope = ObjectDefinitionScope.SINGLETON;
			if (cache.hasInstance(objectName)) {
				cache.removeInstance(objectName);
			}
			cache.putInstance(objectName, genericFactory);
		}

	}
}
