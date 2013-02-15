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
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.objects.ITypeConverter;
	
	/**
	 * Parses a key and value node.
	 *
	 * @author Christophe Herreman
	 */
	public class KeyValueNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the KeyValueNodeParser.
		 *
		 * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#KEY_ELEMENT
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#VALUE_ELEMENT
		 */
		public function KeyValueNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.KEY_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.VALUE_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var result:*;
			var child:XML = node.children()[0];
			
			// return an empty string if we have no child (e.g. node = <value/>)
			// XXX can we always return an empty string here, or should we consider other default type values?
			if (!child) {
				return "";
			}
			
			if (XMLUtils.isElementNode(child)) {
				result = xmlObjectDefinitionsParser.parsePropertyValue(child);
			} else {
				var typeConverter:ITypeConverter = xmlObjectDefinitionsParser.applicationContext.typeConverter;
				var clazz:Class = retrieveType(node);
				var value:String = child.toString();
				
				result = typeConverter.convertIfNecessary(value, clazz);
			}
			
			return result;
		}
		
		/**
		 * Will try to retrieve the type of a node. If no type was found, it will return null.
		 */
		private function retrieveType(node:XML):Class {
			var result:Class;
			
			try {
				result = xmlObjectDefinitionsParser.applicationContext.getClassForName(node.@type);
			} catch (e:Error) {
			}
			
			return result;
		}
	}
}
