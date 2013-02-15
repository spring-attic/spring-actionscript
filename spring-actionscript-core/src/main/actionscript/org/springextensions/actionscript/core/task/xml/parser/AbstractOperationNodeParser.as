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
	import org.springextensions.actionscript.core.command.GenericOperationCommand;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class AbstractOperationNodeParser extends AbstractTaskDefinitionParser {

		protected var builder:ObjectDefinitionBuilder;

		public function AbstractOperationNodeParser() {
			super();
		}

		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			builder = ObjectDefinitionBuilder.objectDefinitionForClass(GenericOperationCommand);
			builder.objectDefinition.isLazyInit = true;
			return builder.objectDefinition;
		}

	}
}