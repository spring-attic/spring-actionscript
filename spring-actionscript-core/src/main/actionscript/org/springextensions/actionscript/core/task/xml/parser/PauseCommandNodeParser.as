/*
 * Copyright 2007-2010 the original author or authors.
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
 	import org.springextensions.actionscript.core.task.command.PauseCommand;
 	import org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler;
 	import org.springextensions.actionscript.ioc.IObjectDefinition;
 	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
 	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
 	
	/**
	 * Converts a &lt;pause/&gt; element to a corresponding <code>IObjectDefinition</code>.
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class PauseCommandNodeParser extends AbstractTaskDefinitionParser {

		/**
		 * Creates a new <code>PauseNodeParser</code> instance.
		 */
		public function PauseCommandNodeParser() {
			super();
		}
		
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(PauseCommand);
			builder.addConstructorArgValue(uint(node.attribute(TaskNamespaceHandler.DURATION_ATTR)));
			return builder.objectDefinition;
		}
		
	}
}