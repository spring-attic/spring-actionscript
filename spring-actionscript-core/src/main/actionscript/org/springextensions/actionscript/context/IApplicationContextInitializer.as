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
package org.springextensions.actionscript.context {
	import flash.events.IEventDispatcher;

	import org.springextensions.actionscript.ioc.config.ITextFilesLoader;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesParser;

	/**
	 * Describes an object that can handle the loading and initialization logic of an <code>IApplicationContext</code> implementation.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IApplicationContextInitializer extends IEventDispatcher {

		/**
		 *
		 * @param context
		 */
		function initialize(context:IApplicationContext):void;

		/**
		 * An <code>IPropertiesParser</code> instance that is used to turn textfiles into property key/value pairs.
		 */
		function get propertiesParser():IPropertiesParser;

		/**
		 * @private
		 */
		function set propertiesParser(value:IPropertiesParser):void;

		/**
		 *
		 */
		function get textFilesLoader():ITextFilesLoader;

		/**
		 * @private
		 */
		function set textFilesLoader(value:ITextFilesLoader):void;
	}
}
