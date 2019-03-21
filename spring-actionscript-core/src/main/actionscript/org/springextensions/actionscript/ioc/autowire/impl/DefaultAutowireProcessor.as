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
package org.springextensions.actionscript.ioc.autowire.impl {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessorAware;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.util.Environment;
	import org.springextensions.actionscript.util.TypeUtils;

	/**
	 * <p>Default <code>IAutowireProcessor</code> implementation.</p>
	 *
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @inheritDoc
	 */
	public class DefaultAutowireProcessor implements IAutowireProcessor, IObjectFactoryAware, IApplicationDomainAware, IDisposable {
		/**
		 * The name of the metadata that determines whether a field needs to be autowired
		 */
		public static const AUTOWIRED_ANNOTATION:String = "Autowired";

		/**
		 * The name of the metadata argument that determines the name of a property in the container that needs to be injected into the specified field
		 */
		public static const AUTOWIRED_ARGUMENT_EXTERNALPROPERTY:String = "externalProperty";

		/**
		 * The name of the metadata argument that determines the autowiring strategy, possibles values are 'autodetect', 'byName', 'byType', 'constructor' or 'no'
		 */
		public static const AUTOWIRED_ARGUMENT_MODE:String = "mode";

		/**
		 * The name of the metadata argument that determines the name of the object in the container that needs to be injected into the specified field
		 */
		public static const AUTOWIRED_ARGUMENT_NAME:String = "name";

		/**
		 * The name of the metadata argument that determines whether the dependency is required or not.
		 */
		public static const AUTOWIRED_ARGUMENT_REQUIRED:String = "required";

		/**
		 * Metadata argument key used for bindings, the value of this key determines the host object's property chain.
		 */
		public static const AUTOWIRED_PROPERTY_NAME:String = "property";
		/**
		 * The name of the metadata that determines whether a field needs to be autowired
		 */
		public static const INJECT_ANNOTATION:String = "Inject";
		/**
		 *
		 */
		public static const TRUE_VALUE:String = 'true';
		private static const BINDING_UTILS_CLASS_NAME:String = "mx.binding.utils.BindingUtils";
		private static const BIND_PROPERTY_METHOD_NAME:String = "bindProperty";
		private static const IS_AUTO_WIRE_CANDIDATE_FIELD_NAME:String = "isAutoWireCandidate";
		private static const POINT_CHAR:String = '.';
		private static const logger:ILogger = getClassLogger(DefaultAutowireProcessor);

		/**
		 * Creates a new <code>DefaultAutowireProcessor</code> instance.
		 */
		public function DefaultAutowireProcessor(objectFactory:IObjectFactory) {
			Assert.notNull(objectFactory, "The objectFactory parameter must not be null");
			super();
			_objectFactory = objectFactory;
			_processDefinitions = new Dictionary(true);
		}

		private var _applicationDomain:ApplicationDomain;
		private var _autowireMetadataNames:Vector.<String>;
		private var _bindingFunction:Function;
		private var _isDisposed:Boolean;
		private var _objectFactory:IObjectFactory;
		private var _processDefinitions:Dictionary;

		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		public function get autowireMetadataNames():Vector.<String> {
			if (_autowireMetadataNames == null) {
				_autowireMetadataNames = new <String>[AUTOWIRED_ANNOTATION, INJECT_ANNOTATION];
			}
			return _autowireMetadataNames;
		}

		public function set autowireMetadataNames(value:Vector.<String>):void {
			_autowireMetadataNames = value;
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @private
		 */
		public function get objectFactory():IObjectFactory {
			return _objectFactory;
		}

		/**
		 * @inheritDoc
		 */
		public function set objectFactory(value:IObjectFactory):void {
			Assert.notNull(value, "The objectFactory property must not be null");
			_objectFactory = value;
		}

		/**
		 * Method called during object creation. Will autowire unclaimed non simple properties by type or by name if required by the
		 * object definition.
		 * @inheritDoc
		 */
		public function autoWire(object:Object, objectDefinition:IObjectDefinition=null, objectName:String=null):void {
			Assert.notNull(object, "The object parameter must not be null");
			Assert.notNull(_objectFactory, "The objectFactory property must not be null");

			if (objectDefinition != null) {
				switch (objectDefinition.autoWireMode) {
					default:
						break;
					case AutowireMode.BYNAME:
						autoWireByName(object, objectDefinition);
						break;
					case AutowireMode.BYTYPE:
						autoWireByType(object, objectDefinition);
						break;
				}
			}
			if ((objectDefinition == null) || ((objectDefinition.autoWireMode === AutowireMode.NO) && (!objectDefinition.skipMetadata))) {
				processAutowireAnnotations(objectDefinition, object, objectName);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				_objectFactory = null;
				_autowireMetadataNames = null;
				_processDefinitions = null;
				_applicationDomain = null;
				_isDisposed = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function findAutowireCandidateName(clazz:Class):String {
			logger.debug("Trying to find autowiring candidate with class {0}", [clazz]);
			var candidateNames:Vector.<String> = findAutowireCandidateNames(clazz);
			if (candidateNames.length < 1) {
				var proc:IAutowireProcessorAware = (_objectFactory.parent as IAutowireProcessorAware);
				if ((proc != null) && (proc.autowireProcessor != null)) {
					logger.debug("No candidates found, defering to parent context {0}", [proc]);
					return proc.autowireProcessor.findAutowireCandidateName(clazz);
				}
			}

			var finalCandidateName:String = null;
			if (candidateNames.length > 1) {
				logger.debug("Found multiple candidates with class {0}: {1}", [clazz, candidateNames.join(', ')]);
				finalCandidateName = determinePrimaryCandidate(candidateNames);
			} else if (candidateNames.length == 1) {
				logger.debug("Found candidate with class {0}: {1}", [clazz, finalCandidateName]);
				finalCandidateName = candidateNames[0];
			}

			return finalCandidateName;
		}

		/**
		 * <p>Performs <code>AUTODETECT</code> and <code>CONSTRUCTOR</code> checks.</p>
		 * @see org.springextensions.actionscript.ioc.autowire.AutowireMode#AUTODETECT AUTODETECT
		 * @see org.springextensions.actionscript.ioc.autowire.AutowireMode#CONSTRUCTOR CONSTRUCTOR
		 * @inheritDoc
		 */
		public function preprocessObjectDefinition(objectDefinition:IObjectDefinition):void {
			Assert.notNull(objectDefinition, "The objectDefinition parameter must not be null");
			logger.debug("Preprocessing object definition '{0}'", [objectDefinition]);
			if (_processDefinitions[objectDefinition] != null) {
				return;
			}
			_processDefinitions[objectDefinition] = true;
			if (!StringUtils.hasText(objectDefinition.className)) {
				return;
			}
			var type:Type = Type.forName(objectDefinition.className, _objectFactory.applicationDomain);

			// If configured as AUTODETECT we must decide here whether
			// to use CONSTRUCTOR or BYTYPE
			if (objectDefinition.autoWireMode == AutowireMode.AUTODETECT) {
				if (type.constructor.hasNoArguments()) {
					objectDefinition.autoWireMode = AutowireMode.BYTYPE;
				} else {
					objectDefinition.autoWireMode = AutowireMode.CONSTRUCTOR;
				}
			}

			// If configured, use CONSTRUCTOR only if no explicit constructor
			// arguments are passed to the method and no constructor parameter are
			// explicitly set in the object definition
			if ((!objectDefinition.constructorArguments || objectDefinition.constructorArguments.length == 0) && objectDefinition.autoWireMode == AutowireMode.CONSTRUCTOR) {
				objectDefinition.constructorArguments ||= new Vector.<ArgumentDefinition>();
				var idx:int = 0;
				for each (var parameter:Parameter in type.constructor.parameters) {
					var isSimple:Boolean = TypeUtils.isSimpleProperty(parameter.type);
					var candidateName:String = findAutowireCandidateName(parameter.type.clazz);
					if (((isSimple) && (candidateName == null) && ((objectDefinition.dependencyCheck === DependencyCheckMode.ALL) || (objectDefinition.dependencyCheck === DependencyCheckMode.SIMPLE))) || //
						((!isSimple) && (candidateName == null) && ((objectDefinition.dependencyCheck === DependencyCheckMode.ALL) || (objectDefinition.dependencyCheck === DependencyCheckMode.OBJECTS)))) {
						throw new UnsatisfiedDependencyError("(autowired object)", "constructor argument #" + idx, "Constructor argument could not be resolved during autowiring");
					}
					if (candidateName != null) {
						objectDefinition.constructorArguments[objectDefinition.constructorArguments.length] = ArgumentDefinition.newInstance(new RuntimeObjectReference(candidateName));
					} else {
						objectDefinition.constructorArguments[objectDefinition.constructorArguments.length] = ArgumentDefinition.newInstance(null);
					}
					idx++;
				}
			}
		}

		private function assignField(object:Object, field:Field, metadata:Metadata):void {
			var host:String = (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_NAME)) ? metadata.getArgument(AUTOWIRED_ARGUMENT_NAME).value : field.name;
			var hostInstance:Object = objectFactory.getObject(host);
			var value:* = ObjectUtils.resolvePropertyChain(metadata.getArgument(AUTOWIRED_PROPERTY_NAME).value, hostInstance);
			logger.debug("Injecting field {0} with value {1}", [field.qName, value]);
			if (field.namespaceURI == null) {
				object[field.name] = value;
			} else {
				object[field.qName] = value;
			}
		}

		private function autoWireByName(object:Object, objectDefinition:IObjectDefinition):void {
			logger.debug("Autowiring {0} by name", [object]);
			var fields:Vector.<Field> = getUnclaimedSimpleObjectProperties(object, objectDefinition);

			for each (var field:Field in fields) {
				var fieldName:String = field.name;

				if (containsObject(fieldName) && getObjectDefinition(fieldName).isAutoWireCandidate) {
					setField(object, null, fieldName, fieldName);
				}
			}
		}

		private function autoWireByType(object:Object, objectDefinition:IObjectDefinition):void {
			logger.debug("Autowiring {0} by type", [object]);
			var properties:Vector.<Field> = getUnclaimedSimpleObjectProperties(object, objectDefinition);
			var finalCandidateName:String;

			for each (var property:Field in properties) {
				finalCandidateName = findAutowireCandidateName(property.type.clazz);

				if (finalCandidateName) {
					setField(object, null, property.name, finalCandidateName);
				} else {
					if (property.type.clazz === ApplicationDomain) {
						object[property.name] = _objectFactory.applicationDomain;
					} else if ((property.type.clazz === IApplicationContext) || (property.type.clazz === IObjectFactory)) {
						object[property.name] = _objectFactory;
					}
				}
			}
		}

		private function autoWireField(object:Object, field:Field, objectName:String):void {
			var fieldMetaData:Array = getAutowireSpecificMetadata(field);
			if (fieldMetaData == null) {
				return;
			}

			for each (var metadata:Metadata in fieldMetaData) {
				if (((metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_MODE) && metadata.getArgument(AUTOWIRED_ARGUMENT_MODE).value == AutowireMode.BYNAME.name)) || (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_NAME) || metadata.hasArgumentWithKey(""))) {
					if (metadata.hasArgumentWithKey(AUTOWIRED_PROPERTY_NAME)) {
						handlePropertyName(object, field, metadata, objectName);
					} else {
						autoWireFieldByName(object, field, metadata, objectName);
					}
				} else if (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_EXTERNALPROPERTY)) {
					autoWireFieldByPropertyName(object, field, metadata, objectName);
				} else if (metadata.hasArgumentWithKey(AUTOWIRED_PROPERTY_NAME)) {
					handlePropertyName(object, field, metadata, objectName);
				} else {
					autoWireFieldByType(object, field, metadata, objectName);
				}
			}
		}

		private function autoWireFieldByName(object:Object, field:Field, metadata:Metadata, objectName:String):void {
			var name:String = field.name;
			if (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_NAME)) {
				name = metadata.getArgument(AUTOWIRED_ARGUMENT_NAME).value;
			} else if (metadata.hasArgumentWithKey("")) {
				name = metadata.getArgument("").value;
			}

			logger.debug("Autowiring by name '{0}.{1}' with '{2}'", [objectName, field.name, name]);
			try {
				setField(object, objectName, field.name, name);
			} catch (err:Error) {
				throw new UnsatisfiedDependencyError(objectName, field.name, "Can't autowire property by name: ", err);
			}

		}

		private function autoWireFieldByPropertyName(object:Object, field:Field, metadata:Metadata, objectName:String):void {
			var key:String = metadata.getArgument(AUTOWIRED_ARGUMENT_EXTERNALPROPERTY).value;
			logger.debug("Autowiring by propertyName '{0}.{1}' with property '{2}'", [objectName, field.name, key]);

			if (_objectFactory.propertiesProvider != null) {
				if (_objectFactory.propertiesProvider.hasProperty(key)) {
					object[field.name] = _objectFactory.propertiesProvider.getProperty(key);
				} else {
					throw new UnsatisfiedDependencyError(objectName, field.name, "Can't find property referenced in Autowired " + AUTOWIRED_ARGUMENT_EXTERNALPROPERTY + "argument: ");
				}
			} else {
				throw new UnsatisfiedDependencyError(objectName, field.name, "Current IObjectFactory instance doesn't have a valid propertiesProvider property assigned");
			}
		}

		private function autoWireFieldByType(object:Object, field:Field, metadata:Metadata, objectName:String):void {
			var candidateName:String = findAutowireCandidateName(field.type.clazz);

			if (candidateName) {
				logger.debug("Autowiring by type '{0}.{1}' with '{2}'", [objectName, field.name, candidateName]);
				setField(object, objectName, field.name, candidateName);
			} else {
				throw new UnsatisfiedDependencyError(objectName, field.name, "Can't find an autowired candidate: ");
			}
		}

		private function bindField(object:Object, field:Field, metadata:Metadata, objectName:String):void {
			var host:String = (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_NAME)) ? metadata.getArgument(AUTOWIRED_ARGUMENT_NAME).value : field.name;
			var chain:Array = metadata.getArgument(AUTOWIRED_PROPERTY_NAME).value.split(POINT_CHAR);
			var bindPropertyFunction:Function = getBindingUtilsBindPropertyFunction();
			if (bindPropertyFunction != null) {
				try {
					bindPropertyFunction(object, field.name, objectFactory.getObject(host), chain, false, true);
				} catch (e:Error) {
					throw AutowireError.createNew(AutowireError.AUTOWIRE_BINDING_ERROR, objectName, field.name, host, chain.join(POINT_CHAR), e.message);
				}
			} else {
				assignField(object, field, metadata);
			}
			logger.debug("Bound field '{0}.{1}' with '{2}.{3}'", [objectName, field.name, host, chain.join(POINT_CHAR)]);
		}

		private function containsObject(objectName:String):Boolean {
			return _objectFactory.objectDefinitionRegistry.containsObjectDefinition(objectName);
		}

		private function determinePrimaryCandidate(candidateNames:Vector.<String>):String {
			var result:String;
			var definition:IObjectDefinition;
			var explicitSingletonCandidateNames:Vector.<String>;
			for each (var name:String in candidateNames) {
				if (_objectFactory.objectDefinitionRegistry.containsObjectDefinition(name)) {
					definition = _objectFactory.objectDefinitionRegistry.getObjectDefinition(name);
					if (definition.primary) {
						if (!result) {
							result = name;
						} else {
							throw AutowireError.createNew(AutowireError.MULTIPLE_PRIMARY_CANIDATES, candidateNames.join(", "));
						}
					}
				} else {
					explicitSingletonCandidateNames ||= new Vector.<String>();
					explicitSingletonCandidateNames[explicitSingletonCandidateNames.length] = name;
				}
			}

			if ((result == null) && (explicitSingletonCandidateNames != null)) {
				if (explicitSingletonCandidateNames.length == 1) {
					result = explicitSingletonCandidateNames[0];
				} else {
					throw AutowireError.createNew(AutowireError.MULTIPLE_EXPLICIT_SINGLETON_CANIDATES, explicitSingletonCandidateNames.join(", "));
				}
			}
			logger.debug("Primary candidate is '{0}'", [result]);
			return result;
		}

		private function findAutowireCandidateNames(clazz:Class):Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			if (_objectFactory.objectDefinitionRegistry == null) {
				return result;
			}
			var objectDefinition:IObjectDefinition;
			var objectClass:Class;
			var autowiredClassName:String = ClassUtils.getFullyQualifiedName(clazz, true);

			// check each definition and see if it is an autowire candidate for the given clazz
			// note: an autowire candidate must:
			// - have its isAutowireCandidate property set to true
			// - have its class equal to the given class, be a subclass, or implement its interface, or be a factory object that creates the given class

			var autowireCandidateDefinitionNames:Vector.<String> = _objectFactory.objectDefinitionRegistry.getDefinitionNamesWithPropertyValue(IS_AUTO_WIRE_CANDIDATE_FIELD_NAME, true);
			for each (var objectName:String in autowireCandidateDefinitionNames) {
				objectDefinition = _objectFactory.objectDefinitionRegistry.getObjectDefinition(objectName);
				if (!objectDefinition.isAbstract) {
					if (ClassUtils.isImplementationOf(objectDefinition.clazz, IFactoryObject, _objectFactory.applicationDomain) == false) {
						objectClass = objectDefinition.clazz;
					} else {
						var factoryObject:IFactoryObject = _objectFactory.getObject(DefaultObjectFactory.OBJECT_FACTORY_PREFIX + objectName);
						objectClass = factoryObject.getObjectType();
					}

					// NULL-check because MethodInvokingFactoryObject.getObjectType() always returns NULL
					// since the type is not known up front
					if (objectClass) {
						if ((objectClass === clazz) || (autowiredClassName === objectDefinition.className) || //
							ClassUtils.isSubclassOf(objectClass, clazz, _objectFactory.applicationDomain) || //
							ClassUtils.isImplementationOf(objectClass, clazz, _objectFactory.applicationDomain) || //
							isFactoryObjectForClass(objectClass, objectName, clazz)) {
							result[result.length] = objectName;
						}
					}
				}
			}

			// explicit singletons
			var cachedNames:Vector.<String> = _objectFactory.cache.getCachedNames();
			for each (var singletonName:String in cachedNames) {
				if (_objectFactory.objectDefinitionRegistry.containsObjectDefinition(singletonName) == false) {
					objectClass = ClassUtils.forInstance(_objectFactory.cache.getInstance(singletonName), _objectFactory.applicationDomain);

					if ((objectClass === clazz) || //
						ClassUtils.isSubclassOf(objectClass, clazz, _objectFactory.applicationDomain) || //
						ClassUtils.isImplementationOf(objectClass, clazz, _objectFactory.applicationDomain) || //
						isFactoryObjectForClass(objectClass, singletonName, clazz)) {
						result[result.length] = singletonName;
					}
				}
			}

			return result;
		}

		private function getApplicationDomain():ApplicationDomain {
			return _objectFactory.applicationDomain;
		}

		private function getAutowireSpecificMetadata(field:Field):Array {
			for each (var metaDataName:String in autowireMetadataNames) {
				var result:Array = field.getMetadata(metaDataName);
				if (result && (result.length > 0)) {
					return result;
				}
			}
			return null;
		}

		private function getBindingUtilsBindPropertyFunction():Function {
			if (_bindingFunction == null) {
				try {
					var cls:Class = ClassUtils.forName(BINDING_UTILS_CLASS_NAME, _applicationDomain);
					_bindingFunction = cls[BIND_PROPERTY_METHOD_NAME];
				} catch (e:Error) {
				}
			}
			return _bindingFunction;
		}

		private function getObjectDefinition(objectName:String):IObjectDefinition {
			Assert.hasText(objectName, "The object name must have text");

			if (_objectFactory.objectDefinitionRegistry.containsObjectDefinition(objectName)) {
				return _objectFactory.getObjectDefinition(objectName);
			} else {
				throw new NoSuchObjectDefinitionError(objectName);
			}
		}

		private function getUnclaimedAnnotatedSimpleObjectProperties(object:Object, objectDefinition:IObjectDefinition):Vector.<Field> {
			var cls:Class = (objectDefinition != null) ? objectDefinition.clazz : null;
			if (cls == null) {
				try {
					cls = ClassUtils.forInstance(object, _applicationDomain);
				} catch (e:Error) {
					logger.warn("Class could not be retrieved for instance {0}", [object]);
					return null;
				}
			}
			var appDomain:ApplicationDomain = getApplicationDomain();
			var type:Type = Type.forClass(cls, appDomain);
			var result:Vector.<Field>;

			var annotatedFields:Array = type.getMetadataContainers(AUTOWIRED_ANNOTATION);
			var injectFields:Array = type.getMetadataContainers(INJECT_ANNOTATION);
			if (annotatedFields == null) {
				annotatedFields = injectFields;
			} else if (injectFields != null) {
				annotatedFields = annotatedFields.concat(injectFields);
			}

			for each (var field:* in annotatedFields) {
				if (field is Variable) {
					var variable:Variable = field;
					if (!variable.isStatic && isPropertyUnclaimed(objectDefinition, variable)) {
						result ||= new Vector.<Field>();
						result[result.length] = field;
					}
				} else if (field is Accessor) {
					var accessor:Accessor = field;
					if ((accessor.access === AccessorAccess.WRITE_ONLY || accessor.access === AccessorAccess.READ_WRITE) && !accessor.isStatic && isPropertyUnclaimed(objectDefinition, accessor)) {
						result ||= new Vector.<Field>();
						result[result.length] = field;
					}
				}
			}

			return result;
		}

		private function getUnclaimedSimpleObjectProperties(object:Object, objectDefinition:IObjectDefinition):Vector.<Field> {
			var cls:Class = (objectDefinition != null) ? objectDefinition.clazz : null;
			if (cls == null) {
				try {
					cls = ClassUtils.forInstance(object, _applicationDomain);
				} catch (e:Error) {
					logger.warn("Class could not be retrieved for instance {0}", [object]);
					return null;
				}
			}
			var appDomain:ApplicationDomain = getApplicationDomain();
			var type:Type = Type.forClass(cls, appDomain);
			var result:Vector.<Field>;

			for each (var variable:Variable in type.variables) {
				if (!variable.isStatic && isPropertyUnclaimed(objectDefinition, variable)) {
					result ||= new Vector.<Field>();
					result[result.length] = (variable as Field);
				}
			}

			for each (var accessor:Accessor in type.accessors) {
				if ((accessor.access === AccessorAccess.WRITE_ONLY || accessor.access === AccessorAccess.READ_WRITE) && !accessor.isStatic && isPropertyUnclaimed(objectDefinition, accessor)) {
					result ||= new Vector.<Field>();
					result[result.length] = (accessor as Field);
				}
			}

			return result;
		}

		private function handlePropertyName(object:Object, field:Field, metadata:Metadata, objectName:String):void {
			if (Environment.isFlash) {
				assignField(object, field, metadata);
			} else {
				bindField(object, field, metadata, objectName);
			}
		}

		private function isFactoryObjectForClass(factoryObjectClass:Class, objectName:String, objectClass:Class):Boolean {
			var isFactoryObject:Boolean = ClassUtils.isImplementationOf(factoryObjectClass, IFactoryObject, _objectFactory.applicationDomain);

			if (isFactoryObject) {
				var factoryObject:IFactoryObject = _objectFactory.getObject(DefaultObjectFactory.OBJECT_FACTORY_PREFIX + objectName);
				var result:Boolean = (factoryObject.getObjectType() === objectClass);
				logger.debug("Factory {0} can create object class {1}: {2}", [factoryObject, factoryObjectClass, result]);
				return result;
			}
			return false;
		}

		private function isFieldAutowireRequired(field:Field):Boolean {
			var fieldMetadataArray:Array = getAutowireSpecificMetadata(field);
			for each (var metadata:Metadata in fieldMetadataArray) {
				if (!metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_REQUIRED) || metadata.getArgument(AUTOWIRED_ARGUMENT_REQUIRED).value === TRUE_VALUE) {
					logger.debug("Field '{0}' is required to be injected", [field.name]);
					return true;
				}
			}
			return false;
		}

		private function isPropertyUnclaimed(objectDefinition:IObjectDefinition, field:Field):Boolean {
			return ((objectDefinition == null || objectDefinition.getPropertyDefinitionByName(field.name, field.namespaceURI) == null));
		}

		/**
		 *
		 * @param objectDefinition
		 * @param object
		 * @param objectName
		 */
		private function processAutowireAnnotations(objectDefinition:IObjectDefinition, object:Object, objectName:String):void {
			var unclaimedProperties:Vector.<Field> = getUnclaimedAnnotatedSimpleObjectProperties(object, objectDefinition);
			for each (var field:Field in unclaimedProperties) {
				logger.debug("field {0} on instance {1} has injection/autowiring metadata", [field.name, object]);
				try {
					autoWireField(object, field, objectName);
				} catch (err:UnsatisfiedDependencyError) {
					if (isFieldAutowireRequired(field)) {
						logger.error("Error while autowiring property '{0}' of object '{1}': {2}", [field.name, objectName, err.message]);
						throw err;
					}
					logger.warn("Error while autowiring property '{0}' of object '{1}': {2}", [field.name, objectName, err.message]);
				}
			}
		}

		private function setField(object:Object, objectName:String, fieldName:String, objectDefinitionName:String):void {
			try {
				var instance:* = _objectFactory.getObject(objectDefinitionName);
				object[fieldName] = instance;
				logger.debug("Injected field '{0}' with instance {1}", [fieldName, instance]);
			} catch (e:Error) {
				if (!objectName) {
					objectName = object.toString();
				}
				throw AutowireError.createNew(AutowireError.AUTOWIRE_ERROR, objectName, fieldName, objectDefinitionName, e.message, e.getStackTrace());
			}
		}
	}
}
