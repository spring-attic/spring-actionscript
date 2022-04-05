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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;

	/**
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyPlaceholder extends AbstractMXMLObject {

		/**
		 * Creates a new <code>PropertyPlaceholder</code> instance.
		 */
		public function PropertyPlaceholder() {
			super(this);
		}

		private var _URI:String;
		private var _isRequired:Boolean = true;
		private var _preventCache:Boolean = true;

		public function get isRequired():Boolean {
			return _isRequired;
		}

		public function set isRequired(value:Boolean):void {
			_isRequired = value;
		}

		public function get preventCache():Boolean {
			return _preventCache;
		}

		public function set preventCache(value:Boolean):void {
			_preventCache = value;
		}

		public function get URI():String {
			return _URI;
		}

		public function set URI(value:String):void {
			if (value != _URI) {
				_URI = value;
			}
		}

		public function toTextFileURI():TextFileURI {
			return new TextFileURI(_URI, _isRequired, _preventCache);
		}

	}
}
