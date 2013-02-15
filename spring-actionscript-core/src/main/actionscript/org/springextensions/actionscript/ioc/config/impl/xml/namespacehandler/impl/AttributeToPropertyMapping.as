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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl {
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	/**
	 * Describes a mapping between an xml attribute value and a property name
	 * of an object definition.
	 *
	 * <p>Used when parsing custom xml object definitions.</p>
	 *
	 * @author Christophe Herreman
	 * @see ParsingUtils
	 */
	public class AttributeToPropertyMapping {

		private static const logger:ILogger = getClassLogger(AttributeToPropertyMapping);

		private var _attribute:String;

		private var _propertyName:String;

		/**
		 * Creates a new AttributeToPropertyMapping
		 *
		 * @param attribute the name of the attribute
		 * @param propertyName the name of the property
		 */
		public function AttributeToPropertyMapping(attribute:String, propertyName:String) {
			_attribute = attribute;
			_propertyName = propertyName;
			logger.debug("Created mapping between attribute name '{0}' and property '{1}'", [attribute, propertyName]);
		}

		public function get attribute():String {
			return _attribute;
		}

		public function get propertyName():String {
			return _propertyName;
		}
	}
}
