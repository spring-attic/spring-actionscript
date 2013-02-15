/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.core.task.xml.parser {
	import org.springextensions.actionscript.core.command.CompositeCommand;
	import org.springextensions.actionscript.core.command.CompositeCommandKind;
	import org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class CompositeCommandNodeParser extends AbstractTaskDefinitionParser {

		private static const ADD_COMMAND_METHOD_NAME:String = "addCommand";
		private static const FAIL_ON_FAULT_PROPERTY_NAME:String = "failOnFault";
		private static const KIND_PROPERTY_NAME:String = "kind";

		public function CompositeCommandNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(CompositeCommand);
			builder.addPropertyValue(FAIL_ON_FAULT_PROPERTY_NAME, (node.attribute(TaskNamespaceHandler.FAIL_ON_FAULT_ATTR) == "true"));
			builder.addPropertyValue(KIND_PROPERTY_NAME, CompositeCommandKind.fromName(node.attribute(TaskNamespaceHandler.KIND_ATTR)));
			for each (var subnode:XML in node.children()) {
				var args:Array = [];
				args[0] = new RuntimeObjectReference(subnode.@id);
				builder.addMethodInvocation(ADD_COMMAND_METHOD_NAME, args);
			}
			return builder.objectDefinition;
		}

	}
}