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
package org.springextensions.actionscript.ioc.factory.event {

	import flash.events.Event;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class InstanceCacheEvent extends Event {

		/**
		 *
		 */
		public static const CLEARED:String = "cacheCleared";

		/**
		 *
		 */
		public static const INSTANCE_ADDED:String = "instanceAdded";

		/**
		 *
		 */
		public static const BEFORE_INSTANCE_ADD:String = "beforeInstanceAdd";

		/**
		 *
		 */
		public static const INSTANCE_PREPARED:String = "instancePrepared";

		/**
		 *
		 */
		public static const INSTANCE_REMOVED:String = "instanceRemoved";

		/**
		 *
		 */
		public static const BEFORE_INSTANCE_REMOVE:String = "beforeInstanceRemove";

		/**
		 *
		 */
		public static const INSTANCE_UPDATED:String = "instanceUpdated";

		/**
		 *
		 */
		public static const BEFORE_INSTANCE_UPDATE:String = "beforeInstanceUpdate";

		/**
		 * Creates a new <code>InstanceCacheEvent</code> instance.
		 * @param type
		 * @param name
		 * @param instance
		 * @param bubbles
		 * @param cancelable
		 */
		public function InstanceCacheEvent(type:String, name:String=null, instance:*=null, prevInstance:*=null, bubbles:Boolean=false, cancelable:Boolean=true) {
			super(type, bubbles, cancelable);
			_cachedInstance = instance;
			_cacheName = name;
			_previousInstance = prevInstance;
		}

		private var _cacheName:String;
		private var _cachedInstance:*;
		private var _previousInstance:*;

		public function get cachedInstance():* {
			return _cachedInstance;
		}

		public function set cachedInstance(value:*):void {
			_cachedInstance = value;
		}

		public function get cacheName():String {
			return _cacheName;
		}

		public function set cacheName(value:String):void {
			_cacheName = value;
		}

		public function get previousInstance():* {
			return _previousInstance;
		}

		public function set previousInstance(value:*):void {
			_previousInstance = value;
		}

		override public function clone():Event {
			return new InstanceCacheEvent(type, _cacheName, _cachedInstance, _previousInstance, bubbles, cancelable);
		}
	}
}
