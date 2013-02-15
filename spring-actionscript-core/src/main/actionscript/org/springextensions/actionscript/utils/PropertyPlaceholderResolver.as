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
package org.springextensions.actionscript.utils {

	import org.as3commons.lang.IllegalArgumentError;
	import org.springextensions.actionscript.collections.Properties;

	/**
	 * Used for resolving property placeholders.
	 *
	 * @author Christophe Herreman
	 */
	public class PropertyPlaceholderResolver {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a <code>PropertyPlaceholderResolver</code> instance.
		 *
		 * @param regExp the regular expression used for searching for property placeholders
		 * @param properties the properties
		 * @param ignoreUnresolvablePlaceholders whether or not to ignore (fail silent) unresolvable properties or not (throw error)
		 */
		public function PropertyPlaceholderResolver(regExp:RegExp = null, properties:Properties = null, ignoreUnresolvablePlaceholders:Boolean = false) {
			this.regExp = regExp;
			this.properties = properties;
			this.ignoreUnresolvablePlaceholders = ignoreUnresolvablePlaceholders;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// regExp
		// ----------------------------

		private var _regExp:RegExp;

		public function get regExp():RegExp {
			return _regExp;
		}

		public function set regExp(value:RegExp):void {
			if (value !== _regExp) {
				_regExp = value;
			}
		}

		// ----------------------------
		// properties
		// ----------------------------

		private var _properties:Properties;

		public function get properties():Properties {
			return _properties;
		}

		public function set properties(value:Properties):void {
			if (value !== _properties) {
				_properties = value;
			}
		}

		// ----------------------------
		// ignoreUnresolvablePlaceholders
		// ----------------------------

		private var _ignoreUnresolvablePlaceholders:Boolean;

		public function get ignoreUnresolvablePlaceholders():Boolean {
			return _ignoreUnresolvablePlaceholders;
		}

		public function set ignoreUnresolvablePlaceholders(value:Boolean):void {
			if (value !== _ignoreUnresolvablePlaceholders) {
				_ignoreUnresolvablePlaceholders = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Resolves the property placeholders in the given value, using the given regular expression. Property
		 * replacement happens recursively to make sure that property placeholders that are replaced by other
		 * property placeholders also get replaced.
		 *
		 * @param value the string value for which to replace its placeholders
		 * @param regExp the regular expression used to search for property placeholders
		 * @return the value with its property placeholders resolved
		 */
		public function resolvePropertyPlaceholders(value:String, regExp:RegExp = null, properties:Properties = null):String {
			if (!value) {
				return value;
			}

			if (!regExp) {
				regExp = this.regExp;
			}

			if (!properties) {
				properties = this.properties;
			}

			var newValue:String;

			// try to resolve as long as we match the regular expression
			while (value.search(regExp) > -1) {
				newValue = replacePropertyPlaceholder(value, regExp, properties);

				if (newValue != value) {
					//logger.debug("Resolved property placeholders for value '{0}' to '{1}'", value, newValue);
					value = newValue;
				} else {
					// the replaced value is equal to the original value
					// this might be in case we have an unresolved placeholder and unresolved placeholders
					// are ignored, so we need to break to prevent from being in an infinite loop
					break;
				}
			}
			return value;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Resolves the property placeholders for the given string, using the given regular expression. This method
		 * is used recursively by the resolvePropertyPlaceholder method since this will only do a single
		 * non-recursive replacement.
		 *
		 * @param value the string value for which to replace its placeholders
		 * @param regExp the regular expression used to search for property placeholders
		 * @return the value with its property placeholders resolved
		 */
		private function replacePropertyPlaceholder(value:String, regExp:RegExp, properties:Properties):String {
			var matches:Array = value.match(regExp);
			for (var i:int = 0; i < matches.length; i++) {
				var key:String = getPropertyName(matches[i]);
				var newValue:String = properties.getProperty(key);

				// throw error or allow unresolved placeholders
				// note: don't check with !newValue since we also allow empty strings
				if (newValue == null) {
					if (!ignoreUnresolvablePlaceholders) {
						throw new IllegalArgumentError("Could not resolve placeholder '" + matches[i] + "'");
					}
				} else {
					value = value.replace(matches[i], newValue);
				}
			}
			return value;
		}

		/**
		 * Returns the name of the property from a placeholder string.
		 * e.g. ${myProperty} -> myProperty
		 */
		private function getPropertyName(placeholder:String):String {
			const numBeginChars:uint = 2; // '${' or '$('
			const numEndChars:uint = 1; // '}' or ')'
			return placeholder.substring(numBeginChars, placeholder.length - numEndChars);
		}
	}
}