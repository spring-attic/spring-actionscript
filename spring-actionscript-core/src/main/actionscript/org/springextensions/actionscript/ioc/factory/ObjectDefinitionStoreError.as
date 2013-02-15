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
package org.springextensions.actionscript.ioc.factory {
	
	/**
	 * Error thrown when an object factory encounters an invalid object definition.
	 *
	 * @author Christophe Herreman
	 */
	public class ObjectDefinitionStoreError extends Error {
		
		private var _objectName:String;
		
		/**
		 * Creates a new <code>ObjectDefinitionStoreError</code> instance.
		 * @param message the error message
		 * @param objectName the name of the object definition
		 */
		public function ObjectDefinitionStoreError(message:* = "", objectName:String = null) {
			super(message);
			_objectName = objectName;
		}
		
		/**
		 * Returns the name of the object.
		 */
		public function get objectName():String {
			return _objectName;
		}
	}
}