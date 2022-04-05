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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser {
	import org.as3commons.async.task.impl.CountProvider;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	/**
	 * Converts a count attribute to a corresponding <code>IObjectDefinition</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class CountProviderNodeParser extends AbstractTaskDefinitionParser {

		private static const logger:ILogger = getClassLogger(CountProviderNodeParser);

		/**
		 * Creates a new <code>CountProviderNodeParser</code> instance.
		 */
		public function CountProviderNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var hasCount:Boolean = (node.attribute(TaskNamespaceHandler.COUNT_ATTR).length() > 0);
			if (hasCount) {
				var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(CountProvider);
				builder.addConstructorArgValue(node.attribute(TaskNamespaceHandler.COUNT_ATTR));
				logger.debug("Parsed object definition: {0}", [builder.objectDefinition]);
				return builder.objectDefinition;
			} else {
				return null;
			}
		}

	}
}
