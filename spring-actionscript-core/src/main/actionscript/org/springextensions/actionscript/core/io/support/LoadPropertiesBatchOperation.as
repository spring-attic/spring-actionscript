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
package org.springextensions.actionscript.core.io.support {

	import flash.errors.IOError;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.collections.*;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.OperationQueue;
	import org.springextensions.actionscript.core.operation.OperationEvent;

	/**
	 * Operation that loads multiple external properties files in a batch.
	 *
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#operations
	 */
	public class LoadPropertiesBatchOperation extends OperationQueue {

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(LoadPropertiesBatchOperation);

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _properties:Properties;
		private var _ignoreResourceNotFound:Boolean;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>LoadPropertiesBatchOperation</code> object.
		 *
		 * @param locations the locations of the external properties files
		 * @param ignoreResourceNotFound whether or not a failure to load a file should result in a runtime error
		 */
		public function LoadPropertiesBatchOperation(locations:Array, ignoreResourceNotFound:Boolean = false, preventCache:Boolean = true) {
			Assert.notNull(locations, "The locations argument must not be null");
			super();
			init(locations, ignoreResourceNotFound, preventCache);
		}
		
		/**
		 * Creates a new <code>Properties</code> instance and uses this to load the <code>Array</code> of locations.
		 * @param locations the locations of the external properties files
		 * @param ignoreResourceNotFound whether or not a failure to load a file should result in a runtime error
		 */
		protected function init(locations:Array, ignoreResourceNotFound:Boolean, preventCache:Boolean):void {
			_properties = new Properties();
			_ignoreResourceNotFound = ignoreResourceNotFound;

			result = _properties;
			
			for each (var location:String in locations) {
				var operation:IOperation = new LoadPropertiesOperation(location, preventCache);
				operation.addCompleteListener(properties_completeHandler);
				operation.addErrorListener(properties_errorHandler);
				addOperation(operation);
			}
		}
		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function properties_completeHandler(event:OperationEvent):void {
			_properties.merge(event.operation.result);
		}

		private function properties_errorHandler(event:OperationEvent):void {
			var loadOperation:LoadPropertiesOperation = LoadPropertiesOperation(event.operation);
			if (_ignoreResourceNotFound) {
				LOGGER.warn("Could not load properties from location '{0}'. Original error: '{1}'", loadOperation.location, event.operation.error);
			} else {
				throw new IOError("Could not load properties from location '" + loadOperation.location + "'. Original error: '" + event.operation.error + "'");
			}
		}
	}
}