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
package org.springextensions.actionscript.ioc.config.impl.xml.parser {

	/**
	 * Defines a single node parser.
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public interface INodeParser {

		/**
		 * Determines if the given node can be parsed.
		 *
		 * @param node  The node to be checked.
		 *
		 * @return true if this implementation can parse the given node.
		 */
		function canParse(node:XML):Boolean;

		/**
		 * Will parse the given node. The type of the result depends
		 * on the implementation of the node parser.
		 *
		 * @param node  The node that will be parsed
		 *
		 * @return the parsed node
		 */
		function parse(node:XML):*;

		/**
		 * Will add an alias that this node parser will react upon. It has direct influence
		 * on the result of the canParse method.
		 *
		 * @param alias    Alternative nodename that can be parsed by this parser
		 *
		 * @see #canParse
		 */
		function addNodeNameAlias(alias:String):void;

		/**
		 * Return an array containing the node names this parser can parse
		 */
		function getNodeNames():Vector.<String>;
	}
}
