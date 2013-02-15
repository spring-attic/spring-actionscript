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
package org.springextensions.actionscript.collections {
	
	import mx.collections.IViewCursor;
	
	import org.as3commons.lang.IllegalArgumentError;
	import org.springextensions.actionscript.domain.Entity;
	
	/**
	 * Collection that is forced to hold instances of type <code>Entity</code>. 
	 * No duplicate id's can be added to the collection.
	 * <p>
	 * <b>Author:</b> Cardoen Lieven<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class EntityCollection extends TypedCollection {
		
		/**
		 * Creates a new <code>EntityCollection</code> instance.
		 * @param source
		 * TODO: Extra parameter with Class that should be a superclass of Entity
		 */
		public function EntityCollection(source:Array = null) {
			super(Entity, source);
		}
		
		/**
		 * Determines whether the collection contains an <code>Entity</code> instance with the specified id.
		 * @param id the specified id.
		 * @return True if the collection contains an <code>Entity</code> instance with the specified id.
		 */
		public function containsId(id:int):Boolean {
			var cursor:IViewCursor = this.createCursor();
			var entity:Entity;
			
			while (!cursor.afterLast) {
				entity = cursor.current as Entity;
				
				if (entity.id === id) {
					return true;
				}
				cursor.moveNext();
			}
			return false;
		}
		
		/**
		 * Retrieve the <code>Entity</code> instance with the specified id.
		 * @param id The id of the required <code>Entity</code> instance.
		 * @return The <code>Entity</code> instance with the specified id.
		 * @throws org.as3commons.lang.IllegalArgumentError if an <code>Entity</code> with the specified id wasn't found in the current collection.
		 */
		public function getEntityWithId(id:int):Entity {
			var cursor:IViewCursor = this.createCursor();
			var entity:Entity;
			
			while (!cursor.afterLast) {
				entity = cursor.current as Entity;
				
				if (entity.id === id) {
					return entity;
				}
				cursor.moveNext();
			}
			throw new IllegalArgumentError("Entity with id " + entity.id + " doesn't exists.");
		}
		
		/**
		 * Checks if the collection already holds an Entity instance with the same
		 * id as the passed Entity instance
		 * @throws org.as3commons.lang.IllegalArgumentError if an <code>Entity</code> with the specified id exists in the current collection.
		 * @param item the object to be checked
		 */
		override protected function check(item:Object):void {
			super.check(item);
			var entity:Entity = item as Entity;
			
			if (this.containsId(entity.id)) {
				throw new IllegalArgumentError("Entity with id " + entity.id + " already exists.");
			}
		}
		
		/**
		 * Adds a range to the current <code>EntityCollection</code>. If an entity of the range exists
		 * in the entityCollection, then it is copied to the existing entity and
		 * the pointer to the entity is changed to the entity of the entityCollection.
		 * If it doesn't exist, it is added and the pointer stays.
		 *
		 * @param range The EntityCollection to be added
		 */
		public function copyFrom(range:EntityCollection):void {
			var cursor:IViewCursor = range.createCursor();
			var tempEntity:Entity = null;
			
			while (!cursor.afterLast) {
				tempEntity = cursor.current as Entity;
				
				if (this.containsId(tempEntity.id)) {
					this.getEntityWithId(tempEntity.id).copyFrom(tempEntity);
					tempEntity = this.getEntityWithId(tempEntity.id);
				} else {
					this.addItem(tempEntity);
				}
				cursor.moveNext();
			}
		}
	}
}
