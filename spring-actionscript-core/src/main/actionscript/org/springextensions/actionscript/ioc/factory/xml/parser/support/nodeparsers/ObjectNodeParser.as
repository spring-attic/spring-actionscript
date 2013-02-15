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
	
	import org.as3commons.lang.XMLUtils;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Parses an object node.
	 *
	 * @author Christophe Herreman
	 */
	public class ObjectNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs a new <code>ObjectNodeParser</code>.
		 *
		 * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#OBJECT_ELEMENT
		 */
		public function ObjectNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.OBJECT_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var result:Object;
			var isVanillaObject:Boolean = (node.attribute(XMLObjectDefinitionsParser.CLASS_ATTRIBUTE) == undefined);
			
			if (isVanillaObject) {
				result = new Object();
				
				for each (var subNode:XML in node.children()) {
					subNode = XMLUtils.convertAttributeToNode(subNode, XMLObjectDefinitionsParser.VALUE_ATTRIBUTE);
					result[subNode.@name.toString()] = xmlObjectDefinitionsParser.parseProperty(subNode);
				}
			} else {
				xmlObjectDefinitionsParser.parseNode(node);
				result = new RuntimeObjectReference(node.@id.toString());
			}
			
			return result;
		}
	}
}
