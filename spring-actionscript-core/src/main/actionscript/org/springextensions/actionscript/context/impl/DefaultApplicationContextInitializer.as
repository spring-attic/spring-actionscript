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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.IOperationQueue;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.async.operation.impl.OperationQueue;
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.eventbus.impl.EventBus;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextInitializer;
	import org.springextensions.actionscript.context.event.ContextEvent;
	import org.springextensions.actionscript.ioc.IDependencyInjector;
	import org.springextensions.actionscript.ioc.IObjectDestroyer;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessorAware;
	import org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessor;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.ITextFilesLoader;
	import org.springextensions.actionscript.ioc.config.impl.AsyncObjectDefinitionProviderResultOperation;
	import org.springextensions.actionscript.ioc.config.impl.TextFilesLoader;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesParser;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;
	import org.springextensions.actionscript.ioc.config.property.impl.KeyValuePropertiesParser;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.PropertyPlaceholderConfigurerFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.RegisterObjectFactoryPostProcessorsFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.impl.DefaultDependencyInjector;
	import org.springextensions.actionscript.ioc.impl.DefaultObjectDestroyer;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultApplicationContextInitializer extends EventDispatcher implements IApplicationContextInitializer, IDisposable {
		private static const APPLICATION_CONTEXT_PROPERTIES_LOADER_NAME:String = "applicationContextTextFilesLoader";
		private static const DEFINITION_PROVIDER_QUEUE_NAME:String = "definitionProviderQueue";
		private static const LOGGER:ILogger = getClassLogger(DefaultApplicationContextInitializer);
		private static const NEWLINE_CHAR:String = "\n";
		private static const OBJECT_FACTORY_POST_PROCESSOR_QUEUE_NAME:String = "objectFactoryPostProcessorQueue";

		/**
		 * Creates a new <code>DefaultApplicationContextInitializer</code> instance.
		 */
		public function DefaultApplicationContextInitializer(target:IEventDispatcher=null) {
			super(target);
		}

		private var _applicationContext:IApplicationContext;
		private var _isDisposed:Boolean;
		private var _operationQueue:IOperationQueue;
		private var _propertiesParser:IPropertiesParser;
		private var _textFilesLoader:ITextFilesLoader;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function get propertiesParser():IPropertiesParser {
			return _propertiesParser;
		}

		/**
		 * @private
		 */
		public function set propertiesParser(value:IPropertiesParser):void {
			_propertiesParser = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get textFilesLoader():ITextFilesLoader {
			return _textFilesLoader;
		}

		/**
		 * @private
		 */
		public function set textFilesLoader(value:ITextFilesLoader):void {
			_textFilesLoader = value;
		}

		public function dispose():void {
			if (!_isDisposed) {
				_isDisposed = true;
				ContextUtils.disposeInstance(_propertiesParser);
				_propertiesParser = null;
				ContextUtils.disposeInstance(_operationQueue);
				_operationQueue = null;
				ContextUtils.disposeInstance(_textFilesLoader);
				_textFilesLoader = null;
				_applicationContext = null;
				LOGGER.debug("Instance {0} has been disposed", [this]);
			}
		}

		public function initialize(context:IApplicationContext):void {
			_applicationContext = context;
			if (_applicationContext is IEventBusAware) {
				(_applicationContext as IEventBusAware).eventBus = new EventBus();
			}
			if (!_applicationContext.isReady) {
				_operationQueue = new OperationQueue(DEFINITION_PROVIDER_QUEUE_NAME);
				for each (var provider:IObjectDefinitionsProvider in _applicationContext.definitionProviders) {
					LOGGER.debug("Executing object definitions provider {0}", [provider]);
					var operation:IOperation = provider.createDefinitions();
					if (operation != null) {
						LOGGER.debug("Object definitions provider {0} is asynchronous...", [provider]);
						operation.addCompleteListener(providerCompleteHandler, false, 0, true);
						_operationQueue.addOperation(operation);
					} else {
						handleObjectDefinitionResult(provider);
					}
				}
				if (_operationQueue.total > 0) {
					_operationQueue.addCompleteListener(providersLoadedHandler);
					_operationQueue.addErrorListener(providersLoadErrorHandler);
				} else {
					_operationQueue = null;
					cleanUpObjectDefinitionCreation();
				}
			}
		}

		private function cleanQueueAfterDefinitionProviders(queue:IOperationQueue):void {
			queue.removeCompleteListener(providersLoadedHandler);
			queue.removeErrorListener(providersLoadErrorHandler);
		}

		private function cleanUpObjectDefinitionCreation():void {
			injectDependencyInjector();
			if (_applicationContext.propertiesProvider && _applicationContext.propertiesProvider.length > 0) {
				var placeholderConfig:PropertyPlaceholderConfigurerFactoryPostProcessor = retrievePropertyPlaceHolderConfigurer();
				_applicationContext.addObjectFactoryPostProcessor(placeholderConfig);
			} else {
				for each (var factoryPostProcessor:IObjectFactoryPostProcessor in _applicationContext.objectFactoryPostProcessors) {
					if (factoryPostProcessor is PropertyPlaceholderConfigurerFactoryPostProcessor) {
						var idx:int = _applicationContext.objectFactoryPostProcessors.indexOf(factoryPostProcessor);
						if (idx > -1) {
							_applicationContext.objectFactoryPostProcessors.splice(idx, 1);
						}
						break;
					}
				}
			}
			ContextUtils.disposeInstance(_propertiesParser);
			_propertiesParser = null;
			for each (var definitionProvider:IObjectDefinitionsProvider in _applicationContext.definitionProviders) {
				ContextUtils.disposeInstance(definitionProvider);
			}
			_applicationContext.definitionProviders.length = 0;
			_operationQueue = null;
			ContextUtils.disposeInstance(_textFilesLoader);
			_textFilesLoader = null;
			_applicationContext.isReady = true;
			injectContextParts();
			_applicationContext.dispatchEvent(new ContextEvent(ContextEvent.AFTER_INITIALIZED, _applicationContext));
			executeObjectFactoryPostProcessors();
		}

		private function injectContextParts():void {
			injectAutowireProcessor();
			injectObjectDestroyer();
		}

		private function injectAutowireProcessor():void {
			if (_applicationContext is IAutowireProcessorAware) {
				if ((_applicationContext as IAutowireProcessorAware).autowireProcessor != null) {
					return;
				}
				var names:Vector.<String> = _applicationContext.objectDefinitionRegistry.getObjectDefinitionNamesForType(IAutowireProcessor);
				if (names == null) {
					(_applicationContext as IAutowireProcessorAware).autowireProcessor = new DefaultAutowireProcessor(_applicationContext);
				} else if (names.length == 1) {
					(_applicationContext as IAutowireProcessorAware).autowireProcessor = _applicationContext.getObject(names[0]);
				} else {
					throw new IllegalOperationError("Multiple IAutowireProcessor implementations found in context: " + names.join(','));
				}
			}
		}

		private function injectObjectDestroyer():void {
			if (_applicationContext.objectDestroyer != null) {
				return;
			}
			var names:Vector.<String> = _applicationContext.objectDefinitionRegistry.getObjectDefinitionNamesForType(IObjectDestroyer);
			if (names == null) {
				_applicationContext.objectDestroyer = new DefaultObjectDestroyer(_applicationContext);
			} else if (names.length == 1) {
				_applicationContext.objectDestroyer = _applicationContext.getObject(names[0]);
			} else {
				throw new IllegalOperationError("Multiple IObjectDestroyer implementations found in context: " + names.join(','));
			}
		}

		private function injectDependencyInjector():void {
			if (_applicationContext.dependencyInjector != null) {
				return;
			}
			var names:Vector.<String> = _applicationContext.objectDefinitionRegistry.getObjectDefinitionNamesForType(IDependencyInjector);
			if (names == null) {
				_applicationContext.dependencyInjector = new DefaultDependencyInjector();
			} else if (names.length == 1) {
				_applicationContext.dependencyInjector = _applicationContext.getObject(names[0]);
			} else {
				throw new IllegalOperationError("Multiple IDependencyInjector implementations found in context: " + names.join(','));
			}
		}

		private function injectEventBus():void {
			if (_applicationContext is IEventBusAware) {
				if ((_applicationContext as IEventBusAware).eventBus != null) {
					return;
				}
				var names:Vector.<String> = _applicationContext.objectDefinitionRegistry.getObjectDefinitionNamesForType(IEventBus);
				if (names == null) {
					(_applicationContext as IEventBusAware).eventBus = new EventBus();
				} else if (names.length == 1) {
					(_applicationContext as IEventBusAware).eventBus = _applicationContext.getObject(names[0]);
				} else {
					throw new IllegalOperationError("Multiple IEventBus implementations found in context: " + names.join(','));
				}
			}
		}

		private function retrievePropertyPlaceHolderConfigurer():PropertyPlaceholderConfigurerFactoryPostProcessor {
			var names:Vector.<String> = _applicationContext.objectDefinitionRegistry.getObjectDefinitionNamesForType(PropertyPlaceholderConfigurerFactoryPostProcessor);
			if (names != null) {
				return _applicationContext.getObject(names[0]);
			}
			return new PropertyPlaceholderConfigurerFactoryPostProcessor(0);
		}

		private function completeContextInitialization():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function executeObjectFactoryPostProcessors():void {
			if ((_applicationContext.objectFactoryPostProcessors == null) || (_applicationContext.objectFactoryPostProcessors.length < 1)) {
				finalizeObjectFactoryProcessorExecution();
			}
			_operationQueue = new OperationQueue(OBJECT_FACTORY_POST_PROCESSOR_QUEUE_NAME);
			var postprocessor:IObjectFactoryPostProcessor;
			var index:int = -1;
			var i:int = 0;
			for each (postprocessor in _applicationContext.objectFactoryPostProcessors) {
				if (postprocessor is RegisterObjectFactoryPostProcessorsFactoryPostProcessor) {
					postprocessor.postProcessObjectFactory(_applicationContext);
					index = i;
					break;
				}
				++i;
			}
			if (index > -1) {
				_applicationContext.objectFactoryPostProcessors.splice(index, 1);
			}
			for each (postprocessor in _applicationContext.objectFactoryPostProcessors) {
				LOGGER.debug("Executing object factory postprocessor {0}", [postprocessor]);
				var operation:IOperation = postprocessor.postProcessObjectFactory(_applicationContext);
				if (operation != null) {
					LOGGER.debug("Objectfactory postprocessor {0} is asynchronous...", [postprocessor]);
					_operationQueue.addOperation(operation);
				}
			}
			if (_operationQueue.total > 0) {
				_operationQueue.addCompleteListener(handleObjectFactoryPostProcessorsComplete, false, 0, true);
				_operationQueue.addErrorListener(handleObjectFactoryPostProcessorsError, false, 0, true);
			} else {
				finalizeObjectFactoryProcessorExecution();
			}
		}

		private function finalizeObjectFactoryProcessorExecution():void {
			for each (var postprocessor:IObjectFactoryPostProcessor in _applicationContext.objectFactoryPostProcessors) {
				ContextUtils.disposeInstance(postprocessor);
			}
			if (_applicationContext.objectFactoryPostProcessors != null) {
				_applicationContext.objectFactoryPostProcessors.length = 0;
			}
			var names:Vector.<String>;
			if (_applicationContext.cache != null) {
				names = _applicationContext.cache.getCachedNames();
			}
			instantiateSingletons();
			wireExplicitSingletons(names);
			completeContextInitialization();
		}

		private function handleObjectDefinitionResult(objectDefinitionsProvider:IObjectDefinitionsProvider):void {
			if (objectDefinitionsProvider == null) {
				return;
			}
			registerObjectDefinitions(objectDefinitionsProvider.objectDefinitions);

			var propertyURIs:Vector.<TextFileURI> = objectDefinitionsProvider.propertyURIs;
			var objectDefinitionsProviderHasPropertyURIs:Boolean = (propertyURIs != null) && (propertyURIs.length > 0);

			if (objectDefinitionsProviderHasPropertyURIs) {
				loadPropertyURIs(propertyURIs);
			}
			if ((objectDefinitionsProvider.propertiesProvider != null) && (objectDefinitionsProvider.propertiesProvider.length > 0)) {
				LOGGER.debug("Object definitions provider returned a set of properties, adding it to the context");
				_applicationContext.propertiesProvider.merge(objectDefinitionsProvider.propertiesProvider);
			}
		}

		private function handleObjectFactoryPostProcessorsComplete(result:*):void {
			finalizeObjectFactoryProcessorExecution();
		}

		private function handleObjectFactoryPostProcessorsError(error:*):void {
			LOGGER.error("Objectfactory post processing encountered an error: ", [error]);
		}

		private function instantiateSingletons():void {
			if ((_applicationContext.cache == null) || (_applicationContext.objectDefinitionRegistry == null)) {
				return;
			}
			var names:Vector.<String> = _applicationContext.objectDefinitionRegistry.getSingletons();
			for each (var name:String in names) {
				if (!_applicationContext.cache.hasInstance(name)) {
					LOGGER.debug("Instantiating singleton named '{0}'", [name]);
					_applicationContext.getObject(name);
				}
			}
		}

		private function loadPropertyURIs(propertyURIs:Vector.<TextFileURI>):void {
			LOGGER.debug("Loading property URI's");
			_textFilesLoader ||= createTextFilesLoader();
			_textFilesLoader.addURIs(propertyURIs);
		}

		private function createTextFilesLoader():ITextFilesLoader {
			var textFilesLoader:ITextFilesLoader = new TextFilesLoader(APPLICATION_CONTEXT_PROPERTIES_LOADER_NAME);
			textFilesLoader.addCompleteListener(propertyTextFilesLoadComplete, false, 0, true);
			_operationQueue.addOperation(textFilesLoader);
			return textFilesLoader;
		}

		private function propertyTextFilesLoadComplete(operationEvent:OperationEvent):void {
			var propertySources:Vector.<String> = operationEvent.result;
			if (propertySources != null) {
				var properties:Properties = new Properties();
				var source:String = propertySources.join(NEWLINE_CHAR);
				propertiesParser ||= new KeyValuePropertiesParser();
				LOGGER.debug("External properties files loaded, starting to parse it using {0}", [propertiesParser]);
				propertiesParser.parseProperties(source, properties);
				_applicationContext.propertiesProvider.merge(properties);
			}
		}

		private function providerCompleteHandler(event:OperationEvent):void {
			handleObjectDefinitionResult(AsyncObjectDefinitionProviderResultOperation(event.operation).objectDefinitionsProvider);
		}

		private function providersLoadErrorHandler(error:*):void {
			cleanQueueAfterDefinitionProviders(_operationQueue);
			LOGGER.error("Object definitions provider encountered an error: ", [error]);
		}

		private function providersLoadedHandler(operationEvent:OperationEvent):void {
			cleanQueueAfterDefinitionProviders(_operationQueue);
			cleanUpObjectDefinitionCreation();
		}

		private function registerObjectDefinitions(newObjectDefinitions:Object):void {
			if (_applicationContext.objectDefinitionRegistry != null) {
				for (var name:String in newObjectDefinitions) {
					_applicationContext.objectDefinitionRegistry.registerObjectDefinition(name, newObjectDefinitions[name]);
				}
			}
		}

		private function wireExplicitSingletons(names:Vector.<String>):void {
			if (_applicationContext.dependencyInjector != null) {
				for each (var name:String in names) {
					if (!_applicationContext.objectDefinitionRegistry.containsObjectDefinition(name)) {
						LOGGER.debug("Wiring explicit singleton named '{0}' (a cached object without a corresponding object definition)", [name]);
						_applicationContext.manage(_applicationContext.cache.getInstance(name), name);
					}
				}
			}
		}
	}
}
