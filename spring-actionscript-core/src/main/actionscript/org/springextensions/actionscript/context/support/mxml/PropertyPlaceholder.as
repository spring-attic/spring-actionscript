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
package org.springextensions.actionscript.context.support.mxml {

	/**
	 * 
	 * @author Christophe Herreman
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class PropertyPlaceholder {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>PropertyPlaceholder</code> instance.
		 */
		public function PropertyPlaceholder() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// location
		// ----------------------------

		private var _location:String;

		public function get location():String {
			return _location;
		}

		public function set location(value:String):void {
			if (value !== _location) {
				_location = value;
			}
		}

	}
}