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

	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_stageprocessing;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.stage.DefaultAutowiringStageProcessor;

	use namespace spring_actionscript_stageprocessing;

	public class AutowiringStageProcessorNodeParser extends StageProcessorNodeParser {

		public static const OBJECTDEFINITION_RESOLVER_ATTR:String = "objectdefinition-resolver";
		public static const AUTOWIRE_ONCE_ATTR:String = "autowire-once";
		public static const TRUE_VALUE:String = "true";
		private static const logger:ILogger = getClassLogger(AutowiringStageProcessorNodeParser);

		public function AutowiringStageProcessorNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var result:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(DefaultAutowiringStageProcessor);

			context.parseAttributes(result.objectDefinition, node);
			context.parseConstructorArguments(result.objectDefinition, node);
			context.parseMethodInvocations(result.objectDefinition, node);
			context.parseProperties(result.objectDefinition, node);

			var objectName:String = resolveID(node, result.objectDefinition, context);

			if (node.attribute(OBJECT_SELECTOR_ATTR).length() > 0) {
				var objectSelectorName:String = String(node.attribute(OBJECT_SELECTOR_ATTR)[0]);
				result.objectDefinition.customConfiguration = objectSelectorName;
			}
			if (node.attribute(OBJECTDEFINITION_RESOLVER_ATTR).length() > 0) {
				var objectDefinitionResolverName:String = node.attribute(OBJECTDEFINITION_RESOLVER_ATTR);
				if (StringUtils.hasText(objectDefinitionResolverName)) {
					result.addPropertyReference("objectDefinitionResolver", objectDefinitionResolverName);
				}
			}
			if (node.attribute(AUTOWIRE_ONCE_ATTR).length() > 0) {
				var autowireOnce:String = node.attribute(AUTOWIRE_ONCE_ATTR);
				if (StringUtils.hasText(objectDefinitionResolverName)) {
					result.addPropertyValue("autowireOnce", (autowireOnce.toLowerCase() == TRUE_VALUE));
				}
			}

			logger.debug("Parsed object definition: {0} for id '{1}'", [result.objectDefinition, objectName]);

			return result.objectDefinition;
		}

	}
}
