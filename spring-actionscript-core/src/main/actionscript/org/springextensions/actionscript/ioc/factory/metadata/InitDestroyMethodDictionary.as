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
package org.springextensions.actionscript.ioc.factory.metadata {
	import flash.utils.Dictionary;

	import org.as3commons.reflect.Method;

	/**
	 * Dictionary that maps a Class to an array of Method objects, used in the InitDestroyMetadataProcessor.
	 *
	 * @author Christophe Herreman
	 */
	public class InitDestroyMethodDictionary extends Dictionary {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InitDestroyMethodDictionary() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds the given method to the associated methods for the given class.
		 *
		 * @param clazz
		 * @param method
		 */
		public function addMethod(clazz:Class, method:Method):void {
			getMethods(clazz).push(method);
		}

		/**
		 * Returns the methods associated with the given class. If not methods for this class were found, an empty
		 * array is returned.
		 *
		 * @param clazz
		 * @return an array of Method objects, associated with the given class
		 */
		public function getMethods(clazz:Class):Array {
			if (!this[clazz]) {
				this[clazz] = [];
			}
			return this[clazz];
		}

	}
}