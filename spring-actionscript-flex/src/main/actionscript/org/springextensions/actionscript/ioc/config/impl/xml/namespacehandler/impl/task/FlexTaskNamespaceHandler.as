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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task {
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadModuleNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadResourceModuleNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadStyleModuleNodeParser;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FlexTaskNamespaceHandler extends TaskNamespaceHandler {

		public function FlexTaskNamespaceHandler() {
			super();
			registerObjectDefinitionParser(LOAD_MODULE_ELEMENT, new LoadModuleNodeParser());
			registerObjectDefinitionParser(LOAD_RESOURCE_MODULE_ELEMENT, new LoadResourceModuleNodeParser());
			registerObjectDefinitionParser(LOAD_STYLE_MODULE_ELEMENT, new LoadStyleModuleNodeParser());
		}

	}
}
