/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.messaging {
	
	import mx.messaging.ChannelSet;
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.factory.xml.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * @docref xml-schema-based-configuration.html#the_messaging_schema
	 * @author Christophe Herreman
	 */
	public class ChannelSetNodeParser extends AbstractObjectDefinitionParser {
		
		public static const CHANNELS_ATTR:String			= "channels";
		public static const CLUSTERED_ATTR:String			= "clustered";
		public static const INITIAL_DESTINATION_ID:String	= "initial-destination-id";
		
		public function ChannelSetNodeParser() {
		}
		
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(ChannelSet);
			
			mapProperties(builder.objectDefinition, node);
			
			return builder.objectDefinition;
		}
		
		protected function mapProperties(objectDefinition:IObjectDefinition, node:XML):void {
			ParsingUtils.mapProperties(objectDefinition, node, CLUSTERED_ATTR, INITIAL_DESTINATION_ID);
			ParsingUtils.mapReferenceArrays(objectDefinition, node, CHANNELS_ATTR);
		}
	}
}