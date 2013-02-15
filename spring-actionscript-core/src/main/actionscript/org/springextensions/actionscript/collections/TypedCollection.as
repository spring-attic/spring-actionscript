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
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import org.as3commons.lang.Assert;
	
	/**
	 * Collection that is forced to hold values of a certain type.
	 *
	 * <p>
	 * <b>Authors:</b> Christophe Herreman, Bert Vandamme<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class TypedCollection extends ArrayCollection {
		
		/**
		 * Creates a new <code>TypedCollection</code> instance for the specified type.
		 * @param type the new <code>TypedCollection</code> can only hold instances of this specified type.
		 * @param source an optional list of values for the new <code>TypedCollection</code>.
		 */
		public function TypedCollection(type:Class, source:Array = null) {
			TypedCollectionInit(type, source);
		}
		
		/**
		 * Initializes the <code>TypedCollectionInit</code> instance.
		 */
		protected function TypedCollectionInit(type:Class, source:Array):void {
			Assert.notNull(type, "The type argument must not be null");
			_type = type;
			
			if (source) {
				for each(var item:Object in source){
					check(item);
				}
				this.source = source;
			}
			
			addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChange_handler);
		}
		
		private var _type:Class;
		
		
		/**
		 * Checks if the specified <code>Object</code> is of the required type and if so adds it to the collection.
		 * Otherwise a TypeError will be thrown.
		 * @param item the <code>Object</code> to be added.
		 */
		override public function addItem(item:Object):void {
			check(item);
			super.addItem(item);
		}
		
		/**
		 * Checks if the specified <code>Object</code> is of the required type and if so adds it to the collection at the spcified index.
		 * Otherwise a TypeError will be thrown.
		 * @param item the <code>Object</code> to be added.
		 * @param index the position in the list where the <code>Object</code> needs to be added.
		 */
		override public function addItemAt(item:Object, index:int):void {
			check(item);
			super.addItemAt(item, index);
		}
		
		/**
		 * Registers an ITypedCollectionListener listener
		 *
		 * @param listener the event listener
		 */
		public function addListener(listener:ITypedCollectionListener):void {
			addEventListener(TypedCollectionEvent.ADD, listener.onTypedCollectionItemAdd);
		}
		
		/**
		 * Adds a list of items to the current <code>TypedCollection</code> by calling
		 * the addItem() method for every item in the specified list.
		 */
		public function addRange(range:TypedCollection):void {
			var cursor:IViewCursor = range.createCursor();
			
			while (!cursor.afterLast) {
				this.addItem(cursor.current);
				cursor.moveNext();
			}
		}
		
		override public function createCursor():IViewCursor {
			return new TypedCollectionViewCursor(_type, super.createCursor());
		}
		
		/**
		 * Removes an item from the TypedCollection
		 *
		 * @param item the item to be removed from the TypedCollection
		 *
		 * @return a boolean indicating the succes of the operation
		 */
		public function removeItem(item:Object):Boolean {
			var result:Boolean = false;
			var itemIndex:int = getItemIndex(item);
			
			// only remove an entry that exists in the collection
			// else a RangeError will be thrown else
			if (itemIndex != -1) {
				var removedItem:Object = removeItemAt(itemIndex) as _type;
				result = (removedItem != null);
			}
			return result;
		}
		
		/**
		 * All items added to the current <code>TypedCollection</code> instance must be of this type.
		 * @return the specified type.
		 */
		public function get type():Class {
			return _type;
		}
		
		/**
		 * Checks if the passed item is of the object type of the TypedCollection
		 * @param item the object to be checked
		 * @throws TypeError if the specified <code>Object</code> is not of the required type. 
		 */
		protected function check(item:Object):void {
			if (!(item is _type)) {
				throw new TypeError("Wrong type, " + _type.toString() + " was expected");
			}
		}
		
		/**
		 * Handles the COLLECTION_CHANGE event. Dispatches a <code>TypedCollectionEvent.ADD</code> event
		 * if the specified <code>CollectionEvent</code> is a <code>CollectionEvent.ADD</code> instance.
		 */
		protected function collectionChange_handler(event:CollectionEvent):void {
			switch (event.kind) {
				case CollectionEventKind.ADD:
					for (var i:int = 0; i < event.items.length; i++) {
						var item:Object = event.items[i];
						dispatchEvent(new TypedCollectionEvent(TypedCollectionEvent.ADD, item));
					}
					break;
			}
		}
	}
}
