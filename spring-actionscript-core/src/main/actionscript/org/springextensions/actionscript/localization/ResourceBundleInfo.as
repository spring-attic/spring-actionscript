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
package org.springextensions.actionscript.localization {

	/**
	 * Simple immutable value object that contains information about a resource bundle. It is used internally by the
	 * FlexXMLApplicationContext to load resource bundles from external properties files.
	 *
	 * @author Christophe Herreman
	 */
	public class ResourceBundleInfo {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ResourceBundleInfo object.
		 * 
		 * @param url the location of the resource bundle properties file
		 * @param name the name of the resource bundle
		 * @param locale the locale
		 */
		public function ResourceBundleInfo(url:String, name:String, locale:String) {
			_url = url;
			_name = name;
			_locale = locale;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// url
		// ----------------------------

		private var _url:String;

		/**
		 * The location of the external resource bundle.
		 */
		public function get url():String {
			return _url;
		}

		// ----------------------------
		// name
		// ----------------------------

		private var _name:String;

		/**
		 * The name of the resource bundle.
		 */
		public function get name():String {
			return _name;
		}

		// ----------------------------
		// locale
		// ----------------------------

		private var _locale:String;

		/**
		 * The locale of the resource bundle
		 */
		public function get locale():String {
			return _locale;
		}

	}
}