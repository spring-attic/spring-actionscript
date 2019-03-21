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
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.AbstractTaskDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 * Internally used for nodes that are converted by another node parser but will still be
	 * interated over the main parser. This will simply return null so that its result will be ignored.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class NullReturningNodeParser extends AbstractTaskDefinitionParser {

		/**
		 * Creates a new <code>NullReturningNodeParser</code> instance.
		 */
		public function NullReturningNodeParser() {
			super();
		}

		/**
		 * Does nothing, only returns null
		 * @param node argument will be ignored
		 * @param context argument will be ingored
		 * @return null
		 */
		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			return null;
		}

	}
}
