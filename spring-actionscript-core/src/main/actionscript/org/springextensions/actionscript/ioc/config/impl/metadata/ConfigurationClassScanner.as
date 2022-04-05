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
package org.springextensions.actionscript.ioc.config.impl.metadata {
	import avmplus.getQualifiedClassName;
	
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.metadata.util.MetadataConfigUtils;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ConfigurationClassScanner implements IApplicationDomainAware {

		public static const SCANNING_CONFIG_CLASS:String = "Scanning configuration class '{0}'.";
		public static const NAME_ATTR:String = "name";
		public static const NAMESPACE_ATTR:String = "namespace";

		private var _metadataConfigUtils:MetadataConfigUtils;
		private var _applicationDomain:ApplicationDomain;
		private static const LOGGER:ILogger = getClassLogger(ConfigurationClassScanner);
		private static const IS_STATIC_ATTR:String = "isStatic";
		private var _applicationContext:IApplicationContext;

		/**
		 * Creates a new <code>ConfgurationClassScanner</code> instance.
		 */
		public function ConfigurationClassScanner(utils:MetadataConfigUtils, applicationContext:IApplicationContext) {
			super();
			_metadataConfigUtils = utils;
			_applicationContext = applicationContext;
		}

		public function scanClassNames(classNames:Array, objectDefinitionRegistry:IObjectDefinitionRegistry, customConfigurators:Object):void {
			for each (var className:String in classNames) {
				scan(className, objectDefinitionRegistry, customConfigurators);
			}
		}

		public function scan(className:String, objectDefinitionRegistry:IObjectDefinitionRegistry, customConfigurators:Object):void {
			LOGGER.debug(SCANNING_CONFIG_CLASS, [className]);
			var type:Type = Type.forName(className, _applicationDomain);
			var properties:Array = type.properties;
			for each (var property:Field in properties) {
				if (property.declaringType === type) {
					scanProperty(property, objectDefinitionRegistry, customConfigurators);
				}
			}
		}

		public function scanProperty(property:Field, objectDefinitionRegistry:IObjectDefinitionRegistry, customConfigurators:Object):void {
			var definitionName:String = getDefinitionName(property);
			var className:String = getQualifiedClassName(property.type.clazz);
			var definition:IObjectDefinition = new ObjectDefinition(className);
			definition.isInterface = ClassUtils.isInterface(property.type.clazz);
			if (property.hasMetadata(MetadataConfigUtils.COMPONENT_METADATA)) {
				var md:Metadata = property.getMetadata(MetadataConfigUtils.COMPONENT_METADATA)[0] as Metadata;
				_metadataConfigUtils.resolveDefinitionProperties(md, definition, className);
			}
			objectDefinitionRegistry.registerObjectDefinition(definitionName, definition);
			resolveConstructorArgs(property, definition, definitionName);
			resolveMethods(property, definition);
			resolveProperties(property, definition, definitionName);
			for (var name:String in customConfigurators) {
				if (property.hasMetadata(name)) {
					var metadatas:Array = property.getMetadata(name);
					var configurators:Vector.<ICustomConfigurationClassScanner> = customConfigurators[name];
					for each (var configurator:ICustomConfigurationClassScanner in configurators) {
						for each (var metadata:Metadata in metadatas) {
							configurator.execute(metadata, definitionName, definition, objectDefinitionRegistry, _applicationContext);
						}
					}
				}
			}
		}

		public function resolveProperties(property:Field, definition:IObjectDefinition, definitionName:String):void {
			var properties:Array = property.getMetadata(MetadataConfigUtils.PROPERTY_METADATA);
			for each (var metadata:Metadata in properties) {
				addProperty(metadata, definition);
			}
		}

		public function addProperty(metadata:Metadata, definition:IObjectDefinition):void {
			var name:String;
			var namespaceURI:String;
			var isStatic:Boolean;
			if (metadata.hasArgumentWithKey(NAME_ATTR)) {
				name = metadata.getArgument(NAME_ATTR).value;
			} else {
				throw new IllegalOperationError("[Property] metadata requires a name argument when used inside a [Configuration] class.");
			}
			if (metadata.hasArgumentWithKey(NAMESPACE_ATTR)) {
				namespaceURI = metadata.getArgument(NAMESPACE_ATTR).value;
			}
			if (metadata.hasArgumentWithKey(IS_STATIC_ATTR)) {
				isStatic = (metadata.getArgument(IS_STATIC_ATTR).value == MetadataConfigUtils.TRUE_VALUE);
			}
			var propertyValue:*;
			if (metadata.hasArgumentWithKey(MetadataConfigUtils.REF_ATTR)) {
				propertyValue = new RuntimeObjectReference(metadata.getArgument(MetadataConfigUtils.REF_ATTR).value);
			} else if (metadata.hasArgumentWithKey(MetadataConfigUtils.VALUE_ATTR)) {
				propertyValue = metadata.getArgument(MetadataConfigUtils.VALUE_ATTR).value;
			}
			var propertyDef:PropertyDefinition = new PropertyDefinition(name, propertyValue, namespaceURI, isStatic);
			definition.addPropertyDefinition(propertyDef);
		}

		public function resolveMethods(property:Field, definition:IObjectDefinition):void {
			var metadatas:Array = property.getMetadata(MetadataConfigUtils.INVOKE_METADATA);
			for each (var metadata:Metadata in metadatas) {
				addMethod(metadata, definition);
			}
		}

		public function addMethod(metadata:Metadata, definition:IObjectDefinition):void {
			var name:String;
			var namespaceURI:String;
			if (metadata.hasArgumentWithKey(NAME_ATTR)) {
				name = metadata.getArgument(NAME_ATTR).value;
			} else {
				throw new IllegalOperationError("[Invoke] metadata requires a name argument when used inside a [Configuration] class.");
			}
			if (metadata.hasArgumentWithKey(NAMESPACE_ATTR)) {
				namespaceURI = metadata.getArgument(NAMESPACE_ATTR).value;
			}
			var arguments:Vector.<ArgumentDefinition> = _metadataConfigUtils.resolveArguments(metadata);
			var mv:MethodInvocation = new MethodInvocation(name, arguments, namespaceURI);
			definition.addMethodInvocation(mv);

		}

		public function resolveConstructorArgs(property:Field, definition:IObjectDefinition, definitionName:String):void {
			if (property.hasMetadata(MetadataConfigUtils.CONSTRUCTOR_METADATA)) {
				var constructorArguments:Vector.<ArgumentDefinition> = _metadataConfigUtils.resolveArguments(property.getMetadata(MetadataConfigUtils.CONSTRUCTOR_METADATA)[0]);
				if (constructorArguments) {
					definition.constructorArguments = constructorArguments;
				}
			}
		}

		public function getDefinitionName(property:Field):String {
			if (property.hasMetadata(MetadataConfigUtils.COMPONENT_METADATA)) {
				var md:Metadata = property.getMetadata(MetadataConfigUtils.COMPONENT_METADATA)[0] as Metadata;
				if (md.hasArgumentWithKey(MetadataConfigUtils.ID_ATTR)) {
					return md.getArgument(MetadataConfigUtils.ID_ATTR).value;
				}
			}
			return property.name;
		}

		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}
	}
}
