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
package org.springextensions.actionscript.context.config.impl.xml {

	import mx.binding.utils.BindingUtils;

	import org.springextensions.actionscript.ioc.config.impl.xml.XMLObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.EventBusNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.MessagingNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.rpc.RPCNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.StageProcessingNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.FlexTaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.UtilNamespaceHandler;


	/**
	 * <code>IXMLConfigurationPackage</code> that adds the <code>StageProcessingNamespaceHandler</code>, <code>EventBusNamespacehandler</code>, <code>FlexTaskNamespaceHandler</code>,
	 * <code>UtilNamespaceHandler</code>, <code>MessagingNamespaceHandler</code> and <code>RPCNamespaceHandler</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FullFlexXMLConfigurationPackage extends FullXMLConfigurationPackage {

		{
			BindingUtils;
		}

		/**
		 * Adds the <code>StageProcessingNamespaceHandler</code>, <code>EventBusNamespacehandler</code>, <code>FlexTaskNamespaceHandler</code>,
		 * <code>UtilNamespaceHandler</code>, <code>MessagingNamespaceHandler</code> and <code>RPCNamespaceHandler</code>.
		 * @param xmlProvider
		 */
		override protected function addNamespaceHandlers(xmlProvider:XMLObjectDefinitionsProvider):void {
			xmlProvider.addNamespaceHandler(new StageProcessingNamespaceHandler());
			xmlProvider.addNamespaceHandler(new EventBusNamespaceHandler());
			xmlProvider.addNamespaceHandler(new FlexTaskNamespaceHandler());
			xmlProvider.addNamespaceHandler(new UtilNamespaceHandler());
			xmlProvider.addNamespaceHandler(new MessagingNamespaceHandler());
			xmlProvider.addNamespaceHandler(new RPCNamespaceHandler());
		}

	}
}
