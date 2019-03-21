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
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.config.property.IPropertyPlaceholderResolver;
	import org.springextensions.actionscript.ioc.config.property.impl.PropertyPlaceholderResolver;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.util.TypeUtils;

	/**
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyPlaceholderConfigurerFactoryPostProcessor extends AbstractOrderedFactoryPostProcessor {

		private static var logger:ILogger = getClassLogger(PropertyPlaceholderConfigurerFactoryPostProcessor);

		public static const DESTROY_METHOD_FIELD_NAME:String = 'destroyMethod';
		public static const FACTORY_METHOD_FIELD_NAME:String = 'factoryMethod';
		public static const FACTORY_OBJECT_NAME_FIELD_NAME:String = 'factoryObjectName';
		public static const INIT_METHOD_FIELD_NAME:String = 'initMethod';
		public static const PARENT_NAME_FIELD_NAME:String = 'parentName';

		/** Regular expression to resolve property placeholder with the pattern ${...} */
		public static const PROPERTY_REGEXP:RegExp = /\$\{[^}]+\}/g;

		/** Regular expression to resolve property placeholder with the pattern $(...) */
		public static const PROPERTY_REGEXP2:RegExp = /\$\([^)]+\)/g;

		/**
		 * Creates a new <code>PropertyPlaceholderConfigurer</code> instance.
		 */
		public function PropertyPlaceholderConfigurerFactoryPostProcessor(orderPosition:int) {
			super(orderPosition);
		}

		private var _ignoreUnresolvablePlaceholders:Boolean = false;

		/**
		 * @private
		 */
		public function get ignoreUnresolvablePlaceholders():Boolean {
			return _ignoreUnresolvablePlaceholders;
		}

		/**
		 * Sets whether to ignore unresolvable placeholders. Default is "false":
		 * An exception will be thrown if a placeholder cannot be resolved.
		 */
		public function set ignoreUnresolvablePlaceholders(value:Boolean):void {
			if (value != _ignoreUnresolvablePlaceholders) {
				_ignoreUnresolvablePlaceholders = value;
			}
		}

		override public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			logger.debug("Post processing object factory {0}, ignore unresolvable placeholders set to '{1}'", [objectFactory, _ignoreUnresolvablePlaceholders]);
			
			if ((objectFactory == null) || (objectFactory.propertiesProvider == null)) {
				return null;
			}
			
			var resolver:IPropertyPlaceholderResolver = new PropertyPlaceholderResolver(null, objectFactory.propertiesProvider, _ignoreUnresolvablePlaceholders);

			if (objectFactory.objectDefinitionRegistry != null) {
				for each (var objectName:String in objectFactory.objectDefinitionRegistry.objectDefinitionNames) {
					resolvePropertyPlaceholdersForObjectName(resolver, objectName, objectFactory);
				}
			}

			if (objectFactory.cache != null) {
				var names:Vector.<String> = objectFactory.cache.getCachedNames();
				for each (objectName in names) {
					resolvePropertyPlaceholdersForInstance(resolver, objectFactory.cache.getInstance(objectName), objectFactory);
				}
			}

			return null;
		}

		public function resolveObjectDefinitionProperty(resolver:IPropertyPlaceholderResolver, objectDefinition:IObjectDefinition, propertyName:String):void {
			if (!StringUtils.hasText(objectDefinition[propertyName])) {
				return;
			}
			logger.debug("Resolving property placeholder in property '{0}' of the object definition", [propertyName]);
			objectDefinition[propertyName] = resolver.resolvePropertyPlaceholders(objectDefinition[propertyName], PROPERTY_REGEXP);
			objectDefinition[propertyName] = resolver.resolvePropertyPlaceholders(objectDefinition[propertyName], PROPERTY_REGEXP2);
			logger.debug("Result of resolving property placeholder in property '{0}': '{1}'", [propertyName, objectDefinition[propertyName]]);
		}

		private function resolvePropertyPlaceholdersForInstance(resolver:IPropertyPlaceholderResolver, instance:Object, objectFactory:IObjectFactory):void {
			if ((!resolver && !instance) || (instance is Class)) {
				return;
			}
			logger.debug("Resolving property placeholders in instance '{0}'", [instance]);
			if (instance is Array) {
				logger.debug("Instance '{0}' is an array, checking to see if any items are strings and attempting to resolve possible placeholders.", [instance]);
				var array:Array = instance as Array;
				var numItems:uint = array.length;
				for (var i:int = 0; i < numItems; i++) {
					if ((array[i] is String) && (StringUtils.hasText(array[i]))) {
						logger.debug("Item '{0}' is a String, attempting to resolve placeholders...", [array[i]]);
						array[i] = resolver.resolvePropertyPlaceholders(array[i], PROPERTY_REGEXP);
						array[i] = resolver.resolvePropertyPlaceholders(array[i], PROPERTY_REGEXP2);
						logger.debug("Result of placeholder resolving: '{0}'", [array[i]]);
					}
				}
			} else if (!ObjectUtils.isSimple(instance)) {
				logger.debug("Instance '{0}' is a complex type, attempting to resolve possible placeholder in its properties.", [instance]);
				var type:Type = Type.forInstance(instance, objectFactory.applicationDomain);
				var ns:String = "";
				var qname:QName;
				var prefix:String;
				for each (var property:Accessor in type.accessors) {
					if ((property) && (property.type) && (property.type.clazz == String) && (property.writeable && property.readable)) {
						ns = StringUtils.hasText(property.namespaceURI) ? property.namespaceURI : "";
						prefix = StringUtils.hasText(ns) ? null : "";
						qname = new QName(new Namespace(prefix, ns), property.name);
						try {
							if (StringUtils.hasText(instance[qname])) {
								logger.debug("Accessor '{0}' is of type String, its value is '{1}', attempting to resolve placeholders...", [property.name, instance[qname]]);
								instance[qname] = resolver.resolvePropertyPlaceholders(instance[qname], PROPERTY_REGEXP);
								instance[qname] = resolver.resolvePropertyPlaceholders(instance[qname], PROPERTY_REGEXP2);
								logger.debug("Result of placeholder resolving in accessor '{0}': '{1}'", [property.name, instance[qname]]);
							}
						} catch (e:Error) {
							logger.warn("Accessor '{0}' could not be resolved: {1}", [property.name, e.message]);
						}
					}
				}
				for each (var variable:Variable in type.variables) {
					if ((variable) && (variable.type) && (variable.type.clazz == String)) {
						ns = StringUtils.hasText(variable.namespaceURI) ? variable.namespaceURI : "";
						prefix = StringUtils.hasText(ns) ? null : "";
						qname = new QName(new Namespace(prefix, ns), variable.name);
						try {
							if (StringUtils.hasText(instance[qname])) {
								logger.debug("Variable '{0}' is of type String, its value is '{1}', attempting to resolve placeholders...", [variable.name, instance[qname]]);
								instance[qname] = resolver.resolvePropertyPlaceholders(instance[qname], PROPERTY_REGEXP);
								instance[qname] = resolver.resolvePropertyPlaceholders(instance[qname], PROPERTY_REGEXP2);
								logger.debug("Result of placeholder resolving in variable '{0}': '{1}'", [variable.name, instance[qname]]);
							}
						} catch (e:Error) {
							logger.warn("Property '{0}' could not be resolved: {1}", [variable.name, e.message]);
						}
					}
				}
			}
		}

		private function resolvePropertyPlaceholdersForObjectName(resolver:IPropertyPlaceholderResolver, objectName:String, objectFactory:IObjectFactory):void {
			logger.debug("Resolving property placeholders in object definition '{0}'", [objectName]);
			var objectDefinition:IObjectDefinition = objectFactory.getObjectDefinition(objectName);
			var ref:RuntimeObjectReference;
			var resolvedObjectName:String;

			var i:int = 0;
			var len:int = (objectDefinition.constructorArguments) ? objectDefinition.constructorArguments.length : 0;
			var constructorArg:ArgumentDefinition;
			for (i=0; i < len; ++i) {
				constructorArg = objectDefinition.constructorArguments[i];
				if (constructorArg.value is String) {
					logger.debug("Resolving property placeholders in String constructor arg '{0}'", [constructorArg]);
					constructorArg.value = resolver.resolvePropertyPlaceholders(constructorArg.value, PROPERTY_REGEXP);
					constructorArg.value = resolver.resolvePropertyPlaceholders(constructorArg.value, PROPERTY_REGEXP2);
					logger.debug("Result of placeholder resolving in String constructor arg: '{0}'", [objectDefinition.constructorArguments[i]]);
				} else if (constructorArg.ref != null) {
					logger.debug("Constructor argument is a RuntimeObjectReference, attempting to resolve placeholders in its objectName property.");
					ref = constructorArg.ref;
					resolvedObjectName = null;
					if (ref.objectName.match(PROPERTY_REGEXP).length > 0) {
						resolvedObjectName = resolver.resolvePropertyPlaceholders(ref.objectName, PROPERTY_REGEXP);
					} else if (ref.objectName.match(PROPERTY_REGEXP2).length > 0) {
						resolvedObjectName = resolver.resolvePropertyPlaceholders(ref.objectName, PROPERTY_REGEXP2);
					}
					if (resolvedObjectName != null) {
						objectDefinition.constructorArguments[i].ref = new RuntimeObjectReference(resolvedObjectName);
						logger.debug("Result of placeholder resolving in objectName property: '{0}'", [resolvedObjectName]);
					}
				}
			}

			var propDef:PropertyDefinition;
			len = (objectDefinition.properties) ? objectDefinition.properties.length : 0;
			for (i=0; i < len; ++i) {
				propDef = objectDefinition.properties[i];
				logger.debug("Resolving property placeholders in property '{0}'", [propDef]);
				if (propDef.lazyPropertyResolving) {
					logger.debug("property '{0}' as lazy property resolving set to true, skipping it for now.", [propDef.name]);
					continue;
				}
				propDef.name = resolver.resolvePropertyPlaceholders(propDef.name, PROPERTY_REGEXP);
				propDef.name = resolver.resolvePropertyPlaceholders(propDef.name, PROPERTY_REGEXP2);
				propDef.namespaceURI = resolver.resolvePropertyPlaceholders(propDef.namespaceURI, PROPERTY_REGEXP);
				propDef.namespaceURI = resolver.resolvePropertyPlaceholders(propDef.namespaceURI, PROPERTY_REGEXP2);
				if (propDef.valueDefinition.value is String) {
					logger.debug("Resolving property placeholders in property '{0}' with value '{1}'", [propDef.name, propDef.valueDefinition]);
					propDef.valueDefinition.value = resolver.resolvePropertyPlaceholders(propDef.valueDefinition.value, PROPERTY_REGEXP);
					propDef.valueDefinition.value = resolver.resolvePropertyPlaceholders(propDef.valueDefinition.value, PROPERTY_REGEXP2);
					logger.debug("Result of resolving property placeholders in property '{0}': '{1}'", [propDef.name, propDef.valueDefinition]);
				} else if (propDef.valueDefinition.ref != null) {
					logger.debug("Property definition value is a RuntimeObjectReference, attempting to resolve placeholders in its objectName property.");
					ref = propDef.valueDefinition.ref;
					resolvedObjectName = null;
					if (ref.objectName.match(PROPERTY_REGEXP).length > 0) {
						resolvedObjectName = resolver.resolvePropertyPlaceholders(ref.objectName, PROPERTY_REGEXP);
					} else if (ref.objectName.match(PROPERTY_REGEXP2).length > 0) {
						resolvedObjectName = resolver.resolvePropertyPlaceholders(ref.objectName, PROPERTY_REGEXP2);
					}
					if (resolvedObjectName != null) {
						propDef.valueDefinition = ArgumentDefinition.newInstance(new RuntimeObjectReference(resolvedObjectName), propDef.lazyPropertyResolving);
						logger.debug("Result of placeholder resolving in objectName property: '{0}'", [resolvedObjectName]);
					}
				}
			}

			// resolve method invocations
			var arg:ArgumentDefinition;
			for each (var mi:MethodInvocation in objectDefinition.methodInvocations) {
				mi.methodName = resolver.resolvePropertyPlaceholders(mi.methodName, PROPERTY_REGEXP);
				mi.methodName = resolver.resolvePropertyPlaceholders(mi.methodName, PROPERTY_REGEXP2);
				mi.namespaceURI = resolver.resolvePropertyPlaceholders(mi.namespaceURI, PROPERTY_REGEXP);
				mi.namespaceURI = resolver.resolvePropertyPlaceholders(mi.namespaceURI, PROPERTY_REGEXP2);
				len = (mi.arguments) ? mi.arguments.length : 0;
				for (i=0; i < len; ++i) {
					arg = mi.arguments[i];
					if (arg.value is String) {
						logger.debug("Resolving property placeholders in String method invocation arg arg '{0}'", [arg]);
						mi.arguments[i].value = resolver.resolvePropertyPlaceholders(String(arg.value), PROPERTY_REGEXP);
						mi.arguments[i].value = resolver.resolvePropertyPlaceholders(String(arg.value), PROPERTY_REGEXP2);
						logger.debug("Result of placeholder resolving in String constructor arg: '{0}'", [mi.arguments[i]]);
					} else if (arg.ref != null) {
						logger.debug("Method invocation arg is a RuntimeObjectReference, attempting to resolve placeholders in its objectName property.");
						ref = arg.ref;
						resolvedObjectName = null;
						if (ref.objectName.match(PROPERTY_REGEXP).length > 0) {
							resolvedObjectName = resolver.resolvePropertyPlaceholders(ref.objectName, PROPERTY_REGEXP);
						} else if (ref.objectName.match(PROPERTY_REGEXP2).length > 0) {
							resolvedObjectName = resolver.resolvePropertyPlaceholders(ref.objectName, PROPERTY_REGEXP2);
						}
						if (resolvedObjectName != null) {
							mi.arguments[i] = new ArgumentDefinition(null, new RuntimeObjectReference(resolvedObjectName));
							logger.debug("Result of placeholder resolving in objectName property: '{0}'", [resolvedObjectName]);
						}
					}
				}
			}

			var dep:String;
			len = (objectDefinition.dependsOn) ? objectDefinition.dependsOn.length : 0;
			for (i=0; i < len; ++i) {
				dep = objectDefinition.dependsOn[i];
				logger.debug("Resolving property placeholders in depends-on value: '{0}'", [dep]);
				dep = resolver.resolvePropertyPlaceholders(dep, PROPERTY_REGEXP);
				objectDefinition.dependsOn[i] = resolver.resolvePropertyPlaceholders(dep, PROPERTY_REGEXP2);
				logger.debug("Result of resolving property placeholders in depends-on value: '{0}'", [objectDefinition.dependsOn[i]]);
			}

			resolveObjectDefinitionProperty(resolver, objectDefinition, DESTROY_METHOD_FIELD_NAME);
			resolveObjectDefinitionProperty(resolver, objectDefinition, FACTORY_METHOD_FIELD_NAME);
			resolveObjectDefinitionProperty(resolver, objectDefinition, FACTORY_OBJECT_NAME_FIELD_NAME);
			resolveObjectDefinitionProperty(resolver, objectDefinition, INIT_METHOD_FIELD_NAME);
			resolveObjectDefinitionProperty(resolver, objectDefinition, PARENT_NAME_FIELD_NAME);

			// resolve result of factory method
			if (objectDefinition.factoryObjectName && objectDefinition.factoryMethod && objectDefinition.isSingleton) {
				resolvePropertyPlaceholdersForInstance(resolver, objectFactory.getObject(objectName), objectFactory);
			}
		}
	}
}
