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

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventInterceptorCustomConfigurator extends AbstractInterceptorCustomConfigurator {

		private static const logger:ILogger = getClassLogger(EventInterceptorCustomConfigurator);

		/**
		 * Creates a new <code>EventInterceptorCustomConfigurator</code> instance.
		 * @param eventBusUserRegistry
		 * @param eventName
		 * @param eventClass
		 * @param topics
		 * @param topicProperties
		 */
		public function EventInterceptorCustomConfigurator(eventBusUserRegistry:IEventBusUserRegistry, eventName:String=null, eventClass:Class=null, topics:Vector.<String>=null, topicProperties:Vector.<String>=null) {
			super(eventBusUserRegistry, eventName, eventClass, topics, topicProperties);
		}

		/**
		 *
		 * @param instance
		 * @param objectDefinition
		 */
		override public function execute(instance:*, objectDefinition:IObjectDefinition):* {
			logger.debug("Exectuting...");
			if ((eventName == null) && (eventClass == null)) {
				logger.debug("Adding interceptors");
				addInterceptors(instance);
			} else {
				if (eventName != null) {
					logger.debug("Adding event interceptors");
					addEventInterceptors(instance);
				}
				if (eventClass != null) {
					logger.debug("Adding event class interceptors");
					addEventClassInterceptors(instance);
				}
			}
		}

		override public function toString():String {
			return "EventInterceptorCustomConfigurator{eventName:\"" + eventName + "\", eventClass:" + eventClass + ", topics:[" + topics + "], topicProperties:[" + topicProperties + "]}";
		}

		private function addInterceptors(instance:IEventInterceptor):void {
			if ((topics == null) && (topicProperties == null)) {
				eventBusUserRegistry.addInterceptor(instance);
			} else {
				var topic:String;
				for each (topic in topics) {
					eventBusUserRegistry.addInterceptor(instance, topic);
				}
				for each (topic in topicProperties) {
					eventBusUserRegistry.addInterceptor(instance, instance[topic]);
				}
			}
		}

		private function addEventClassInterceptors(instance:IEventInterceptor):void {
			if ((topics == null) && (topicProperties == null)) {
				eventBusUserRegistry.addEventClassInterceptor(eventClass, instance);
			} else {
				var topic:String;
				for each (topic in topics) {
					eventBusUserRegistry.addEventClassInterceptor(eventClass, instance, topic);
				}
				for each (topic in topicProperties) {
					eventBusUserRegistry.addEventClassInterceptor(eventClass, instance, instance[topic]);
				}
			}
		}

		private function addEventInterceptors(instance:IEventInterceptor):void {
			if ((topics == null) && (topicProperties == null)) {
				eventBusUserRegistry.addEventInterceptor(eventName, instance);
			} else {
				var topic:String;
				for each (topic in topics) {
					eventBusUserRegistry.addEventInterceptor(eventName, instance, topic);
				}
				for each (topic in topicProperties) {
					eventBusUserRegistry.addEventInterceptor(eventName, instance, instance[topic]);
				}
			}
		}
	}
}
