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
package org.springextensions.actionscript.context.metadata {
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.AbstractMember;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.core.IOrdered;
	import org.springextensions.actionscript.ioc.AutowireMode;
	import org.springextensions.actionscript.ioc.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.MethodInvocation;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.UnsatisfiedDependencyError;
	import org.springextensions.actionscript.utils.PropertyPlaceholderResolver;

	/**
	 * The <code>ObjectDefinitionScanner</code> scans all classes in the application that have been annotated with
	 * [Component] metadata and builds object definitions from these classes. This eliminates the need to configure
	 * the object definition in XML or MXML.
	 *
	 * <p>To configure a class, eligible for component scanning, annotate it with <code>[Component]</code> metadata.
	 * Optionally you can assign it an id ([Component(id="myComponent")]) or use other attributes such as "scope",
	 * "lazyInit", "factoryMethod", "autowire".</p>
	 *
	 * <p>To execute a scan, call the scan() method and pass in a class name that is annotated with [Component]
	 * metadata.</p>
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @docref componentscan.html
	 * @sampleref movie-app-metadata
	 */
	public class ComponentClassScanner extends AbstractClassScanner implements IApplicationContextAware, IOrdered {

		/** Regular expression to resolve property placeholder with the pattern ${...} */
		private static const PROPERTY_REGEXP:RegExp = /\$\{[^}]+\}/g;

		/** Regular expression to resolve property placeholder with the pattern $(...) */
		private static const PROPERTY_REGEXP2:RegExp = /\$\([^)]+\)/g;

		/** The Constructor metadata. */
		public static const CONSTRUCTOR_METADATA:String = "Constructor";

		/** The Invoke metadata. */
		public static const INVOKE_METADATA:String = "Invoke";

		/** The "args" attribute. */
		public static const ARGS_ATTR:String = "args";

		/** The SetProperty metadata. */
		public static const PROPERTY_METADATA:String = "Property";

		/** The "value" attribute. */
		public static const VALUE_ATTR:String = "value";

		/** The "ref" attribute. */
		public static const REF_ATTR:String = "ref";

		/** The Component metadata. */
		public static const COMPONENT_METADATA:String = "Component";

		/** The "id" attribute. */
		public static const ID_ATTR:String = "id";

		/** The "scope" attribute. */
		public static const SCOPE_ATTR:String = "scope";

		/** The "lazyInit" attribute. */
		public static const LAZY_INIT_ATTR:String = "lazyInit";

		/** The "factoryMethod" attribute. */
		public static const FACTORY_METHOD_ATTR:String = "factoryMethod";

		/** The "factoryObject" attribute. */
		public static const FACTORY_OBJECT_NAME_ATTR:String = "factoryObjectName";

		/** The "initMethod" attribute. */
		public static const INIT_METHOD_ATTR:String = "initMethod";

		/** The "destroyMethod" attribute. */
		public static const DESTROY_METHOD_ATTR:String = "destroyMethod";

		/** The "primary" attribute. */
		public static const PRIMARY_ATTR:String = "primary";

		/** The "autowireCandidate" attribute. */
		public static const AUTOWIRE_CANDIDATE_ATTR:String = "autowireCandidate";

		/** The "dependencyCheck" attribute. */
		public static const DEPENDENCY_CHECK_ATTR:String = "dependencyCheck";

		/** The "dependsOn" attribute. */
		public static const DEPENDS_ON_ATTR:String = "dependsOn";

		/** The "autowire" attribute. */
		public static const AUTOWIRE_ATTR:String = "autowire";

		/** The "skipMetaData" attribute. */
		public static const SKIP_METADATA_ATTR:String = "skipMetaData";

		/** The "skipPostProcessors" attribute. */
		public static const SKIP_POSTPROCESSORS_ATTR:String = "skipPostProcessors";

		/** The prefix used when generating object definition names. */
		public static const SCANNED_COMPONENT_NAME_PREFIX:String = "scannedComponent#";

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(ComponentClassScanner);
		private static const TRUE_VALUE:String = "true";
		private static const UNKNOWN_METADATA_ARGUMENT_ERROR:String = "Unknown metadata argument '{0}' encountered on class {1}.";
		private static const MULTIPLE_COMPONENT_METADATA_ERROR:String = "Only one Component metadata annotation can be used";
		private static const CREATING_OBJECT_DEFINITION:String = "Creating object definition for class '{0}'.";
		private static const OBJECT_DEFINITION_ALREADY_EXISTS:String = "Object definition for class '{0}' already exists.";
		private static const SCANNING_CLASS:String = "Scanning class '{0}' for Component metadata.";
		private static const SKIPPING_INTERFACE:String = "Skipping component scan on interface '{0}'.";
		private static const COMMA:String = ',';
		private static const EQUALS:String = '=';

		/** The number of generated components by scanning, used to generate unique object names. */
		private static var _numScannedComponents:uint = 0;

		private var _classBeingScanned:Array;
		private var _resolver:PropertyPlaceholderResolver;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>ObjectDefinitionScanner</code> instance.
		 */
		public function ComponentClassScanner() {
			super([COMPONENT_METADATA]);
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
		// applicationContext
		// ----------------------------

		private var _applicationContext:IApplicationContext;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function scan(className:String):void {
			_resolver = new PropertyPlaceholderResolver();
			_resolver.properties = _applicationContext.properties;

			var clazz:Class = ClassUtils.forName(className, applicationContext.applicationDomain);
			if (ClassUtils.isInterface(clazz)) {
				LOGGER.debug(SKIPPING_INTERFACE, className);
				return;
			}

			var type:Type = Type.forClass(clazz, applicationContext.applicationDomain);

			LOGGER.debug(SCANNING_CLASS, className);

			if (type.hasMetaData(COMPONENT_METADATA)) {
				var metaData:Array = type.getMetaData(COMPONENT_METADATA);

				if (metaData.length > 1) {
					// XXX error out if we have more than 1 component annotation
					// this might be more intelligent and allow for multiple object definitions
					// from the same class
					throw new Error(MULTIPLE_COMPONENT_METADATA_ERROR);
				}

				var componentMetaData:MetaData = metaData[0];
				var componentId:String = getComponentIdFromMetaData(componentMetaData);
				var objectDefinitionExists:Boolean = false;

				if (componentId) {
					objectDefinitionExists = applicationContext.containsObjectDefinition(componentId);
				} else {
					objectDefinitionExists = (ObjectUtils.getNumProperties(applicationContext.getObjectsOfType(clazz)) > 0);
				}

				if (objectDefinitionExists) {
					LOGGER.debug(OBJECT_DEFINITION_ALREADY_EXISTS, className);
				} else {
					LOGGER.debug(CREATING_OBJECT_DEFINITION, className);

					var definition:ObjectDefinition = new ObjectDefinition(className);

					// Definitions for stage components should be non-singleton as they will probably be
					// autowired by a stage processor, so set it isSingleton to false by default.
					// This can always be overridden by adding explicit metadata to the class.
					definition.isSingleton = !ClassUtils.isSubclassOf(clazz, DisplayObject, applicationContext.applicationDomain);

					// set all other properties on the object definition
					for each (var arg:MetaDataArgument in componentMetaData.arguments) {

						switch (arg.key) {
							case SCOPE_ATTR:
								definition.scope = ObjectDefinitionScope.fromName(arg.value);
								break;
							case LAZY_INIT_ATTR:
								definition.isLazyInit = (arg.value == TRUE_VALUE);
								break;
							case PRIMARY_ATTR:
								definition.primary = (arg.value == TRUE_VALUE);
								break;
							case AUTOWIRE_CANDIDATE_ATTR:
								definition.isAutoWireCandidate = (arg.value == TRUE_VALUE);
								break;
							case SKIP_METADATA_ATTR:
								definition.skipMetadata = (arg.value == TRUE_VALUE);
								break;
							case SKIP_POSTPROCESSORS_ATTR:
								definition.skipPostProcessors = (arg.value == TRUE_VALUE);
								break;
							case FACTORY_METHOD_ATTR:
								definition.factoryMethod = arg.value;
								break;
							case FACTORY_OBJECT_NAME_ATTR:
								definition.factoryObjectName = arg.value;
								break;
							case INIT_METHOD_ATTR:
								definition.initMethod = arg.value;
								break;
							case DESTROY_METHOD_ATTR:
								definition.destroyMethod = arg.value;
							case AUTOWIRE_ATTR:
								definition.autoWireMode = AutowireMode.fromName(arg.value);
								break;
							case DEPENDENCY_CHECK_ATTR:
								definition.dependencyCheck = DependencyCheckMode.fromName(arg.value);
							case DEPENDS_ON_ATTR:
								definition.dependsOn = arg.value.split(' ').join('').split(COMMA);
								break;
							default:
								LOGGER.debug(UNKNOWN_METADATA_ARGUMENT_ERROR, arg.key, className);
						}
					}

					// create the object definition id if needed
					if (componentId == null) {
						componentId = SCANNED_COMPONENT_NAME_PREFIX + ++_numScannedComponents;
					}

					_applicationContext.objectDefinitions[componentId] = definition;

					resolveConstructorArgs(type, definition, componentId);
					resolveProperties(type, definition, componentId);
					resolveMethods(type, definition);

					resolvePropertyPlaceholdersForObjectDefinition(_resolver, definition);
				}
			}
		}

		override public function scanClassNames(classNames:Array):void {
			var classes:Array = getClassesFromClassNames(classNames);

			_classBeingScanned = classes;

			for each (var clazz:Class in classes) {
				scan(ClassUtils.getFullyQualifiedName(clazz, true));
			}

			_classBeingScanned = [];
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function resolveConstructorArgs(type:Type, definition:IObjectDefinition, objectDefinitionId:String):void {
			if (type.hasMetaData(CONSTRUCTOR_METADATA)) {
				var constructorArguments:Array = resolveArguments(type.getMetaData(CONSTRUCTOR_METADATA)[0]);
				if (constructorArguments) {
					definition.constructorArguments = constructorArguments;
				}
			} else {
				resolveConstructorArgsViaReflection(type, definition, objectDefinitionId);
			}
		}

		protected function resolveConstructorArgsViaReflection(type:Type, definition:IObjectDefinition, objectDefinitionId:String):void {
			if (type.constructor && type.constructor.parameters) {
				var numConstructorArgs:uint = type.constructor.parameters.length;

				for (var i:int = 0; i < numConstructorArgs; i++) {
					var constructorArg:Parameter = type.constructor.parameters[i];
					var constructorArgClass:Class = constructorArg.type.clazz;
					var objectDefinitionsThatMatchConstructorArgClass:Object = getObjectDefinitionsThatMatchClass(constructorArgClass, objectDefinitionId);
					var numObjectDefinitions:int = ObjectUtils.getNumProperties(objectDefinitionsThatMatchConstructorArgClass);

					if (numObjectDefinitions == 0) {
						throw new Error("Unsatisfied dependency");
					} else if (numObjectDefinitions == 1) {
						if (definition.constructorArguments == null) {
							definition.constructorArguments = [];
						}

						var constructorArgDefinitionId:String = ObjectUtils.getKeys(objectDefinitionsThatMatchConstructorArgClass)[0];
						definition.constructorArguments.push(new RuntimeObjectReference(constructorArgDefinitionId));
					}

				}
			}
		}

		protected function resolveProperties(type:Type, definition:IObjectDefinition, objectDefinitionId:String):void {
			resolvePropertiesFromMetadata(type, definition);
			//resolvePropertiesViaReflection(type, definition, objectDefinitionId);
		}

		protected function resolvePropertiesFromMetadata(type:Type, definition:IObjectDefinition):void {
			var containers:Array = type.getMetaDataContainers(PROPERTY_METADATA);
			for each (var container:IMetaDataContainer in containers) {
				if (container is Field) {
					addProperty(Field(container), definition);
				}
			}
		}

		protected function resolvePropertiesViaReflection(type:Type, definition:IObjectDefinition, objectDefinitionId:String):void {
			if (type.properties) {
				var numProperties:uint = type.properties.length;

				for (var i:int = 0; i < numProperties; i++) {
					var property:AbstractMember = type.properties[i];
					var isPrototypeProperty:Boolean = (property.name == "prototype");
					var propertyAlreadyInObjectDefinition:Boolean = (definition.properties[property.name] != null);

					if (!isPrototypeProperty && !propertyAlreadyInObjectDefinition) {
						var propertyClass:Class = property.type.clazz;
						var objectDefinitionsThatMatchPropertyClass:Object = getObjectDefinitionsThatMatchClass(propertyClass, objectDefinitionId, property.name);
						var numObjectDefinitions:int = ObjectUtils.getNumProperties(objectDefinitionsThatMatchPropertyClass);

						if (numObjectDefinitions == 0) {
							throw new Error("Unsatisfied dependency");
						} else if (numObjectDefinitions == 1) {
							if (definition.properties == null) {
								definition.properties = [];
							}

							var propertyDefinitionId:String = ObjectUtils.getKeys(objectDefinitionsThatMatchPropertyClass)[0];
							definition.properties[property.name] = new RuntimeObjectReference(propertyDefinitionId);
						}
					}
				}
			}
		}

		protected function getObjectDefinitionsThatMatchClass(clazz:Class, objectDefinitionId:String, propertyName:String = ""):Object {
			var result:Object = applicationContext.getObjectsOfType(clazz);

			// no definition for class, perhaps the class has not been scanned yet
			if (ObjectUtils.getNumProperties(result) == 0) {
				// if this clazz is an interface, look up an implementation in the classes that are currently being scanned
				if (ClassUtils.isInterface(clazz)) {
					var implementationClasses:Array = getInterfaceImplementations(clazz, _classBeingScanned);

					if (implementationClasses.length == 0) {
						throw new UnsatisfiedDependencyError(objectDefinitionId, propertyName, "No implementation of interface '" + clazz + "' found.");
					} else if (implementationClasses.length == 1) {
						scan(ClassUtils.getFullyQualifiedName(implementationClasses[0], true));
					} else {
						throw new UnsatisfiedDependencyError(objectDefinitionId, propertyName, "More than one implementation of interface '" + clazz + "' found.");
					}
				} else {
					scan(ClassUtils.getFullyQualifiedName(clazz, true));
				}
			}

			result = applicationContext.getObjectsOfType(clazz);

			return result;
		}

		protected function addProperty(field:Field, definition:IObjectDefinition):void {
			var metadata:MetaData = field.getMetaData(PROPERTY_METADATA)[0];
			if (metadata.hasArgumentWithKey(REF_ATTR)) {
				definition.properties[field.name] = new RuntimeObjectReference(metadata.getArgument(REF_ATTR).value);
			} else if (metadata.hasArgumentWithKey(VALUE_ATTR)) {
				definition.properties[field.name] = metadata.getArgument(VALUE_ATTR).value;
			}
		}

		protected function resolveMethods(type:Type, definition:IObjectDefinition):void {
			var containers:Array = type.getMetaDataContainers(INVOKE_METADATA);
			for each (var container:IMetaDataContainer in containers) {
				if (container is Method) {
					addMethod(Method(container), definition);
				}
			}
		}

		protected function addMethod(method:Method, definition:IObjectDefinition):void {
			var metadata:MetaData = method.getMetaData(INVOKE_METADATA)[0];
			var arguments:Array = resolveArguments(metadata);
			definition.methodInvocations[definition.methodInvocations.length] = new MethodInvocation(method.name, arguments);
		}

		protected function resolveArguments(metadata:MetaData):Array {
			var result:Array = [];

			if (metadata.hasArgumentWithKey(ARGS_ATTR)) {
				var arg:String = metadata.getArgument(ARGS_ATTR).value;
				if (arg.length > 0) {
					var args:Array = arg.split(COMMA);
					var keyvalue:Array;
					for each (var val:String in args) {
						val = StringUtils.trim(val);
						keyvalue = val.split(EQUALS);
						if (StringUtils.trim(keyvalue[0]) == REF_ATTR) {
							result[result.length] = new RuntimeObjectReference(StringUtils.trim(keyvalue[1]));
						} else if (StringUtils.trim(keyvalue[0]) == VALUE_ATTR) {
							result[result.length] = StringUtils.trim(keyvalue[1]);
						}
					}
				}
			}

			return (result.length > 0) ? result : null;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function getComponentIdFromMetaData(metadata:MetaData):String {
			var result:String;

			if (metadata.hasArgumentWithKey(ID_ATTR)) {
				result = metadata.getArgument(ID_ATTR).value;
			} else if (metadata.hasArgumentWithKey("")) {
				result = metadata.getArgument("").value;
			}

			return result;
		}

		private function getClassesFromClassNames(classNames:Array):Array {
			var result:Array = [];
			var appDomain:ApplicationDomain;

			if (applicationContext) {
				appDomain = applicationContext.applicationDomain;
			}

			for each (var className:String in classNames) {
				result.push(ClassUtils.forName(className, appDomain));
			}

			return result;
		}

		private function getInterfaceImplementations(interfaze:Class, classes:Array):Array {
			var result:Array = [];

			for each (var clazz:Class in classes) {
				if (ClassUtils.isAssignableFrom(interfaze, clazz)) {
					result.push(clazz);
				}
			}

			return result;
		}

		private function resolvePropertyPlaceholdersForObjectDefinition(resolver:PropertyPlaceholderResolver, objectDefinition:IObjectDefinition):void {
			//logger.debug("Resolving property placeholders in object definition '{0}'", objectDefinition.className);

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
		}

	}

}