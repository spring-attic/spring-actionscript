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
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;


	/**
	 * Parses an array node.
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class ArrayNodeParser extends AbstractNodeParser {

		private static const logger:ILogger = getClassLogger(ArrayNodeParser);

		/**
		 * Creates a new <code>ArrayNodeParser</code> instance.
		 *
		 * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#ARRAY_ELEMENT
		 */
		public function ArrayNodeParser(xmlObjectDefinitionsParser:IXMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.ARRAY_ELEMENT);
		}

		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):* {
			var result:Array = [];
			logger.debug("Creating new Array");
			for each (var subNode:XML in node.children()) {
				var value:* = xmlObjectDefinitionsParser.parsePropertyValue(subNode);
				result[result.length] = value;
				logger.debug("Adding value {0} to new Array", [value]);
			}

			return result;
		}
	}
}
