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
package org.springextensions.actionscript.domain.util {

	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;

	import org.springextensions.actionscript.domain.IEntity;
	
	/**
	 * Provides utilities for working with <code>IEntity</code> implementations and collections holding <code>IEntity</code> implementations.
	 * @author Christophe Herreman
	 */
	public final class EntityUtil {
	
		/**
		 * 
		 */
		public static function containsEntityWithID(entities:Array, id:Object):Boolean {
			var result:Boolean = false;
			var numEntities:int = entities.length;
		
			for (var i:int = 0; i<numEntities; i++) {
				if (entities[i] is IEntity) {
					if (entities[i].id == id) {
						result = true;
						break;
					}
				}
			}
		
			return result;
		}
		
		/**
		 * 
		 */
		public static function getEntitiesByID(entities:Array, id:Object):Array {
			var result:Array = [];
			var numEntities:int = entities.length;
		
			for (var i:int = 0; i<numEntities; i++) {
				if (entities[i] is IEntity) {
					if (entities[i].id == id) {
						result.push(entities[i]);
					}
				}
			}
		
			return result;
		}
		
		/**
		 * Returns the first entity in the given array that has the given id.
		 * If none was found, null is returned.
		 */
		public static function getEntityByID(entities:Array, id:Object):* {
			var numEntities:int = entities.length;
		
			for (var i:int = 0; i<numEntities; i++) {
				if (entities[i] is IEntity) {
					if (entities[i].id == id) {
						return entities[i];
					}
				}
			}
		
			return null;
		}
		
		/**
		 * 
		 */
		public static function getEntityByProperty(entities:Array, propertyName:String, propertyValue:Object):* {
			var numEntities:int = entities.length;
		
			for (var i:int = 0; i<numEntities; i++) {
				if (entities[i] is IEntity) {
					if (entities[i][propertyName] == propertyValue) {
						return entities[i];
					}
				}
			}
		
			return null;
		}
		
		/**
		 * Returns the first entity in the given array that has the given type and id.
		 * If none was found, null is returned.
		 */
		public static function getEntityByTypeAndID(entities:Array, type:Class, id:Object):IEntity {
			var numEntities:int = entities.length;
		
			for (var i:int = 0; i<numEntities; i++) {
				if (entities[i] is type) {
					if (entities[i] is IEntity) {
						if (entities[i].id == id) {
							return entities[i];
						}
					}
				}
			}
		
			return null;
		}
		
		/**
		 * Returns the index of an entity in the given array based on its id.
		 * If no entity was found, -1 is returned.
		 * 
		 * @param entities the array of IEntity instances
		 * @param id the id of the entity
		 * @return the index of the entity in the array or -1 if it was not found
		 */
		public static function getEntityIndexByID(entities:Array, id:Object):int {
			if (entities == null) {
				return -1;
			}
			
			var result:int = -1;
			
			for (var i:int = 0; i<entities.length; i++) {
				if (entities[i] is IEntity) {
					if (entities[i].id == id) {
						result = i;
						break;
					}
				}
				
			}
			
			return result;
		}
		
		/**
		 * 
		 */
		public static function removeEntityByID(entities:ICollectionView, id:*):IEntity {
			for (var cursor:IViewCursor = entities.createCursor(); !cursor.afterLast; cursor.moveNext()) {
				var entity:IEntity = IEntity(cursor.current);
				if (entity.id == id) {
					return IEntity(cursor.remove());
				}
			}
			return null;
		}
		
		/**
		 * 
		 */
		public static function containsEntityWithSamePropertyValue(entities:ArrayCollection, entity:Object, prop:String):Boolean {
			var result:Boolean = false;
			var numEntities:int = entities.length;
	
			for (var i:int = 0; i<numEntities; i++) {
				if (entities[i] is IEntity) {
					if (entities[i][prop] == entity[prop] && entities[i] != entity) {
						result = true;
						break;
					}
				}
			}
			return result;
		}
		
		/**
		 * Returns all ids of the given entities.
		 * 
		 * @return an array containing all ids of the given entities
		 */
		public static function getIDs(entities:Array):Array {
			var result:Array = [];
			
			for each (var entity:IEntity in entities) {
				result.push(entity.id);
			}
			
			return result;
		}
		
		/**
		 * Returns an array of unique entities based on their id.
		 */
		public static function getUniqueEntitiesUsingID(entities:Array):Array {
			var result:Array = [];
			var usedIDs:Array = [];
			
			for each (var entity:IEntity in entities) {
				if (usedIDs.indexOf(entity.id) > -1) {
					usedIDs.push(entity.id);
					result.push(entity);
				}
			}
			
			return result;
		}
	}
}