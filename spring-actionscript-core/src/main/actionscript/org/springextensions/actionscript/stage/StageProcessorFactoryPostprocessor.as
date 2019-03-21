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
package org.springextensions.actionscript.stage {
	import flash.display.DisplayObject;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistry;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistryAware;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 * <p><code>IObjectFactoryPostProcessor</code> implementation that retrieves all the <code>IStageProcessor</code>
	 * from the <code>IConfigurableListableObjectFactory</code> instance and registers them by invoking the
	 * <code>registerStageProcessor()</code> method on the <code>IStageProcessorRegistry</code> instance.</p>
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StageProcessorFactoryPostprocessor implements IObjectFactoryPostProcessor {

		private var _defaultObjectSelector:IObjectSelector;

		private static var logger:ILogger = getClassLogger(StageProcessorFactoryPostprocessor);

		/**
		 * Creates a new <code>StageProcessorFactoryPostprocessor</code> instance.
		 */
		public function StageProcessorFactoryPostprocessor() {
			super();
		}

		/**
		 * <p>First checks if the <code>objectFactory</code> argument is an implementation of <code>IStageProcessorRegistryAware</code>, if not
		 * the objectFactory is checked to see if it contains an object that implements <code>IStageProcessorRegistry</code>.</p>
		 * <p>If an <code>IStageProcessorRegistry</code> instance has been found in the <code>objectFactory</code> is used to retrieve all
		 * <code>IStageProcessor</code> instances which all are registered with the specified <code>IStageProcessorRegistry</code>.</p>
		 * <p>If no <code>IStageProcessors</code> are found in the current <code>IObjectFactory</code>, the <code>IStageProcessorRegistry</code>
		 * will be disposed.</p>
		 */
		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			var stageProcessorRegistry:IStageObjectProcessorRegistry;
			var stageProcessorNames:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IStageObjectProcessor);
			if (stageProcessorNames == null) {
				if ((objectFactory is IStageObjectProcessorRegistryAware) && (IStageObjectProcessorRegistryAware(objectFactory).stageProcessorRegistry != null)) {
					stageProcessorRegistry = IStageObjectProcessorRegistryAware(objectFactory).stageProcessorRegistry;
					if (stageProcessorRegistry.getAllStageObjectProcessors() == null) {
						if ((stageProcessorRegistry is SpringStageObjectProcessorRegistry) && ((stageProcessorRegistry as SpringStageObjectProcessorRegistry).owner === (objectFactory as IApplicationContext))) {
							ContextUtils.disposeInstance(stageProcessorRegistry);
						}
						IStageObjectProcessorRegistryAware(objectFactory).stageProcessorRegistry = null;
					}
				}
				logger.debug("No stageprocessors were registered, removing the stageProcessorRegistry since it is now obsolete.");
				return null;
			}

			var rootViews:Vector.<DisplayObject>;
			if (objectFactory is IApplicationContext) {
				rootViews = IApplicationContext(objectFactory).rootViews;
			}
			stageProcessorRegistry = (objectFactory is IStageObjectProcessorRegistryAware) ? IStageObjectProcessorRegistryAware(objectFactory).stageProcessorRegistry : null;

			if (stageProcessorRegistry == null) {
				logger.debug("No stageProcessorRegistry instance found yet, checking factory...");
				stageProcessorRegistry = findStageProcessorRegistryInFactory(objectFactory);
				if (stageProcessorRegistry == null) {
					logger.debug("No stageProcessorRegistry instance found in factory, creating SpringStageObjectProcessorRegistry as default");
					stageProcessorRegistry = new SpringStageObjectProcessorRegistry(objectFactory as IApplicationContext);
					if (objectFactory is IStageObjectProcessorRegistryAware) {
						IStageObjectProcessorRegistryAware(objectFactory).stageProcessorRegistry = stageProcessorRegistry;
					}
				}
			}

			if (stageProcessorRegistry != null) {
				for each (var name:String in stageProcessorNames) {
					var objectSelector:IObjectSelector = resolveObjectSelector(objectFactory, name);
					for each (var rootView:DisplayObject in rootViews) {
						registerProcessor(stageProcessorRegistry, IStageObjectProcessor(objectFactory.getObject(name)), rootView, objectSelector);
					}
				}
				stageProcessorRegistry.initialize();
				if (PopupAndTooltipWireManager.instances == 0) {
					var manager:PopupAndTooltipWireManager = new PopupAndTooltipWireManager();
					var result:Boolean = manager.initializePopupsAndTooltips(stageProcessorRegistry);
					if (result) {
						objectFactory.cache.putInstance("springactionscript_popupAndTooltipWireManager", manager);
					}
				}
			}
			return null;
		}

		protected function resolveObjectSelector(objectFactory:IObjectFactory, processorName:String):IObjectSelector {
			var selector:* = objectFactory.getObjectDefinition(processorName).customConfiguration;
			if (selector is String) {
				var selectorName:String = selector;
				if (objectFactory.canCreate(selectorName)) {
					logger.debug("Retrieving custom object selector with name {0}", [selectorName]);
					return objectFactory.getObject(selectorName);
				}
			} else if (selector is IObjectSelector) {
				logger.debug("Retrieving custom object selector {0}", [selector]);
				return selector;
			}
			logger.debug("Retrieving default object selector");
			return getDefaultObjectSelector();
		}

		protected function getDefaultObjectSelector():IObjectSelector {
			return _defaultObjectSelector ||= new DefaultSpringObjectSelector();
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Retrieves all objects in the container of the type <code>IStageProcessorRegistry</code> and returns the first instance.
		 * If no objects are found, null is returned.
		 * @param objectFactory The <code>IConfigurableListableObjectFactory</code> that will be searched.
		 * @return An <code>IStageProcessorRegistry</code> or null if none was found.
		 *
		 */
		protected function findStageProcessorRegistryInFactory(objectFactory:IObjectFactory):IStageObjectProcessorRegistry {
			var stageProcessorRegistryNames:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IStageObjectProcessorRegistry);
			logger.debug("StageProcessorRegistry instance found in factory:" + (stageProcessorRegistryNames && stageProcessorRegistryNames.length > 0));
			return (stageProcessorRegistryNames && stageProcessorRegistryNames.length > 0) ? objectFactory.getObject(stageProcessorRegistryNames[0]) as IStageObjectProcessorRegistry : null;
		}

		/**
		 * Registers the specified <code>IStageProcessor</code> with the specified <code>IStageProcessorRegistry</code>. If the specified <code>IStageProcessor.document</code>
		 * property is null, it will be assigned with the specified <code>document</code> instance.
		 * @param stageProcessorRegistry The specified <code>IStageProcessorRegistry</code> instance.
		 * @param name The name under which the specified <code>IStageProcessor</code> will be registered.
		 * @param stageProcessor The specified <code>IStageProcessor</code> instance.
		 * @param document The specified <code>document</code> instance.
		 *
		 */
		protected function registerProcessor(stageProcessorRegistry:IStageObjectProcessorRegistry, stageProcessor:IStageObjectProcessor, rootView:DisplayObject, objectSelector:IObjectSelector):void {
			stageProcessorRegistry.registerStageObjectProcessor(stageProcessor, objectSelector, rootView);
		}

	}
}
