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
package org.springextensions.actionscript.eventbus.process {

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Method;
	import org.springextensions.actionscript.metadata.IMetadataDestroyer;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventHandlerMetadataDestroyer extends EventHandlerMetadataProcessor implements IMetadataDestroyer {

		private static var logger:ILogger = getClassLogger(EventHandlerMetadataDestroyer);

		/**
		 * Creates a new <code>EventHandlerMetadataDestroyer</code> instance.
		 */
		public function EventHandlerMetadataDestroyer() {
			super();
			metadataNames[metadataNames.length] = EventHandlerMetadataProcessor.EVENT_HANDLER_METADATA;
		}

		override protected function processMetaData(object:Object, method:Method, metaData:Metadata):void {
			var className:String = getEventClassName(metaData);
			var properties:Vector.<String> = getProperties(metaData);
			var topics:Array = getTopics(metaData, object);
			topics = (topics.length > 0) ? topics : null;
			var useWeak:Boolean = getUseWeak(metaData);
			var proxy:EventHandlerProxy = new EventHandlerProxy(object, method, properties);
			var topic:Object;
			proxy.applicationDomain = objFactory.applicationDomain;

			if (className == null) {
				var eventName:String = getEventName(method, metaData);
				if (topics == null) {
					eventBusUserRegistry.removeEventListenerProxy(eventName, proxy);
					logger.debug("Removed event handler for '{0}' on the EventBus", [eventName]);
				} else {
					for each (topic in topics) {
						eventBusUserRegistry.removeEventListenerProxy(eventName, proxy, topic);
						logger.debug("Removed event handler for '{0}' on the EventBus for topic {1}", [eventName, topic]);
					}
				}
			} else {
				var cls:Class = ClassUtils.forName(className, objFactory.applicationDomain);
				if (topics == null) {
					eventBusUserRegistry.removeEventClassListenerProxy(cls, proxy);
					logger.debug("Removed event class handler for '{0}' on the EventBus", [className]);
				} else {
					for each (topic in topics) {
						eventBusUserRegistry.removeEventClassListenerProxy(cls, proxy, topic);
						logger.debug("Removed event class handler for '{0}' on the EventBus for topic {1}", [eventName, topic]);
					}
				}
			}
		}

	}
}
