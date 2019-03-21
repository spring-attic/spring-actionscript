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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ICustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ISpringConfigurationComponent;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.RouteEventsCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventRouterConfiguration extends EventDispatcher implements IMXMLObject, ICustomObjectDefinitionComponent {
		public static const DOCUMENT_CHANGED_EVENT:String = "documentChanged";
		public static const EVENTNAMES_CHANGED_EVENT:String = "eventNamesChanged";
		public static const ID_CHANGED_EVENT:String = "idChanged";
		public static const TOPICPROPERTIES_CHANGED_EVENT:String = "topicPropertiesChanged";
		public static const TOPICS_CHANGED_EVENT:String = "topicsChanged";

		public static const logger:ILogger = getClassLogger(EventRouterConfiguration);

		/**
		 * Creates a new <code>EventRouterConfiguration</code> instance.
		 */
		public function EventRouterConfiguration(target:IEventDispatcher=null) {
			super(target);
		}

		private var _document:Object;

		[Bindable(event="documentChanged")]
		public function get document():Object {
			return _document;
		}

		public function set document(value:Object):void {
			if (_document != value) {
				_document = value;
				dispatchEvent(new Event(DOCUMENT_CHANGED_EVENT));
			}
		}
		private var _eventBusUserRegistry:IEventBusUserRegistry;

		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return _eventBusUserRegistry;
		}

		public function set eventBusUserRegistry(value:IEventBusUserRegistry):void {
			_eventBusUserRegistry = value;
		}
		private var _eventNames:String;

		[Bindable(event="eventNamesChanged")]
		public function get eventNames():String {
			return _eventNames;
		}

		public function set eventNames(value:String):void {
			if (_eventNames != value) {
				_eventNames = value;
				dispatchEvent(new Event(EVENTNAMES_CHANGED_EVENT));
			}
		}
		private var _id:String;

		[Bindable(event="idChanged")]
		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			if (_id != value) {
				_id = value;
				dispatchEvent(new Event(ID_CHANGED_EVENT));
			}
		}
		private var _topicProperties:String;

		[Bindable(event="topicPropertiesChanged")]
		public function get topicProperties():String {
			return _topicProperties;
		}

		public function set topicProperties(value:String):void {
			if (_topicProperties != value) {
				_topicProperties = value;
				dispatchEvent(new Event(TOPICPROPERTIES_CHANGED_EVENT));
			}
		}
		private var _topics:String;

		[Bindable(event="topicsChanged")]
		public function get topics():String {
			return _topics;
		}

		public function set topics(value:String):void {
			if (_topics != value) {
				_topics = value;
				dispatchEvent(new Event(TOPICS_CHANGED_EVENT));
			}
		}

		public function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			logger.debug("Executing EventRouterConfiguration...");
			if (parentId == null) {
				return;
			}
			if (applicationContext is IEventBusUserRegistryAware) {
				eventBusUserRegistry = (applicationContext as IEventBusUserRegistryAware).eventBusUserRegistry;
			} else {
				return;
			}
			var objectName:String = parentId;
			var customConfiguration:Vector.<Object> = ContextUtils.getCustomConfigurationForObjectName(objectName, applicationContext.objectDefinitionRegistry);
			var eventNames:Vector.<String> = ContextUtils.commaSeparatedPropertyValueToStringVector(eventNames);
			var topics:Vector.<String> = ContextUtils.commaSeparatedPropertyValueToStringVector(topics);
			var topicProperties:Vector.<String> = ContextUtils.commaSeparatedPropertyValueToStringVector(topicProperties);
			var configurator:RouteEventsCustomConfigurator = new RouteEventsCustomConfigurator(eventBusUserRegistry, eventNames, topics, topicProperties);
			customConfiguration[customConfiguration.length] = configurator;
			applicationContext.objectDefinitionRegistry.registerCustomConfiguration(objectName, customConfiguration);
		}

		public function initialized(document:Object, id:String):void {
			_document = document;
			_id = id;
		}
	}
}
