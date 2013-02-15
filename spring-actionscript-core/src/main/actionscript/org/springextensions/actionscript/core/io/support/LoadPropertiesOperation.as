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
package org.springextensions.actionscript.core.io.support {

	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.collections.*;
	import org.springextensions.actionscript.core.operation.AbstractOperation;

	/**
	 * Operation that loads a <code>Properties</code> object.
	 * @author Christophe Herreman
	 * @see org.springextensions.actionscript.collections.Properties Properties
	 * @docref the_operation_api.html#operations
	 */
	public class LoadPropertiesOperation extends AbstractOperation {

		private static const logger:ILogger = getLogger(LoadPropertiesOperation);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new LoadPropertiesOperation and immediately loads the properties.
		 *
		 * @param location the location of the external *.properties file
		 */
		public function LoadPropertiesOperation(location:String, preventCache:Boolean = true) {
			super();
			init(location, preventCache);
		}

		/**
		 * Creates a new <code>Properties</code> instance, adds the appropriate event handlers
		 * and starts the loading process.
		 * @param location the location of the external *.properties file
		 */
		protected function init(location:String, preventCache:Boolean):void {
			Assert.hasText(location, "location argument must not be null or empty");
			var properties:Properties = new Properties();

			_location = location;

			properties.addEventListener(Event.COMPLETE, properties_completeHandler);
			properties.addEventListener(IOErrorEvent.IO_ERROR, properties_ioErrorHandler);

			logger.debug("Loading properties from '{0}'", [location]);
			properties.load(location, null, preventCache);
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		private var _location:String;

		/**
		 * Returns the location/url of the external properties file.
		 *
		 * @return the location/url of the external properties file
		 */
		public function get location():String {
			return _location;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function disconnectListeners(properties:Properties):void {
			properties.removeEventListener(Event.COMPLETE, properties_completeHandler);
			properties.removeEventListener(IOErrorEvent.IO_ERROR, properties_ioErrorHandler);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function properties_completeHandler(event:Event):void {
			logger.debug("Loaded properties from '{0}'", [_location]);
			result = Properties(event.target);
			disconnectListeners(result);
			dispatchCompleteEvent();
		}

		private function properties_ioErrorHandler(event:IOErrorEvent):void {
			logger.warn("Could not load properties from '{0}'", [_location]);
			error = event.text;
			disconnectListeners(event.target as Properties);
			dispatchErrorEvent();
		}

	}
}
