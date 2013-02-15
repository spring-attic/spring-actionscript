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
package org.springextensions.actionscript.stage {

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedSuperclassName;

	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.modules.Module;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.module.ModulePolicy;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * <p>A singleton implementation of the <code>IStageProcessorRegistry</code> that can be shared amongst <code>FlexXMLApplicationContext</code>
	 * instances that perform stage processing.</p>
	 * @author Roland Zwaga
	 * @sampleref stagewiring
	 * @inheritDoc
	 */
	public class FlexStageProcessorRegistry extends FlashStageProcessorRegistry {

		{
			//force inclusion of the default selector
			FlexStageDefaultObjectSelector;
		}

		// --------------------------------------------------------------------
		//
		// Public Static Constants
		//
		// --------------------------------------------------------------------

		public static const MX_WINDOW_CLASS:String = "mx.core::Window";
		public static const SPARK_WINDOW_CLASS:String = "spark.components::Window";

		// --------------------------------------------------------------------
		//
		// Private Static Constants
		//
		// --------------------------------------------------------------------

		private static const _singletonToken:Object = {};
		private static const REGISTERED_CONTEXT_WITH_MODULE:String = "Registered context {0} with module {1}";
		private static const UNREGISTERED_CONTEXT_WITH_MODULE:String = "Unregistered context {0} with module {1}";
		private static const UNABLE_TO_UNREGISTER_MODULE_CONTEXT:String = "Unable to unregister context {0} with module {1}";
		private static const REGISTERED_WINDOW:String = "Registered window '{0}'";
		private static const UNREGISTERED_WINDOW:String = "Unregistered window '{0}'";
		private static const FLEX_STAGE_PROCESSOR_REGISTRY_INITIALIZED:String = "FlexStageProcessorRegistry was initialized";
		private static const CANNOT_INSTANTIATE_DIRECTLY:String = "Cannot instantiate FlexStageProcessorRegistry directly, invoke getInstance() instead";

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var LOGGER:ILogger = LoggerFactory.getClassLogger(FlexStageProcessorRegistry);

		private static var _instance:FlexStageProcessorRegistry;

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns a singleton instance for the current <code>FlexStageProcessorRegistry</code>. Use this method to receive
		 * an instance of <code>FlexStageProcessorRegistry</code> instead of calling the constructor directly.
		 */
		public static function getInstance():FlexStageProcessorRegistry {
			if (!_instance) {
				_instance = new FlexStageProcessorRegistry(_singletonToken);
			}
			return _instance;
		}

		// --------------------------------------------------------------------
		//
		// Public Variables
		//
		// --------------------------------------------------------------------

		/**
		 * Determines how the <code>FlexStageProcessorRegistry</code> handles Modules that are added to the stage.
		 */
		public var modulePolicy:ModulePolicy = ModulePolicy.AUTOWIRE;

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		/**
		 * The <code>ISystemManager</code> instance that is used to listen for the <code>Event.ADDED</code> event.
		 */
		private var _systemManager:ISystemManager;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>FlexStageProcessorRegistry</code>. Do not call this constructor directly, invoke <code>getInstance()</code> instead.
		 * @param singletonToken
		 */
		public function FlexStageProcessorRegistry(singletonToken:Object) {
			initFlexStageProcessorRegistry(singletonToken);
		}

		protected function initFlexStageProcessorRegistry(singletonToken:Object):void {
			if ((singletonToken !== _singletonToken) || (_instance)) {
				throw new IllegalOperationError(CANNOT_INSTANTIATE_DIRECTLY);
			}
			init();
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// stage
		// ----------------------------

		override public function get stage():Stage {
			return _systemManager.stage;
		}

		override public function set stage(value:Stage):void {
			//Unused, internally _systemManager.stage is used
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function clear():void {
			super.clear();
			removeEventListeners(_systemManager as DisplayObject);
		}

		/**
		 * @inheritDoc
		 */
		override public function registerContext(parentDocument:Object, applicationContext:IApplicationContext):void {
			if (parentDocument is Module) {
				registerContextForModule(Module(parentDocument), applicationContext);
			} else {
				super.registerContext(parentDocument, applicationContext);
			}
		}

		private function registerContextForModule(module:Module, applicationContext:IApplicationContext):void {
			contexts[module] = applicationContext;
			unregisterContextForApplication(ApplicationUtils.application, applicationContext);
			LOGGER.debug(REGISTERED_CONTEXT_WITH_MODULE, applicationContext, module);
		}

		/**
		 * @inheritDoc
		 */
		override public function unregisterContext(parentDocument:Object, applicationContext:IApplicationContext):void {
			unregisterStageProcessors(parentDocument);
			if (parentDocument is Module) {
				unregisterContextForModule(Module(parentDocument), applicationContext);
			} else {
				unregisterContextForApplication(parentDocument, applicationContext);
			}
		}

		private function unregisterContextForModule(module:Module, applicationContext:IApplicationContext):void {
			var context:IApplicationContext = contexts[module] as IApplicationContext;
			if (applicationContext == context) {
				delete contexts[module];
				LOGGER.debug(UNREGISTERED_CONTEXT_WITH_MODULE, applicationContext, module);
			} else {
				LOGGER.debug(UNABLE_TO_UNREGISTER_MODULE_CONTEXT, applicationContext, module);
			}
		}

		public function registerWindow(window:IEventDispatcher):void {
			if (window) {
				window.addEventListener(Event.ADDED_TO_STAGE, window_addedToStageHandler, true);
				//window.addEventListener(Event.ADDED, window_addedHandler);
				LOGGER.info(REGISTERED_WINDOW, window);
			}
		}

		public function unregisterWindow(window:IEventDispatcher):void {
			if (window) {
				window.removeEventListener(Event.ADDED_TO_STAGE, window_addedToStageHandler, true);
				//window.removeEventListener(Event.ADDED, window_addedHandler);
				LOGGER.info(UNREGISTERED_WINDOW, window);
			}
		}

		private function window_addedToStageHandler(event:Event):void {
			//logger.debug("Window added_to_stage handler");
			processDisplayObject(event.target as UIComponent);
		}

		private function window_addedHandler(event:Event):void {
			//logger.debug("Window added handler");
			processDisplayObject(event.target as UIComponent);
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize():void {
			if (!initialized) {
				setInitialized();
				_systemManager = ApplicationUtils.application.systemManager;
				processStage();
				addEventListeners(_systemManager as DisplayObject);
				LOGGER.debug(FLEX_STAGE_PROCESSOR_REGISTRY_INITIALIZED);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function processStage(startComponent:DisplayObject = null):void {
			if (!startComponent) {
				startComponent = DisplayObject(_systemManager);
			}

			LOGGER.debug(STAGE_PROCESSING_STARTED, startComponent);
			processDisplayObjectRecursively(startComponent);
			LOGGER.debug(STAGE_PROCESSING_COMPLETED);
		}

		/**
		 * First searches for all the <code>IStageProcessors</code> with a document property that match the specified <code>stageComponent.parentDocument</code> property
		 * and lets these <code>IStageProcessors</code> process the <code>stageComponent</code>. If no matching <code>IStageProcessors</code> are found a list of
		 * <code>IStageProcessors</code> is retrieved that have a <code>document</code> property whose value matches the current <code>Application</code>.
		 * @param displayObject The <code>UIComponent</code> instance that needs to be processed.
		 * @param stageProcessorRegistration The <code>StageProcessorRegistration</code> instance that is searched for appropriate <code>IStageProcessor</code> instances.
		 */
		override protected function processDisplayObjectWithStageProcessorRegistration(displayObject:DisplayObject, stageProcessorRegistration:StageProcessorRegistration):void {
			if (!displayObject) {
				return;
			}

			var parentComponent:Object = getRoot(displayObject as UIComponent);

			if (parentComponent is Module) {
				if (modulePolicy == ModulePolicy.IGNORE) {
					LOGGER.debug("Component of module will not be processed because the modulePolicy is set to ModulePolicy.IGNORE");
				}
			}

			if (!parentComponent) {
				LOGGER.debug("Could not process '{0}' since root is null", displayObject);
				return;
			}

			var processors:Array = stageProcessorRegistration.getProcessorsByDocument(parentComponent);

			if ((!processors) && (modulePolicy == ModulePolicy.AUTOWIRE)) {
				LOGGER.debug("FlexStageProcessorRegistry didn't find appropriate stage processors for document '{0}', retrieving application processors instead", displayObject);
				processors = stageProcessorRegistration.getProcessorsByDocument(ApplicationUtils.application);
			}

			if (processors) {
				for each (var stageProcessor:IStageProcessor in processors) {
					stageProcessor.process(displayObject);
				}
			}
		}

		/**
		 * Retrieves the root component of the given UIComponent. The root will either be the Application, Module or (native) Window
		 * the component lives in.
		 */
		protected function getRoot(component:UIComponent):Object {
			if (!component) {
				return null;
			}

			if ((component == ApplicationUtils.application) || (component is Module) || isMXWindow(component) || isSparkWindow(component)) {
				return component;
			}

			return getRoot(component.parentDocument as UIComponent);
		}

		/**
		 * Returns whether or not the given component is a mx.core.Window instance.
		 * @return true if the given component is a mx window; false if not
		 */
		private function isMXWindow(component:UIComponent):Boolean {
			return (getQualifiedSuperclassName(component) == MX_WINDOW_CLASS);
		}

		/**
		 * Returns whether or not the given component is a mx.core.Window instance.
		 * @return true if the given component is a spark window; false if not
		 */
		private function isSparkWindow(component:UIComponent):Boolean {
			return (getQualifiedSuperclassName(component) == SPARK_WINDOW_CLASS);
		}

	}
}
