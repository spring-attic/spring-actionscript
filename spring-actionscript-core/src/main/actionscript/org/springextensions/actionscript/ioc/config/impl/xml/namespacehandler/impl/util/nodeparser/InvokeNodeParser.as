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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser {
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.ParsingUtils;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_util;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.impl.MethodInvokingFactoryObject;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	use namespace spring_actionscript_util;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class InvokeNodeParser extends AbstractObjectDefinitionParser {

		private static const logger:ILogger = getClassLogger(InvokeNodeParser);

		public static const TARGET_CLASS:String = "target-class";
		public static const TARGET_OBJECT:String = "target-object";
		public static const TARGET_METHOD:String = "target-method";
		private static const ARGUMENTS_FIELD_NAME:String = "arguments";

		/**
		 * Creates a new <code>InvokeNodeParser</code> instance.
		 */
		public function InvokeNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(MethodInvokingFactoryObject);

			setNamespace(node, node.namespace());

			ParsingUtils.mapProperties(spring_actionscript_util, builder.objectDefinition, node, TARGET_CLASS);
			ParsingUtils.mapProperties(spring_actionscript_util, builder.objectDefinition, node, TARGET_OBJECT);
			ParsingUtils.mapProperties(spring_actionscript_util, builder.objectDefinition, node, TARGET_METHOD);

			var args:Array = [];

			var argNodes:XMLList = node.children();
			for each (var argXML:XML in argNodes) {
				args[args.length] = context.parseProperty(argXML);
			}

			builder.addPropertyValue(ARGUMENTS_FIELD_NAME, args);
			logger.debug("Parsed result: {0}", [builder.objectDefinition]);
			return builder.objectDefinition;
		}

		protected function setNamespace(node:XML, ns:Namespace):void {
			for each (var desc:XML in node.descendants()) {
				desc.setNamespace(ns);
				setNamespace(desc, ns);
			}
		}

	}
}
