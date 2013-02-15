/*
 * Copyright 2007-2008 the original author or authors.
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
	
	import flash.utils.getDefinitionByName;
	
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	/**
	 * @author Roland Zwaga
	 */
	public class VectorNodeParser extends AbstractNodeParser {
		
		/**
		 * Creates a new <code>VectorNodeParser</code> instance.
		 * @param xmlObjectDefinitionsParser
		 * 
		 */
		public function VectorNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.VECTOR_ELEMENT);
		}

		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var type:String = node.attribute("type").toString();
			var className:String = "__AS3__.vec.Vector.<" + type + ">";
			var cls:Class = getDefinitionByName(className) as Class;
			var result:Array = [];
			result.push(cls);

			for each (var n:XML in node.children()) {
				result.push(Object(xmlObjectDefinitionsParser.parsePropertyValue(n)));
			}

			return result;
		}

	}
}