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
package org.springextensions.actionscript.ioc.factory.impl {
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.util.OrderedUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.MethodInvoker;
	import org.as3commons.reflect.Type;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistryAware;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.eventbus.impl.DefaultEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.IDependencyInjector;
	import org.springextensions.actionscript.ioc.IObjectDestroyer;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessorAware;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.config.property.IPropertyPlaceholderResolver;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;
	import org.springextensions.actionscript.ioc.config.property.impl.PropertyPlaceholderResolver;
	import org.springextensions.actionscript.ioc.error.ObjectContainerError;
	import org.springextensions.actionscript.ioc.error.ObjectFactoryError;
	import org.springextensions.actionscript.ioc.event.LazyPropertyPlaceholderResolveEvent;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.event.ObjectFactoryEvent;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.PropertyPlaceholderConfigurerFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.error.ObjectDefinitionNotFoundError;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 */
	[Event(name="objectCreated", type="org.springextensions.actionscript.ioc.factory.event.ObjectFactoryEvent")]
	/**
	 *
	 */
	[Event(name="objectRetrieved", type="org.springextensions.actionscript.ioc.factory.event.ObjectFactoryEvent")]
	/**
	 *
	 */
	[Event(name="objectWired", type="org.springextensions.actionscript.ioc.factory.event.ObjectFactoryEvent")]
	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultObjectFactory extends EventDispatcher implements IObjectFactory, IEventBusAware, IAutowireProcessorAware, IDisposable, IEventBusUserRegistryAware {

		public static const OBJECT_FACTORY_PREFIX:String = "&";
		private static const NON_LAZY_SINGLETON_CTOR_ARGS_ERROR:String = "The object definition for '{0}' is not lazy. Constructor arguments can only be supplied for lazy instantiating objects.";
		private static const OBJECT_DEFINITION_NOT_FOUND_ERROR:String = "An object definition for '{0}' was not found.";

		private static var logger:ILogger = getClassLogger(DefaultObjectFactory);

		/**
		 * Creates a new <code>DefaultObjectFactory</code> instance.
		 * @param parentFactory optional other <code>IObjectFactory</code> to be used as this <code>ObjectFactory's</code> parent.
		 *
		 */
		public function DefaultObjectFactory(parentFactory:IObjectFactory=null) {
			super();
			parent = parentFactory;
		}

		private var _applicationDomain:ApplicationDomain;
		private var _autowireProcessor:IAutowireProcessor;
		private var _cache:IInstanceCache;
		private var _dependencyInjector:IDependencyInjector;
		private var _eventBus:IEventBus;
		private var _eventBusUserRegistry:IEventBusUserRegistry;
		private var _isDisposed:Boolean;
		private var _isReady:Boolean;
		private var _objectDefinitionRegistry:IObjectDefinitionRegistry;
		private var _objectDestroyer:IObjectDestroyer;
		private var _objectPostProcessors:Vector.<IObjectPostProcessor>;
		private var _parent:IObjectFactory;
		private var _propertiesProvider:IPropertiesProvider;
		private var _referenceResolvers:Vector.<IReferenceResolver>;
		private var _propertyPlaceholderResolver:IPropertyPlaceholderResolver;

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
			value ||= Type.currentApplicationDomain;
			_applicationDomain = value;
			var appDomainAware:IApplicationDomainAware = (_objectDefinitionRegistry as IApplicationDomainAware);
			if (appDomainAware != null) {
				appDomainAware.applicationDomain = this.applicationDomain;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get autowireProcessor():IAutowireProcessor {
			return _autowireProcessor;
		}

		/**
		 * @private
		 */
		public function set autowireProcessor(value:IAutowireProcessor):void {
			_autowireProcessor = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():IInstanceCache {
			return _cache;
		}

		/**
		 * @private
		 */
		public function set cache(value:IInstanceCache):void {
			_cache = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get dependencyInjector():IDependencyInjector {
			return _dependencyInjector;
		}

		/**
		 * @private
		 */
		public function set dependencyInjector(value:IDependencyInjector):void {
			_dependencyInjector = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get eventBus():IEventBus {
			return _eventBus;
		}

		/**
		 * @private
		 */
		public function set eventBus(value:IEventBus):void {
			if (value !== _eventBus) {
				removeParentEventBusListener();
				ContextUtils.disposeInstance(_eventBusUserRegistry);
				_eventBus = value;
				addParentEventBusListener();
				if (_eventBus != null) {
					_eventBusUserRegistry = new DefaultEventBusUserRegistry(_eventBus);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return _eventBusUserRegistry;
		}

		/**
		 * @private
		 */
		public function set eventBusUserRegistry(value:IEventBusUserRegistry):void {
			_eventBusUserRegistry = value;
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function get isReady():Boolean {
			return _isReady;
		}

		/**
		 * @private
		 */
		public function set isReady(value:Boolean):void {
			_isReady = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectDefinitionRegistry():IObjectDefinitionRegistry {
			return _objectDefinitionRegistry;
		}

		/**
		 * @private
		 */
		public function set objectDefinitionRegistry(value:IObjectDefinitionRegistry):void {
			_objectDefinitionRegistry = value;
			var appDomainAware:IApplicationDomainAware = (_objectDefinitionRegistry as IApplicationDomainAware);
			if (appDomainAware != null) {
				appDomainAware.applicationDomain = this.applicationDomain;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get objectDestroyer():IObjectDestroyer {
			return _objectDestroyer;
		}

		/**
		 * @private
		 */
		public function set objectDestroyer(value:IObjectDestroyer):void {
			_objectDestroyer = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectPostProcessors():Vector.<IObjectPostProcessor> {
			return _objectPostProcessors ||= new Vector.<IObjectPostProcessor>();
		}

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
			if (_parent !== value) {
				removeParentEventBusListener();
				_parent = value;
				if ((parent is IStageObjectProcessorRegistryAware) && (this is IStageObjectProcessorRegistryAware)) {
					if (IStageObjectProcessorRegistryAware(parent).stageProcessorRegistry != null) {
						IStageObjectProcessorRegistryAware(this).stageProcessorRegistry = IStageObjectProcessorRegistryAware(parent).stageProcessorRegistry;
					}
				}
				addParentEventBusListener();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get propertiesProvider():IPropertiesProvider {
			return _propertiesProvider ||= new Properties();
		}

		/**
		 * @private
		 */
		public function set propertiesProvider(value:IPropertiesProvider):void {
			_propertiesProvider = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get referenceResolvers():Vector.<IReferenceResolver> {
			return _referenceResolvers ||= new Vector.<IReferenceResolver>();
		}

		/**
		 * @inheritDoc
		 */
		public function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):IObjectFactory {
			if (objectPostProcessor != null) {
				if (objectPostProcessors.indexOf(objectPostProcessor) < 0) {
					objectPostProcessors[objectPostProcessors.length] = objectPostProcessor;
					_objectPostProcessors.sort(OrderedUtils.orderedCompareFunction);
				}
			} else {
				logger.error("addObjectPostProcessor() received a null argument");
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addReferenceResolver(referenceResolver:IReferenceResolver):IObjectFactory {
			if (referenceResolver != null) {
				referenceResolvers[referenceResolvers.length] = referenceResolver;
				_referenceResolvers.sort(OrderedUtils.orderedCompareFunction);
			} else {
				logger.error("addReferenceResolver() received a null argument");
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function canCreate(objectName:String):Boolean {
			return ((_objectDefinitionRegistry.containsObjectDefinition(objectName)) || (cache.hasInstance(objectName)));
		}

		/**
		 * @inheritDoc
		 */
		public function createInstance(clazz:Class, constructorArguments:Array=null):* {
			Assert.notNull(clazz, "The clazz arguments must not be null");
			var result:* = ClassUtils.newInstance(clazz, constructorArguments);
			result = manage(result);
			logger.debug("Created and injected an instance of {0}", [clazz]);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function destroyObject(instance:Object):void {
			if (_objectDestroyer != null) {
				logger.debug("Destroying instance {0}...", [instance]);
				_objectDestroyer.destroy(instance);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				if ((parent is IEventBusAware) && (_eventBus is IEventBusListener)) {
					IEventBusAware(parent).eventBus.removeListener(IEventBusListener(_eventBus));
				}
				_applicationDomain = null;
				ContextUtils.disposeInstance(_autowireProcessor);
				_autowireProcessor = null;
				if (_objectDestroyer != null) {
					var names:Vector.<String> = _cache.getCachedNames();
					for each (var name:String in names) {
						_objectDestroyer.destroy(_cache.getInstance(name));
					}
				}
				ContextUtils.disposeInstance(_objectDestroyer);
				_objectDestroyer = null;
				ContextUtils.disposeInstance(_cache);
				_cache = null;
				ContextUtils.disposeInstance(_dependencyInjector);
				_dependencyInjector = null;
				if (_eventBus != null) {
					_eventBus.clear();
				}
				ContextUtils.disposeInstance(_eventBus);
				_eventBus = null;
				ContextUtils.disposeInstance(_objectDefinitionRegistry);
				_objectDefinitionRegistry = null;
				for each (var postProcessor:IObjectPostProcessor in _objectPostProcessors) {
					ContextUtils.disposeInstance(postProcessor);
				}
				_objectPostProcessors = null;
				_parent = null; //Do NOT invoke dispose() on the parent!
				ContextUtils.disposeInstance(_propertiesProvider);
				_propertiesProvider = null;
				for each (var resolver:IReferenceResolver in _referenceResolvers) {
					ContextUtils.disposeInstance(resolver);
				}
				_referenceResolvers = null;
				_isDisposed = true;
				logger.debug("Instance {0} has been disposed...", [this]);
			}
		}


		/**
		 * @inheritDoc
		 */
		public function getObject(name:String, constructorArguments:Array=null):* {
			Assert.hasText(name, "name parameter must not be empty");
			var result:*;
			var isFactoryDereference:Boolean = (name.charAt(0) == OBJECT_FACTORY_PREFIX);
			var objectName:String = (isFactoryDereference ? name.substring(1) : name);
			
			var ctorArgs:Vector.<ArgumentDefinition> = ArgumentDefinition.newInstances(constructorArguments);

			// try to get the object from the explicit singleton cache
			if (_cache.hasInstance(objectName)) {
				result = _cache.getInstance(objectName);
			} else {
				// we don't have an object in the cache, so create it
				result = buildObject(name, ctorArgs);
			}

			// if we have an object factory and we don't ask for the object factory,
			// replace the result with the object the factory creates
			if ((result is IFactoryObject) && !isFactoryDereference) {
				result = IFactoryObject(result).getObject();
			}

			if (result != null) {
				var evt:ObjectFactoryEvent = new ObjectFactoryEvent(ObjectFactoryEvent.OBJECT_RETRIEVED, result, name, ctorArgs);
				dispatchEvent(evt);
				dispatchEventThroughEventBus(evt);
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinition(objectName:String):IObjectDefinition {
			if (_objectDefinitionRegistry) {
				return _objectDefinitionRegistry.getObjectDefinition(objectName);
			}
			return null;
		}

		public function manage(instance:*, objectName:String=null):* {
			var definition:IObjectDefinition;
			if (objectName == null) {
				var cls:Class = Object(instance).constructor as Class;
				var names:Vector.<String> = _objectDefinitionRegistry.getObjectDefinitionNamesForType(cls);
				if ((names != null) && (names.length == 1)) {
					objectName = names[0];
				} else if ((names != null) && (names.length > 1)) {
					logger.warn("More than one object definition found for class ", [cls]);
				} else {
					logger.info("No object definition found for class ", [cls]);
				}
			}
			if (objectName != null) {
				definition = objectDefinitionRegistry.getObjectDefinition(objectName);
			}
			instance = wire(instance, definition, null, objectName);
			if (_objectDestroyer != null) {
				_objectDestroyer.registerInstance(instance, objectName);
			}
			if ((definition != null) && ((definition.scope === ObjectDefinitionScope.SINGLETON || definition.scope === ObjectDefinitionScope.REMOTE)) && (!cache.hasInstance(objectName))) {
				cache.putInstance(objectName, instance);
			}
			return instance;
		}

		/**
		 * @inheritDoc
		 */
		public function resolveReference(reference:*):* {
			if (!reference) {
				return reference;
			}
			var arg:ArgumentDefinition = reference as ArgumentDefinition;
			if (arg) {
				if (arg.lazyPropertyResolving) {
					_propertyPlaceholderResolver ||= new PropertyPlaceholderResolver(null, _propertiesProvider);
					arg = _propertyPlaceholderResolver.resolveArgumentPropertyPlaceHolders(arg, this);
				}
				reference = arg.argumentValue;
			}
			for each (var referenceResolver:IReferenceResolver in referenceResolvers) {
				if (referenceResolver.canResolve(reference)) {
					return referenceResolver.resolve(reference);
				}
			}
			return reference;
		}
		
		/**
		 * @inheritDoc
		 */
		public function resolveReferences(references:Vector.<ArgumentDefinition>):Array {
			var result:Array = (references && references.length > 0) ? [] : null;
			for each (var ref:* in references) {
				result[result.length] = resolveReference(ref);
			}
			return result;
		}

		public function wire(instance:*, objectDefinition:IObjectDefinition=null, constructorArguments:Vector.<ArgumentDefinition>=null, objectName:String=null):* {
			if (dependencyInjector != null) {
				var wiredResult:* = dependencyInjector.wire(instance, this, objectDefinition, objectName);
				if (wiredResult != null) {
					instance = wiredResult;
				}
				var objectWiredEvent:ObjectFactoryEvent = new ObjectFactoryEvent(ObjectFactoryEvent.OBJECT_WIRED, instance, objectName, constructorArguments);
				dispatchEvent(objectWiredEvent);
				dispatchEventThroughEventBus(objectWiredEvent);
			}
			return instance;
		}

		private function addParentEventBusListener():void {
			if ((parent is IEventBusAware) && (_eventBus is IEventBusListener)) {
				IEventBusAware(parent).eventBus.addListener(IEventBusListener(_eventBus));
			}
		}

		private function attemptToInstantiate(objectDefinition:IObjectDefinition, constructorArguments:Vector.<ArgumentDefinition>, name:String, objectName:String):* {
			var result:* = null;
			try {
				logger.debug("Attempting to instantiate object for definition '{0}'...", [objectName]);
				result = instantiateClass(objectDefinition, (!constructorArguments) ? objectDefinition.constructorArguments : constructorArguments, objectName);
				var objectCreatedEvent:ObjectFactoryEvent = new ObjectFactoryEvent(ObjectFactoryEvent.OBJECT_CREATED, result, name, constructorArguments);
				dispatchEvent(objectCreatedEvent);
				dispatchEventThroughEventBus(objectCreatedEvent);
				result = wire(result, objectDefinition, constructorArguments, objectName);
			} catch (e:ClassNotFoundError) {
				throw new ObjectContainerError(e.message, objectName);
			}
			return result;
		}


		private function buildObject(name:String, constructorArguments:Vector.<ArgumentDefinition>):* {
			var result:*;
			var isFactoryDereference:Boolean = (name.charAt(0) == OBJECT_FACTORY_PREFIX);
			var objectName:String = (isFactoryDereference ? name.substring(1) : name);
			var objectDefinition:IObjectDefinition = getObjectDefinition(objectName);

			if (!objectDefinition) {
				objectDefinition = getObjectDefinitionFromParent(name, parent);
			} else if (objectDefinition.isInterface) {
				throw new ObjectFactoryError(StringUtils.substitute("Objectdefinition {0} describes an interface which cannot be directly instantiated", objectName));
			} else if ((objectDefinition.scope === ObjectDefinitionScope.STAGE) || ((objectDefinition.scope === ObjectDefinitionScope.REMOTE))){
				logger.debug("Object definition scope is '{0}', returning null", [objectDefinition.scope]);
				return null;
			}

			if ((objectDefinition.scope !== ObjectDefinitionScope.SINGLETON) && (objectDefinition.scope !== ObjectDefinitionScope.PROTOTYPE)) {
				throw new ObjectFactoryError(StringUtils.substitute("Only definitions with scope 'singleton', 'prototype' or 'remote' can be instantiated. Definition name: {0}", objectName));
			}

			if (objectDefinition.isSingleton && (constructorArguments && !objectDefinition.isLazyInit)) {
				throw new IllegalOperationError(StringUtils.substitute(NON_LAZY_SINGLETON_CTOR_ARGS_ERROR, objectName));
			}

			if (objectDefinition.isSingleton) {
				result = getInstanceFromCache(objectName);
			}

			guaranteeDependencies(result, objectName, objectDefinition);

			if (!result) {
				result = attemptToInstantiate(objectDefinition, constructorArguments, name, objectName);
				if (_objectDestroyer != null) {
					_objectDestroyer.registerInstance(result, name);
				}
			}

			return result;
		}

		private function createObjectViaInstanceFactoryMethod(objectName:String, methodName:String, args:Array=null):* {
			var factoryObject:Object = getObject(objectName);
			var factoryObjectMethodInvoker:MethodInvoker = new MethodInvoker();
			factoryObjectMethodInvoker.target = factoryObject;
			factoryObjectMethodInvoker.method = methodName;
			factoryObjectMethodInvoker.arguments = args;
			logger.debug("Creating object using factory method '{0}' on instance {1}", [methodName, objectName]);
			return factoryObjectMethodInvoker.invoke();
		}

		private function createObjectViaStaticFactoryMethod(clazz:Class, applicationDomain:ApplicationDomain, factoryMethodName:String, args:Array=null):* {
			var type:Type = Type.forClass(clazz, applicationDomain);
			var factoryMethod:Method = type.getMethod(factoryMethodName);
			logger.debug("Creating object using static factory method '{0}' on class {1}", [factoryMethodName, clazz]);
			return factoryMethod.invoke(clazz, args);
		}

		private function dispatchEventThroughEventBus(evt:ObjectFactoryEvent):void {
			if (_eventBus != null) {
				_eventBus.dispatchEvent(evt);
			}
		}

		private function getInstanceFromCache(objectName:String):* {
			var result:*;
			if (_cache.hasInstance(objectName)) {
				result = _cache.getInstance(objectName);
			}

			// not in cache -> perhaps it is prepared as a circular reference
			if ((!result) && (_cache.isPrepared(objectName))) {
				result = _cache.getPreparedInstance(objectName);
			}
			return result;
		}

		private function getObjectDefinitionFromParent(objectName:String, parentFactory:IObjectFactory):IObjectDefinition {
			if (parentFactory == null) {
				throw new ObjectDefinitionNotFoundError(StringUtils.substitute(OBJECT_DEFINITION_NOT_FOUND_ERROR, objectName));
			}
			var objectDefinition:IObjectDefinition = parentFactory.getObjectDefinition(objectName);
			if (objectDefinition != null) {
				return objectDefinition;
			} else {
				objectDefinition = getObjectDefinitionFromParent(objectName, parentFactory.parent);
				if (objectDefinition != null) {
					return objectDefinition;
				}
				throw new ObjectDefinitionNotFoundError(StringUtils.substitute(OBJECT_DEFINITION_NOT_FOUND_ERROR, objectName));
			}
		}

		private function getObjectFromParentFactory(objectName:String, constructorArguments:Array):* {
			if (_parent != null) {
				var objectDefinition:IObjectDefinition = getObjectDefinitionFromParent(objectName, _parent);
				if ((objectDefinition != null)) {
					return _parent.getObject(objectName, constructorArguments);
				}
			}
			if (!objectDefinition) {
				throw new ObjectDefinitionNotFoundError(StringUtils.substitute(OBJECT_DEFINITION_NOT_FOUND_ERROR, objectName));
			}
		}

		private function guaranteeDependencies(result:*, objectName:String, objectDefinition:IObjectDefinition):void {
			// Only do dependency guarantee loop when the object hasn't been retrieved from
			// the cache, when the object is in the early cache, do the dependency check. (Not sure if this is necessary though).
			if ((!result) || (_cache.isPrepared(objectName))) {
				// guarantee creation of objects that the current object depends on
				for each (var dependsOnObject:String in objectDefinition.dependsOn) {
					getObject(dependsOnObject);
				}
			}
		}

		private function instantiateClass(objectDefinition:IObjectDefinition, constructorArguments:Vector.<ArgumentDefinition>, objectName:String):* {
			logger.debug("Instantiating class: {0}", [objectDefinition.className]);
			var clazz:Class = objectDefinition.clazz;

			if (_autowireProcessor != null) {
				_autowireProcessor.preprocessObjectDefinition(objectDefinition);
			}

			var resolvedConstructorArgs:Array = resolveReferences(constructorArguments);

			try {
				if (objectDefinition.factoryMethod) {
					if (objectDefinition.factoryObjectName) {
						return createObjectViaInstanceFactoryMethod(objectDefinition.factoryObjectName, objectDefinition.factoryMethod, resolvedConstructorArgs);
					} else {
						return createObjectViaStaticFactoryMethod(clazz, applicationDomain, objectDefinition.factoryMethod, resolvedConstructorArgs);
					}
				} else {
					return ClassUtils.newInstance(clazz, resolvedConstructorArgs);
				}
			} catch (e:Error) {
				throw new IllegalOperationError(StringUtils.substitute("Failed to instantiate class '{0}' for definition with id '{1}':{2} , original error:\n{3}", clazz, objectName, objectDefinition, e.message));
			}
		}

		private function removeParentEventBusListener():void {
			if ((parent is IEventBusAware) && (IEventBusAware(parent).eventBus != null) && (_eventBus is IEventBusListener)) {
				logger.debug("Removing eventbus listener from parent's eventbus");
				IEventBusAware(parent).eventBus.removeListener(IEventBusListener(_eventBus));
			}
		}
	}
}
