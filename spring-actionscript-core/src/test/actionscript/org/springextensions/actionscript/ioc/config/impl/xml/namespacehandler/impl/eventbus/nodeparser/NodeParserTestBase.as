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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser {
	import mockolate.runner.MockolateRule;

	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;


	public class NodeParserTestBase {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var objectDefinitionRegistry:IObjectDefinitionRegistry;
		[Mock]
		public var eventBusUserRegistry:IEventBusUserRegistry;
		[Mock]
		public var xmlParser:IXMLObjectDefinitionsParser;
		[Mock]
		public var objectDefinition:IObjectDefinition;

		public function NodeParserTestBase() {
			super();
		}

	}
}
