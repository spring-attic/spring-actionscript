/*
 * Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.context.config.impl.xml {

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.config.impl.FullConfigurationPackage;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.xml.XMLObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.EventBusNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.StageProcessingNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.UtilNamespaceHandler;

	/**
	 * <code>IXMLConfigurationPackage</code> that adds the <code>StageProcessingNamespaceHandler</code>, <code>EventBusNamespacehandler</code>, <code>TaskNamespaceHandler</code> and
	 * <code>UtilNamespaceHandler</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FullXMLConfigurationPackage extends FullConfigurationPackage {

		public function FullXMLConfigurationPackage() {
			super();
		}

		/**
		 *
		 * @param applicationContext
		 */
		override public function execute(applicationContext:IApplicationContext):void {
			super.execute(applicationContext);
			for each (var definitionProvider:IObjectDefinitionsProvider in applicationContext.definitionProviders) {
				if (definitionProvider is XMLObjectDefinitionsProvider) {
					var xmlProvider:XMLObjectDefinitionsProvider = XMLObjectDefinitionsProvider(definitionProvider);
					addNamespaceHandlers(xmlProvider);
					break;
				}
			}
		}

		/**
		 * Adds the <code>StageProcessingNamespaceHandler</code>, <code>EventBusNamespacehandler</code>, <code>TaskNamespaceHandler</code> and
		 * <code>UtilNamespaceHandler</code>.
		 * @param xmlProvider
		 */
		protected function addNamespaceHandlers(xmlProvider:XMLObjectDefinitionsProvider):void {
			xmlProvider.addNamespaceHandler(new StageProcessingNamespaceHandler());
			xmlProvider.addNamespaceHandler(new EventBusNamespaceHandler());
			xmlProvider.addNamespaceHandler(new TaskNamespaceHandler());
			xmlProvider.addNamespaceHandler(new UtilNamespaceHandler());
		}

	}
}
