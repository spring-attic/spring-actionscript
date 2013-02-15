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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.rpc {
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * mx.rpc.AbstractService node parser.
	 * @docref xml-schema-based-configuration.html#the_rpc_schema
	 * @author Christophe Herreman
	 */
	public class AbstractServiceNodeParser extends AbstractObjectDefinitionParser {
		
		/** The channel-set attribute */
		public static const CHANNEL_SET_ATTR:String = "channel-set";
		
		/** The destination attribute */
		public static const DESTINATION_ATTR:String = "destination";
		
		/** The request-timeout attribute */
		public static const REQUEST_TIMEOUT_ATTR:String = "request-timeout";
		
		/**
		 * Creates a new AbstractServiceNodeParser
		 */
		public function AbstractServiceNodeParser() {
			super();
		}
		
		/**
		 *
		 */
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = new ObjectDefinition("");
			
			ParsingUtils.mapProperties(result, node, DESTINATION_ATTR, REQUEST_TIMEOUT_ATTR);
			ParsingUtils.mapReferences(result, node, CHANNEL_SET_ATTR);
			
			return result;
		}
	}
}