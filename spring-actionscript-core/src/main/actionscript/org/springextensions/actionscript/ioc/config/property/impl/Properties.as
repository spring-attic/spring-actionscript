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
package org.springextensions.actionscript.ioc.config.property.impl {
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;

	/**
	 * The <code>Properties</code> class represents a collection of properties
	 * in the form of key-value pairs. All keys and values are of type
	 * <code>String</code>
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class Properties implements IPropertiesProvider {

		private static const logger:ILogger = getClassLogger(Properties);

		/**
		 * Creates a new <code>Properties</code> object.
		 */
		public function Properties() {
			super();
			_content = {};
			_propertyNames = new Vector.<String>();
		}

		private var _content:Object;
		private var _propertyNames:Vector.<String>;

		/**
		 * The content of the Properties instance as an object.
		 * @return an object containing the content of the properties
		 */
		public function get content():Object {
			return _content;
		}

		public function get length():uint {
			return _propertyNames.length;
		}

		/**
		 * Returns an array with the keys of all properties. If no properties
		 * were found, an empty array is returned.
		 *
		 * @return an array with all keys
		 */
		public function get propertyNames():Vector.<String> {
			return _propertyNames;
		}

		/**
		 * Gets the value of property that corresponds to the given <code>key</code>.
		 * If no property was found, <code>null</code> is returned.
		 *
		 * @param key the name of the property to get
		 * @returns the value of the property with the given key, or null if none was found
		 */
		public function getProperty(key:String):* {
			return _content[key];
		}

		public function hasProperty(key:String):Boolean {
			return _content.hasOwnProperty(key);
		}

		/**
		 * Adds all conIPropertiese given properties object to this Properties.
		 */
		public function merge(properties:IPropertiesProvider, overrideProperty:Boolean=false):void {
			if ((!properties) || (properties === this)) {
				logger.debug("Invalid properties argument: {0}, ignoring merge", [properties]);
				return;
			}
			logger.debug("Merging properties from {0} with override set to {1}", [properties, overrideProperty]);
			for (var key:String in properties.content) {
				if (!_content[key] || (_content[key] && overrideProperty)) {
					setProperty(key, properties.content[key]);
					/*addPropertyName(key);
					_content[key] = properties.content[key];*/
				}
			}
		}

		/**
		 * Sets a property. If the property with the given key already exists,
		 * it will be replaced by the new value.
		 *
		 * @param key the key of the property to set
		 * @param value the value of the property to set
		 */
		public function setProperty(key:String, value:String):void {
			addPropertyName(key);
			_content[key] = value;
			logger.debug("Added property: {0}={1}", [key, value]);
		}

		private function addPropertyName(key:String):void {
			if (_propertyNames.indexOf(key) < 0) {
				_propertyNames[_propertyNames.length] = key;
			}
		}
	}
}
