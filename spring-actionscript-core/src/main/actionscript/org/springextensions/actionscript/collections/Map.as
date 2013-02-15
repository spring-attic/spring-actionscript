/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.collections {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import mx.collections.ICollectionView;
	import mx.collections.ISort;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;

	/**
	 * Dispatched when the <code>Map</code> is changed.
	 * @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
	*/
	[Event(name = "collectionChange", type = "mx.events.CollectionEvent")]
	/**
	 * Basic implementation of the IMap interface.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @inheritDoc
	 */
	public dynamic class Map extends Dictionary implements IMap, ICollectionView {

		/**
		 * Constructs a new <code>Map</code> instance.
		 */
		public function Map() {
			_eventDispatcher = new EventDispatcher(this);
		}

		private var _eventDispatcher:EventDispatcher;

		private var _filterFunction:Function;

		private var _sort:ISort;

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function clear():void {
			for (var key:* in this) {
				delete this[key];
			}
		}

		public function contains(item:Object):Boolean {
			return (get(item) != null);
		}

		public function createCursor():IViewCursor {
			return new MapViewCursor(this);
		}

		public function disableAutoUpdate():void {
		}

		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}

		public function enableAutoUpdate():void {
		}

		public function get filterFunction():Function {
			return _filterFunction;
		}

		public function set filterFunction(value:Function):void {
			_filterFunction = value;
		}

		[Bindable("collectionChange")]
		/**
		 * @inheritDoc
		 */
		public function get(key:Object):* {
			return this[key];
		}

		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}

		public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void {
		}

		public function get length():int {
			return size;
		}

		/**
		 * @inheritDoc
		 */
		public function put(key:Object, value:Object):void {
			this[key] = value;
		}

		// TODO
		public function refresh():Boolean {
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(key:Object):* {
			var result:* = get(key);
			delete this[key];
			return result;
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function get size():uint {
			var result:uint = 0;
			for (var key:* in this) {
				result++;
			}
			return result;
		}

		public function get sort():ISort {
			return _sort;
		}

		public function set sort(value:ISort):void {
			_sort = value;
		}

		/**
		 * @return String representation of the current <code>Map</code> instance.
		 */
		public function toString():String {
			var result:Array = ["[Map("];
			for (var p:String in this) {
				result.push(p + ": " + this[p] + ", ");
			}
			//result = result.substr(0, result.length-2);
			result.push(")]");
			return result.join('');
		}

		/**
		 * @inheritDoc
		 */
		public function get values():Array {
			var result:Array = new Array();
			for each (var value:* in this) {
				result.push(value);
			}
			return result;
		}

		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
		//---------------------------------------------------------------------
	}
}
