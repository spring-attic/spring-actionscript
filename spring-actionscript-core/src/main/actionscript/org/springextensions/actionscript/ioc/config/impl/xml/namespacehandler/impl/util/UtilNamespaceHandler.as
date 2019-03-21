/*
 * Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util {

	import flash.system.ApplicationDomain;

	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser.ConstantNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser.FactoryNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser.InvokeNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_util;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 * Util namespace handler.
	 * xml-schema-based-configuration.html#the_util_schema
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class UtilNamespaceHandler extends AbstractNamespaceHandler {

		public static const CONSTANT:String = "constant";
		public static const INVOKE:String = "invoke";
		public static const FACTORY:String = "factory";

		private var _initialized:Boolean = false;

		/**
		 * Creates a new <code>UtilNamespaceHandler</code> instance.
		 */
		public function UtilNamespaceHandler() {
			super(spring_actionscript_util);
		}

		override public function parse(node:XML, parser:IXMLObjectDefinitionsParser):IObjectDefinition {
			if (!_initialized) {
				initialize(parser);
			}
			return super.parse(node, parser);
		}

		private function initialize(parser:IXMLObjectDefinitionsParser):void {
			var objectDefinitionRegistry:IObjectDefinitionRegistry = parser.applicationContext.objectDefinitionRegistry;
			var applicationDomain:ApplicationDomain = parser.applicationContext.applicationDomain;

			registerObjectDefinitionParser(CONSTANT, new ConstantNodeParser());
			registerObjectDefinitionParser(INVOKE, new InvokeNodeParser());
			registerObjectDefinitionParser(FACTORY, new FactoryNodeParser(objectDefinitionRegistry, applicationDomain));

			_initialized = true;
		}

	}
}
