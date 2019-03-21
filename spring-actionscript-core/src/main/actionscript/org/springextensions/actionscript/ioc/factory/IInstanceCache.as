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
package org.springextensions.actionscript.ioc.factory {
	import flash.events.IEventDispatcher;

	/**
	 * Describes an object that acts as a cache for object instances.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IInstanceCache extends IEventDispatcher {

		/**
		 * Removes all the instances from the cache.
		 */
		function clearCache():void;

		/**
		 * Returns a <code>Vector.&lt;String&gt;</code> of all the names of the cached objects in the current <code>IInstanceCache</code>.
		 */
		function getCachedNames():Vector.<String>;

		/**
		 * Returns the instance that was associated with the specified name.
		 * @param name The specified name
		 * @return The instance associated with the specified name
		 * @throws org.springextensions.actionscript.ioc.objectdefinition.error.ObjectDefinitionNotFoundError Thrown when an object with the specified name does not exist
		 */
		function getInstance(name:String):*;

		/**
		 * Returns the names of the instances that are of the specified type.
		 * @param clazz The specified type.
		 * @return The names of the instances that are of the specified type.
		 */
		function getCachedNamesForType(clazz:Class):Vector.<String>;

		/**
		 * Returns the prepared instance that was associated with the specified name.
		 * @param name The specified name
		 * @return The prepared instance associated with the specified name
		 * @throws org.springextensions.actionscript.ioc.objectdefinition.error.ObjectDefinitionNotFoundError Thrown when a prepared object with the specified name does not exist
		 */
		function getPreparedInstance(name:String):*;

		/**
		 * Returns <code>true</code> if an instance has been associated with the specified name
		 * @param name The specified name
		 * @return <code>true</code> if an instance has been associated with the specified name
		 */
		function hasInstance(name:String):Boolean;

		/**
		 *
		 * @param name
		 * @return
		 */
		function isPrepared(name:String):Boolean;

		/**
		 * Returns <code>true</code> if the object for the specified name will be disposed by the current <code>IInstanceCache</code> after clearing.
		 * @param name The name of the specified object.
		 * @return <code>True</code> if the object for the specified name will be disposed by the current <code>IInstanceCache</code> after clearing.
		 */
		function isManaged(name:String):Boolean

		/**
		 * Returns the number of instances that have been added to the cache.
		 * @return The number of instances that have been added to the cache.
		 */
		function numInstances():uint;

		/**
		 * Returns the number of instances that have been added to the cache and that will be disposed after clearing of the current <code>IInstanceCache</code>.
		 * @return The number of instances that have been added to the cache and that will be disposed after clearing of the current <code>IInstanceCache</code>.
		 */
		function numManagedInstances():uint;

		/**
		 * Pre-caches an instance, instances in the prepared cache are not ready to be used yet, but usually in the process of being configured.
		 * @param name
		 * @param instance
		 */
		function prepareInstance(name:String, instance:*):void;

		/**
		 * Adds the specified instance using the specified name.
		 * @param name The specified name.
		 * @param instance The specified instance.
		 * @param isManaged Determines whether the cache will dispose the specified instance when it gets cleared.
		 * @see #hasInstance()
		 * @see #getInstance()
		 */
		function putInstance(name:String, instance:*, isManaged:Boolean=true):void;

		/**
		 * Removes the instance that was associated with the specified name.
		 * @param name The specified name
		 */
		function removeInstance(name:String):*;
	}
}
