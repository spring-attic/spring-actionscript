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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser {
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.ParsingUtils;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_messaging;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	use namespace spring_actionscript_messaging;

	/**
	 * @docref xml-schema-based-configuration.html#the_messaging_schema
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractProducerNodeParser extends MessageAgentNodeParser {

		public static const AUTO_CONNECT_ATTR:String = "auto-connect";

		public static const DEFAULT_HEADERS_ATTR:String = "default-headers";

		public static const PRIORITY_ATTR:String = "priority";

		public static const RECONNECT_ATTEMPTS_ATTR:String = "reconnect-attempts";

		public static const RECONNECT_INTERVAL_ATTR:String = "reconnect-interval";

		/**
		 * Creates a new AbstractProducerNodeParser
		 */
		public function AbstractProducerNodeParser() {
		}

		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = IObjectDefinition(super.parseInternal(node, context));

			mapProperties(spring_actionscript_messaging, result, node);

			return result;
		}

		override protected function mapProperties(ns:Namespace, objectDefinition:IObjectDefinition, node:XML):void {
			super.mapProperties(ns, objectDefinition, node);
			ParsingUtils.mapProperties(ns, objectDefinition, node, AUTO_CONNECT_ATTR, PRIORITY_ATTR, RECONNECT_ATTEMPTS_ATTR, RECONNECT_INTERVAL_ATTR);
			ParsingUtils.mapReferences(ns, objectDefinition, node, DEFAULT_HEADERS_ATTR);
		}

	}
}
