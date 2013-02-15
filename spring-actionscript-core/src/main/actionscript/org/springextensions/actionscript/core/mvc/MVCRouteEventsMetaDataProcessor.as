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
package org.springextensions.actionscript.core.mvc {
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.core.mvc.event.MVCEvent;
	import org.springextensions.actionscript.metadata.AbstractMetadataProcessor;
	import org.springextensions.actionscript.module.IOwnerModuleAware;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * <code>IMetaDataProcessor</code> implementation that examines objects (that have been annotated with
	 * the <code>[RouteMVCEvents]</code> metadata) and reroutes their specified events through the <code>EventBus</code>
	 * so they can be picked up the an <code>IController</code> instance that, in turn, can execute any associated
	 * commands.
	 * @author Roland Zwaga
	 * @sampleref cafe-townsend-mvc
	 */
	public class MVCRouteEventsMetaDataProcessor extends AbstractMetadataProcessor implements IApplicationContextAware {

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(MVCRouteEventsMetaDataProcessor);

		/** The RouteEvents metadata */
		private static const ROUTE_MVC_EVENTS_METADATA:String = "RouteMVCEvents";

		/** The Event metadata */
		protected static const EVENT_METADATA:String = "Event";

		/** The events metadata argument */
		protected static const EVENTS_KEY:String = "events";

		/** The name metadata argument */
		protected static const NAME_KEY:String = "name";

		public function MVCRouteEventsMetaDataProcessor() {
			super(true, [ROUTE_MVC_EVENTS_METADATA]);
		}

		private var _applicationContext:IApplicationContext;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function process(instance:Object, container:IMetaDataContainer, name:String, objectName:String):void {
			var type:Type = container as Type;
			if ((type != null) && (instance is IEventDispatcher)) {
				var metadata:MetaData = type.getMetaData(ROUTE_MVC_EVENTS_METADATA)[0];
				var eventTypes:Array;
				if (metadata.hasArgumentWithKey(EVENTS_KEY)) {
					eventTypes = extractEventTypeNamesFromMetaDataArgument(metadata.getArgument(EVENTS_KEY));
				} else {
					eventTypes = extractEventTypeNamesFromMetaData(type);
				}
				addEventListeners(instance as IEventDispatcher, eventTypes);
			}
		}

		protected function addEventListeners(eventDispatcher:IEventDispatcher, eventTypes:Array):void {
			for each (var eventType:String in eventTypes) {
				eventDispatcher.addEventListener(eventType, rerouteToEventBus, false, 0, true);
				LOGGER.debug("added listener for event type '" + eventType + "' on " + eventDispatcher);
			}
		}

		public function extractEventTypeNamesFromMetaDataArgument(metaDataArgument:MetaDataArgument):Array {
			return metaDataArgument.value.split(' ').join('').split(',');
		}

		private function extractEventTypeNamesFromMetaData(type:Type):Array {
			var events:Array = type.getMetaData(EVENT_METADATA);
			var result:Array = [];
			for each (var metaData:MetaData in events) {
				if (metaData.hasArgumentWithKey(NAME_KEY)) {
					var arg:MetaDataArgument = metaData.getArgument(NAME_KEY);
					if (result.indexOf(arg.value) < 0) {
						result[result.length] = arg.value;
						LOGGER.debug("Found [Event] metadata for event " + arg.value);
					}
				}
			}
			return result;
		}

		/**
		 * Wraps the specified <code>Event</code> in an <code>MVCEvent</code> instance and
		 * dispatches this through the <code>IEventBus</code>.
		 * @param event The specified <code>Event</code>
		 * @see org.springextensions.actionscript.core.event.IEventBus IEventBus
		 */
		protected function rerouteToEventBus(event:Event):void {
			var owner:Object = ApplicationUtils.application;
			if ((_applicationContext != null) && (_applicationContext as IOwnerModuleAware).ownerModule != null) {
				owner = (_applicationContext as IOwnerModuleAware).ownerModule;
			}
			EventBus.dispatchEvent(new MVCEvent(owner, event));
		}

	}
}