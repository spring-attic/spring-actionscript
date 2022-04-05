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
package org.springextensions.actionscript.ioc.error {

	/**
	 * This error is thrown when a needed dependency can't be found.
	 *
	 * @author Martino Piccinato
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode
	 * @docref
	 */
	public class UnsatisfiedDependencyError extends Error {

		private var _objectName:String;

		private var _propertyName:String;

		/**
		 * Creates a new <code>UnsatisfiedDependencyError</code> instance.
		 */
		public function UnsatisfiedDependencyError(objectName:String, propertyName:String, message:String="", rootError:Error = null) {
			message += "Unsatisfied dependency in object [" + objectName + "] for property [" + propertyName + "]";

			if (rootError) {
				message += "\nCaused by: " + rootError.message + "\n" + rootError.getStackTrace();
			}

			_objectName = objectName;
			_propertyName = propertyName;
			super(message);
		}

		public function get objectName():String {
			return _objectName;
		}

		public function get propertyName():String {
			return _propertyName;
		}

	}
}
