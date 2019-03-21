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
package org.springextensions.actionscript.context.impl {
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.util.OrderedUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Type;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistry;
	import org.springextensions.actionscript.context.ContextShareSettings;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.context.IApplicationContextInitializer;
	import org.springextensions.actionscript.context.IChildContextManager;
	import org.springextensions.actionscript.context.config.IConfigurationPackage;
	import org.springextensions.actionscript.context.event.ChildContextEvent;
	import org.springextensions.actionscript.context.event.ContextEvent;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.IDependencyInjector;
	import org.springextensions.actionscript.ioc.IObjectDestroyer;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessorAware;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.metadata.ILoaderInfoAware;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.stage.SpringStageObjectProcessorRegistry;
	import org.springextensions.actionscript.util.ContextUtils;
	import org.springextensions.actionscript.util.Environment;

	/**
	 *
	 */
	[Event(name="afterApplicationContextDispose", type="org.springextensions.actionscript.context.event.ContextEvent")]
	/**
	 *
	 */
	[Event(name="beforeChildContextRemove", type="org.springextensions.actionscript.context.event.ChildContextEvent")]
	/**
	 *
	 */
	[Event(name="afterChildContextRemove", type="org.springextensions.actionscript.context.event.ChildContextEvent")]
	/**
	 *
	 */
	[Event(name="beforeChildContextAdd", type="org.springextensions.actionscript.context.event.ChildContextEvent")]
	/**
	 *
	 */
	[Event(name="afterChildContextAdd", type="org.springextensions.actionscript.context.event.ChildContextEvent")]
	/**
	 *
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Basic implementation of the <code>IApplicationContext</code> interface. No object or factory processors are created by default inside this base class. Use this class for
	 * custom configured application contexts. Otherwise use the <code>DefaultApplicationContext</code> which offers some basic functionality 'out-of-the-box'.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ApplicationContext implements IApplicationContext, IDisposable, IAutowireProcessorAware, IEventBusAware, IEventBusUserRegistryAware, ILoaderInfoAware {

		public static const APPLICATIONCONTEXTINITIALIZER_CHANGED_EVENT:String = "applicationContextInitializerChanged";
		private static const GET_ASSOCIATED_FACTORY_METHOD_NAME:String = "getAssociatedFactory";
		private static const LOGGER:ILogger = getClassLogger(ApplicationContext);
		private static const MXMODULES_MODULE_MANAGER_CLASS_NAME:String = "mx.modules.ModuleManager";

		/**
		 * Creates a new <code>ApplicationContext</code> instance.
		 */
		public function ApplicationContext(rootViews:Vector.<DisplayObject>=null, objFactory:IObjectFactory=null) {
			super();
			_objectFactory = objFactory;
			_definitionProviders = new Vector.<IObjectDefinitionsProvider>();
			_rootViews = rootViews;
			applicationDomain = resolveRootViewApplicationDomain(_rootViews);
			loaderInfo = resolveRootViewLoaderInfo(_rootViews);
		}

		private var _applicationContextInitializer:IApplicationContextInitializer;
		private var _childContextManagerName:String;
		private var _childContexts:Vector.<IApplicationContext>;
		private var _definitionProviders:Vector.<IObjectDefinitionsProvider>;
		private var _eventBus:IEventBus;
		private var _ignoredRootViews:Vector.<DisplayObject>;
		private var _isDisposed:Boolean;
		private var _loaderInfo:LoaderInfo;
		private var _objectFactory:IObjectFactory;
		private var _objectFactoryPostProcessors:Vector.<IObjectFactoryPostProcessor>;
		private var _rootViews:Vector.<DisplayObject>;
		private var _stageProcessorRegistry:IStageObjectProcessorRegistry;
		private var _token:uint;

		[Bindable(event="applicationContextInitializerChanged")]
		public function get applicationContextInitializer():IApplicationContextInitializer {
			return _applicationContextInitializer;
		}

		public function set applicationContextInitializer(value:IApplicationContextInitializer):void {
			if (_applicationContextInitializer !== value) {
				_applicationContextInitializer = value;
				dispatchEvent(new Event(APPLICATIONCONTEXTINITIALIZER_CHANGED_EVENT));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get applicationDomain():ApplicationDomain {
			return (_objectFactory != null) ? _objectFactory.applicationDomain : Type.currentApplicationDomain;
		}

		/**
		 * @private
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			if (_objectFactory != null) {
				_objectFactory.applicationDomain = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get autowireProcessor():IAutowireProcessor {
			return (_objectFactory is IAutowireProcessorAware) ? IAutowireProcessorAware(_objectFactory).autowireProcessor : null;
		}

		/**
		 * @private
		 */
		public function set autowireProcessor(value:IAutowireProcessor):void {
			if (_objectFactory is IAutowireProcessorAware) {
				IAutowireProcessorAware(_objectFactory).autowireProcessor = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():IInstanceCache {
			return _objectFactory.cache;
		}

		/**
		 * @inheritDoc
		 */
		public function get childContexts():Vector.<IApplicationContext> {
			return _childContexts ||= new Vector.<IApplicationContext>();
		}

		/**
		 * @inheritDoc
		 */
		public function get definitionProviders():Vector.<IObjectDefinitionsProvider> {
			return _definitionProviders;
		}

		/**
		 * @inheritDoc
		 */
		public function get dependencyInjector():IDependencyInjector {
			return _objectFactory.dependencyInjector;
		}

		/**
		 * @private
		 */
		public function set dependencyInjector(value:IDependencyInjector):void {
			_objectFactory.dependencyInjector = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get eventBus():IEventBus {
			return (_objectFactory is IEventBusAware) ? IEventBusAware(_objectFactory).eventBus : _eventBus;
		}

		/**
		 * @private
		 */
		public function set eventBus(value:IEventBus):void {
			if (_objectFactory is IEventBusAware) {
				IEventBusAware(_objectFactory).eventBus = value;
			} else {
				_eventBus = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get eventBusUserRegistry():IEventBusUserRegistry {
			if (_objectFactory is IEventBusUserRegistryAware) {
				return IEventBusUserRegistryAware(_objectFactory).eventBusUserRegistry;
			}
			return null;
		}

		/**
		 * @private
		 */
		public function set eventBusUserRegistry(value:IEventBusUserRegistry):void {
			if (_objectFactory is IEventBusUserRegistryAware) {
				IEventBusUserRegistryAware(_objectFactory).eventBusUserRegistry = value;
			}
		}

		public function get ignoredRootViews():Vector.<DisplayObject> {
			return _ignoredRootViews;
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
		public function get isReady():Boolean {
			return _objectFactory.isReady;
		}

		/**
		 * @private
		 */
		public function set isReady(value:Boolean):void {
			_objectFactory.isReady = true;
		}

		/**
		 * @inheritDoc
		 */
		public function get loaderInfo():LoaderInfo {
			return _loaderInfo;
		}

		/**
		 * @private
		 */
		public function set loaderInfo(value:LoaderInfo):void {
			_loaderInfo = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectDefinitionRegistry():IObjectDefinitionRegistry {
			return _objectFactory.objectDefinitionRegistry;
		}

		/**
		 * @private
		 */
		public function set objectDefinitionRegistry(value:IObjectDefinitionRegistry):void {
			_objectFactory.objectDefinitionRegistry = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectDestroyer():IObjectDestroyer {
			return _objectFactory.objectDestroyer;
		}

		/**
		 * @private
		 */
		public function set objectDestroyer(value:IObjectDestroyer):void {
			_objectFactory.objectDestroyer = value;
		}

		public function get objectFactory():IObjectFactory {
			return _objectFactory;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectFactoryPostProcessors():Vector.<IObjectFactoryPostProcessor> {
			return _objectFactoryPostProcessors ||= new Vector.<IObjectFactoryPostProcessor>();
		}

		/**
		 * @inheritDoc
		 */
		public function get objectPostProcessors():Vector.<IObjectPostProcessor> {
			return _objectFactory.objectPostProcessors;
		}

		/**
		 * @inheritDoc
		 */
		public function get parent():IObjectFactory {
			return _objectFactory.parent;
		}

		/**
		 * @private
		 */
		public function set parent(value:IObjectFactory):void {
			_objectFactory.parent = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get propertiesProvider():IPropertiesProvider {
			return _objectFactory.propertiesProvider;
		}

		/**
		 * @private
		 */
		public function set propertiesProvider(value:IPropertiesProvider):void {
			_objectFactory.propertiesProvider = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get referenceResolvers():Vector.<IReferenceResolver> {
			return _objectFactory.referenceResolvers;
		}

		/**
		 * @inheritDoc
		 */
		public function get rootViews():Vector.<DisplayObject> {
			return _rootViews;
		}

		/**
		 * @inheritDoc
		 */
		public function get stageProcessorRegistry():IStageObjectProcessorRegistry {
			return _stageProcessorRegistry;
		}

		/**
		 * @private
		 */
		public function set stageProcessorRegistry(value:IStageObjectProcessorRegistry):void {
			_stageProcessorRegistry = value;
		}

		/**
		 * @inheritDoc
		 */
		public function addChildContext(childContext:IApplicationContext, settings:ContextShareSettings=null):IApplicationContext {
			var manager:IChildContextManager = getChildContextManager();
			manager.addEventListener(ChildContextEvent.BEFORE_CHILD_CONTEXT_ADD, redispatch);
			manager.addEventListener(ChildContextEvent.AFTER_CHILD_CONTEXT_ADD, redispatch);
			manager.addChildContext(this, childContext, settings);
			manager.removeEventListener(ChildContextEvent.BEFORE_CHILD_CONTEXT_ADD, redispatch);
			manager.removeEventListener(ChildContextEvent.AFTER_CHILD_CONTEXT_ADD, redispatch);
			childContext.addEventListener(ContextEvent.AFTER_DISPOSE, childContextDisposedHandler, false, 0, true);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addDefinitionProvider(provider:IObjectDefinitionsProvider):IApplicationContext {
			if (definitionProviders.indexOf(provider) < 0) {
				if (provider is IApplicationDomainAware) {
					IApplicationDomainAware(provider).applicationDomain = applicationDomain;
				}
				if (provider is IApplicationContextAware) {
					IApplicationContextAware(provider).applicationContext = this;
				}
				definitionProviders[definitionProviders.length] = provider;
				LOGGER.debug("Definition provider {0} added", [provider]);
			}
			return this;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_objectFactory.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function addIgnoredRootView(rootView:DisplayObject):void {
			_ignoredRootViews ||= new Vector.<DisplayObject>();
			if (addDisplayObject(_ignoredRootViews, rootView)) {

			}
		}

		/**
		 * @inheritDoc
		 */
		public function addObjectFactoryPostProcessor(objectFactoryPostProcessor:IObjectFactoryPostProcessor):IApplicationContext {
			if (objectFactoryPostProcessors.indexOf(objectFactoryPostProcessor) < 0) {
				if (objectFactoryPostProcessor is IApplicationDomainAware) {
					IApplicationDomainAware(objectFactoryPostProcessor).applicationDomain = applicationDomain;
				}
				objectFactoryPostProcessors[objectFactoryPostProcessors.length] = objectFactoryPostProcessor;
				_objectFactoryPostProcessors.sort(OrderedUtils.orderedCompareFunction);
				LOGGER.debug("Object factory postprocessor {0} added", [objectFactoryPostProcessor]);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):IObjectFactory {
			LOGGER.debug("Object postprocessor {0} added", [objectPostProcessor]);
			return _objectFactory.addObjectPostProcessor(objectPostProcessor);
		}

		/**
		 * @inheritDoc
		 */
		public function addReferenceResolver(referenceResolver:IReferenceResolver):IObjectFactory {
			LOGGER.debug("Reference resolver {0} added", [referenceResolver]);
			return _objectFactory.addReferenceResolver(referenceResolver);
		}

		/**
		 * @inheritDoc
		 */
		public function addRootView(rootView:DisplayObject):void {
			_rootViews ||= new Vector.<DisplayObject>();
			if (addDisplayObject(_rootViews, rootView)) {
				LOGGER.debug("Root view {0} added", [rootView]);
				if ((_objectFactory.isReady) && (rootViews.length > 1) && (stageProcessorRegistry != null)) {
					var processors:Vector.<IStageObjectProcessor> = stageProcessorRegistry.getStageProcessorsByRootView(rootViews[0]);
					for each (var processor:IStageObjectProcessor in processors) {
						var selectors:Vector.<IObjectSelector> = stageProcessorRegistry.getObjectSelectorsForStageProcessor(processor);
						for each (var selector:IObjectSelector in selectors) {
							stageProcessorRegistry.registerStageObjectProcessor(processor, selector, rootView);
						}
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function canCreate(objectName:String):Boolean {
			return _objectFactory.canCreate(objectName);
		}

		/**
		 * @inheritDoc
		 */
		public function configure(configurationPackage:IConfigurationPackage):IApplicationContext {
			configurationPackage.execute(this);
			LOGGER.debug("Configuration package {0} executed on current application context", [configurationPackage]);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function createInstance(clazz:Class, constructorArguments:Array=null):* {
			return _objectFactory.createInstance(clazz, constructorArguments);
		}

		/**
		 * @inheritDoc
		 */
		public function destroyObject(instance:Object):void {
			_objectFactory.destroyObject(instance);
		}

		public function dispatchEvent(event:Event):Boolean {
			return _objectFactory.dispatchEvent(event);
		}

		/**
		 * Clears, disposes and nulls out every member of the current <code>ApplicationContext</code>.
		 */
		public function dispose():void {
			if (!_isDisposed) {
				try {
					for each (var childContext:IApplicationContext in _childContexts) {
						ContextUtils.disposeInstance(childContext);
					}
					_childContexts = null;

					for each (var provider:IObjectDefinitionsProvider in _definitionProviders) {
						ContextUtils.disposeInstance(provider);
					}
					_definitionProviders = null;

					ContextUtils.disposeInstance(_objectFactory);

					ContextUtils.disposeInstance(_applicationContextInitializer);
					_applicationContextInitializer = null;

					if (_eventBus != null) {
						_eventBus.clear();
						ContextUtils.disposeInstance(_eventBus);
					}
					_eventBus = null;
					_rootViews = null;
					_loaderInfo = null;

					if ((_stageProcessorRegistry is SpringStageObjectProcessorRegistry) && ((_stageProcessorRegistry as SpringStageObjectProcessorRegistry).owner !== this)) {
						unregisterStageProcessors(_stageProcessorRegistry);
					} else {
						if (_stageProcessorRegistry != null) {
							_stageProcessorRegistry.clear();
							ContextUtils.disposeInstance(_stageProcessorRegistry);
						}
					}
					_stageProcessorRegistry = null;

					for each (var factoryPostProcessor:IObjectFactoryPostProcessor in _objectFactoryPostProcessors) {
						ContextUtils.disposeInstance(factoryPostProcessor);
					}
					_objectFactoryPostProcessors = null;
					LOGGER.debug("Context disposed");
				} finally {
					_isDisposed = true;
				}
				dispatchEvent(new ContextEvent(ContextEvent.AFTER_DISPOSE, this));
				_objectFactory = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getObject(name:String, constructorArguments:Array=null):* {
			return _objectFactory.getObject(name, constructorArguments);
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinition(objectName:String):IObjectDefinition {
			return _objectFactory.getObjectDefinition(objectName);
		}

		public function hasEventListener(type:String):Boolean {
			return _objectFactory.hasEventListener(type);
		}

		/**
		 *
		 */
		public function load():void {
			_applicationContextInitializer ||= new DefaultApplicationContextInitializer();
			_applicationContextInitializer.addEventListener(Event.COMPLETE, handleInitializationComplete);
			_applicationContextInitializer.initialize(this);
		}

		public function manage(instance:*, objectName:String=null):* {
			return _objectFactory.manage(instance, objectName);
		}

		/**
		 *
		 * @param childContext
		 * @return The current <code>IApplicationContext</code>
		 */
		public function removeChildContext(childContext:IApplicationContext):IApplicationContext {
			var manager:IChildContextManager = getChildContextManager();
			var removeListener:Function = function(event:ChildContextEvent):void {
				event.childContext.removeEventListener(ChildContextEvent.AFTER_CHILD_CONTEXT_REMOVE, childContextDisposedHandler);
				redispatch(event);
			};
			manager.addEventListener(ChildContextEvent.AFTER_CHILD_CONTEXT_REMOVE, removeListener);
			manager.addEventListener(ChildContextEvent.BEFORE_CHILD_CONTEXT_REMOVE, redispatch);
			manager.removeChildContext(this, childContext);
			manager.removeEventListener(ChildContextEvent.AFTER_CHILD_CONTEXT_REMOVE, removeListener);
			manager.removeEventListener(ChildContextEvent.BEFORE_CHILD_CONTEXT_REMOVE, redispatch);
			return this;
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_objectFactory.removeEventListener(type, listener, useCapture);
		}

		public function removeIgnoredRootView(rootView:DisplayObject):void {
			if (removeDisplayObject(_ignoredRootViews, rootView)) {

			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeRootView(rootView:DisplayObject):void {
			if (removeDisplayObject(_rootViews, rootView)) {
				removeRootViewFromStageProcessing(rootView);
				LOGGER.debug("Removed root view {0}", [rootView]);
			}
		}

		/**
		 * @private
		 */
		public function resolveReference(reference:*):* {
			return _objectFactory.resolveReference(reference);
		}

		/**
		 *
		 * @param references
		 * @return
		 */
		public function resolveReferences(references:Vector.<ArgumentDefinition>):Array {
			return _objectFactory.resolveReferences(references);
		}

		public function willTrigger(type:String):Boolean {
			return _objectFactory.willTrigger(type);
		}

		public function wire(instance:*, objectDefinition:IObjectDefinition=null, constructorArguments:Vector.<ArgumentDefinition>=null, objectName:String=null):* {
			return _objectFactory.wire(instance, objectDefinition, constructorArguments, objectName);
		}

		private function addDisplayObject(list:Vector.<DisplayObject>, displayObject:DisplayObject):Boolean {
			if ((null != displayObject) && list.indexOf(displayObject) < 0) {
				list[list.length] = displayObject;
				return true;
			}
			return false;
		}

		private function childContextDisposedHandler(event:ContextEvent):void {
			removeChildContext(event.applicationContext);
		}

		private function getChildContextManager():IChildContextManager {
			if (_childContextManagerName == null) {
				var names:Vector.<String> = objectDefinitionRegistry.getObjectDefinitionNamesForType(IChildContextManager);
				_childContextManagerName = (names != null) ? names[0] : "";
			}
			if (_childContextManagerName.length > 0) {
				LOGGER.debug("Found definition for IChildContextManager in the current context, retrieving it");
				return _objectFactory.getObject(_childContextManagerName);
			} else {
				LOGGER.debug("No definition found for IChildContextManager in the current context, creating DefaultChildContextManager instance instead");
				return new DefaultChildContextManager();
			}
		}

		private function handleInitializationComplete(event:Event):void {
			_applicationContextInitializer.removeEventListener(Event.COMPLETE, handleInitializationComplete);
			ContextUtils.disposeInstance(_applicationContextInitializer);
			_applicationContextInitializer = null;
			_objectFactoryPostProcessors = null;
			_definitionProviders = null;
			LOGGER.debug("Application context initialization complete");
			redispatch(event);
		}

		private function redispatch(event:Event):void {
			dispatchEvent(event);
		}

		private function removeDisplayObject(_rootViews:Vector.<DisplayObject>, rootView:DisplayObject):Boolean {
			if (_rootViews == null) {
				return false;
			}
			var idx:int = _rootViews.indexOf(rootView);
			if (idx > -1) {
				_rootViews.splice(idx, 1);
				return true;
			}
			return false;
		}

		private function removeRootViewFromStageProcessing(rootView:DisplayObject):void {
			if (stageProcessorRegistry != null) {
				var processors:Vector.<IStageObjectProcessor> = stageProcessorRegistry.getStageProcessorsByRootView(rootView);
				for each (var processor:IStageObjectProcessor in processors) {
					var selectors:Vector.<IObjectSelector> = stageProcessorRegistry.getObjectSelectorsForStageProcessor(processor);
					for each (var selector:IObjectSelector in selectors) {
						stageProcessorRegistry.unregisterStageObjectProcessor(processor, selector, rootView);
					}
				}
			}
		}

		private function resolveRootViewApplicationDomain(views:Vector.<DisplayObject>):ApplicationDomain {
			if ((views != null) && (views.length > 0)) {
				try {
					var cls:Class = ClassUtils.forName(MXMODULES_MODULE_MANAGER_CLASS_NAME, Type.currentApplicationDomain);
					var factory:Object = cls[GET_ASSOCIATED_FACTORY_METHOD_NAME](views[0]);
					if (factory != null) {
						LOGGER.debug("Retrieving application domain from associated factory: {0}", [factory]);
						return ApplicationDomain(factory.info().currentDomain);
					}
				} catch (e:Error) {
				}
			}
			return Type.currentApplicationDomain;
		}

		private function resolveRootViewLoaderInfo(views:Vector.<DisplayObject>):LoaderInfo {
			var loaderInfo:LoaderInfo;
			if ((views == null) || (views.length == 0)) {
				var stage:Stage = Environment.getCurrentStage();
				if (stage != null) {
					loaderInfo = stage.loaderInfo;
				}
			} else {
				loaderInfo = views[0].loaderInfo;
			}
			if (loaderInfo == null) {
				waitForLoaderInfo();
			}
			return loaderInfo;
		}

		private function unregisterStageProcessors(stageProcessorRegistry:IStageObjectProcessorRegistry):void {
			if (stageProcessorRegistry == null) {
				return;
			}
			for each (var view:DisplayObject in _rootViews) {
				var processors:Vector.<IStageObjectProcessor> = stageProcessorRegistry.getStageProcessorsByRootView(view);
				for each (var processor:IStageObjectProcessor in processors) {
					var selectors:Vector.<IObjectSelector> = stageProcessorRegistry.getObjectSelectorsForStageProcessor(processor);
					for each (var selector:IObjectSelector in selectors) {
						stageProcessorRegistry.unregisterStageObjectProcessor(processor, selector, view);
						ContextUtils.disposeInstance(processor);
					}
					ContextUtils.disposeInstance(selector);
				}
			}
		}

		private function waitForLoaderInfo():void {
			_token = setTimeout(function():void {
				clearTimeout(_token);
				if (_loaderInfo == null) {
					_loaderInfo = resolveRootViewLoaderInfo(_rootViews);
				}
			}, 100);
		}
	}
}
