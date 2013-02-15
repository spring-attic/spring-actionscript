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
package org.springextensions.actionscript.ioc.factory.support {

	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.MethodInvoker;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.errors.ClassNotFoundError;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.ioc.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.IDisposable;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.MethodInvocation;
	import org.springextensions.actionscript.ioc.ObjectContainerError;
	import org.springextensions.actionscript.ioc.ObjectDefinitionNotFoundError;
	import org.springextensions.actionscript.ioc.ResolveReferenceError;
	import org.springextensions.actionscript.ioc.autowire.DefaultAutowireProcessor;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessorAware;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;
	import org.springextensions.actionscript.ioc.factory.IInitializingObject;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.MethodInvokingObject;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;
	import org.springextensions.actionscript.ioc.factory.config.ApplicationDomainAwarePostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.CustomEditorConfigurer;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IDestructionAwareObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.ObjectFactoryAwarePostProcessor;
	import org.springextensions.actionscript.ioc.factory.support.event.ObjectFactoryEvent;
	import org.springextensions.actionscript.ioc.factory.support.referenceresolvers.ArrayReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.support.referenceresolvers.DictionaryReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.support.referenceresolvers.ObjectReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.support.referenceresolvers.VectorReferenceResolver;
	import org.springextensions.actionscript.objects.IPropertyEditor;
	import org.springextensions.actionscript.objects.IPropertyEditorRegistry;
	import org.springextensions.actionscript.objects.ITypeConverter;
	import org.springextensions.actionscript.objects.SimpleTypeConverter;
	import org.springextensions.actionscript.utils.DisposeUtils;
	import org.springextensions.actionscript.utils.OrderedUtils;
	import org.springextensions.actionscript.utils.TypeUtils;

	/**
	 * Dispatched after an object has been instantiated and wired by the current object factory
	 * @eventType org.springextensions.actionscript.ioc.factory.support.event.ObjectFactoryEvent.OBJECT_CREATED OBJECT_CREATED
	 */
	[Event(name="objectCreated", type="org.springextensions.actionscript.ioc.factory.support.event.ObjectFactoryEvent")]
	/**
	 * Dispatched right before an object is returned by the current object factory
	 * @eventType org.springextensions.actionscript.ioc.factory.support.event.ObjectFactoryEvent.OBJECT_RETRIEVED OBJECT_RETRIEVED
	 */
	[Event(name="objectRetrieved", type="org.springextensions.actionscript.ioc.factory.support.event.ObjectFactoryEvent")]
	/**
	 * This is the basic implementation of <code>IConfigurableObjectFactory</code>. Manages object
	 * definitions and creates and configures new objects based on those definitions.
	 *
	 * @author Christophe Herreman
	 * @author Damir Murat
	 * @author Erik Westra
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 *
	 * @see org.springextensions.actionscript.ioc.factory.config.IConfigurableObjectFactory IConfigurableObjectFactory
	 * @docref container-documentation.html#instantiating_a_container
	 */
	public class AbstractObjectFactory extends EventDispatcher implements IConfigurableObjectFactory, IAutowireProcessorAware, IDisposable {

		// static code block to force compilation of certain classes
		{
			MethodInvokingObject;
			CustomEditorConfigurer;
		}

		// --------------------------------------------------------------------
		//
		// Public Static Constants
		//
		// --------------------------------------------------------------------

		public static const THIS:String = "this";

		/**
		 * Used to dereference an <code>IFactoryObject</code> instance and distinguish it from
		 * objects <i>created</i> by the <code>IFactoryObject</code>. For example, if the object named
		 * <code>myDataType</code> is a <code>IFactoryObject</code>, getting <code>&amp;myDataType</code>
		 * will return the factory, not the instance returned by the factory.
		 */
		public static const OBJECT_FACTORY_PREFIX:String = "&";
		private static const POINT:String = '.';

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = LoggerFactory.getClassLogger(AbstractObjectFactory);

		// --------------------------------------------------------------------
		//
		// Protected Variables
		//
		// --------------------------------------------------------------------

		/** Reference resolvers used when creating objects */
		protected var referenceResolvers:Array /* <IReferenceResolver> */ = [];

		/** Cache of early cached singletons for circular references */
		protected var earlySingletonCache:Object /* <String, Object> */ = {};

		/** Cache of singleton objects registered without object definition */
		protected var explicitSingletonCache:Object /* <String, Object> */ = {};

		/** Cache of created singleton objects via an object definition */
		protected var singletonCache:Object /* <String, Object> */ = {};

		// ------------------------------------------------------------------------
		//
		// Constructor
		//
		// ------------------------------------------------------------------------

		/**
		 * Constructs a new <code>AbstractObjectFactory</code>.
		 * <p />
		 * The following post processors are added by default:
		 * <ul>
		 *  <li>ObjectFactoryAwarePostProcessor</li>
		 *  <li>ApplicationDomainAwarePostProcessor</li>
		 * </ul>
		 *
		 * The following reference resolvers are added by default:
		 * <ul>
		 *   <li>ObjectReferenceResolver</li>
		 *   <li>ArrayReferenceResolver</li>
		 *   <li>DictionaryReferenceResolver</li>
		 *   <li>VectorReferenceResolver</li>
		 * </ul>
		 *
		 * @see org.springextensions.actionscript.ioc.factory.config.ObjectFactoryAwarePostProcessor
		 * @see org.springextensions.actionscript.ioc.factory.support.referenceresolvers.ObjectReferenceResolver
		 * @see org.springextensions.actionscript.ioc.factory.support.referenceresolvers.ArrayReferenceResolver
		 * @see org.springextensions.actionscript.ioc.factory.support.referenceresolvers.DictionaryReferenceResolver
		 * @see #addReferenceResolver()
		 * @see #addObjectPostProcessor()
		 */
		public function AbstractObjectFactory() {
			super();
			init();
		}

		protected function init():void {
			applicationDomain = ApplicationDomain.currentDomain;

			if (autowireProcessor == null) {
				autowireProcessor = new DefaultAutowireProcessor(this);
			}

			_objectPostProcessors = [new ObjectFactoryAwarePostProcessor(this), new ApplicationDomainAwarePostProcessor(this)];

			addReferenceResolver(new ObjectReferenceResolver(this));
			addReferenceResolver(new ArrayReferenceResolver(this));
			addReferenceResolver(new DictionaryReferenceResolver(this));
			addReferenceResolver(new VectorReferenceResolver(this));
		}

		// ------------------------------------------------------------------------
		//
		// Properties
		//
		// ------------------------------------------------------------------------

		// --------------------------------
		// properties
		// --------------------------------

		private var _properties:Properties = new Properties();

		public function get properties():Properties {
			return _properties;
		}

		// --------------------------------
		// objectDefinitions
		// --------------------------------

		/** The registered object definitions */
		private var _objectDefinitions:Object /* <String, IObjectDefintion> */ = {};

		public function get objectDefinitions():Object {
			return _objectDefinitions;
		}

		// --------------------------------
		// parent
		// --------------------------------

		private var _parent:IObjectFactory;

		/**
		 * @inheritDoc
		 */
		public function get parent():IObjectFactory {
			return _parent;
		}

		/**
		 * @private
		 */
		public function set parent(value:IObjectFactory):void {
			if (value !== this) {
				_parent = value;
			}
		}

		// ----------------------------
		// objectPostProcessors
		// ----------------------------

		private var _objectPostProcessors:Array /* <IObjectPostProcessor> */ = [];

		public function get objectPostProcessors():Array {
			return _objectPostProcessors;
		}

		// --------------------------------
		// applicationDomain
		// --------------------------------

		private var _applicationDomain:ApplicationDomain;

		/**
		 * @inheritDoc
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 * @private
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
			//if new app domain is set, recreate the type converter with the new app domain
			_typeConverter = new SimpleTypeConverter(value);
		}

		// --------------------------------
		// autowireProcessor
		// --------------------------------

		private var _autowireProcessor:IAutowireProcessor;

		/**
		 * @private
		 */
		public function get autowireProcessor():IAutowireProcessor {
			return _autowireProcessor;
		}

		/**
		 * @inheritDoc
		 */
		public function set autowireProcessor(value:IAutowireProcessor):void {
			if (value !== autowireProcessor) {
				_autowireProcessor = value;
				if (_autowireProcessor is IObjectFactoryAware) {
					IObjectFactoryAware(_autowireProcessor).objectFactory = this;
				}
			}
		}

		// ----------------------------
		// explicitSingletonNames
		// ----------------------------

		/**
		 * The names of the explicit singletons registered in this factory.
		 * @return the names of the explicit singletons registered in this factory
		 */
		public function get explicitSingletonNames():Array {
			return ObjectUtils.getKeys(explicitSingletonCache);
		}

		// ----------------------------
		// hasDestructionAwareObjectPostProcessors
		// ----------------------------

		private var _hasDestructionAwareObjectPostProcessors:Boolean = false;

		public function get hasDestructionAwareObjectPostProcessors():Boolean {
			return _hasDestructionAwareObjectPostProcessors;
		}

		// ----------------------------
		// isDisposed
		// ----------------------------

		private var _isDisposed:Boolean = false;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		// ----------------------------
		// typeConverter
		// ----------------------------

		private var _typeConverter:ITypeConverter;

		/**
		 * @inheritDoc
		 */
		public function get typeConverter():ITypeConverter {
			return _typeConverter;
		}

		public function set typeConverter(value:ITypeConverter):void {
			Assert.notNull(typeConverter, "The type converter cannot be null");
			_typeConverter = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function registerSingleton(name:String, object:Object):void {
			Assert.hasText(name, "'name' must not be empty");
			Assert.notNull(object, "'object' must not be null");
			explicitSingletonCache[name] = object;
		}

		/**
		 * @inheritDoc
		 */
		public function getObject(name:String, constructorArguments:Array = null):* {
			Assert.hasText(name, "name parameter must not be empty");
			if (StringUtils.startsWith(name, THIS)) {
				if (name == THIS) {
					return this;
				} else if (StringUtils.startsWith(name, THIS + POINT)) {
					return resolvePropertyChain(name);
				}
			}
			var result:*;
			var isFactoryDereference:Boolean = (name.charAt(0) == OBJECT_FACTORY_PREFIX);
			var objectName:String = (isFactoryDereference ? name.substring(1) : name);

			// try to get the object from the explicit singleton cache
			if (explicitSingletonCache[objectName]) {
				result = explicitSingletonCache[objectName];
			} else {
				// we don't have an object in the cache, so create it
				result = buildObject(name, constructorArguments);
			}

			// if we have an object factory and we don't ask for the object factory,
			// replace the result with the object the factory creates
			if ((result is IFactoryObject) && !isFactoryDereference) {
				result = IFactoryObject(result).getObject();
			}

			//resolvePropertyPlaceholders(result);
			var evt:ObjectFactoryEvent = new ObjectFactoryEvent(ObjectFactoryEvent.OBJECT_RETRIEVED, result, name, constructorArguments);
			dispatchEvent(evt);
			EventBus.dispatchEvent(evt);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function createInstance(clazz:Class, constructorArguments:Array = null):* {
			Assert.notNull(clazz, "The clazz arguments must not be null");
			var result:* = ClassUtils.newInstance(clazz, constructorArguments);
			wire(result);
			return result;
		}

		public function getClassForName(className:String):Class {
			return ClassUtils.forName(className, applicationDomain);
		}

		public function getClassForInstance(object:Object):Class {
			return ClassUtils.forInstance(object, applicationDomain);
		}

		public function dispose():void {
			if (!_isDisposed) {
				destroyAllSingletons();
				clearCaches();

				parent = null;
				DisposeUtils.disposeCollection(objectPostProcessors);
				_objectPostProcessors = null;

				_applicationDomain = null;
				_typeConverter = null;
				if (_autowireProcessor is IDisposable) {
					IDisposable(_autowireProcessor).dispose();
				}
				DisposeUtils.disposeCollection(referenceResolvers);
				referenceResolvers = null;
				_autowireProcessor = null;
				_properties = null;
				_objectDefinitions = null;
				_isDisposed = true;
			}
		}

		/**
		 * Builds an object for the given name and returns it.
		 *
		 * @param name
		 * @param constructorArguments
		 * @throws org.springextensions.actionscript.ioc.ObjectContainerError ObjectContainerError if the class for the specified <code>ObjectDefinition</code> isn't found
		 * @return the built object
		 */
		protected function buildObject(name:String, constructorArguments:Array = null):* {
			var result:*;
			var isFactoryDereference:Boolean = (name.charAt(0) == OBJECT_FACTORY_PREFIX);
			var objectName:String = (isFactoryDereference ? name.substring(1) : name);
			var objectDefinition:IObjectDefinition = objectDefinitions[objectName];

			// look up the object definition in the parent context if we don't have one in this context
			if (!objectDefinition) {
				if (_parent) {
					objectDefinition = _parent.objectDefinitions[objectName];
					if (objectDefinition && objectDefinition.isSingleton) {
						return _parent.getObject(name, constructorArguments);
					}
				}
				// we don't have an object definition for the given name
				if (!objectDefinition) {
					throw new ObjectDefinitionNotFoundError("An object definition for '" + objectName + "' was not found.");
				}
			}

			if (objectDefinition.isSingleton && (constructorArguments && !objectDefinition.isLazyInit)) {
				// dmurat: constructor parameters are only allowed for lazy instantiating objects (at least for now)
				throw new IllegalOperationError("The object definition for '" + objectName + "' is not lazy. Constructor arguments can only be " + "supplied for lazy instantiating objects.");
			}

			// if this is a singleton, try to get it from the cache
			if (objectDefinition.isSingleton) {
				result = singletonCache[objectName];

				// not in cache -> perhaps it is early cached as a circular reference
				if (!result) {
					result = earlySingletonCache[objectName];
				}
			}

			// Only do dependency guarantee loop when the object hasn't been retrieved from
			// the cache, when the object is in the early cache, do the dependency check. (Not sure if this is necessary though).
			if (!result || earlySingletonCache[objectName]) {
				// guarantee creation of objects that the current object depends on
				var dependsOn:Array = objectDefinition.dependsOn;

				if (dependsOn) {
					for each (var dependsOnObject:String in dependsOn) {
						getObject(dependsOnObject);
					}
				}
			}

			// the object was not found in the cache or in the early singleton cache
			// create a new object from its definition
			if (!result) {
				try {
					var clazz:Class = getClassForName(objectDefinition.className);

					if (constructorArguments) {
						objectDefinition.constructorArguments = constructorArguments;
					}

					if (_autowireProcessor) {
						_autowireProcessor.preprocessObjectDefinition(objectDefinition);
					}

					// create the object
					var resolvedConstructorArgs:Array = resolveReferences(objectDefinition.constructorArguments);

					if (objectDefinition.factoryMethod) {
						if (objectDefinition.factoryObjectName) {
							result = createObjectViaInstanceFactoryMethod(objectDefinition.factoryObjectName, objectDefinition.factoryMethod, resolvedConstructorArgs);
						} else {
							result = createObjectViaStaticFactoryMethod(clazz, applicationDomain, objectDefinition.factoryMethod, resolvedConstructorArgs);
						}
					} else {
						result = ClassUtils.newInstance(clazz, resolvedConstructorArgs);
					}

					wire(result, objectDefinition, objectName);

				} catch (e:ClassNotFoundError) {
					throw new ObjectContainerError(e.message);
				}
			}
			var evt:ObjectFactoryEvent = new ObjectFactoryEvent(ObjectFactoryEvent.OBJECT_CREATED, result, name, constructorArguments);
			dispatchEvent(evt);
			EventBus.dispatchEvent(evt);
			return result;
		}

		protected function createObjectViaInstanceFactoryMethod(objectName:String, methodName:String, args:Array = null):* {
			var factoryObject:Object = getObject(objectName);
			var factoryObjectMethodInvoker:MethodInvoker = new MethodInvoker();
			factoryObjectMethodInvoker.target = factoryObject;
			factoryObjectMethodInvoker.method = methodName;
			factoryObjectMethodInvoker.arguments = args;
			return factoryObjectMethodInvoker.invoke();
		}

		protected function createObjectViaStaticFactoryMethod(clazz:Class, applicationDomain:ApplicationDomain, factoryMethodName:String, args:Array = null):* {
			var type:Type = Type.forClass(clazz, applicationDomain);
			var factoryMethod:Method = type.getMethod(factoryMethodName);
			return factoryMethod.invoke(clazz, args);
		}

		/**
		 * @inheritDoc
		 */
		public function wire(object:*, objectDefinition:IObjectDefinition = null, objectName:String = null):void {
			var clazz:Class = getClassForInstance(object);

			if (objectDefinition == null) {
				if (_autowireProcessor) {
					_autowireProcessor.autoWire(object);
				}

				// resolve object name
				if (!StringUtils.hasText(objectName)) {
					if (object.hasOwnProperty("id")) {
						objectName = object["id"];
					} else {
						objectName = "(no name)";
					}
				}

				doPostProcessingBeforeInitialization(object, objectName);
				if (object is IInitializingObject) {
					IInitializingObject(object).afterPropertiesSet();
				}
				doPostProcessingAfterInitialization(object, objectName);
			} else {
				var name:String = (objectName == null) ? objectDefinition.className : objectName;

				// cache the object if it is a singleton for circular references
				// ... when cached at this stage, the object will not be be completely initialized
				if (objectDefinition.isSingleton) {
					earlySingletonCache[name] = object;
				}

				// Autowire happens before setting all explicitly configured properties
				// so that autowired properties can be overridden.
				if (_autowireProcessor) {
					_autowireProcessor.autoWire(object, objectDefinition, name);
				}

				if (objectDefinition.dependencyCheck != DependencyCheckMode.NONE) {
					checkDependencies(object, objectDefinition, name);
				}

				// set the properties on the newly created object
				var newValue:Object;

				for (var property:String in objectDefinition.properties) {
					// Note: Using two try blocks in order to improve error reporting
					// resolve the reference to the property
					try {
						newValue = resolveReference(objectDefinition.properties[property]);
					} catch (e:Error) {
						throw new ResolveReferenceError("The property '" + property + "' on the definition of '" + name + "' could not be resolved. Original error: \n" + e.message);
					}

					// set the property on the created instance
					try {
						var type:Type = Type.forClass(clazz, applicationDomain);
						var field:Field = type.getField(property);

						if (newValue && field && field.type.clazz) {
							newValue = typeConverter.convertIfNecessary(newValue, field.type.clazz);
						}

						// do the actual property setting
						// note: skip this if the current property is equal to the new property
						//if (object[property] !== newValue) {
						object[property] = newValue;
							//}
							//} catch (typeError:TypeError) {
							//	throw new PropertyTypeError("The property '" + property + "' on the object definition '" + name + "' was given the wrong type. Original error: \n" + typeError.message);
					} catch (e:Error) {
						throw e;
					}
				}

				if (!objectDefinition.skipPostProcessors) {
					doPostProcessingBeforeInitialization(object, name);
				}

				if (object is IInitializingObject) {
					IInitializingObject(object).afterPropertiesSet();
				}

				if (objectDefinition.initMethod) {
					object[objectDefinition.initMethod]();
				}

				// execute all method invocations if any
				if (objectDefinition.methodInvocations) {
					for each (var methodInvocation:MethodInvocation in objectDefinition.methodInvocations) {
						var methodInvoker:MethodInvoker = new MethodInvoker();
						methodInvoker.target = object;
						methodInvoker.method = methodInvocation.methodName;
						methodInvoker.arguments = resolveReferences(methodInvocation.arguments);
						methodInvoker.invoke();
					}
				}

				if (!objectDefinition.skipPostProcessors) {
					doPostProcessingAfterInitialization(object, name);
				}

				if (objectDefinition.isSingleton) {
					// cache the object if its definition is a singleton
					// note: if the object is an object factory, the object factory is cached and not the
					// object it creates
					singletonCache[name] = object;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function containsObject(objectName:String):Boolean {
			return (objectDefinitions[objectName] != null);
		}

		/**
		 * @inheritDoc
		 */
		public function canCreate(objectName:String):Boolean {
			var result:Boolean = containsObject(objectName);
			if (!result && parent) {
				result = parent.canCreate(objectName);
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function isSingleton(objectName:String):Boolean {
			var objectDefinition:IObjectDefinition = _getObjectDefinition(objectName);
			return objectDefinition.isSingleton;
		}

		/**
		 * @inheritDoc
		 */
		public function isPrototype(objectName:String):Boolean {
			return (!isSingleton(objectName));
		}

		/**
		 * @inheritDoc
		 */
		public function getType(objectName:String):Class {
			var objectDefinition:IObjectDefinition = _getObjectDefinition(objectName);
			return ClassUtils.forName(objectDefinition.className, applicationDomain);
		}

		/**
		 * @inheritDoc
		 */
		public function resolveReference(property:Object):Object {
			if (property == null) { // note: don't change this to !property since we might pass in empty strings here
				return null;
			}

			for each (var referenceResolver:IReferenceResolver in referenceResolvers) {
				if (referenceResolver.canResolve(property)) {
					property = referenceResolver.resolve(property);
					break;
				}
			}

			return property;
		}

		/**
		 * @inheritDoc
		 */
		public function clearObjectFromInternalCache(name:String):Object {
			clearFromCache(earlySingletonCache, name);
			return clearFromCache(singletonCache, name);
		}

		public function clearObjectFromExplicitInternalCache(name:String):Object {
			return clearFromCache(explicitSingletonCache, name);
		}

		protected function clearFromCache(cache:Object, name:String):Object {
			var result:Object = cache[name];
			delete cache[name];
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function addReferenceResolver(referenceResolver:IReferenceResolver):void {
			Assert.notNull(referenceResolver, "The reference resolver cannot not be null");
			referenceResolvers.push(referenceResolver);
		}

		// ========================================================================
		// IConfigurableObjectFactory implementation
		// ========================================================================

		/**
		 * <p>If the specified <code>IObjectPostProcessor</code> implements <code>IApplicationDomainAware</code> the
		 * current <code>AbstractObjectFactory.applicationDomain</code> will be injected.</p>
		 * @inheritDoc
		 */
		public function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void {
			Assert.notNull(objectPostProcessor, "The 'objectPostProcessor' must not be null");

			if (objectPostProcessor is IApplicationDomainAware) {
				IApplicationDomainAware(objectPostProcessor).applicationDomain = applicationDomain;
			}

			if (objectPostProcessor is IDestructionAwareObjectPostProcessor) {
				_hasDestructionAwareObjectPostProcessors = true;
			}

			objectPostProcessors[objectPostProcessors.length] = objectPostProcessor;
			_objectPostProcessors = OrderedUtils.sortOrderedArray(objectPostProcessors);
		}

		/**
		 * @inheritDoc
		 */
		public function removeObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void {
			Assert.notNull(objectPostProcessor, "The 'objectPostProcessor' must not be null");
			var idx:int = objectPostProcessors.indexOf(objectPostProcessor);
			if (idx > -1) {
				objectPostProcessors.splice(idx, 1);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectPostProcessors(objectPostProcessorClass:Class):Array {
			var result:Array = [];
			for each (var processor:IObjectPostProcessor in objectPostProcessors) {
				if (processor is objectPostProcessorClass) {
					result[result.length] = processor;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function get numObjectPostProcessors():int {
			return objectPostProcessors.length;
		}

		/**
		 * @inheritDoc
		 */
		public function isFactoryObject(objectName:String):Boolean {
			var objectDefinition:IObjectDefinition = objectDefinitions[objectName];
			var clazz:Class = ClassUtils.forName(objectDefinition.className, applicationDomain);
			return ClassUtils.isImplementationOf(clazz, IFactoryObject, applicationDomain);
		}

		/**
		 * @inheritDoc
		 */
		public function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void {
			if (_typeConverter is IPropertyEditorRegistry) {
				IPropertyEditorRegistry(_typeConverter).registerCustomEditor(requiredType, propertyEditor);
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Retrieves the definition with the given name.
		 *
		 * @param objectName  The name/id of the definition that needs to be retrieved
		 *
		 * @return an instance of IObjectDefinition
		 *
		 * @throws org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError  The definition should exist
		 */
		private function _getObjectDefinition(objectName:String):IObjectDefinition {
			Assert.notNull(objectName, "The object name cannot be null");
			Assert.hasText(objectName, "The object name must have text");

			var result:IObjectDefinition = objectDefinitions[objectName];

			if (!result) {
				throw new NoSuchObjectDefinitionError(objectName);
			}

			return result;
		}

		/**
		 * Loops through the object post processors and calls the postProcessBeforeInitialization
		 */
		private function doPostProcessingBeforeInitialization(object:Object, name:String):void {
			for each (var o:IObjectPostProcessor in objectPostProcessors) {
				//logger.debug("Invoking object post processor '{0}' on object '{1}' before initialization.", o, name);
				o.postProcessBeforeInitialization(object, name);
			}
		}

		/**
		 * Loops through the object post processors and calls the postProcessAfterInitialization
		 */
		private function doPostProcessingAfterInitialization(object:*, name:String):void {
			for each (var o:IObjectPostProcessor in objectPostProcessors) {
				//logger.debug("Invoking object post processor '{0}' on object '{1}' after initialization.", o, name);
				o.postProcessAfterInitialization(object, name);
			}
		}

		private function doPostProcessingBeforeDestruction(object:Object, name:String):void {
			for each (var postProcessor:IObjectPostProcessor in objectPostProcessors) {
				if (postProcessor is IDestructionAwareObjectPostProcessor) {
					//logger.debug("Invoking object post processor '{0}' on object '{1}' before destruction.", postProcessor, name);
					IDestructionAwareObjectPostProcessor(postProcessor).postProcessBeforeDestruction(object, name);
				}
			}
		}

		/**
		 * Check object
		 * @param object
		 * @param objectDefinition
		 */
		private function checkDependencies(object:*, objectDefinition:IObjectDefinition, name:String):void {
			var type:Type = Type.forInstance(object, applicationDomain);
			for each (var field:Field in type.properties) {

				if (field.name === 'prototype')
					continue;

				//TODO M: take a decision on which "isSimple" to use...
				var isSimple:Boolean = TypeUtils.isSimpleProperty(field.type);
				var isNull:Boolean = (field.getValue(object) === null);
				var unSatisfied:Boolean = (isNull && (isSimple && objectDefinition.dependencyCheck.checkSimpleProperties() || (!isSimple && objectDefinition.dependencyCheck.checkObjectProperties())));
				if (unSatisfied) {
					throw new UnsatisfiedDependencyError(name, field.name);
				}
			}
		}

		private function resolvePropertyChain(name:String):* {
			var propertyNames:Array = name.split(POINT);
			var field:String = propertyNames.pop().toString();
			var targetObject:Object = this;
			var propName:String;
			for each (propName in propertyNames) {
				targetObject = targetObject[propName];
			}
			return targetObject[field];
		}

		/**
		 * Will resolve an array of properties using the resolveReference method.
		 *
		 * @param properties  The properties to resolve
		 *
		 * @return properties  An array containing the resolved properties
		 */
		private function resolveReferences(properties:Array):Array {
			var result:Array = [];

			for each (var p:Object in properties) {
				result.push(resolveReference(p));
			}

			return result;
		}

		private function destroyAllSingletons():void {
			var singletons:Object = getSingletonHashMap();

			for (var name:String in singletons) {
				destroyObject(singletons[name], name);
			}
		}

		/**
		 * Returns a hashmap of all singletons.
		 */
		private function getSingletonHashMap():Object {
			var result:Object = {};

			// early singletons
			for (var earlySingletonName:String in earlySingletonCache) {
				result[earlySingletonName] = earlySingletonCache[earlySingletonName];
			}

			// singletons
			for (var singletonName:String in singletonCache) {
				result[singletonName] = singletonCache[singletonName];
			}

			// explicit singletons
			for (var explicitSingletonName:String in explicitSingletonCache) {
				result[explicitSingletonName] = explicitSingletonCache[explicitSingletonName];
			}

			return result;
		}

		/**
		 * Destroys the given object by invoking its custom destroy method, the destruction aware post processors
		 * and the object's dispose method if applicable.
		 *
		 * @param object the object to be destroyed
		 * @param name the name of the object to be destroyed
		 */
		private function destroyObject(object:Object, name:String):void {
			var objectDefinition:IObjectDefinition;

			// destroy-method on object definition
			if (objectDefinitions && objectDefinitions.hasOwnProperty(name)) {
				objectDefinition = objectDefinitions[name];
				if (StringUtils.hasText(objectDefinition.destroyMethod)) {
					object[objectDefinition.destroyMethod]();
				}
			}

			// destruction aware post processors
			if (objectDefinition && !objectDefinition.skipPostProcessors) {
				doPostProcessingBeforeDestruction(object, name);
			}

			// disposable
			if (object is IDisposable) {
				if (!IDisposable(object).isDisposed) {
					IDisposable(object).dispose();
				}
			}
		}

		private function clearCaches():void {
			earlySingletonCache = {};
			singletonCache = {};
			explicitSingletonCache = {};
		}

	}
}
