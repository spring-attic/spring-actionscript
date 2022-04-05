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
package org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.XMLUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.object.ITypeConverter;
	import org.springextensions.actionscript.object.SimpleTypeConverter;

	/**
	 * Parses a key and value node.
	 *
	 * @author Christophe Herreman
	 */
	public class KeyValueNodeParser extends AbstractNodeParser {
		private static const TYPE_CONVERTER_FIELD_NAME:String = "typeConverter";

		private var _applicationDomain:ApplicationDomain;
		private static const logger:ILogger = getClassLogger(KeyValueNodeParser);

		/**
		 * Constructs the KeyValueNodeParser.
		 *
		 * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#KEY_ELEMENT
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#VALUE_ELEMENT
		 */
		public function KeyValueNodeParser(xmlObjectDefinitionsParser:IXMLObjectDefinitionsParser, applicationDomain:ApplicationDomain) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.KEY_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.VALUE_ELEMENT);
			_applicationDomain = applicationDomain;
		}

		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):* {
			var result:*;
			var child:XML = node.children()[0];

			// return an empty string if we have no child (e.g. node = <value/>)
			// XXX can we always return an empty string here, or should we consider other default type values?
			if (!child) {
				logger.debug("Returning empty string for node without children: {0}", [node]);
				return "";
			}

			if (XMLUtils.isElementNode(child)) {
				result = xmlObjectDefinitionsParser.parsePropertyValue(child);
			} else {
				var typeConverter:ITypeConverter;
				if ((xmlObjectDefinitionsParser.applicationContext != null) && //
					(xmlObjectDefinitionsParser.applicationContext.dependencyInjector != null) && //
					(xmlObjectDefinitionsParser.applicationContext.dependencyInjector[TYPE_CONVERTER_FIELD_NAME] != null)) {
					typeConverter = xmlObjectDefinitionsParser.applicationContext.dependencyInjector[TYPE_CONVERTER_FIELD_NAME];
				} else {
					typeConverter = new SimpleTypeConverter(_applicationDomain);
				}
				var clazz:Class = retrieveType(node);
				var value:String = child.toString();
				result = typeConverter.convertIfNecessary(value, clazz);
			}
			logger.debug("Parsed result: {0}", [result]);
			return result;
		}

		/**
		 * Will try to retrieve the type of a node. If no type was found, it will return null.
		 */
		private function retrieveType(node:XML):Class {
			var typeValue:String = node.@type;
			if (!typeValue) {
				return null;
			}
			switch (typeValue.toLowerCase()) {
				case "class":
					return Class;
					break;
				case "boolean":
					return Boolean;
					break;
				case "number":
					return Number;
					break;
				default:
					return null;
			}
		}
	}
}
