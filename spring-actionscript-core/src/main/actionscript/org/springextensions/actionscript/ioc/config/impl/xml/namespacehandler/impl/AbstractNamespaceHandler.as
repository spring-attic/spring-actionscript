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
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.INamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.IObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;


	/**
	 * Offers basic support for namespace handlers. This class should not be instantiated directly, but subclassed
	 * to add object definition parsers.
	 *
	 * <p>Subclasses can register new object definition parsers via the "registerObjectDefinitionParser" method.</p>
	 * @docref extensible_xml_authoring.html#coding_an_inamespacehandler_implementation
	 * @author Christophe Herreman
	 */
	public class AbstractNamespaceHandler implements INamespaceHandler {

		private var _namespace:Namespace;
		private var _nodeParsers:Object /* of String, IObjectDefinitionParser*/ = {};
		private static const logger:ILogger = getClassLogger(AbstractNamespaceHandler);

		/**
		 *
		 */
		public function AbstractNamespaceHandler(ns:Namespace) {
			_namespace = ns;
		}

		/**
		 * @inheritDoc
		 */
		public function getNamespace():Namespace {
			return _namespace;
		}

		/**
		 * @inheritDoc
		 */
		public function parse(node:XML, parser:IXMLObjectDefinitionsParser):IObjectDefinition {
			var nodeParser:IObjectDefinitionParser = findParserForNode(node);
			return nodeParser.parse(node, parser);
		}

		/**
		 * Registers an object definition parser.
		 *
		 * @param element the name of the node that the parser supports
		 * @param parser the object definition parser
		 */
		protected function registerObjectDefinitionParser(element:String, parser:IObjectDefinitionParser):void {
			logger.debug("Added parser for element '{0}': {1}", [element, parser]);
			_nodeParsers[element] = parser;
		}

		/**
		 * Looks up an IObjectDefinitionParser registered for the given node.
		 *
		 * @param node the xml node for which to find a parser
		 */
		protected function findParserForNode(node:XML):IObjectDefinitionParser {
			var element:String = node.localName().toString();
			var result:IObjectDefinitionParser = _nodeParsers[element];

			if (!result) {
				throw new Error("No parser was found for element '" + element + "' in namespace handler '" + _namespace + "'");
			}
			logger.debug("Found parser for element '{0}' in namespace {1}: {2}", [element, _namespace, result]);
			return result;
		}
	}
}
