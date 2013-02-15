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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler {
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 * Interface to be implemented when creating a custom namespace handler.
	 *
	 * <p>A namespace handler can be added to the main XMLObjectDefinitionsParser to handle user defined xml
	 * namespaces.</p>
	 * @docref extensible_xml_authoring.html#coding_an_inamespacehandler_implementation
	 * @author Christophe Herreman
	 */
	public interface INamespaceHandler {

		/**
		 * Return the namespace supported by this namespace handler.
		 */
		function getNamespace():Namespace;

		/**
		 * Parses the given node and returns the resulting object definition.
		 *
		 * @param node the xml node to parse
		 * @param context the root xml parser (XXX this might change to a parser context object)
		 */
		function parse(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition;

	}
}
