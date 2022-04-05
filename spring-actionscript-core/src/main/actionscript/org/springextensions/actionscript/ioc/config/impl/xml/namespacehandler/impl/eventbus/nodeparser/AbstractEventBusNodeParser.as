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
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.IObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_eventbus;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractEventBusNodeParser implements IObjectDefinitionParser, IApplicationDomainAware {

		public static const INSTANCE_ATTRIBUTE_NAME:String = "instance";
		public static const EVENT_NAMES_ATTRIBUTE_NAME:String = "event-names";
		public static const EVENT_NAME_ATTRIBUTE_NAME:String = "event-name";
		public static const METHOD_NAME_ATTRIBUTE_NAME:String = "method-name";
		public static const EVENT_CLASS_ATTRIBUTE_NAME:String = "event-class";
		public static const TOPICS_ATTRIBUTE_NAME:String = "topics";
		public static const TOPIC_PROPERTIES_ATTRIBUTE_NAME:String = "topic-properties";
		public static const PROPERTIES_ATTRIBUTE_NAME:String = "properties";
		public static const INTERCEPTION_CONFIGURATION_ATTRIBUTE_NAME:String = "interception-configuration";
		public static const COMMA:String = ',';
		public static const SPACE:String = ' ';
		public static const EMPTY:String = '';
		private static const logger:ILogger = getClassLogger(AbstractEventBusNodeParser);

		private var _objectDefinitionRegistry:IObjectDefinitionRegistry;
		private var _eventBusUserRegistry:IEventBusUserRegistry;
		private var _applicationDomain:ApplicationDomain;

		use namespace spring_actionscript_eventbus;

		/**
		 * Creates a new <code>AbstractEventBusNodeParser</code> instance.
		 * @param objectDefinitionRegistry
		 * @param eventBusUserRegistry
		 */
		public function AbstractEventBusNodeParser(objectDefinitionRegistry:IObjectDefinitionRegistry, eventBusUserRegistry:IEventBusUserRegistry, applicationDomain:ApplicationDomain) {
			super();
			_objectDefinitionRegistry = objectDefinitionRegistry;
			_eventBusUserRegistry = eventBusUserRegistry;
			_applicationDomain = applicationDomain;
		}

		/**
		 *
		 */
		public function get objectDefinitionRegistry():IObjectDefinitionRegistry {
			return _objectDefinitionRegistry;
		}

		/**
		 *
		 * @return
		 */
		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return _eventBusUserRegistry;
		}

		/**
		 *
		 * @param node
		 * @param context
		 * @return
		 */
		public function parse(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			throw new IllegalOperationError("Not implemented in base class");
		}

		/**
		 *
		 * @param node
		 * @return
		 */
		protected function getEventNames(node:XML):Vector.<String> {
			var result:Vector.<String>;
			if (node.attribute(EVENT_NAMES_ATTRIBUTE_NAME).length() > 0) {
				result = new Vector.<String>();
				var arr:Array = String(node.attribute(EVENT_NAMES_ATTRIBUTE_NAME)[0]).split(SPACE).join(EMPTY).split(COMMA);
				for each (var str:String in arr) {
					result[result.length] = str;
					logger.debug("Parsed event name: {0}", [str]);
				}
			}
			return result;
		}

		/**
		 *
		 * @param node
		 * @param attributeName
		 * @return
		 */
		public function commaSeparatedAttributeNameToStringVector(node:XML, attributeName:String):Vector.<String> {
			if (node.attribute(attributeName).length() > 0) {
				var parts:Array = String(node.attribute(attributeName)[0]).split(SPACE).join(EMPTY).split(COMMA);
				var result:Vector.<String> = new Vector.<String>();
				for each (var name:String in parts) {
					result[result.length] = name;
					logger.debug("Parsed value: {0}", [name]);
				}
				return result;
			}
			return null;
		}

		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

	}
}
