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
package org.springextensions.actionscript.eventbus.impl {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.IEventListenerInterceptor;
import org.as3commons.lang.DictionaryUtils;
import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.SoftReference;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.MethodInvoker;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.process.EventHandlerProxy;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultEventBusUserRegistry implements IEventBusUserRegistry, IEventBusAware, IDisposable {

		private static const LOGGER:ILogger = getClassLogger(DefaultEventBusUserRegistry);

		public function DefaultEventBusUserRegistry(eventBus:IEventBus) {
			super();
			_listenerCache = new Dictionary(true);
			_eventBusRegistryEntryCache = new Dictionary();
			_typesLookup = new Dictionary();
			_proxies = new Dictionary(true);
			_proxyLookup = new Dictionary(true);
			_eventBus = eventBus;
		}

		private var _eventBus:IEventBus;
		private var _eventBusRegistryEntryCache:Dictionary;
		private var _isDisposed:Boolean;
		private var _listenerCache:Dictionary;
		private var _proxies:Dictionary;
		private var _proxyLookup:Dictionary;
		private var _typesLookup:Dictionary;

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
			_eventBus = value;
		}

		/**
		 *
		 */
		public function get eventBusRegistryEntryCache():Dictionary {
			return _eventBusRegistryEntryCache;
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
		public function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor] ||= new EventBusRegistryEntry(interceptor);
			registryItem.classEntries[registryItem.classEntries.length] = new ClassEntry(eventClass, topic);
			_eventBus.addEventClassInterceptor(eventClass, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor] ||= new EventBusRegistryEntry(interceptor);
			registryItem.classEntries[registryItem.classEntries.length] = new ClassEntry(eventClass, topic);
			_eventBus.addEventClassListenerInterceptor(eventClass, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			if (!proxyExists(_proxyLookup, proxy)) {
				(_proxyLookup[proxy.target] ||= new Vector.<MethodInvoker>()).push(proxy);
				var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[proxy] ||= new EventBusRegistryEntry(proxy);
				registryItem.classEntries[registryItem.classEntries.length] = new ClassEntry(eventClass, topic);
				return _eventBus.addEventClassListenerProxy(eventClass, proxy, useWeakReference, topic);
			} else {
				return false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor] ||= new EventBusRegistryEntry(interceptor);
			registryItem.eventTypeEntries[registryItem.eventTypeEntries.length] = new EventTypeEntry(type, topic);
			_eventBus.addEventInterceptor(type, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor] ||= new EventBusRegistryEntry(interceptor);
			registryItem.eventTypeEntries[registryItem.eventTypeEntries.length] = new EventTypeEntry(type, topic);
			_eventBus.addEventListenerInterceptor(type, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			if (!proxyExists(_proxyLookup, proxy)) {
				(_proxyLookup[proxy.target] ||= new Vector.<MethodInvoker>()).push(proxy);
				var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[proxy] ||= new EventBusRegistryEntry(proxy);
				registryItem.eventTypeEntries[registryItem.eventTypeEntries.length] = new EventTypeEntry(type, topic);
				return _eventBus.addEventListenerProxy(type, proxy, useWeakReference, topic);
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListeners(eventDispatcher:IEventDispatcher, eventTypes:Vector.<String>, topics:Array):void {
			for each (var eventType:String in eventTypes) {
				var types:Vector.<String> = _listenerCache[eventDispatcher] ||= new Vector.<String>();
				types[types.length] = eventType;
				if ((topics != null) && (topics.length > 0)) {
					_typesLookup[eventType] ||= new Dictionary(true);
					_typesLookup[eventType][eventDispatcher] = topics;
				}
				eventDispatcher.addEventListener(eventType, rerouteToEventBus, false, 0, true);
				LOGGER.debug("added listener for event type '" + eventType + "' on " + eventDispatcher);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addInterceptor(interceptor:IEventInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor] ||= new EventBusRegistryEntry(interceptor);
			registryItem.eventTypeEntries[registryItem.eventTypeEntries.length] = new EventTypeEntry(null, topic);
			_eventBus.addInterceptor(interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor] ||= new EventBusRegistryEntry(interceptor);
			registryItem.eventTypeEntries[registryItem.eventTypeEntries.length] = new EventTypeEntry(null, topic);
			_eventBus.addListenerInterceptor(interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				_isDisposed = true;
				for (var dispatcher:* in _listenerCache) {
					if (dispatcher != null) {
						removeEventListeners(dispatcher as IEventDispatcher);
					}
					delete _listenerCache[dispatcher];
				}
				_listenerCache = null;
				for (var proxy:* in _eventBusRegistryEntryCache) {
					var entry:EventBusRegistryEntry = _eventBusRegistryEntryCache[proxy];
					var classEntry:ClassEntry;
					var eventEntry:EventTypeEntry;
					if (proxy is MethodInvoker) {
						for each (classEntry in entry.classEntries) {
							return _eventBus.removeEventClassListenerProxy(classEntry.clazz, proxy, classEntry.topic);
						}
						for each (eventEntry in entry.eventTypeEntries) {
							return _eventBus.removeEventListenerProxy(eventEntry.eventType, proxy, eventEntry.topic);
						}
					} else if (proxy is IEventInterceptor) {
						for each (classEntry in entry.classEntries) {
							return _eventBus.removeEventClassInterceptor(classEntry.clazz, proxy, classEntry.topic);
						}
						for each (eventEntry in entry.eventTypeEntries) {
							return _eventBus.removeEventInterceptor(eventEntry.eventType, proxy, eventEntry.topic);
						}
					} else if (proxy is IEventListenerInterceptor) {
						for each (classEntry in entry.classEntries) {
							return _eventBus.removeEventClassListenerInterceptor(classEntry.clazz, proxy, classEntry.topic);
						}
						for each (eventEntry in entry.eventTypeEntries) {
							return _eventBus.removeEventListenerInterceptor(eventEntry.eventType, proxy, eventEntry.topic);
						}
					}
				}
				for (var target:* in _proxyLookup) {
					var invokers:Vector.<MethodInvoker> = _proxyLookup[target];
					for each (var invoker:MethodInvoker in invokers) {
						invoker.target = null;
					}
					delete _proxyLookup[proxy.target];
				}
				_proxyLookup = null;
				_typesLookup = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor];
			if (registryItem != null) {
				var idx:int = 0;
				for each (var entry:ClassEntry in registryItem.classEntries) {
					if ((entry.clazz === eventClass) && (entry.topic == topic)) {
						registryItem.classEntries.splice(idx, 1);
						break;
					}
					idx++;
				}
			}
			_eventBus.removeEventClassInterceptor(eventClass, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor];
			if (registryItem != null) {
				var idx:int = 0;
				for each (var entry:ClassEntry in registryItem.classEntries) {
					if ((entry.clazz === eventClass) && (entry.topic === topic)) {
						registryItem.classEntries.splice(idx, 1);
					}
					idx++;
				}
			}
			_eventBus.removeEventClassListenerInterceptor(eventClass, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object=null):void {
			var proxies:Vector.<MethodInvoker> = _proxyLookup[proxy.target];
			var handlerProxy:MethodInvoker = findProxy(proxy, proxies);
			if (handlerProxy == null) {
				return;
			}
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[handlerProxy];
			var i:int = registryItem.classEntries.length - 1;
			while (i > -1) {
				var entry:ClassEntry = registryItem.classEntries[i];
				if ((eventClass === entry.clazz) && (entry.topic == topic)) {
					_eventBus.removeEventClassListenerProxy(eventClass, handlerProxy, topic);
					registryItem.classEntries.splice(i, 1);
				}
				--i;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor];
			if (registryItem != null) {
				var idx:int = 0;
				for each (var entry:EventTypeEntry in registryItem.eventTypeEntries) {
					if ((entry.eventType == type) && (entry.topic == topic)) {
						registryItem.eventTypeEntries.splice(idx, 1);
						break;
					}
					idx++;
				}
			}
			_eventBus.removeEventInterceptor(type, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor];
			if (registryItem != null) {
				var idx:int = 0;
				for each (var entry:EventTypeEntry in registryItem.eventTypeEntries) {
					if ((entry.eventType == type) && (entry.topic === topic)) {
						registryItem.eventTypeEntries.splice(idx, 1);
					}
					idx++;
				}
			}
			_eventBus.removeEventListenerInterceptor(type, interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object=null):void {
			var proxies:Vector.<MethodInvoker> = _proxyLookup[proxy.target];
			var handlerProxy:MethodInvoker = findProxy(proxy, proxies);
			if (handlerProxy == null) {
				return;
			}
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[handlerProxy];
			var i:int = registryItem.eventTypeEntries.length - 1;
			while (i > -1) {
				var entry:EventTypeEntry = registryItem.eventTypeEntries[i];
				if ((type == entry.eventType) && (entry.topic === topic)) {
					_eventBus.removeEventListenerProxy(type, handlerProxy, topic);
					registryItem.eventTypeEntries.splice(i, 1);
				}
				--i;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListeners(eventDispatcher:IEventDispatcher):void {
			var types:Vector.<String> = _listenerCache[eventDispatcher] as Vector.<String>;
			for each (var type:String in types) {
				eventDispatcher.removeEventListener(type, rerouteToEventBus);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeInterceptor(interceptor:IEventInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor];
			if (registryItem != null) {
				var idx:int = 0;
				for each (var entry:EventTypeEntry in registryItem.eventTypeEntries) {
					if ((entry.eventType == null) && (entry.topic === topic)) {
						registryItem.eventTypeEntries.splice(idx, 1);
					}
					idx++;
				}
			}
			_eventBus.removeInterceptor(interceptor, topic);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void {
			var registryItem:EventBusRegistryEntry = _eventBusRegistryEntryCache[interceptor];
			if (registryItem != null) {
				var idx:int = 0;
				for each (var entry:EventTypeEntry in registryItem.eventTypeEntries) {
					if ((entry.eventType == null) && (entry.topic === topic)) {
						registryItem.eventTypeEntries.splice(idx, 1);
					}
					idx++;
				}
			}
			_eventBus.removeListenerInterceptor(interceptor, topic);
		}

		/**
		 *
		 * @param event
		 */
		public function rerouteToEventBus(event:Event):void {
			var topics:Array;
			if ((_typesLookup[event.type] != null) && (_typesLookup[event.type][event.target] != null)) {
				topics = _typesLookup[event.type][event.target] as Array;
			}
			if (topics == null) {
				eventBus.dispatchEvent(event);
			} else {
				var toDelete:Array;
				for each (var topic:Object in topics) {
					if (topic is String) {
						eventBus.dispatchEvent(event, topic);
					} else {
						if (SoftReference(topic).value != null) {
							eventBus.dispatchEvent(event, SoftReference(topic).value);
						} else {
							toDelete ||= [];
							toDelete[toDelete.length] = topic
						}
					}
				}
				for each (var item:* in toDelete) {
					topics.splice(topics.indexOf(item), 1);
				}
			}
		}

		private function findProxy(proxy:MethodInvoker, proxies:Vector.<MethodInvoker>):MethodInvoker {
			for each (var ehp:MethodInvoker in proxies) {
				if (proxy is IEquals) {
					if (IEquals(ehp).equals(proxy)) {
						return ehp;
					}
				} else if ((ehp.target === proxy.target) && (ehp.method == proxy.method) && (ehp.namespaceURI == proxy.namespaceURI)) {
					return ehp;
				}
			}
			return null;
		}

		private function proxyExists(proxyLookup:Dictionary, proxy:MethodInvoker):Boolean {
			var invokers:Vector.<MethodInvoker> = _proxyLookup[proxy.target];
			for each (var invoker:MethodInvoker in invokers) {
				if (invoker.equals(proxy)) {
					return true;
				}
			}
			return false;
		}

		private function removeEventClassListener(eventClass:Class, handler:Function=null):void {
			for (var proxy:* in _proxies) {
				var key:* = _proxies[proxy];
				if (key is Class) {
					var cls:Class = Class(key);
					var m:MethodInvoker = MethodInvoker(proxy);
					if ((cls === eventClass) && ((handler == null) || (handler === m.target[m.method]))) {
						eventBus.removeEventClassListenerProxy(cls, m);
					}
				}
			}
		}

		private function removeEventListener(eventName:String, handler:Function=null):void {
			for (var proxy:* in _proxies) {
				var key:* = _proxies[proxy];
				if (key is String) {
					var name:String = String(key);
					var m:MethodInvoker = MethodInvoker(proxy);
					if ((name == eventName) && ((handler == null) || (handler === m.target[m.method]))) {
						eventBus.removeEventListenerProxy(name, m);
					}
				}
			}
		}

		public function clearAllProxyRegistrations(target:Object):void {
			var entry:EventBusRegistryEntry;
			var proxy:MethodInvoker;
			var matchingInvokers:Array = [];

			for (var invoker:* in _eventBusRegistryEntryCache) {
				if (invoker is MethodInvoker) {
					if (MethodInvoker(invoker).target === target) {
						entry = _eventBusRegistryEntryCache[invoker];
						proxy = invoker;

						matchingInvokers.push(invoker);

						removeEventBusRegistryEntry(entry, proxy);
					}
				}
			}

			if (matchingInvokers.length > 0) {
				DictionaryUtils.deleteKeys(_eventBusRegistryEntryCache, matchingInvokers);
			}
		}
		
		private function removeEventBusRegistryEntry(entry:EventBusRegistryEntry, proxy:MethodInvoker):void {
			var classEntry:ClassEntry;
			var eventEntry:EventTypeEntry;
			for each (classEntry in entry.classEntries) {
				return _eventBus.removeEventClassListenerProxy(classEntry.clazz, proxy, classEntry.topic);
			}
			for each (eventEntry in entry.eventTypeEntries) {
				return _eventBus.removeEventListenerProxy(eventEntry.eventType, proxy, eventEntry.topic);
			}
			proxy.target = null;
		}
	}
}
