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
package org.springextensions.actionscript.core.event {

	import flash.events.Event;
	import flash.utils.Dictionary;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * The <code>EventBus</code> is used as a publish/subscribe event mechanism that lets objects communicate
	 * with eachother in a loosely coupled way.
	 *
	 * <p>Objects interested in receiving events can either implement the <code>IEventBusListener</code> interface
	 * and add themselves as listeners for all events on the event bus via the <code>EventBus.addListener()</code> method,
	 * if they are only interested in some events, they can add a specific event handler via the
	 * <code>EventBus.addEventListener()</code> method. The last option is too subscribe to events of a specific Class, use the</p>
	 * <code>EventBus.addEventClassListener()</code> for this purpose.
	 * <p>To dispatch an event, invoke the <code>EventBus.dispatchEvent()</code> or <code>EventBus.dispatch()</code> method.</p>
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @docref the_eventbus.html#the_eventbus_introduction
	 */
	public final class EventBus {

		private static var LOGGER:ILogger = LoggerFactory.getClassLogger(EventBus);

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		/** The <code>Dictionary&lt;Class,Function[]&gt;</code> that holds a mapping between event classes and a list of listener functions */
		protected static var _classListeners:Dictionary = new Dictionary();

		/** The <code>Dictionary&lt;Class,MethodInvoker[]&gt;</code> that holds a mapping between event classes and a list of listener proxies */
		protected static var _classProxyListeners:Dictionary = new Dictionary();

		/** The IEventBusListener objects that listen to all events on the event bus. */
		protected static var _listeners:ListenerCollection = new ListenerCollection();

		/** A map of event types/names with there corresponding handler functions. */
		protected static var _eventListeners:Object /* <String, ListenerCollection> */ = {};

		/** A map of event types/names with there corresponding proxied handler functions. */
		protected static var _eventListenerProxies:Object /* <String, ListenerCollection> */ = {};

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds the given listener object as a listener to all events send via the event bus.
		 */
		public static function addListener(listener:IEventBusListener, useWeakReference:Boolean = false):void {
			if (!listener || (_listeners.indexOf(listener) > -1)) {
				return;
			}
			_listeners.add(listener, useWeakReference);
			LOGGER.debug("Added IEventBusListener " + listener);
		}

		/**
		 * Removes the given listener from the event bus.
		 * @param listener
		 */
		public static function removeListener(listener:IEventBusListener):void {
			_listeners.remove(listener);
			LOGGER.debug("Removed IEventBusListener " + listener);
		}

		/**
		 * Adds the given listener function as an event handler to the given event type.
		 * @param type the type of event to listen to
		 * @param listener the event handler function
		 */
		public static function addEventListener(type:String, listener:Function, useWeakReference:Boolean = false):void {
			var eventListeners:ListenerCollection = getEventListenersForEventType(type);
			if (eventListeners.indexOf(listener) == -1) {
				eventListeners.add(listener, useWeakReference);
				LOGGER.debug("Added eventbus listener " + listener + " for type " + type);
			}
		}

		/**
		 * Removes the given listener function as an event handler from the given event type.
		 * @param type
		 * @param listener
		 */
		public static function removeEventListener(type:String, listener:Function):void {
			var eventListeners:ListenerCollection = getEventListenersForEventType(type);
			eventListeners.remove(listener);
			LOGGER.debug("Removed eventbus listener " + listener + " for type " + type);
		}

		/**
		 * Adds a proxied event handler as a listener to the specified event type.
		 * @param type the type of event to listen to
		 * @param proxy a proxy method invoker for the event handler
		 */
		public static function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean = false):void {
			var eventListenerProxies:ListenerCollection = getEventListenerProxiesForEventType(type);
			if (eventListenerProxies.indexOf(proxy) == -1) {
				eventListenerProxies.add(proxy, useWeakReference);
				LOGGER.debug("Added eventbus listenerproxy " + proxy + " for type " + type);
			}
		}

		/**
		 * Removes a proxied event handler as a listener from the specified event type.
		 */
		public static function removeEventListenerProxy(type:String, proxy:MethodInvoker):void {
			var eventListenerProxies:ListenerCollection = getEventListenerProxiesForEventType(type);
			eventListenerProxies.remove(proxy);
			LOGGER.debug("Removed eventbus listenerproxy " + proxy + " for type " + type);
		}

		/**
		 * Adds a listener function for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		public static function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false):void {
			var listeners:ListenerCollection = (_classListeners[eventClass] == null) ? new ListenerCollection() : _classListeners[eventClass] as ListenerCollection;
			if (listeners.indexOf(listener) < 0) {
				listeners.add(listener, useWeakReference);
				_classListeners[eventClass] = listeners;
				LOGGER.debug("Added eventbus classlistener " + listener + " for class " + eventClass);
			}
		}

		/**
		 * Removes a listener function for events of a specific Class.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		public static function removeEventClassListener(eventClass:Class, listener:Function):void {
			var listeners:ListenerCollection = _classListeners[eventClass] as ListenerCollection;
			if (listeners != null) {
				listeners.remove(listener);
				if (listeners.length < 1) {
					delete _classListeners[eventClass];
				}
				LOGGER.debug("Removed eventbus classlistener " + listener + " for class " + eventClass);
			}
		}

		/**
		 * Adds a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		public static function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false):void {
			var proxies:ListenerCollection = (_classProxyListeners[eventClass] == null) ? new ListenerCollection() : _classProxyListeners[eventClass] as ListenerCollection;
			if (proxies.indexOf(proxy) < 0) {
				proxies.add(proxy, useWeakReference);
				_classProxyListeners[eventClass] = proxies;
				LOGGER.debug("Added eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * Removes a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		public static function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker):void {
			var proxies:ListenerCollection = _classProxyListeners[eventClass] as ListenerCollection;
			if (proxies != null) {
				proxies.remove(proxy);
				if (proxies.length < 1) {
					delete _classProxyListeners[eventClass];
				}
				LOGGER.debug("Removed eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * Clears the entire <code>EventBus</code> by removing all types of listeners.
		 */
		public static function removeAll():void {
			_classListeners = new Dictionary();
			_classProxyListeners = new Dictionary();
			_listeners = new ListenerCollection();
			_eventListeners = {};
			_eventListenerProxies = {};
			LOGGER.debug("Eventbus was cleared entirely");
		}

		/**
		 * Dispatches the specified <code>Event</code> on the event bus.
		 * @param event The specified <code>Event</code>.
		 */
		public static function dispatchEvent(event:Event):void {
			if (!event) {
				return;
			}
			var i:uint;

			// notify all event bus listeners
			for (i = _listeners.length; i > 0; i--) {
				var listener:IEventBusListener = _listeners.get(i-1) as IEventBusListener;
				if (listener != null) {
					listener.onEvent(event);
					LOGGER.debug("Notified eventbus listener " + listener + " of event " + event);
				}
			}

			// notify all specific event listeners
			var eventListeners:ListenerCollection = _eventListeners[event.type];
			if (eventListeners != null) {
				for (i = eventListeners.length; i > 0; i--) {
					var eventListener:Function = eventListeners.get(i-1) as Function;
					if (eventListener != null) {
						eventListener.apply(null, [event]);
						LOGGER.debug("Notified listener " + eventListener + " of event " + event);
					}
				}
			}

			// notify all proxies
			var eventListenerProxies:ListenerCollection = _eventListenerProxies[event.type];
			if (eventListenerProxies != null) {
				for (i = eventListenerProxies.length; i > 0; i--) {
					var proxy:MethodInvoker = eventListenerProxies.get(i-1) as MethodInvoker;
					if (proxy != null) {
						proxy.arguments = [event];
						proxy.invoke();
						LOGGER.debug("Notified proxy " + proxy + " of event " + event);
					}
				}
			}

			// notify listeners for a specific event Class
			var obj:Object;
			var cls:Class;
			var eventClass:Class = Object(event).constructor as Class;
			if (eventClass != null) {
				for (obj in _classListeners) {
					cls = Class(obj);
					if (eventClass === cls) {
						var funcs:ListenerCollection = _classListeners[obj];
						if (funcs != null) {
							for (i = funcs.length; i > 0; i--) {
								var func:Function = funcs.get(i-1) as Function;
								if (func != null) {
									func.apply(null, [event]);
									LOGGER.debug("Notified class listener " + func + " of event " + event);
								}
							}
						}
						break;
					}
				}
			}

			// notify proxies for a specific event Class
			for (obj in _classProxyListeners) {
				cls = Class(obj);
				if (eventClass === cls) {
					var proxies:ListenerCollection = _classProxyListeners[obj];
					if (proxies != null) {
						for (i = proxies.length; i > 0; i--) {
							proxy = proxies.get(i-1) as MethodInvoker;
							if (proxy != null) {
								proxy.arguments = [event];
								proxy.invoke();
								LOGGER.debug("Notified class listenerproxy " + proxy + " of event " + event);
							}
						}
					}
					break;
				}
			}
		}

		/**
		 * Convenience method for dispatching an event. This will create an Event instance with the given
		 * type and call dispatchEvent() on the event bus.
		 * @param type the type of the event to dispatch
		 */
		public static function dispatch(type:String):void {
			dispatchEvent(new Event(type));
		}

		// --------------------------------------------------------------------
		//
		// Private Static Methods
		//
		// --------------------------------------------------------------------

		private static function getEventListenersForEventType(eventType:String):ListenerCollection {
			if (!_eventListeners[eventType]) {
				_eventListeners[eventType] = new ListenerCollection();
			}
			return _eventListeners[eventType];
		}

		private static function getEventListenerProxiesForEventType(eventType:String):ListenerCollection {
			if (!_eventListenerProxies[eventType]) {
				_eventListenerProxies[eventType] = new ListenerCollection();
			}
			return _eventListenerProxies[eventType];
		}

	}

}