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
	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.impl.CompositeCommand;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 *
	 */
	public class CompositeCommandNodeParser extends AbstractTaskDefinitionParser {

		private static const ADD_COMMAND_METHOD_NAME:String = "addCommand";
		private static const FAIL_ON_FAULT_PROPERTY_NAME:String = "failOnFault";
		private static const KIND_PROPERTY_NAME:String = "kind";

		private static const logger:ILogger = getClassLogger(CompositeCommandNodeParser);

		public function CompositeCommandNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(CompositeCommand);
			builder.addPropertyValue(FAIL_ON_FAULT_PROPERTY_NAME, (node.attribute(TaskNamespaceHandler.FAIL_ON_FAULT_ATTR) == "true"));
			builder.addPropertyValue(KIND_PROPERTY_NAME, CompositeCommandKind.fromName(node.attribute(TaskNamespaceHandler.KIND_ATTR)));
			for each (var subnode:XML in node.children()) {
				builder.addMethodInvocation(ADD_COMMAND_METHOD_NAME, [new RuntimeObjectReference(subnode.@id)]);
			}
			logger.debug("Parsed object definition: {0}", [builder.objectDefinition]);
			return builder.objectDefinition;
		}

	}
}
