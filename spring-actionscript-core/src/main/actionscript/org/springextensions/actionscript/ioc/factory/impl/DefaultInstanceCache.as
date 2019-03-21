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
package org.springextensions.actionscript.ioc.factory.impl {
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.error.CachedInstanceNotFoundError;
	import org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent;
	import org.springextensions.actionscript.ioc.objectdefinition.error.ObjectDefinitionNotFoundError;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 */
	[Event(name="instancePrepared", type="org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent")]
	/**
	 *
	 */
	[Event(name="instanceAdded", type="org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent")]
	/**
	 *
	 */
	[Event(name="instanceRemoved", type="org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent")]
	/**
	 *
	 */
	[Event(name="instanceUpdated", type="org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent")]
	/**
	 *
	 */
	[Event(name="cacheCleared", type="org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent")]
	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultInstanceCache extends EventDispatcher implements IInstanceCache, IDisposable {

		private static var logger:ILogger = getClassLogger(DefaultInstanceCache);

		/**
		 * Creates a new <code>DefaultInstanceCache</code> instance.
		 */
		public function DefaultInstanceCache() {
			super();
			initialize();
		}

		private var _cache:Object;
		private var _cachedNames:Vector.<String>;
		private var _isDisposed:Boolean;
		private var _managedNames:Vector.<String>;
		private var _preparedCache:Object;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function clearCache():void {
			clearCacheObject(_cache);
			clearCacheObject(_preparedCache);
			initialize();
			dispatchCacheEvent(InstanceCacheEvent.CLEARED);
			logger.debug("Instance {0} has been cleared", [this]);
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!isDisposed) {
				clearCacheObject(_cache);
				_cache = null;
				clearCacheObject(_preparedCache);
				_preparedCache = null;
				_cachedNames = null;
				_isDisposed = true;
				logger.debug("Instance {0} has been disposed", [this]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getCachedNames():Vector.<String> {
			return _cachedNames.concat.apply(this);
		}

		public function getCachedNamesForType(clazz:Class):Vector.<String> {
			var result:Vector.<String>;
			for each (var name:String in _cachedNames) {
				if (getInstance(name) is clazz) {
					result[(result ||= new Vector.<String>()).length] = name;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getInstance(name:String):* {
			if (hasInstance(name)) {
				return _cache[name];
			} else {
				throw new CachedInstanceNotFoundError(name);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getPreparedInstance(name:String):* {
			if (isPrepared(name)) {
				return _preparedCache[name];
			} else {
				throw new ObjectDefinitionNotFoundError(name);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hasInstance(name:String):Boolean {
			return _cache.hasOwnProperty(name);
		}

		/**
		 * @inheritDoc
		 */
		public function isManaged(name:String):Boolean {
			return (_managedNames.indexOf(name) > -1);
		}

		/**
		 * @inheritDoc
		 */
		public function isPrepared(name:String):Boolean {
			return _preparedCache.hasOwnProperty(name);
		}

		/**
		 * @inheritDoc
		 */
		public function numInstances():uint {
			return _cachedNames.length;
		}

		/**
		 * @inheritDoc
		 */
		public function numManagedInstances():uint {
			return _managedNames.length;
		}

		/**
		 * @inheritDoc
		 */
		public function prepareInstance(name:String, instance:*):void {
			_preparedCache[name] = instance;
			logger.debug("instance {0} named '{1}' added to prepared cache", [instance, name]);
			dispatchCacheEvent(InstanceCacheEvent.INSTANCE_PREPARED, name, instance);
		}

		/**
		 * @inheritDoc
		 */
		public function putInstance(name:String, instance:*, isManaged:Boolean=true):void {
			if ((instance == null) || (instance == undefined)) {
				throw new IllegalOperationError("Null or undefined values are not allowed to be added to the instance cache");
			}
			if (eventWasCancelled(InstanceCacheEvent.BEFORE_INSTANCE_ADD, name, instance)) {
				return;
			}
			var idx:int = _managedNames.indexOf(name);
			if (idx > -1) {
				_managedNames.splice(idx, 1);
			}
			if (isManaged) {
				_managedNames[_managedNames.length] = name;
			}
			if (!hasInstance(name)) {
				logger.debug("Adding instance {0} named '{1}'", [instance, name]);
				_cachedNames[_cachedNames.length] = name;
			}
			if (_cache[name] == null) {
				_cache[name] = instance;
				removePreparedInstance(name);
				dispatchCacheEvent(InstanceCacheEvent.INSTANCE_ADDED, name, instance);
			} else {
				var prevInstance:* = _cache[name];
				if (!eventWasCancelled(InstanceCacheEvent.BEFORE_INSTANCE_UPDATE, name, instance, prevInstance)) {
					logger.debug("Replacing instance {0} named '{1}' with new instance {1}", [prevInstance, name, instance]);
					_cache[name] = instance;
					dispatchCacheEvent(InstanceCacheEvent.INSTANCE_UPDATED, name, instance, prevInstance);
				} else {
					logger.debug("Replacement of instance {0} named '{1}' with instance {2} was cancelled", [prevInstance, name, instance]);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeInstance(name:String):* {
			if (hasInstance(name)) {
				if (eventWasCancelled(InstanceCacheEvent.BEFORE_INSTANCE_REMOVE, name, instance)) {
					return;
				}
				var instance:* = _cache[name];
				delete _cache[name];
				var idx:int = _managedNames.indexOf(name);
				if (idx > -1) {
					_managedNames.splice(idx, 1);
				}
				idx = _cachedNames.indexOf(name);
				if (idx > -1) {
					_cachedNames.splice(idx, 1);
					dispatchCacheEvent(InstanceCacheEvent.INSTANCE_REMOVED, name, instance);
					logger.debug("Removed instance {0} named '{1}'", [instance, name]);
				}
				return instance;
			}
			return null;
		}

		private function clearCacheObject(cacheObject:Object):void {
			for (var name:String in cacheObject) {
				if (isManaged(name)) {
					ContextUtils.disposeInstance(cacheObject[name]);
				}
			}
			cacheObject = {};
		}

		private function dispatchCacheEvent(type:String, name:String=null, instance:*=null, previousInstance:*=null):InstanceCacheEvent {
			if (hasEventListener(type)) {
				var event:InstanceCacheEvent = new InstanceCacheEvent(type, name, instance, previousInstance);
				dispatchEvent(event);
				return event;
			}
			return null;
		}

		private function eventWasCancelled(eventType:String, name:String, instance:*, prevInstance:*=null):Boolean {
			var event:InstanceCacheEvent = dispatchCacheEvent(eventType, name, instance, prevInstance);
			if ((event != null) && (event.isDefaultPrevented())) {
				return true;
			}
			return false;
		}

		private function initialize():void {
			_preparedCache = {};
			_cache = {};
			_cachedNames = new Vector.<String>();
			_managedNames = new Vector.<String>();
		}

		private function removePreparedInstance(name:String):void {
			if (isPrepared(name)) {
				delete _preparedCache[name];
			}
		}
	}
}
