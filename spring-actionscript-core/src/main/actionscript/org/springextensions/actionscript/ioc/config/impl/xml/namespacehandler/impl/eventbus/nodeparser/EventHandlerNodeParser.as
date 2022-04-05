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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.EventBusNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventHandlerCustomConfigurator;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_eventbus;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.util.ContextUtils;

	use namespace spring_actionscript_eventbus;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventHandlerNodeParser extends AbstractEventBusNodeParser {

		private static const logger:ILogger = getClassLogger(EventHandlerNodeParser);

		/**
		 * Creates a new <code>EventHandlerNodeParser</code> instance.
		 * @param objectDefinitionRegistry
		 * @param eventBusUserRegistry
		 */
		public function EventHandlerNodeParser(objectDefinitionRegistry:IObjectDefinitionRegistry, eventBusUserRegistry:IEventBusUserRegistry, applicationDomain:ApplicationDomain) {
			super(objectDefinitionRegistry, eventBusUserRegistry, applicationDomain);
		}

		override public function parse(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var ref:String = String(node.attribute(INSTANCE_ATTRIBUTE_NAME)[0]);
			logger.debug("Parsing event handler XML for object definition '{0}'", [ref]);
			var customConfiguration:Vector.<Object> = ContextUtils.getCustomConfigurationForObjectName(ref, objectDefinitionRegistry);
			createConfigurations(customConfiguration, node);
			objectDefinitionRegistry.registerCustomConfiguration(ref, customConfiguration);
			return null;
		}

		private function createConfigurations(customConfiguration:Vector.<Object>, node:XML):void {
			var QN:QName = new QName(spring_actionscript_eventbus, EventBusNamespaceHandler.EVENT_HANDLER_METHOD_ELEMENT_NAME);
			for each (var child:XML in node.descendants(QN)) {
				var eventName:String = null;
				var eventClass:Class = null;
				var methodName:String = String(child.attribute(AbstractEventBusNodeParser.METHOD_NAME_ATTRIBUTE_NAME)[0]);
				if (child.attribute(AbstractEventBusNodeParser.EVENT_NAME_ATTRIBUTE_NAME).length() > 0) {
					eventName = String(child.attribute(AbstractEventBusNodeParser.EVENT_NAME_ATTRIBUTE_NAME)[0]);
				}
				if (child.attribute(AbstractEventBusNodeParser.EVENT_CLASS_ATTRIBUTE_NAME).length() > 0) {
					var clsName:String = String(child.attribute(AbstractEventBusNodeParser.EVENT_CLASS_ATTRIBUTE_NAME)[0]);
					eventClass = ClassUtils.forName(clsName, applicationDomain);
				}
				var topics:Vector.<String> = this.commaSeparatedAttributeNameToStringVector(child, TOPICS_ATTRIBUTE_NAME);
				var topicProperties:Vector.<String> = this.commaSeparatedAttributeNameToStringVector(child, TOPIC_PROPERTIES_ATTRIBUTE_NAME);
				var properties:Vector.<String> = this.commaSeparatedAttributeNameToStringVector(child, PROPERTIES_ATTRIBUTE_NAME);
				var configurator:EventHandlerCustomConfigurator = new EventHandlerCustomConfigurator(eventBusUserRegistry, methodName, eventName, eventClass, properties, topics, topicProperties);
				logger.debug("Added new EventHandlerCustomConfigurator: {0}", [configurator]);
				customConfiguration[customConfiguration.length] = configurator;
			}
		}

	}
}
