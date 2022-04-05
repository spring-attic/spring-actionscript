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
package org.springextensions.actionscript.ioc.config.impl.metadata.customscanner.eventbus {

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Metadata;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.config.impl.metadata.customscanner.AbstractCustomConfigurationClassScanner;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.RouteEventsCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class RouteEventsInterceptorCustomConfigurationClassScanner extends AbstractCustomConfigurationClassScanner {

		public static const ROUTE_EVENTS_NAME:String = "RouteEvents";
		public static const EVENT_NAMES_ARG:String = "eventNames";
		public static const TOPICS_ARG:String = "topics";
		public static const TOPIC_PROPERTIES_ARG:String = "topicProperties";
		private static const LOGGER:ILogger = getClassLogger(RouteEventsInterceptorCustomConfigurationClassScanner);

		/**
		 * Creates a new <code>RouteEventsInterceptorCustomConfigurationClassScanner</code> instance.
		 */
		public function RouteEventsInterceptorCustomConfigurationClassScanner() {
			super();
			metadataNames[metadataNames.length] = ROUTE_EVENTS_NAME;
		}

		override public function execute(metadata:Metadata, objectName:String, objectDefinition:IObjectDefinition, objectDefinitionsRegistry:IObjectDefinitionRegistry, applicationContext:IApplicationContext):void {
			var eventBusUserRegistry:IEventBusUserRegistry;
			if (applicationContext is IEventBusUserRegistryAware) {
				eventBusUserRegistry = (applicationContext as IEventBusUserRegistryAware).eventBusUserRegistry;
			}
			var customConfiguration:Vector.<Object> = ContextUtils.getCustomConfigurationForObjectName(objectName, applicationContext.objectDefinitionRegistry);
			var eventNames:Vector.<String> = ContextUtils.getCommaSeparatedArgument(metadata, EVENT_NAMES_ARG);
			var topics:Vector.<String> = ContextUtils.getCommaSeparatedArgument(metadata, TOPICS_ARG);
			var topicProperties:Vector.<String> = ContextUtils.getCommaSeparatedArgument(metadata, TOPIC_PROPERTIES_ARG);
			var configurator:RouteEventsCustomConfigurator = new RouteEventsCustomConfigurator(eventBusUserRegistry, eventNames, topics, topicProperties);
			customConfiguration[customConfiguration.length] = configurator;
			applicationContext.objectDefinitionRegistry.registerCustomConfiguration(objectName, customConfiguration);
			LOGGER.debug("Parsed custom configurator: {0}", [customConfiguration]);
		}

	}
}
