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
package org.springextensions.actionscript.context.impl.xml {

	import flash.display.DisplayObject;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.XMLObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.INamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.StageProcessingNamespaceHandler;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistryAware;


	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class XMLApplicationContext extends DefaultApplicationContext {

		public function XMLApplicationContext(configLocation:*=null, parent:IApplicationContext=null, rootViews:Vector.<DisplayObject>=null, objFactory:IObjectFactory=null) {
			super(parent, rootViews, objFactory);
			var provider:XMLObjectDefinitionsProvider = new XMLObjectDefinitionsProvider((configLocation != null) ? [configLocation] : null);
			addDefinitionProvider(provider);
		}

		public function addLocation(location:*):XMLObjectDefinitionsProvider {
			return XMLObjectDefinitionsProvider(definitionProviders[0]).addLocation(location);
		}

		public function addLocations(locations:Array):XMLObjectDefinitionsProvider {
			return XMLObjectDefinitionsProvider(definitionProviders[0]).addLocations(locations);
		}

		public function addNamespaceHandler(namespaceHandler:INamespaceHandler):XMLObjectDefinitionsProvider {
			return XMLObjectDefinitionsProvider(definitionProviders[0]).addNamespaceHandler(namespaceHandler);
		}

		public function addNamespaceHandlers(namespaceHandlers:Vector.<INamespaceHandler>):XMLObjectDefinitionsProvider {
			return XMLObjectDefinitionsProvider(definitionProviders[0]).addNamespaceHandlers(namespaceHandlers);
		}
	}
}
