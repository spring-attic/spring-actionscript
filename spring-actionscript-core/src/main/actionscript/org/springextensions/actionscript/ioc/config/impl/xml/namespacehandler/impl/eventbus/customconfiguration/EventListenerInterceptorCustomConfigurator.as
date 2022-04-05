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

	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventListenerInterceptorCustomConfigurator extends AbstractInterceptorCustomConfigurator {

		private static const logger:ILogger = getClassLogger(EventListenerInterceptorCustomConfigurator);

		/**
		 *
		 * @param eventBusUserRegistry
		 * @param eventName
		 * @param eventClass
		 * @param topics
		 * @param topicProperties
		 */
		public function EventListenerInterceptorCustomConfigurator(eventBusUserRegistry:IEventBusUserRegistry, eventName:String=null, eventClass:Class=null, topics:Vector.<String>=null, topicProperties:Vector.<String>=null) {
			super(eventBusUserRegistry, eventName, eventClass, topics, topicProperties);
		}

		/**
		 *
		 * @param instance
		 * @param objectDefinition
		 */
		override public function execute(instance:*, objectDefinition:IObjectDefinition):* {
			logger.debug("Executing...");
			if ((eventName == null) && (eventClass == null)) {
				addListenerInterceptors(instance);
				logger.debug("Adding listener interceptors");
			} else {
				if (eventName != null) {
					addEventListenerInterceptors(instance);
					logger.debug("Adding event listener interceptors");
				}
				if (eventClass != null) {
					addEventClassListenerInterceptors(instance);
					logger.debug("Adding eventclass listener interceptors");
				}
			}
		}

		override public function toString():String {
			return "EventListenerInterceptorCustomConfigurator{eventName:\"" + eventName + "\", eventClass:" + eventClass + ", topics:[" + topics + "], topicProperties:[" + topicProperties + "]}";
		}

		private function addListenerInterceptors(instance:IEventListenerInterceptor):void {
			if ((topics == null) && (topicProperties == null)) {
				eventBusUserRegistry.addListenerInterceptor(instance);
			} else {
				var topic:String;
				for each (topic in topics) {
					eventBusUserRegistry.addListenerInterceptor(instance, topic);
				}
				for each (topic in topicProperties) {
					eventBusUserRegistry.addListenerInterceptor(instance, instance[topic]);
				}
			}
		}

		private function addEventClassListenerInterceptors(instance:IEventListenerInterceptor):void {
			if ((topics == null) && (topicProperties == null)) {
				eventBusUserRegistry.addEventClassListenerInterceptor(eventClass, instance);
			} else {
				var topic:String;
				for each (topic in topics) {
					eventBusUserRegistry.addEventClassListenerInterceptor(eventClass, instance, topic);
				}
				for each (topic in topicProperties) {
					eventBusUserRegistry.addEventClassListenerInterceptor(eventClass, instance, instance[topic]);
				}
			}
		}

		private function addEventListenerInterceptors(instance:IEventListenerInterceptor):void {
			if ((topics == null) && (topicProperties == null)) {
				eventBusUserRegistry.addEventListenerInterceptor(eventName, instance);
			} else {
				var topic:String;
				for each (topic in topics) {
					eventBusUserRegistry.addEventListenerInterceptor(eventName, instance, topic);
				}
				for each (topic in topicProperties) {
					eventBusUserRegistry.addEventListenerInterceptor(eventName, instance, instance[topic]);
				}
			}
		}

	}
}
