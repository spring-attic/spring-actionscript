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
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import flash.net.ObjectEncoding;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.util.ContextUtils;
	import org.springextensions.actionscript.util.TypeUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultObjectDefinitionRegistry implements IObjectDefinitionRegistry, IDisposable, IApplicationDomainAware {
		private static const CHARACTERS:String = "abcdefghijklmnopqrstuvwxyz";
		private static const FACTORY_OBJECT_PREFIX:String = '&';
		private static const IS_SINGLETON_FIELD_NAME:String = "isSingleton";
		private static const METADATA_KEY_SUFFIX:String = '____';
		private static const OBJECT_DEFINITION_NAME_EXISTS_ERROR:String = "Object definition with name '{0}' has already been registered and no overrides are allowed.";

		private static var logger:ILogger = getClassLogger(DefaultObjectDefinitionRegistry);

		public static function generateRegistryId():String {
			var len:int = 20;
			var result:Array = new Array(20);
			while (len) {
				result[len--] = CHARACTERS.charAt(Math.floor(Math.random() * 26));
			}
			return result.join('');
		}

		/**
		 * Creates a new <code>DefaultObjectDefinitionRegistry</code> instance.
		 *
		 */
		public function DefaultObjectDefinitionRegistry() {
			super();
			_objectDefinitions = {};
			_objectDefinitionList = new Vector.<IObjectDefinition>();
			_objectDefinitionNames = new Vector.<String>();
			_objectDefinitionClasses = new Vector.<Class>();
			_objectDefinitionMetadataLookup = new Dictionary();
			_objectDefinitionNameLookup = new Dictionary();
			_id = generateRegistryId();
			logger.debug("Created new DefaultObjectDefinitionRegistry with id {0}", [_id]);
		}

		private var _applicationDomain:ApplicationDomain;
		private var _customConfigurations:Object;
		private var _id:String;
		private var _isDisposed:Boolean;
		private var _objectDefinitionClasses:Vector.<Class>;
		private var _objectDefinitionList:Vector.<IObjectDefinition>;
		private var _objectDefinitionMetadataLookup:Dictionary;
		private var _objectDefinitionNameLookup:Dictionary;
		private var _objectDefinitionNames:Vector.<String>;
		private var _objectDefinitions:Object;

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get id():String {
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function get numObjectDefinitions():uint {
			return _objectDefinitionNames.length;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectDefinitionNames():Vector.<String> {
			return _objectDefinitionNames;
		}

		/**
		 * @inheritDoc
		 */
		public function containsObjectDefinition(objectName:String):Boolean {
			var result:Boolean = _objectDefinitions.hasOwnProperty(objectName);
			if (!result) {
				result = _objectDefinitions.hasOwnProperty(FACTORY_OBJECT_PREFIX + objectName);
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				for each (var name:String in _objectDefinitionNames) {
					var objectDefinition:IObjectDefinition = IObjectDefinition(_objectDefinitions[name]);
					if (objectDefinition.registryId == _id) {
						ContextUtils.disposeInstance(objectDefinition);
					}
				}
				_objectDefinitions = null;
				_objectDefinitionNames = null;
				_objectDefinitionClasses = null;
				_objectDefinitionMetadataLookup = null;
				_objectDefinitionList = null;
				_objectDefinitionNames = null;
				_customConfigurations = null;
				_isDisposed = true;
				logger.debug("Instance {0} has been disposed...", [this]);
			}
		}

		public function getCustomConfiguration(objectName:String):* {
			return (_customConfigurations != null) ? _customConfigurations[objectName] : null;
		}

		/**
		 * @inheritDoc
		 */
		public function getDefinitionNamesWithPropertyValue(propertyName:String, propertyValue:*, returnMatching:Boolean=true):Vector.<String> {
			var result:Vector.<String>;
			for each (var name:String in _objectDefinitionNames) {
				var definition:IObjectDefinition = getObjectDefinition(name);
				var match:Boolean = (definition[propertyName] == propertyValue);
				if (((match) && (returnMatching)) || ((!match) && (!returnMatching))) {
					result ||= new Vector.<String>();
					result[result.length] = name;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinition(objectName:String):IObjectDefinition {
			return _objectDefinitions[objectName] as IObjectDefinition;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinitionName(objectDefinition:IObjectDefinition):String {
			return _objectDefinitionNameLookup[objectDefinition] as String;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinitionNamesForType(type:Class):Vector.<String> {
			var result:Vector.<String>;
			for each (var name:String in _objectDefinitionNames) {
				var definition:IObjectDefinition = getObjectDefinition(name);
				if (definition.clazz != null) {
					if (ClassUtils.isAssignableFrom(type, definition.clazz, _applicationDomain)) {
						(result ||= new Vector.<String>())[result.length] = name;
					}
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinitionsForType(type:Class):Vector.<IObjectDefinition> {
			var result:Vector.<IObjectDefinition>;
			for each (var definition:IObjectDefinition in _objectDefinitionList) {
				if (definition.clazz != null) {
					if (ClassUtils.isAssignableFrom(type, definition.clazz, _applicationDomain)) {
						(result ||= new Vector.<IObjectDefinition>())[result.length] = definition;
					}
				}
			}
			return result;
		}

		/**
		 * @inheritDoc 
		 */
		public function getObjectDefinitionsThatReference(definitionName:String):Vector.<IObjectDefinition> {
			var ref:RuntimeObjectReference;
			var result:Vector.<IObjectDefinition>;
			var found:Boolean;
			for each(var definition:IObjectDefinition in _objectDefinitionList) {
				found = false;
				for each(var propertyDefinition:PropertyDefinition in definition.properties) {
					ref = propertyDefinition.valueDefinition.ref;
					if ((ref != null) && (ref.objectName == definitionName)){
						result ||= new Vector.<IObjectDefinition>();
						result[result.length] = definition;
						found = true;
						break;
					}
				}
				if (found) {
					continue;
				}
				for each(var methodInvocation:MethodInvocation in definition.methodInvocations) {
					for each(var arg:ArgumentDefinition in methodInvocation.arguments) {
						ref = arg.ref;
						if ((ref != null) && (ref.objectName == definitionName)){
							result ||= new Vector.<IObjectDefinition>();
							result[result.length] = definition;
							found = true;
							break;
						}
					}
					if (found) {
						break;
					}
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinitionsWithMetadata(metadataNames:Vector.<String>):Vector.<IObjectDefinition> {
			var result:Vector.<IObjectDefinition>;
			for each (var name:String in metadataNames) {
				name = name.toLowerCase() + METADATA_KEY_SUFFIX;
				var list:Vector.<IObjectDefinition> = _objectDefinitionMetadataLookup[name];
				if (list != null) {
					result = (result ||= new Vector.<IObjectDefinition>()).concat(list);
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getPrototypes():Vector.<String> {
			var result:Vector.<String>;
			var names:Vector.<String> = getDefinitionNamesWithPropertyValue(IS_SINGLETON_FIELD_NAME, false);
			for each (var name:String in names) {
				var definition:IObjectDefinition = getObjectDefinition(name);
				if ((!definition.isAbstract) && (!definition.isInterface)) {
					(result ||= new Vector.<String>())[result.length] = name;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getSingletons(lazyInit:Boolean=false):Vector.<String> {
			var result:Vector.<String>;
			for each (var name:String in _objectDefinitionNames) {
				var definition:IObjectDefinition = getObjectDefinition(name);
				if ((definition.isSingleton) && (definition.isLazyInit == lazyInit) && (!definition.isAbstract) && (!definition.isInterface)) {
					(result ||= new Vector.<String>())[result.length] = name;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getType(objectName:String):Class {
			var objectDefinition:IObjectDefinition = getObjectDefinition(objectName);
			if (objectDefinition != null) {
				return ClassUtils.forName(objectDefinition.className, _applicationDomain);
			} else {
				return null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getUsedTypes():Vector.<Class> {
			return _objectDefinitionClasses;
		}

		/**
		 * @inheritDoc
		 */
		public function isPrototype(objectName:String):Boolean {
			var objectDefinition:IObjectDefinition = getObjectDefinition(objectName);
			return (objectDefinition != null) ? (objectDefinition.scope === ObjectDefinitionScope.PROTOTYPE) : false;
		}

		/**
		 * @inheritDoc
		 */
		public function isSingleton(objectName:String):Boolean {
			return (getObjectDefinition(objectName).scope === ObjectDefinitionScope.SINGLETON);
		}

		public function registerCustomConfiguration(objectName:String, configuration:*):void {
			if (containsObjectDefinition(objectName)) {
				var objectDefinition:IObjectDefinition = getObjectDefinition(objectName);
				objectDefinition.customConfiguration = configuration;
				logger.debug("Registered custom configuration {0} for object definition {1}", [configuration, objectName]);
			} else {
				_customConfigurations ||= {};
				_customConfigurations[objectName] = configuration;
				logger.debug("Cached custom configuration {0} for object definition {1} for later use (a definition with that name hasn't been registered yet)", [configuration, objectName]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition, override:Boolean=true):void {
			var contains:Boolean = containsObjectDefinition(objectName);
			if (contains && override) {
				removeObjectDefinition(objectName);
			} else if (contains && !override) {
				throw new Error(StringUtils.substitute(OBJECT_DEFINITION_NAME_EXISTS_ERROR, objectName));
			}

			_objectDefinitions[objectName] = objectDefinition;
			_objectDefinitionNames[_objectDefinitionNames.length] = objectName;

			if ((StringUtils.hasText(objectDefinition.className)) && (objectDefinition.registryId.length == 0)) {
				var cls:Class = (objectDefinition.clazz == null) ? ClassUtils.forName(objectDefinition.className, _applicationDomain) : objectDefinition.clazz;

				addToMetadataLookup(objectDefinition, cls);

				if (_objectDefinitionClasses.indexOf(cls) < 0) {
					_objectDefinitionClasses[_objectDefinitionClasses.length] = cls;
				}
				if (ClassUtils.isImplementationOf(cls, IFactoryObject)) {
					objectName = FACTORY_OBJECT_PREFIX + objectName;
				}
				objectDefinition.clazz = cls;
				objectDefinition.isInterface = ClassUtils.isInterface(cls);
				determineSimpleProperties(objectDefinition);
			}

			if (objectDefinition.registryId.length == 0) {
				if ((_customConfigurations != null) && (_customConfigurations.hasOwnProperty(objectName))) {
					objectDefinition.customConfiguration = _customConfigurations[objectName];
					delete _customConfigurations[objectName];
				}
				objectDefinition.registryId = id;
			}

			_objectDefinitionNameLookup[objectDefinition] = objectName;
			_objectDefinitionList[_objectDefinitionList.length] = objectDefinition;
			logger.debug("Registered definition '{0}': {1}", [objectName, objectDefinition]);
		}

		/**
		 * @inheritDoc
		 */
		public function removeObjectDefinition(objectName:String):IObjectDefinition {
			var definition:IObjectDefinition;
			if (containsObjectDefinition(objectName)) {
				definition = getObjectDefinition(objectName);
				var idx:int;
				var list:Vector.<String> = getObjectDefinitionNamesForType(definition.clazz);
				var deleteClass:Boolean = ((list != null) && (list.length == 1));
				if (deleteClass) {
					idx = _objectDefinitionClasses.indexOf(definition.clazz);
					if (idx > -1) {
						_objectDefinitionClasses.splice(idx, 1);
					}
				}
				var type:Type = Type.forName(definition.className, _applicationDomain);
				for each (var metadata:Metadata in type.metadata) {
					var name:String = metadata.name.toLowerCase();
					removeFromMetadataLookup(name, definition);
				}
				delete _objectDefinitionNameLookup[definition];
				idx = _objectDefinitionList.indexOf(definition);
				if (idx > -1) {
					_objectDefinitionList.splice(idx, 1);
				}
				delete _objectDefinitions[objectName];
				idx = _objectDefinitionNames.indexOf(objectName);
				if (idx > -1) {
					_objectDefinitionNames.splice(idx, 1);
				}
			}
			logger.debug("Removed definition {0}", [objectName]);
			return definition;
		}

		private function addToMetadataLookup(objectDefinition:IObjectDefinition, clazz:Class):void {
			var type:Type = Type.forClass(clazz, _applicationDomain);
			for each (var metadata:Metadata in type.metadata) {
				var name:String = metadata.name.toLowerCase() + METADATA_KEY_SUFFIX;
				var vec:Vector.<IObjectDefinition> = _objectDefinitionMetadataLookup[name] ||= new Vector.<IObjectDefinition>();
				vec[vec.length] = objectDefinition;
			}
		}

		private function determineSimpleProperties(objectDefinition:IObjectDefinition):void {
			if ((objectDefinition.properties != null) && (objectDefinition.properties.length > 0)) {
				var propertyType:Type;
				var field:Field;
				var type:Type = Type.forClass(objectDefinition.clazz, _applicationDomain);
				for each (var property:PropertyDefinition in objectDefinition.properties) {
					field = type.getField(property.name, property.namespaceURI);
					if (field != null) {
						propertyType = field.type;
						property.isSimple = TypeUtils.isSimpleProperty(propertyType);
					}
				}
			}
		}

		private function removeFromMetadataLookup(name:String, definition:IObjectDefinition):void {
			name += METADATA_KEY_SUFFIX;
			var list:Vector.<IObjectDefinition> = _objectDefinitionMetadataLookup[name];
			if (list != null) {
				var idx:int = list.indexOf(definition);
				if (idx > -1) {
					list.splice(idx, 1);
				}
				if (list.length == 0) {
					delete _objectDefinitionMetadataLookup[name];
				}
			}
		}
	}
}
