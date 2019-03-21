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
package org.springextensions.actionscript.ioc.config.property {

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class TextFileURI {

		/**
		 * Creates a new <code>TextFileURI</code> instance.
		 * @param URI
		 * @param prevent
		 */
		public function TextFileURI(URI:String, required:Boolean, prevent:Boolean=true) {
			super();
			_textFileURI = URI;
			_isRequired = required;
			_preventCache = prevent;
		}

		private var _preventCache:Boolean;
		private var _isRequired:Boolean;
		private var _textFileURI:String;


		public function get isRequired():Boolean {
			return _isRequired;
		}

		public function get preventCache():Boolean {
			return _preventCache;
		}

		public function get textFileURI():String {
			return _textFileURI;
		}

		public function toString():String {
			return "TextFileURI{preventCache:" + _preventCache + ", isRequired:" + _isRequired + ", textFileURI:\"" + _textFileURI + "\"}";
		}


	}
}
