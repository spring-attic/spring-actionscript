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
	import flash.system.ApplicationDomain;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	/**
	 * Aggregates all <code>IObjectDefinitions</code> who have non-null parent and/or interfaceDefinitions properties
	 * and merges the referenced <code>IObjectDefinitions</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinitionFactoryPostProcessor extends AbstractOrderedFactoryPostProcessor {
		private static const DESTROY_METHOD_FIELD_NAME:String = "destroyMethod";
		private static const FACTORY_METHOD_FIELD_NAME:String = "factoryMethod";
		private static const FACTORY_OBJECT_NAME_FIELD_NAME:String = "factoryObjectName";
		private static const INIT_METHOD_FIELD_NAME:String = "initMethod";
		private static const IS_INTERFACE_FIELD_NAME:String = "isInterface";
		private static const PARENT_FIELD_NAME:String = "parent";
		private static const CLASS_NAME_FIELD_NAME:String = "className";

		private static var logger:ILogger = getClassLogger(ObjectDefinitionFactoryPostProcessor);

		/**
		 * Creates a new <code>ObjectDefinitionFactoryPostProcessor</code> instance.
		 */
		public function ObjectDefinitionFactoryPostProcessor(orderPosition:int) {
			super(orderPosition);
		}

		/**
		 *
		 * @param objectFactory
		 * @return
		 */
		override public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			var registry:IObjectDefinitionRegistry = objectFactory.objectDefinitionRegistry;
			resolveParentDefinitions(registry);
			mergeParentDefinitions(registry, objectFactory.applicationDomain);
			mergeInterfaceDefinitions(registry, objectFactory.applicationDomain);
			return null;
		}

		/**
		 *
		 * @param sourceDefinition
		 * @param destinationDefinition
		 */
		public function copyConstructorArguments(sourceDefinition:IObjectDefinition, destinationDefinition:IObjectDefinition):void {
			if ((destinationDefinition.constructorArguments == null) && (sourceDefinition.constructorArguments != null)) {
				destinationDefinition.constructorArguments = sourceDefinition.constructorArguments.concat();
			}
		}

		/**
		 *
		 * @param sourceDefinition
		 * @param destinationDefinition
		 * @param propertyName
		 */
		public function copyDefinitionProperty(sourceDefinition:IObjectDefinition, destinationDefinition:IObjectDefinition, propertyName:String):void {
			if (!StringUtils.hasText(destinationDefinition[propertyName])) {
				destinationDefinition[propertyName] = sourceDefinition[propertyName];
			}
		}

		public function copyMethodInvocation(destinationDefinition:IObjectDefinition, methodInvocation:MethodInvocation):void {
			if (destinationDefinition.getMethodInvocationByName(methodInvocation.methodName, methodInvocation.namespaceURI) == null) {
				destinationDefinition.addMethodInvocation(methodInvocation.clone());
			}
		}

		/**
		 *
		 * @param destinationDefinition
		 * @param propertyDefinition
		 */
		public function copyProperty(destinationDefinition:IObjectDefinition, propertyDefinition:PropertyDefinition):void {
			if (destinationDefinition.getPropertyDefinitionByName(propertyDefinition.name, propertyDefinition.namespaceURI) == null) {
				destinationDefinition.addPropertyDefinition(PropertyDefinition(propertyDefinition.clone()));
			}
		}


		/**
		 *
		 * @param objectNames
		 * @param interfaceClass
		 * @param registry
		 * @param applicationDomain
		 * @return
		 */
		public function getImplementations(objectNames:Vector.<String>, interfaceClass:Class, registry:IObjectDefinitionRegistry, applicationDomain:ApplicationDomain):Vector.<IObjectDefinition> {
			var result:Vector.<IObjectDefinition>;
			for each (var objectName:String in objectNames) {
				var definition:IObjectDefinition = registry.getObjectDefinition(objectName);
				if (ClassUtils.isImplementationOf(definition.clazz, interfaceClass, applicationDomain)) {
					result ||= new Vector.<IObjectDefinition>();
					result[result.length] = definition;
					logger.debug("Definition {0} implements {1}, adding it to the list to be merged", [objectName, interfaceClass]);
				}
			}
			return result;
		}

		/**
		 *
		 * @param interfaceDefinition
		 * @param implementations
		 */
		public function mergeInterfaceDefinitionWithObjectDefinitions(interfaceDefinition:IObjectDefinition, implementations:Vector.<IObjectDefinition>):void {
			for each (var objectDefinition:IObjectDefinition in implementations) {
				copyDefinitionProperty(interfaceDefinition, objectDefinition, DESTROY_METHOD_FIELD_NAME);
				copyDefinitionProperty(interfaceDefinition, objectDefinition, FACTORY_METHOD_FIELD_NAME);
				copyDefinitionProperty(interfaceDefinition, objectDefinition, FACTORY_OBJECT_NAME_FIELD_NAME);
				copyDefinitionProperty(interfaceDefinition, objectDefinition, INIT_METHOD_FIELD_NAME);
				mergeObjectDefinitions(interfaceDefinition, objectDefinition);
				mergeCustomConfigurators(interfaceDefinition, objectDefinition);
			}
		}

		/**
		 *
		 * @param registry
		 * @param applicationDomain
		 */
		public function mergeInterfaceDefinitions(registry:IObjectDefinitionRegistry, applicationDomain:ApplicationDomain):void {
			var interfaces:Vector.<String> = registry.getDefinitionNamesWithPropertyValue(IS_INTERFACE_FIELD_NAME, true);
			var objects:Vector.<String> = registry.getDefinitionNamesWithPropertyValue(IS_INTERFACE_FIELD_NAME, false);
			if ((interfaces != null) && (objects != null)) {
				for each (var interfaceName:String in interfaces) {
					var interfaceDefinition:IObjectDefinition = registry.getObjectDefinition(interfaceName);
					var cls:Class = interfaceDefinition.clazz;
					logger.debug("Processing interface definition '{0}', for interface {1}", [cls]);
					var implementations:Vector.<IObjectDefinition> = getImplementations(objects, cls, registry, applicationDomain);
					logger.debug("Found {0} definitions that implement interface '{1}', merging...", [(implementations != null) ? implementations.length : 0, cls]);
					mergeInterfaceDefinitionWithObjectDefinitions(interfaceDefinition, implementations);
				}
			}
		}

		/**
		 *
		 * @param sourceDefinition
		 * @param destinationDefinition
		 */
		public function mergeMethodInvocations(sourceDefinition:IObjectDefinition, destinationDefinition:IObjectDefinition):void {
			for each (var methodInvocation:MethodInvocation in sourceDefinition.methodInvocations) {
				copyMethodInvocation(destinationDefinition, methodInvocation);
			}
		}

		/**
		 *
		 * @param sourceDefinition
		 * @param destinationDefinition
		 */
		public function mergeObjectDefinitions(sourceDefinition:IObjectDefinition, destinationDefinition:IObjectDefinition):void {
			mergeProperties(sourceDefinition, destinationDefinition);
			mergeMethodInvocations(sourceDefinition, destinationDefinition);
			mergeCustomConfigurators(sourceDefinition, destinationDefinition);
		}

		public function mergeCustomConfigurators(sourceDefinition:IObjectDefinition, destinationDefinition:IObjectDefinition):void {
			if (sourceDefinition.customConfiguration != null) {
				var configurators:Vector.<Object>;
				if (sourceDefinition.customConfiguration is Vector.<Object>) {
					configurators = sourceDefinition.customConfiguration;
				} else if (sourceDefinition.customConfiguration is ICustomConfigurator) {
					configurators = new Vector.<Object>();
					configurators[configurators.length] = sourceDefinition.customConfiguration;
				}
				if (configurators != null) {
					if (destinationDefinition.customConfiguration != null) {
						var otherConfigurators:Vector.<Object>;
						if (destinationDefinition.customConfiguration is Vector.<Object>) {
							otherConfigurators = destinationDefinition.customConfiguration;
						} else if (destinationDefinition.customConfiguration is ICustomConfigurator) {
							otherConfigurators = new Vector.<Object>();
							otherConfigurators[otherConfigurators.length] = destinationDefinition.customConfiguration;
						}
						if (otherConfigurators != null) {
							for each (var config:Object in configurators) {
								otherConfigurators[otherConfigurators.length] = config;
							}
							destinationDefinition.customConfiguration = otherConfigurators;
						}
					} else {
						if (configurators.length > 1) {
							destinationDefinition.customConfiguration = configurators;
						} else {
							destinationDefinition.customConfiguration = configurators[0];
						}
					}
				}
			}
		}

		/**
		 *
		 * @param registry
		 * @param objectDefinition
		 */
		public function mergeParentDefinition(registry:IObjectDefinitionRegistry, objectDefinition:IObjectDefinition):void {
			copyConstructorArguments(objectDefinition.parent, objectDefinition);
			copyDefinitionProperty(objectDefinition.parent, objectDefinition, DESTROY_METHOD_FIELD_NAME);
			copyDefinitionProperty(objectDefinition.parent, objectDefinition, FACTORY_METHOD_FIELD_NAME);
			copyDefinitionProperty(objectDefinition.parent, objectDefinition, FACTORY_OBJECT_NAME_FIELD_NAME);
			copyDefinitionProperty(objectDefinition.parent, objectDefinition, INIT_METHOD_FIELD_NAME);
			copyDefinitionProperty(objectDefinition.parent, objectDefinition, CLASS_NAME_FIELD_NAME);
			if (objectDefinition.clazz == null) {
				objectDefinition.clazz = objectDefinition.parent.clazz;
			}
			objectDefinition.autoWireMode = objectDefinition.parent.autoWireMode;
			objectDefinition.dependencyCheck = objectDefinition.parent.dependencyCheck;
			objectDefinition.scope = objectDefinition.parent.scope;
			objectDefinition.isLazyInit = objectDefinition.parent.isLazyInit;
			objectDefinition.dependsOn = objectDefinition.parent.dependsOn;
		}

		/**
		 *
		 * @param registry
		 * @param applicationDomain
		 */
		public function mergeParentDefinitions(registry:IObjectDefinitionRegistry, applicationDomain:ApplicationDomain):void {
			var objectNames:Vector.<String> = registry.getDefinitionNamesWithPropertyValue(PARENT_FIELD_NAME, null, false);
			for each (var name:String in objectNames) {
				var objectDefinition:IObjectDefinition = registry.getObjectDefinition(name);
				logger.debug("Merging parent '{0}' with definition '{1}'", [objectDefinition.parentName, name]);
				mergeParentDefinition(registry, objectDefinition);
				mergeObjectDefinitions(objectDefinition.parent, objectDefinition);
			}
		}

		/**
		 *
		 * @param sourceDefinition
		 * @param destinationDefinition
		 */
		public function mergeProperties(sourceDefinition:IObjectDefinition, destinationDefinition:IObjectDefinition):void {
			for each (var propertyDefinition:PropertyDefinition in sourceDefinition.properties) {
				copyProperty(destinationDefinition, propertyDefinition);
			}
		}

		/**
		 *
		 * @param registry
		 */
		public function resolveParentDefinitions(registry:IObjectDefinitionRegistry):void {
			for each (var name:String in registry.objectDefinitionNames) {
				var objectDefinition:IObjectDefinition = registry.getObjectDefinition(name);
				if (StringUtils.hasText(objectDefinition.parentName)) {
					logger.debug("Setting parent '{0}' for definition '{1}'", [objectDefinition.parentName, name]);
					objectDefinition.parent = registry.getObjectDefinition(objectDefinition.parentName);
				}
			}
		}
	}
}
