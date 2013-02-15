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
package org.springextensions.actionscript.ioc.factory.config {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.ioc.IDisposable;
	import org.springextensions.actionscript.metadata.AbstractMetadataProcessor;

	/**
	 * <code>IMetadataProcessor</code> implementation that can re-route events from arbitrary objects through
	 * the <code>EventBus.dispatchEvent()</code> method.
	 * <p>To re-route all events that are dispatched by an object add this metadata to a class:<br/>
	 * <pre>
	 * [RouteEvents]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {
	 * //implementation omitted...
	 * }
	 * </pre>
	 * If only certain events need to be re-routed, then add them to the events argument of the [RouteEvents] key:<br/>
	 * <pre>
	 * [RouteEvents(events="eventName1,eventName2")]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {<br/>
	 * //implementation omitted...
	 * }
	 * </pre>
	 * </p>
	 * <p>Finally, to use the <code>RouteEventsMetaDataProcessor</code> in an application, add an object definition
	 * to the XML configuration like this:
	 * <pre>
	 * &lt;object id="routeEventsProcessor" class="org.springextensions.actionscript.ioc.factory.config.RouteEventsMetaDataPostProcessor"/&gt;
	 * </pre>
	 * </p>
	 * <p>This way the processor will be automatically registered with the application context.</p>
	 * @see org.springextensions.actionscript.core.event.EventBus EventBus
	 * @author Roland Zwaga
	 * @docref the_eventbus.html#routing_other_events_through_the_eventbus
	 */
	public class RouteEventsMetaDataProcessor extends AbstractMetadataProcessor implements IDisposable {

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(RouteEventsMetaDataProcessor);

		/** The RouteEvents metadata */
		private static const ROUTE_EVENTS_METADATA:String = "RouteEvents";

		/** The Event metadata */
		protected static const EVENT_METADATA:String = "Event";

		/** The events metadata argument */
		protected static const EVENTS_KEY:String = "events";

		/** The name metadata argument */
		protected static const NAME_KEY:String = "name";

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _listenerCache:Dictionary;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>RouteEventsMetaDataPostProcessor</code> instance.
		 */
		public function RouteEventsMetaDataProcessor() {
			super(true, [ROUTE_EVENTS_METADATA]);
			_listenerCache = new Dictionary(true);
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		private var _isDisposed:Boolean = false;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function process(instance:Object, container:IMetaDataContainer, name:String, objectName:String):void {
			var type:Type = container as Type;
			if ((type != null) && (instance is IEventDispatcher)) {
				var metadata:MetaData = type.getMetaData(ROUTE_EVENTS_METADATA)[0];
				var eventTypes:Array;
				if (metadata.hasArgumentWithKey(EVENTS_KEY)) {
					eventTypes = extractEventTypeNamesFromMetaDataArgument(metadata.getArgument(EVENTS_KEY));
				} else {
					eventTypes = extractEventTypeNamesFromMetaData(type);
				}
				addEventListeners(IEventDispatcher(instance), eventTypes);
			}
		}

		/**
		 * Loops through the internal cache of eventDispatchers, removes all added eventlisteners,
		 * clears the cache and nulls it.
		 */
		public function dispose():void {
			if (!_isDisposed) {
				for each (var dispatcher:* in _listenerCache) {
					if (dispatcher != null) {
						removeListeners(dispatcher as IEventDispatcher);
					}
					delete _listenerCache[dispatcher];
				}
				_listenerCache = null;
				_isDisposed = true;
			}
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function addEventListeners(eventDispatcher:IEventDispatcher, eventTypes:Array):void {
			for each (var eventType:String in eventTypes) {
				eventDispatcher.addEventListener(eventType, rerouteToEventBus, false, 0, true);
				var types:Array = _listenerCache[eventDispatcher] as Array;
				if (types == null) {
					types = [];
					_listenerCache[eventDispatcher] = types;
				}
				types[types.length] = eventType;
				LOGGER.debug("added listener for event type '" + eventType + "' on " + eventDispatcher);
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function extractEventTypeNamesFromMetaDataArgument(metaDataArgument:MetaDataArgument):Array {
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

		protected function rerouteToEventBus(event:Event):void {
			EventBus.dispatchEvent(event);
		}

		/**
		 * Removes all the event listeners that were added to the specified <code>IEventDispatcher</code>.
		 */
		protected function removeListeners(eventDispatcher:IEventDispatcher):void {
			var types:Array = _listenerCache[eventDispatcher] as Array;
			if (types != null) {
				for each (var type:String in types) {
					eventDispatcher.removeEventListener(type, rerouteToEventBus);
				}
			}
		}

	}
}