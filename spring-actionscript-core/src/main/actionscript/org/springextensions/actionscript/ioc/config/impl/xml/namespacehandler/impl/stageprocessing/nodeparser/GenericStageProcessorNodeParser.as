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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.nodeparser {
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.ParsingUtils;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_stageprocessing;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.stage.GenericStageProcessor;

	use namespace spring_actionscript_stageprocessing;

	/**
	 * genericstageprocessor node parser
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class GenericStageProcessorNodeParser extends AbstractObjectDefinitionParser {

		public static const OBJECT_SELECTOR_ATTR:String = "object-selector";

		/** The target-method attribute */
		public static const TARGET_METHOD_ATTR:String = "target-method";

		/** The target-object attribute */
		public static const TARGET_OBJECT_ATTR:String = "target-object";

		/** The target-property attribute */
		public static const TARGET_PROPERTY_ATTR:String = "target-property";

		private static const logger:ILogger = getClassLogger(GenericStageProcessorNodeParser);

		/**
		 * Creates a new <code>StageProcessorNodeParser</code> instance.
		 */
		public function GenericStageProcessorNodeParser() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var result:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(GenericStageProcessor);

			ParsingUtils.mapProperties(spring_actionscript_stageprocessing, result.objectDefinition, node, TARGET_PROPERTY_ATTR, TARGET_METHOD_ATTR);
			ParsingUtils.mapReferences(spring_actionscript_stageprocessing, result.objectDefinition, node, TARGET_OBJECT_ATTR);

			if (node.attribute(OBJECT_SELECTOR_ATTR).length() > 0) {
				var objectSelectorName:String = String(node.attribute(OBJECT_SELECTOR_ATTR)[0]);
				result.objectDefinition.customConfiguration = objectSelectorName;
				logger.debug("Registered '{0}' as the name of the custom IObjectSelector", [objectSelectorName]);
			}

			logger.debug("Parsed object definition: {0}", [result.objectDefinition]);

			return result.objectDefinition;
		}
	}
}
