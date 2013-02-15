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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers {
	
	import mx.collections.ArrayCollection;
	
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Parses an array-collection node.
	 *
	 * <p>
	 * <b>Authors:</b> Christophe Herreman, Erik Westra<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class ArrayCollectionNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the ArrayCollectionNodeParser.
		 *
		 * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#ARRAY_COLLECTION_ELEMENT
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#LIST_ELEMENT
		 */
		public function ArrayCollectionNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.ARRAY_COLLECTION_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.LIST_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			/*
			   Putting the items in an array first, the ArrayCollection performs actions
			   on every addItem call. This way we can set the source as a onetime operation.
			 */
			var parsedNodes:Array = [];
			var result:ArrayCollection = new ArrayCollection();
			
			for each (var n:XML in node.children()) {
				parsedNodes.push(xmlObjectDefinitionsParser.parsePropertyValue(n));
			}
			
			result.source = parsedNodes;
			
			return result;
		}
	}
}
