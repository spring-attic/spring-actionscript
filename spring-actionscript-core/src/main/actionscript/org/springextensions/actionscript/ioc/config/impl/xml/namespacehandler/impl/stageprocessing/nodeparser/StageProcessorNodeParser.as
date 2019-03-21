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

	import flash.errors.IllegalOperationError;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_stageprocessing;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	use namespace spring_actionscript_stageprocessing;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StageProcessorNodeParser extends AbstractObjectDefinitionParser {

		private static const logger:ILogger = getClassLogger(StageProcessorNodeParser);

		/** The object-selector attribute */
		public static const OBJECT_SELECTOR_ATTR:String = "object-selector";

		/**
		 * Creates a new <code>StageProcessorNodeParser</code> instance.
		 */
		public function StageProcessorNodeParser() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var cls:Class = ClassUtils.forName(String(node.attribute("class")[0]));
			if (ClassUtils.isImplementationOf(cls, IStageObjectProcessor) == false) {
				throw new IllegalOperationError("The class defined in the <stageprocessor/> element is not an implementation of IStageObjectProcessor");
			}
			var result:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(cls);

			context.parseAttributes(result.objectDefinition, node);
			context.parseConstructorArguments(result.objectDefinition, node);
			context.parseMethodInvocations(result.objectDefinition, node);
			context.parseProperties(result.objectDefinition, node);

			var objectName:String = resolveID(node, result.objectDefinition, context);
			context.registerObjectDefinition(objectName, result.objectDefinition);

			if (node.attribute(OBJECT_SELECTOR_ATTR).length() > 0) {
				var objectSelectorName:String = node.attribute(OBJECT_SELECTOR_ATTR);
				result.objectDefinition.customConfiguration = objectSelectorName;
				logger.debug("Registered '{0}' as the name of the custom IObjectSelector", [objectSelectorName]);
			}

			logger.debug("Parsed object definition: {0}, for id '{1}'", [result.objectDefinition, objectName]);

			return result.objectDefinition;
		}
	}
}
