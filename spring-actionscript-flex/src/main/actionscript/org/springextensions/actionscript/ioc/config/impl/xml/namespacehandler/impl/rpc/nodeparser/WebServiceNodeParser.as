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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.rpc.nodeparser {

	import mx.rpc.soap.WebService;

	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AttributeToPropertyMapping;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.ParsingUtils;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_messaging;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	use namespace spring_actionscript_messaging;

	/**
	 * WebService node parser.
	 * @docref xml-schema-based-configuration.html#the_rpc_schema
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class WebServiceNodeParser extends AbstractServiceNodeParser {

		// ------------------- Attributes -------------------------

		public static const DESCRIPTION_ATTR:String = "description";

		public static const ENDPOINT_URI_ATTR:String = "endpoint-uri";

		public static const MAKE_OBJECTS_BINDABLE_ATTR:String = "make-objects-bindable";

		public static const PORT_ATTR:String = "port";

		public static const ROOT_URL_ATTR:String = "root-url";

		public static const SERVICE_ATTR:String = "service";

		public static const USE_PROXY_ATTR:String = "use-proxy";

		public static const WSDL_ATTR:String = "wsdl";

		// -------------------- Attribute Mappings ----------------------

		private static const ENDPOINT_URI_MAPPING:AttributeToPropertyMapping = new AttributeToPropertyMapping(ENDPOINT_URI_ATTR, "endpointURI");

		private static const ROOT_URL_MAPPING:AttributeToPropertyMapping = new AttributeToPropertyMapping(ROOT_URL_ATTR, "rootURL");

		/**
		 * Creates a new WebServiceNodeParser
		 */
		public function WebServiceNodeParser() {
			super();
		}

		/**
		 *
		 */
		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = IObjectDefinition(super.parse(node, context));

			result.className = ClassUtils.getFullyQualifiedName(WebService, true);

			ParsingUtils.mapProperties(spring_actionscript_messaging, result, node, DESCRIPTION_ATTR, ENDPOINT_URI_MAPPING, MAKE_OBJECTS_BINDABLE_ATTR, PORT_ATTR, ROOT_URL_MAPPING, SERVICE_ATTR, USE_PROXY_ATTR, WSDL_ATTR);

			return result;
		}
	}
}
