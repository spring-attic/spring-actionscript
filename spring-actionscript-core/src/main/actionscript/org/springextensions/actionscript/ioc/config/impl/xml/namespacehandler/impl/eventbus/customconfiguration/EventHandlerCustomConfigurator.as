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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration {
	import flash.errors.IllegalOperationError;
	
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.MethodInvoker;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.process.EventHandlerProxy;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventHandlerCustomConfigurator extends AbstractEventBusCustomConfigurator {

		/**
		 * Creates a new <code>EventHandlerCustomConfigurator</code>
		 * @param eventBusUserRegistry
		 * @param eventHandlerMethodName
		 * @param eventName
		 * @param eventClass
		 * @param properties
		 * @param topics
		 * @param topicProperties
		 */
		public function EventHandlerCustomConfigurator(eventBusUserRegistry:IEventBusUserRegistry, eventHandlerMethodName:String, eventName:String=null, eventClass:Class=null, properties:Vector.<String>=null, topics:Vector.<String>=null, topicProperties:Vector.<String>=null) {
			super(eventBusUserRegistry);
			_eventHandlerMethodName = eventHandlerMethodName;
			_eventName = eventName;
			_eventClass = eventClass;
			_properties = properties;
			_topics = topics;
			_topicProperties = topicProperties;
		}

		private var _eventClass:Class;
		private var _eventHandlerMethodName:String;
		private var _eventName:String;
		private var _properties:Vector.<String>;
		private var _topicProperties:Vector.<String>;
		private var _topics:Vector.<String>;

		/**
		 *
		 */
		public function get eventClass():Class {
			return _eventClass;
		}

		/**
		 *
		 */
		public function get eventHandlerMethodName():String {
			return _eventHandlerMethodName;
		}

		/**
		 *
		 */
		public function get eventName():String {
			return _eventName;
		}

		/**
		 *
		 */
		public function get properties():Vector.<String> {
			return _properties;
		}

		/**
		 *
		 */
		public function get topicProperties():Vector.<String> {
			return _topicProperties;
		}

		/**
		 *
		 */
		public function get topics():Vector.<String> {
			return _topics;
		}

		/**
		 *
		 * @param instance
		 * @param objectDefinition
		 */
		override public function execute(instance:*, objectDefinition:IObjectDefinition):* {
			var type:Type = Type.forClass(objectDefinition.clazz);
			var method:Method = type.getMethod(_eventHandlerMethodName);
			if (method == null) {
				throw new IllegalOperationError("No method with name '" + _eventHandlerMethodName + "' found on class " + objectDefinition.clazz);
			}
			var proxy:EventHandlerProxy = new EventHandlerProxy(instance, method, _properties);
			var topic:String;
			if (((_topics == null) || (_topics.length == 0)) && ((_topicProperties == null) || (_topicProperties.length == 0))) {
				addEventBusListener(eventBusUserRegistry, _eventName, _eventClass, proxy);
			}
			for each (topic in _topics) {
				addEventBusListener(eventBusUserRegistry, _eventName, _eventClass, proxy, topic);
			}
			for each (topic in _topicProperties) {
				var topicInstance:* = instance[topic];
				if (topicInstance != null) {
					addEventBusListener(eventBusUserRegistry, _eventName, _eventClass, proxy, topicInstance);
				}
			}
		}

		public function toString():String {
			return "EventHandlerCustomConfigurator{eventClass:" + _eventClass + ", eventHandlerMethodName:\"" + _eventHandlerMethodName + "\", eventName:\"" + _eventName + "\", properties:[" + _properties + "], topicProperties:[" + _topicProperties + "], topics:[" + _topics + "]}";
		}

		private function addEventBusListener(registry:IEventBusUserRegistry, name:String, clazz:Class, proxy:EventHandlerProxy, topic:*=null):void {
			if (name != null) {
				registry.addEventListenerProxy(name, proxy, false, topic);
			}
			if (clazz != null) {
				registry.addEventClassListenerProxy(clazz, proxy, false, topic);
			}
		}

	}
}
