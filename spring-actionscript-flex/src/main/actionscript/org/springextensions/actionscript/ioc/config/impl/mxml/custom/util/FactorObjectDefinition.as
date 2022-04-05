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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.util {

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ICustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MXMLObjectDefinition;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.customconfiguration.FactoryObjectCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FactorObjectDefinition extends MXMLObjectDefinition implements ICustomObjectDefinitionComponent {

		private static const logger:ILogger = getClassLogger(FactorObjectDefinition);

		/**
		 * Creates a new <code>FactorObjectDefinition</code> instance.
		 */
		public function FactorObjectDefinition() {
			super();
		}

		/**
		 *
		 * @param applicationContext
		 * @param objectDefinitions
		 */
		public function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			if (!isInitialized) {
				initializeComponent(applicationContext, defaultDefinition);
			}
			definition.customConfiguration = new FactoryObjectCustomConfigurator(definition.factoryMethod);
			definition.factoryMethod = "";
			definition.factoryObjectName = "";
			objectDefinitions[this.id] = definition;
			logger.debug("Created factory object definition for {0} with factory method {1}", [definition.className, definition.factoryMethod]);
		}

	}
}
