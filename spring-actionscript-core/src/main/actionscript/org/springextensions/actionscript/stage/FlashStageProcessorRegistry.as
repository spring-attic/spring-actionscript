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
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.IDisposable;

	public class FlashStageProcessorRegistry implements IStageProcessorRegistry {

		// --------------------------------------------------------------------
		//
		// Private Static Constants
		//
		// --------------------------------------------------------------------

		private static const CANNOT_INSTANTIATE_ERROR:String = "Cannot instantiate FlashStageProcessorRegistry directly, invoke getInstance() instead";
		private static const NEW_STAGE_PROCESSOR_REGISTERED:String = "New stage processor '{0}' was registered with name '{1}' and existing {2}";
		private static const NEW_STAGE_PROCESSOR_AND_SELECTOR_REGISTERED:String = "New stage processor '{0}' was registered with name '{1}' and new {2}";
		private static const STAGE_PROCESSOR_UNREGISTERED:String = "Stage processor with name '{0}' and document '{1}' was unregistered";
		private static const FLASH_STAGE_PROCESSOR_REGISTRY_INITIALIZED:String = "FlashStageProcessorRegistry was initialized";
		protected static const STAGE_PROCESSOR_REGISTRY_CLEARED:String = "StageProcessorRegistry was cleared";
		private static const REGISTERED_CONTEXT:String = "Registered context {0} with application {1}";
		protected static const STAGE_PROCESSING_STARTED:String = "Stage processing starting with component '{0}'";
		protected static const STAGE_PROCESSING_COMPLETED:String = "Stage processing completed";
		private static const UNREGISTERED_CONTEXT_WITH_APPLICATION:String = "Unregistered context {0} with application {1}";
		private static const UNABLE_TO_UNREGISTER_APPLICATION_CONTEXT:String = "Unable to unregister context {0} with application {1}";

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var LOGGER:ILogger = LoggerFactory.getClassLogger(FlashStageProcessorRegistry);

		private static var _instance:FlashStageProcessorRegistry;

		protected var contexts:Dictionary;

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns a singleton instance for the current <code>FlashStageProcessorRegistry</code>. Use this method to receive
		 * an instance of <code>FlashStageProcessorRegistry</code> instead of calling the constructor directly.
		 */
		public static function getInstance():FlashStageProcessorRegistry {
			if (!_instance) {
				_instance = new FlashStageProcessorRegistry();
			}
			return _instance;
		}

		public function FlashStageProcessorRegistry() {
			super();
			flashStageProcessorRegistryInit();
		}

		protected function flashStageProcessorRegistryInit():void {
			init();
		}

		protected function init():void {
			_enabled = false;
			_initialized = false;
			contexts = new Dictionary(true);
			stageProcessorRegistrations = [];
		}

		// --------------------------------------------------------------------
		//
		// Protected Variables
		//
		// --------------------------------------------------------------------

		/**
		 * An <code>Array</code> of <code>StageProcessorRegistrations</code> instances.
		 * @see org.springextensions.actionscript.stage.StageProcessorRegistration StageProcessorRegistration
		 */
		protected var stageProcessorRegistrations:Array;

		private var _stage:Stage;

		public function get stage():Stage {
			return _stage;
		}

		public function set stage(value:Stage):void {
			_stage = value;
		}

		private var _enabled:Boolean;

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(value:Boolean):void {
			_enabled = value;
		}

		private var _initialized:Boolean;

		public function get initialized():Boolean {
			return _initialized;
		}

		public function get numRegistrations():uint {
			return stageProcessorRegistrations.length;
		}

		public function initialize():void {
			if ((!_initialized) && (_stage != null)) {
				setInitialized();
				processStage();
				addEventListeners(_stage);
				LOGGER.debug(FLASH_STAGE_PROCESSOR_REGISTRY_INITIALIZED);
			}
		}

		protected function addEventListeners(root:DisplayObject):void {
			if (root != null) {
				root.addEventListener(Event.ADDED_TO_STAGE, added_handler, true);
				root.addEventListener(Event.REMOVED_FROM_STAGE, removed_handler, true);
			}
		}

		protected function removeEventListeners(root:DisplayObject):void {
			if (root != null) {
				root.removeEventListener(Event.ADDED_TO_STAGE, added_handler, true);
				root.removeEventListener(Event.REMOVED_FROM_STAGE, removed_handler, true);
			}
		}

		protected function setInitialized():void {
			_initialized = true;
			_enabled = true;
		}

		/**
		 * If <code>enabled</code> is <code>true</code> this event handler passes the <code>event.target</code> to the
		 * <code>processStageComponent()</code> method.
		 * @param event The <code>Event.ADDED_TO_STAGE</code> instance.
		 */
		protected function added_handler(event:Event):void {
			if (_enabled) {
				processDisplayObjectRecursively(event.target as DisplayObject);
			}
		}

		protected function removed_handler(event:Event):void {
			if (_enabled) {
				processDisplayObjectRemoval(event.target as DisplayObject);
			}
		}

		public function clear():void {
			_initialized = false;
			stageProcessorRegistrations.length = 0;
			for (var itm:* in contexts) {
				contexts[itm] = null;
				delete contexts[itm];
			}
			contexts = new Dictionary(true);
			removeEventListeners(_stage);
			LOGGER.debug(STAGE_PROCESSOR_REGISTRY_CLEARED);
		}

		public function registerStageProcessor(name:String, stageProcessor:IStageProcessor, objectSelector:IObjectSelector):void {
			var registration:StageProcessorRegistration = null;

			stageProcessorRegistrations.some(function(item:StageProcessorRegistration, index:int, arr:Array):Boolean {
				registration = (item.objectSelector === objectSelector) ? item : null;
				return (registration != null);
			});

			if (registration) {
				registration.addStageProcessor(name, stageProcessor, objectSelector);
				LOGGER.debug(NEW_STAGE_PROCESSOR_REGISTERED, stageProcessor, name, objectSelector);
			} else {
				registration = new StageProcessorRegistration(name, stageProcessor, objectSelector);
				stageProcessorRegistrations[stageProcessorRegistrations.length] = registration;
				LOGGER.debug(NEW_STAGE_PROCESSOR_AND_SELECTOR_REGISTERED, stageProcessor, name, objectSelector);
			}
		}

		public function unregisterStageProcessor(name:String, document:Object):void {
			var registration:StageProcessorRegistration = null;
			stageProcessorRegistrations.some(function(item:StageProcessorRegistration, index:int, arr:Array):Boolean {
				var procs:Array = item.getProcessorsByName(name);
				if (procs) {
					for each (var proc:IStageProcessor in procs) {
						if (proc.document === document) {
							registration = item;
							break;
						}
					}
				}
				return (registration != null);
			});

			if (registration) {
				registration.removeStageProcessorByName(name, document);
				if (registration.names.length < 1) {
					var idx:int = stageProcessorRegistrations.indexOf(registration);
					if (idx > -1) {
						stageProcessorRegistrations.splice(idx, 1);
					}
				}
				LOGGER.debug(STAGE_PROCESSOR_UNREGISTERED, name, document);
			}
		}

		public function getAllObjectSelectors():Array {
			var result:Array = [];
			for each (var registration:StageProcessorRegistration in stageProcessorRegistrations) {
				result[result.length] = registration.objectSelector;
			}
			return result;
		}

		public function getAllStageProcessors():Array {
			var result:Array = [];
			for each (var registration:StageProcessorRegistration in stageProcessorRegistrations) {
				for each (var name:String in registration.names) {
					var procs:Array = registration.processors[name] as Array;
					if (procs) {
						result = result.concat(procs);
					}
				}
			}
			return result;
		}

		public function getStageProcessorsByType(type:Class):Array {
			var result:Array;
			for each (var reg:StageProcessorRegistration in stageProcessorRegistrations) {
				var arr:Array = reg.getProcessorsByType(type);
				if (arr) {
					if (!result) {
						result = [];
					}
					result = result.concat(arr);
				}
			}
			return result;
		}

		public function getObjectSelectorForStageProcessor(stageProcessor:IStageProcessor):IObjectSelector {
			var result:IObjectSelector;
			for each (var registration:StageProcessorRegistration in stageProcessorRegistrations) {
				if (registration.containsProcessor(stageProcessor)) {
					result = registration.objectSelector;
					break;
				}
			}
			return result;
		}

		public function getAllRegistrations():Array {
			return stageProcessorRegistrations.concat();
		}

		public function registerContext(parentDocument:Object, applicationContext:IApplicationContext):void {
			registerContextForApplication(parentDocument, applicationContext);
		}

		protected function registerContextForApplication(application:Object, applicationContext:IApplicationContext):void {
			var registeredContextsForApplication:Array = getRegisteredContextsForApplication(application);
			registeredContextsForApplication.push(applicationContext);
			LOGGER.debug(REGISTERED_CONTEXT, applicationContext, application);
		}

		public function getStageProcessorsByDocument(document:Object):Array {
			var result:Array = [];
			for each (var reg:StageProcessorRegistration in stageProcessorRegistrations) {
				result = result.concat(reg.getProcessorsByDocument(document));
			}
			return result;
		}

		public function unregisterContext(parentDocument:Object, applicationContext:IApplicationContext):void {
			unregisterStageProcessors(parentDocument);
			unregisterContextForApplication(parentDocument, applicationContext);
		}

		/**
		 * @inheritDoc
		 */
		public function getStageProcessorByName(name:String):Array {
			var result:Array = null;
			for each (var reg:StageProcessorRegistration in stageProcessorRegistrations) {
				var arr:Array = reg.getProcessorsByName(name);
				if (arr) {
					if (!result) {
						result = [];
					}
					result = result.concat(arr);
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function processStage(startComponent:DisplayObject = null):void {
			if (_stage == null) {
				return;
			}
			if (!startComponent) {
				startComponent = DisplayObject(_stage.root);
			}

			LOGGER.debug(STAGE_PROCESSING_STARTED, startComponent);
			processDisplayObjectRecursively(startComponent);
			LOGGER.debug(STAGE_PROCESSING_COMPLETED);
		}

		/**
		 * Returns the registered contexts for the given application.
		 * @param application
		 * @return the registered contexts
		 */
		private function getRegisteredContextsForApplication(application:Object):Array {
			var result:Array = contexts[application] as Array;
			if (!result) {
				result = [];
				contexts[application] = result;
			}
			return result;
		}

		protected function removeStageProcesser(processor:IStageProcessor):void {
			for each (var reg:StageProcessorRegistration in stageProcessorRegistrations) {
				reg.removeStageProcessor(processor);
			}
		}

		protected function unregisterStageProcessors(parentDocument:Object):void {
			var procs:Array = getStageProcessorsByDocument(parentDocument);
			for each (var proc:IStageProcessor in procs) {
				if (proc == null) {
					continue;
				}
				removeStageProcesser(proc);
				var disp:IDisposable = proc as IDisposable;
				if ((disp != null) && (!disp.isDisposed)) {
					disp.dispose();
				}
			}
		}

		protected function unregisterContextForApplication(application:Object, applicationContext:IApplicationContext):void {
			var arr:Array = contexts[application] as Array;
			if (arr) {
				var idx:int = arr.indexOf(applicationContext);
				if (idx > -1) {
					arr.splice(idx, 1);
				}
				LOGGER.debug(UNREGISTERED_CONTEXT_WITH_APPLICATION, applicationContext, application);
			} else {
				LOGGER.debug(UNABLE_TO_UNREGISTER_APPLICATION_CONTEXT, applicationContext, application);
			}
		}

		/**
		 * First searches for all the <code>IStageProcessors</code> with a document property that match the specified <code>stageComponent.parentDocument</code> property
		 * and lets these <code>IStageProcessors</code> process the <code>stageComponent</code>. If no matching <code>IStageProcessors</code> are found a list of
		 * <code>IStageProcessors</code> is retrieved that have a <code>document</code> property whose value matches the current <code>Application</code>.
		 * @param displayObject The <code>UIComponent</code> instance that needs to be processed.
		 * @param stageProcessorRegistration The <code>StageProcessorRegistration</code> instance that is searched for appropriate <code>IStageProcessor</code> instances.
		 */
		protected function processDisplayObjectWithStageProcessorRegistration(displayObject:DisplayObject, stageProcessorRegistration:StageProcessorRegistration):void {
			if (!displayObject) {
				return;
			}

			var processors:Array = stageProcessorRegistration.getAllProcessors();

			if (processors) {
				for each (var stageProcessor:IStageProcessor in processors) {
					IStageProcessor(stageProcessor).process(displayObject);
				}
			}
		}

		protected function removeDisplayObjectWithStageProcessorRegistration(displayObject:DisplayObject, stageProcessorRegistration:StageProcessorRegistration):void {
			if (!displayObject) {
				return;
			}

			var processors:Array = stageProcessorRegistration.getAllProcessors();

			if (processors) {
				for each (var stageProcessor:IStageProcessor in processors) {
					if (stageProcessor is IStageDestroyer) {
						IStageDestroyer(stageProcessor).destroy(displayObject);
					}
				}
			}
		}

		/**
		 * Detects whether an object added to the stage is a candidate for processing through
		 * the list of <code>StageProcessorRegistration</code> instances, if any <code>IObjectSelector</code>
		 * approves of the object its associated <code>IStageProcessor</code>'s <code>process()</code> method is invoked.
		 * @param displayObject a reference to the object that was added to the stage
		 * @see org.springextensions.actionscript.stage.StageProcessorRegistration StageProcessorRegistration
		 * @see org.springextensions.actionscript.stage.IStageProcessor IStageProcessor
		 */
		protected function processDisplayObject(displayObject:DisplayObject):void {
			if (!displayObject || !_enabled) {
				return;
			}

			for each (var registration:StageProcessorRegistration in stageProcessorRegistrations) {
				if (registration.objectSelector.approve(displayObject)) {
					processDisplayObjectWithStageProcessorRegistration(displayObject, registration);
				}
			}
		}

		protected function processDisplayObjectRemoval(displayObject:DisplayObject):void {
			if (!displayObject || !_enabled) {
				return;
			}

			for each (var registration:StageProcessorRegistration in stageProcessorRegistrations) {
				if (registration.objectSelector.approve(displayObject)) {
					removeDisplayObjectWithStageProcessorRegistration(displayObject, registration);
				}
			}
		}

		/**
		 * Sends the specified <code>DisplayObject</code> instance to the <code>processStageComponent()</code> method,
		 * then loops through its children and recursively sends those to the <code>processStageComponent()</code> method.
		 * @param displayObject The specified <code>DisplayObject</code> instance
		 */
		protected function processDisplayObjectRecursively(displayObject:DisplayObject):void {
			processDisplayObject(displayObject);

			// recursively process this display object's children if it is a display object container
			if (displayObject is DisplayObjectContainer) {
				var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObject);
				var numChildren:int = displayObjectContainer.numChildren;

				for (var i:int = 0; i < numChildren; ++i) {
					var child:DisplayObject = displayObjectContainer.getChildAt(i);
					processDisplayObjectRecursively(child);
				}
			}
		}

	}
}