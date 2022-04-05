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

	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.domain.INamed;
	
	/**
	 * Provides utilities for working with INamed implementations.
	 *
	 * @author Christophe Herreman
	 */
	public final class NamedUtil {

		// --------------------------------------------------------------------
		//
		// Private Static Constants
		//
		// --------------------------------------------------------------------

		/** Regular expression that matches a generated suffix of a name. e.g. "an object (7)" */
		private static const SUFFIX_REG_EXP:RegExp = /\(\d+\)/g;

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns whether the given name is already used.
		 * 
		 * @param name the name to check
		 * @param namedObjects the array of INamed objects
		 */
		public static function isUsedName(name:String, namedObjects:Array):Boolean {
			for each (var namedObject:INamed in namedObjects) {
				if (INamed(namedObject).name == name) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Returns a unique name for a named object based on the given name. If we do have a duplicate name,
		 * we add a counter to the new name, eg. "name (x)"
		 */
		public static function createUniqueName(name:String, namedObjects:Array):String {
			if (isGeneratedName(name)) {
				name = getBaseName(name);
			}

			var result:String = name;

			if (isUsedName(name, namedObjects)) {
				for (var i:uint = 2; ; i++) {
					var newName:String = name + " (" + i + ")";
					if (!isUsedName(newName, namedObjects)) {
						result = newName;
						break;
					}
				}
			}
			
			return result;
		}

		/**
		 * Returns the base name of the given name. This is the part of the name without the generated index.
		 *
		 * @param name
		 * @return the base name
		 */
		public static function getBaseName(name:String):String {
			name = StringUtils.trim(name);
			if (isGeneratedName(name)) {
				return StringUtils.trim(name.substr(0, getSuffixIndex(name)));
			}
			return name;
		}

		/**
		 * Returns whether or not the given name is generated.
		 *
		 * @param name
		 * @return true if the name is generated, false if not
		 */
		public static function isGeneratedName(name:String):Boolean {
			return (getSuffixIndex(name) > -1);
		}

		/**
		 * Returns the index of the generated suffix.
		 *
		 * @param name
		 * @return the index of the suffix
		 */
		public static function getSuffixIndex(name:String):int {
			if (name == null) {
				return -1;
			}
			return name.search(SUFFIX_REG_EXP);
		}
		
	}
}