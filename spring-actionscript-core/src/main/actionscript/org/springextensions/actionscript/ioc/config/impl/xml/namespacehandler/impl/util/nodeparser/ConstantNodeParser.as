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

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.ParsingUtils;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_util;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.impl.FieldRetrievingFactoryObject;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;

	use namespace spring_actionscript_util;

	/**
	 *
	 * @docref xml-schema-based-configuration.html#the_util_schema
	 * @author Christophe Herreman
	 */
	public class ConstantNodeParser extends AbstractObjectDefinitionParser {

		private static const logger:ILogger = getClassLogger(ConstantNodeParser);

		public static const STATIC_FIELD:String = "static-field";
		public static const TARGET_CLASS:String = "target-class";
		public static const TARGET_OBJECT:String = "target-object";
		public static const TARGET_FIELD:String = "target-field";

		/**
		 * Creates a new <code>ConstantNodeParser</code> instance
		 */
		public function ConstantNodeParser() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = new ObjectDefinition(ClassUtils.getFullyQualifiedName(FieldRetrievingFactoryObject, true));

			ParsingUtils.mapProperties(spring_actionscript_util, result, node, STATIC_FIELD);
			ParsingUtils.mapProperties(spring_actionscript_util, result, node, TARGET_CLASS);
			ParsingUtils.mapProperties(spring_actionscript_util, result, node, TARGET_OBJECT);
			ParsingUtils.mapProperties(spring_actionscript_util, result, node, TARGET_FIELD);
			logger.debug("Parsed result: {0}", [result]);
			return result;
		}

	}
}
