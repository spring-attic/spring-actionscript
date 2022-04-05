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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus {
	import flash.system.ApplicationDomain;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventHandlerNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventInterceptorNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventListenerInterceptorNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventRouterNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.NullReturningNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_eventbus;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventBusNamespaceHandler extends AbstractNamespaceHandler {

		public static const EVENT_HANDLER_ELEMENT_NAME:String = "event-handler";
		public static const EVENT_HANDLER_METHOD_ELEMENT_NAME:String = "event-handler-method";
		public static const EVENT_INTERCEPTOR_FIELD_NAME:String = "event-interceptor";
		public static const EVENT_LISTENER_INTERCEPTOR_FIELD_NAME:String = "event-listener-interceptor";
		public static const EVENT_ROUTER_ELEMENT_NAME:String = "event-router";
		public static const ROUTING_CONFIGURATION_ELEMENT_NAME:String = "routing-configuration";

		private var _initialized:Boolean = false;

		/**
		 * Creates a new <code>EventBusNamespaceHandler</code> instance.
		 */
		public function EventBusNamespaceHandler() {
			super(spring_actionscript_eventbus);
		}

		override public function parse(node:XML, parser:IXMLObjectDefinitionsParser):IObjectDefinition {
			if (!_initialized) {
				initialize(parser);
			}
			return super.parse(node, parser);
		}

		private function initialize(parser:IXMLObjectDefinitionsParser):void {
			var context:IApplicationContext = parser.applicationContext;
			var objectDefinitionRegistry:IObjectDefinitionRegistry = context.objectDefinitionRegistry;
			var applicationDomain:ApplicationDomain = context.applicationDomain;
			var eventBusUserRegistry:IEventBusUserRegistry = (context is IEventBusUserRegistryAware) ? IEventBusUserRegistryAware(context).eventBusUserRegistry : null;

			registerObjectDefinitionParser(EVENT_ROUTER_ELEMENT_NAME, new EventRouterNodeParser(objectDefinitionRegistry, eventBusUserRegistry, applicationDomain));
			registerObjectDefinitionParser(EVENT_HANDLER_ELEMENT_NAME, new EventHandlerNodeParser(objectDefinitionRegistry, eventBusUserRegistry, applicationDomain));
			registerObjectDefinitionParser(EVENT_HANDLER_METHOD_ELEMENT_NAME, new NullReturningNodeParser());
			registerObjectDefinitionParser(EVENT_INTERCEPTOR_FIELD_NAME, new EventInterceptorNodeParser(objectDefinitionRegistry, eventBusUserRegistry, applicationDomain));
			registerObjectDefinitionParser(EVENT_LISTENER_INTERCEPTOR_FIELD_NAME, new EventListenerInterceptorNodeParser(objectDefinitionRegistry, eventBusUserRegistry, applicationDomain));
			registerObjectDefinitionParser(ROUTING_CONFIGURATION_ELEMENT_NAME, new NullReturningNodeParser());

			_initialized = true;
		}

	}
}
