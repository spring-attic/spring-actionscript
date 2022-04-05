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
package org.springextensions.actionscript.ioc {
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IObjectDestroyer {
		/**
		 *
		 */
		function get metadataProcessorRegistry():IMetadataProcessorRegistry;
		/**
		 *
		 * @private
		 */
		function set metadataProcessorRegistry(value:IMetadataProcessorRegistry):void;
		/**
		 *
		 */
		function get eventBusUserRegistry():IEventBusUserRegistry;
		/**
		 *
		 * @private
		 */
		function set eventBusUserRegistry(value:IEventBusUserRegistry):void;
		/**
		 *
		 * @param instance
		 * @param objectName
		 */
		function registerInstance(instance:Object, objectName:String=null):void;
		/**
		 *
		 * @param instance
		 */
		function destroy(instance:Object):void;
	}
}
