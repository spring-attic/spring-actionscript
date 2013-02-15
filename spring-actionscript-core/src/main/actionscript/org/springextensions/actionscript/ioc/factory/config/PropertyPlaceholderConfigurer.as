/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.config {

	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.core.IOrdered;
	import org.springextensions.actionscript.core.io.IResourceLoader;
	import org.springextensions.actionscript.core.io.support.LoadPropertiesBatchOperation;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.IProgressOperation;
	import org.springextensions.actionscript.core.operation.OperationEvent;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.MethodInvocation;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.utils.PropertyPlaceholderResolver;

	/**
	 * @author Christophe Herreman
	 */
	public class PropertyPlaceholderConfigurer implements IObjectFactoryPostProcessor, IResourceLoader, IOrdered {

		// --------------------------------------------------------------------
		//
		// Private Constants
		//
		// --------------------------------------------------------------------

		/** Regular expression to resolve property placeholder with the pattern ${...} */
		private static const PROPERTY_REGEXP:RegExp = /\$\{[^}]+\}/g;

		/** Regular expression to resolve property placeholder with the pattern $(...) */
		private static const PROPERTY_REGEXP2:RegExp = /\$\([^)]+\)/g;

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		/** The object factory that this post processor operates on. */
		private var _objectFactory:IObjectFactory;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>PropertyPlaceholderConfigurer</code> instance.
		 */
		public function PropertyPlaceholderConfigurer() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// order
		// ----------------------------

		private var _order:int = 0;

		public function get order():int {
			return _order;
		}

		public function set order(value:int):void {
			_order = value;
		}

		// ----------------------------
		// properties
		// ----------------------------

		private var _properties:Properties;

		public function get properties():Properties {
			return _properties;
		}

		public function set properties(value:Properties):void {
			_properties = value;
		}

		// ----------------------------
		// location
		// ----------------------------

		public function set location(value:String):void {
			_locations = [value];
		}

		// ----------------------------
		// locations
		// ----------------------------

		private var _locations:Array;

		public function set locations(value:Array):void {
			if (value !== _locations) {
				_locations = value;
			}
		}

		// ----------------------------
		// ignoreResourceNotFound
		// ----------------------------

		private var _ignoreResourceNotFound:Boolean = false;

		/**
		 * Sets if a failure to find the property resource should be ignored or should result in a runtime error.
		 *
		 * <p><code>true</code> is appropriate if the properties file is completely optional.</p>
		 * @default false
		 */
		public function set ignoreResourceNotFound(value:Boolean):void {
			if (value !== _ignoreResourceNotFound) {
				_ignoreResourceNotFound = value;
			}
		}

		// ----------------------------
		// ignoreResourceNotFound
		// ----------------------------

		private var _ignoreUnresolvablePlaceholders:Boolean = false;

		/**
		 * Sets whether to ignore unresolvable placeholders. Default is "false":
		 * An exception will be thrown if a placeholder cannot be resolved.
		 */
		public function set ignoreUnresolvablePlaceholders(value:Boolean):void {
			if (value !== _ignoreUnresolvablePlaceholders) {
				_ignoreUnresolvablePlaceholders = value;
			}
		}

		// ----------------------------
		// preventCache
		// ----------------------------

		private var _preventCache:Boolean = true;

		public function set preventCache(value:Boolean):void {
			if (value !== _preventCache) {
				_preventCache = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IObjectFactoryResourceLoader: Methods
		//
		// --------------------------------------------------------------------

		public function load():IOperation {
			var progressOperation:IProgressOperation = new LoadPropertiesBatchOperation(_locations, _ignoreResourceNotFound, _preventCache);

			// complete listener
			progressOperation.addCompleteListener(function(event:OperationEvent):void {
				//logger.debug("Successfully loaded properties from location '{0}'", location);
				_properties = event.operation.result;
			});

			return progressOperation;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IObjectFactoryPostProcessor: Methods
		//
		// --------------------------------------------------------------------

		public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			_objectFactory = objectFactory;

			var mergedProperties:Properties = mergeProperties(_properties);
			var resolver:PropertyPlaceholderResolver = new PropertyPlaceholderResolver(null, mergedProperties, _ignoreUnresolvablePlaceholders);

			_objectFactory.properties.merge(mergedProperties);

			// resolve property placeholders in the object definitions of the factory
			for each (var objectName:String in objectFactory.objectDefinitionNames) {
				resolvePropertyPlaceholdersForObjectName(resolver, objectName);
			}

			// resolve property placeholders in the explicit singleton objects of the factory
			var explicitSingletonNames:Array = objectFactory.explicitSingletonNames;

			for each (var explicitSingletonName:String in explicitSingletonNames) {
				var singleton:Object = objectFactory.getObject(explicitSingletonName);
				resolvePropertyPlaceholdersForInstance(resolver, singleton);
			}
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Merges the loaded properties with any properties set in a subclass.
		 *
		 * @param properties
		 * @return the merged properties
		 */
		protected function mergeProperties(properties:Properties):Properties {
			return properties;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Resolves all property placeholders for the constructor arguments and the properties of
		 * the given object definition.
		 *
		 * Note that we use 2 regular expressions (${...} and $(...)) to handle both XML and MXML property
		 * placeholders.
		 *
		 * @param resolver the property placeholder resolver used
		 * @param objectName the name of the definition for which to resolve it property placeholders
		 */
		private function resolvePropertyPlaceholdersForObjectName(resolver:PropertyPlaceholderResolver, objectName:String):void {
			//logger.debug("Resolving property placeholders in object definition '{0}'", objectDefinition.className);
			var objectDefinition:IObjectDefinition = _objectFactory.objectDefinitions[objectName];

			// resolve constructor arguments

			var numConstructorArgs:uint = objectDefinition.constructorArguments.length;

			for (var i:uint = 0; i < numConstructorArgs; i++) {
				var constructorArg:* = objectDefinition.constructorArguments[i];
				if (constructorArg is String) {
					//logger.debug("Resolving property placeholders in constructor arg '{0}'", constructorArg);
					objectDefinition.constructorArguments[i] = resolver.resolvePropertyPlaceholders(constructorArg, PROPERTY_REGEXP);
					objectDefinition.constructorArguments[i] = resolver.resolvePropertyPlaceholders(objectDefinition.constructorArguments[i], PROPERTY_REGEXP2);
				}
			}

			// resolve properties

			var properties:Object = objectDefinition.properties;
			var propertyNames:Array = ObjectUtils.getKeys(properties);

			for each (var propertyName:String in propertyNames) {
				//logger.debug("Resolving property placeholders in property '{0}'", propertyName);
				if (properties[propertyName] is String) {
					//logger.debug("Resolving property placeholders in property '{0}' with value '{1}'", propertyName, properties[propertyName]);
					properties[propertyName] = resolver.resolvePropertyPlaceholders(properties[propertyName], PROPERTY_REGEXP);
					properties[propertyName] = resolver.resolvePropertyPlaceholders(properties[propertyName], PROPERTY_REGEXP2);
				}
			}

			// resolve method invocations
			for each (var mi:MethodInvocation in objectDefinition.methodInvocations) {
				i = 0;
				for each (var arg:Object in mi.arguments) {
					if (arg is String) {
						mi.arguments[i] = resolver.resolvePropertyPlaceholders(String(arg), PROPERTY_REGEXP);
						mi.arguments[i] = resolver.resolvePropertyPlaceholders(String(arg), PROPERTY_REGEXP2);
					}
					i++;
				}
			}

			// resolve result of factory method
			if (objectDefinition.factoryObjectName && objectDefinition.factoryMethod) {
				resolvePropertyPlaceholdersForInstance(resolver, _objectFactory.getObject(objectName));
			}
		}

		/**
		 * Resolves all property placeholders in the given instance.
		 *
		 * @param resolver the property placeholder resolver used
		 * @param instance the instance for which to resolve its property placeholders
		 */
		private function resolvePropertyPlaceholdersForInstance(resolver:PropertyPlaceholderResolver, instance:Object):void {
			if (!resolver && !instance) {
				return;
			}

			switch (true) {
				case (instance is Array):
					var array:Array = instance as Array;
					var numItems:uint = array.length;
					for (var i:int = 0; i < numItems; i++) {
						if (array[i] is String) {
							array[i] = resolver.resolvePropertyPlaceholders(array[i], PROPERTY_REGEXP);
							array[i] = resolver.resolvePropertyPlaceholders(array[i], PROPERTY_REGEXP2);
						}
					}
					break;

				default:
					var type:Type = Type.forInstance(instance, _objectFactory.applicationDomain);
					for each (var property:Accessor in type.accessors) {
						if ((property) && (property.type)) {
							if ((property.type.clazz == String) && property.writeable && property.readable) {
								instance[property.name] = resolver.resolvePropertyPlaceholders(instance[property.name], PROPERTY_REGEXP);
								instance[property.name] = resolver.resolvePropertyPlaceholders(instance[property.name], PROPERTY_REGEXP2);
							}
						}
					}
			}

		}

	}
}