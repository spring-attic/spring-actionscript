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
package org.springextensions.actionscript.utils {
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	
	import org.as3commons.lang.Assert;
	
	/**
	 * Contains utilities for working with ArrayCollection objects.
	 *
	 * @author Christophe Herreman
	 */
	public final class ArrayCollectionUtils {
		
		/**
		 * Creates an ArrayCollection from the items in the given view.
		 *
		 * @param view the ICollectionView instance from which an arraycollection will be created
		 * @return an ArrayCollection with the items from the view
		 */
		public static function createFromCollectionView(view:ICollectionView):ArrayCollection {
			Assert.notNull(view, "Cannot create ArrayCollection if view is null");
			var result:ArrayCollection = new ArrayCollection();
			
			for (var cursor:IViewCursor = view.createCursor(); !cursor.afterLast; cursor.moveNext()) {
				result.addItem(cursor.current);
			}
			return result;
		}
		
		/**
		 * Creates an ArrayCollection from the items in the given list.
		 *
		 * @param list the IList instance from which an arraycollection will be created
		 * @return an ArrayCollection with the items from the list
		 */
		public static function createFromList(list:IList):ArrayCollection {
			Assert.notNull(list, "Cannot create ArrayCollection if list is null");
			return (new ArrayCollection(list.toArray()));
		}
		
		/**
		 * Removes all items from the collection that are of the given type. Subtypes will also be removed.
		 *
		 * @param collection the collection from which to remove the items
		 * @param type the class or interface of which the items will be removed
		 */
		public static function removeItemsOfType(collection:ArrayCollection, type:Class):void {
			for each (var item:*in collection) {
				if (item is type) {
					var index:int = collection.getItemIndex(item);
					collection.removeItemAt(index);
				}
			}
		}
		
		/**
		 * Returns an array collection with all items from the given collection that have property
		 * specified by the name parameter for which its value equals the given value.
		 */
		public static function getItemsWithProperty(collection:ArrayCollection, name:String, value:*):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection();
			
			for each (var item:*in collection) {
				if ((name in item) && (item[name] == value)) {
					result.addItem(item);
				}
			}
			
			return result;
		}
	}
}