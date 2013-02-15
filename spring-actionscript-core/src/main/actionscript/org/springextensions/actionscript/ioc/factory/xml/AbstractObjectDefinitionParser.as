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
package org.springextensions.actionscript.ioc.factory.xml {
	
	import flash.errors.IllegalOperationError;
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Abstract implementation of IObjectDefinitionParser that offers templating for parsing and registering an
	 * object definition.
	 *
	 * <p>Subclasses must override "parseInternal" to do the actual parsing of the xml.</p>
	 * @docref extensible_xml_authoring.html#coding_an_iobjectdefinitionparser_implementation
	 * @author Christophe Herreman
	 */
	public class AbstractObjectDefinitionParser implements IObjectDefinitionParser {
		
		public function AbstractObjectDefinitionParser() {
		}
		
		/**
		 * @inheritDoc
		 */
		public final function parse(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = parseInternal(node, context);
			
			if (result != null) {
				var objectName:String = resolveID(node, result, context);
				context.registerObjectDefinition(objectName, result);
			}
			
			return result;
		}
		
		/**
		 * Template method for parsing the xml node into an object definition.
		 */
		protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			throw new IllegalOperationError("'parseInternal' is abstract");
		}
		
		/**
		 * Returns the id of the given xml node. If no id is present, one will be generated.
		 */
		protected function resolveID(node:XML, definition:IObjectDefinition, context:XMLObjectDefinitionsParser):String {
			if (node.@id == undefined) {
				node.@id = context.generateObjectName(definition);
			}
			
			return node.@id.toString();
		}
	}
}