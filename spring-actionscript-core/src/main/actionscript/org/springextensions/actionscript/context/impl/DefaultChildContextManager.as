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
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.ContextShareSettings;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IChildContextManager;
	import org.springextensions.actionscript.context.event.ChildContextEvent;
	import org.springextensions.actionscript.context.event.ContextEvent;
	import org.springextensions.actionscript.eventbus.EventBusShareKind;
	import org.springextensions.actionscript.eventbus.IEventBusShareManager;
	import org.springextensions.actionscript.eventbus.impl.DefaultEventBusShareManager;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

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
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultChildContextManager extends EventDispatcher implements IChildContextManager {

		private static const LOGGER:ILogger = getClassLogger(DefaultChildContextManager);

		private var _eventBusShareManager:IEventBusShareManager;

		/**
		 * Creates a new <code>ChildContextManager</code> instance.
		 */
		public function DefaultChildContextManager() {
			super();
		}


		public function get eventBusShareManager():IEventBusShareManager {
			return _eventBusShareManager ||= new DefaultEventBusShareManager();
		}

		public function set eventBusShareManager(value:IEventBusShareManager):void {
			_eventBusShareManager = value;
		}

		/**
		 * @inheritDoc
		 */
		public function addChildContext(parentContext:IApplicationContext, childContext:IApplicationContext, settings:ContextShareSettings=null):void {
			if ((childContext == null) || (childContext === parentContext)) {
				return;
			}
			var childContexts:Vector.<IApplicationContext> = parentContext.childContexts;
			if (childContexts.indexOf(childContext) < 0) {
				var childEvent:ChildContextEvent = new ChildContextEvent(ChildContextEvent.BEFORE_CHILD_CONTEXT_ADD, childContext, settings);
				dispatchEvent(childEvent);
				if (childEvent.isDefaultPrevented()) {
					return;
				}
				settings = childEvent.shareSettings ||= new ContextShareSettings();
				childContexts[childContexts.length] = childContext;
				if (childEvent.customAddChildFunction == null) {
					var handleContextInitialized:Function = function(event:ContextEvent):void {
						childContext.removeEventListener(ContextEvent.AFTER_INITIALIZED, handleContextInitialized);
						if ((settings.eventBusShareSettings != null) && (settings.eventBusShareSettings.shareKind != EventBusShareKind.NONE) && (parentContext is IEventBusAware)) {
							eventBusShareManager.addChildContextEventBusListener(childContext, IEventBusAware(parentContext).eventBus, settings.eventBusShareSettings);
						}
					}
					childContext.addEventListener(ContextEvent.AFTER_INITIALIZED, handleContextInitialized, false, 0, true);
					if (settings.shareDefinitions) {
						addDefinitionsToChildContext(childContext, parentContext.objectDefinitionRegistry);
					}
					if (settings.shareSingletons) {
						addSingletonsToChildContext(childContext, parentContext.cache, parentContext.objectDefinitionRegistry);
					}
					if ((settings.shareProperties) && (parentContext.propertiesProvider != null)) {
						childContext.propertiesProvider.merge(parentContext.propertiesProvider);
					}
					if (parentContext.stageProcessorRegistry != null) {
						childContext.stageProcessorRegistry = parentContext.stageProcessorRegistry;
						var contextCompleteHandler:Function = function(event:Event):void {
							childContext.removeEventListener(Event.COMPLETE, contextCompleteHandler);
							for each (var view:DisplayObject in childContext.rootViews) {
								parentContext.stageProcessorRegistry.processStage(view);
							}
						};
						childContext.addEventListener(Event.COMPLETE, contextCompleteHandler);
					}
					LOGGER.debug("Child context {0} added using these settings: {1}", [childContext, settings]);
				} else {
					childEvent.customAddChildFunction(this, childContext, settings);
					LOGGER.debug("Child context {0} added using a custom add function", [childContext]);
				}
				childEvent = new ChildContextEvent(ChildContextEvent.AFTER_CHILD_CONTEXT_ADD, childContext, settings);
				dispatchEvent(childEvent);
			}
		}

		/**
		 *
		 * @param childContext
		 * @return The current <code>IApplicationContext</code>
		 */
		public function removeChildContext(parentContext:IApplicationContext, childContext:IApplicationContext):void {
			var childEvent:ChildContextEvent = new ChildContextEvent(ChildContextEvent.BEFORE_CHILD_CONTEXT_REMOVE, childContext);
			dispatchEvent(childEvent);
			if (childEvent.isDefaultPrevented()) {
				return;
			}
			var childContexts:Vector.<IApplicationContext> = parentContext.childContexts;
			var idx:int = childContexts.indexOf(childContext);
			if (idx > -1) {
				childContexts.splice(idx, 1);
				if ((parentContext is IEventBusAware) && (IEventBusAware(parentContext).eventBus is IEventBusListener) && (childContext is IEventBusAware) && (IEventBusAware(childContext).eventBus != null)) {
					IEventBusAware(childContext).eventBus.removeListener(IEventBusAware(parentContext).eventBus as IEventBusListener);
				}
				if ((childContext is IEventBusAware) && (IEventBusAware(childContext).eventBus is IEventBusListener) && (parentContext is IEventBusAware) && (IEventBusAware(parentContext).eventBus != null)) {
					IEventBusAware(parentContext).eventBus.removeListener(IEventBusAware(childContext).eventBus as IEventBusListener);
				}
				childEvent = new ChildContextEvent(ChildContextEvent.AFTER_CHILD_CONTEXT_REMOVE, childContext);
				dispatchEvent(childEvent);
				LOGGER.debug("Removed child context {0}", [childContext]);
			}
			return;
		}

		private function addDefinitionsToChildContext(childContext:IApplicationContext, objectDefinitionRegistry:IObjectDefinitionRegistry):void {
			var definitionNames:Vector.<String> = objectDefinitionRegistry.objectDefinitionNames;
			for each (var objectName:String in definitionNames) {
				if (!childContext.objectDefinitionRegistry.containsObjectDefinition(objectName)) {
					var od:IObjectDefinition = objectDefinitionRegistry.getObjectDefinition(objectName);
					if ((od.childContextAccess === ChildContextObjectDefinitionAccess.DEFINITION) || (od.childContextAccess === ChildContextObjectDefinitionAccess.FULL)) {
						if (od is ICloneable) {
							var clone:IObjectDefinition = ICloneable(od).clone();
							childContext.objectDefinitionRegistry.registerObjectDefinition(objectName, clone);
							LOGGER.debug("Added cloned object definition {0} to child context", [clone]);
						}
					}
				}
			}
		}

		private function addSingletonsToChildContext(childContext:IApplicationContext, cache:IInstanceCache, objectDefinitionRegistry:IObjectDefinitionRegistry):void {
			var cacheNames:Vector.<String> = cache.getCachedNames();
			for each (var objectName:String in cacheNames) {
				var share:Boolean = true;
				if (objectDefinitionRegistry.containsObjectDefinition(objectName)) {
					var od:IObjectDefinition = objectDefinitionRegistry.getObjectDefinition(objectName);
					share = ((od.childContextAccess === ChildContextObjectDefinitionAccess.SINGLETON) || (od.childContextAccess === ChildContextObjectDefinitionAccess.FULL));
				}
				if ((share) && (!childContext.cache.hasInstance(objectName))) {
					childContext.cache.putInstance(objectName, cache.getInstance(objectName), false);
					LOGGER.debug("Added singleton {0} from parent context to child", [od]);
				}
			}
		}

	}
}
