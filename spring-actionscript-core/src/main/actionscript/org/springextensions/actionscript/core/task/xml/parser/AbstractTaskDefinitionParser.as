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

	import org.springextensions.actionscript.core.task.command.PauseCommand;
	import org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler;
	import org.springextensions.actionscript.core.task.xml.spring_actionscript_task;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.factory.xml.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	use namespace spring_actionscript_task;

	/**
	 * Base class for definition parsers dealing with task elements
	 * @author Roland
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class AbstractTaskDefinitionParser extends AbstractObjectDefinitionParser {

		/**
		 * Creates a new <code>AbstractTaskDefinitionParser</code> instance.
		 */
		public function AbstractTaskDefinitionParser() {
			super();
		}

	}
}