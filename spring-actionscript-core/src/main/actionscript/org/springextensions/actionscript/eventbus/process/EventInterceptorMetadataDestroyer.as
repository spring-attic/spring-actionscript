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

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.metadata.IMetadataDestroyer;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventInterceptorMetadataDestroyer extends EventInterceptorMetadataProcessor implements IMetadataDestroyer {

		private static var logger:ILogger = getClassLogger(EventInterceptorMetadataDestroyer);

		/**
		 * Creates a new <code>EventInterceptorMetadataDestroyer</code> instance.
		 */
		public function EventInterceptorMetadataDestroyer() {
			super();
			metadataNames[metadataNames.length] = EventInterceptorMetadataProcessor.EVENT_INTERCEPTOR_METADATA_NAME;
		}

		/**
		 *
		 * @param instance
		 * @param type
		 * @param metaData
		 */
		override protected function processMetaData(instance:Object, type:Type, metaData:Metadata):void {
			var interceptor:IEventInterceptor = IEventInterceptor(instance);
			var className:String = getEventInterceptClassName(metaData);
			var topics:Array = getTopics(metaData, interceptor);
			var topic:Object;

			if (className == null) {
				var eventName:String = getEventName(metaData);
				if (eventName == null) {
					if ((topics == null) || (topics.length == 0)) {
						logger.debug("Removing global event interceptor");
						eventBusUserRegistry.removeInterceptor(interceptor);
					} else {
						for each (topic in topics) {
							logger.debug("Removing global event interceptor for topic '{0}'", [topic]);
							eventBusUserRegistry.removeInterceptor(interceptor, topic);
						}
					}
				} else {
					if ((topics == null) || (topics.length == 0)) {
						logger.debug("Removing event interceptor for event name '{0}'", [eventName]);
						eventBusUserRegistry.removeEventInterceptor(eventName, interceptor);
					} else {
						for each (topic in topics) {
							logger.debug("Removing event interceptor for event name '{0}' and topic '{1}'", [eventName, topic]);
							eventBusUserRegistry.removeEventInterceptor(eventName, interceptor, topic);
						}
					}
				}
			} else {
				var clazz:Class = ClassUtils.forName(className, objFactory.applicationDomain);
				if ((topics == null) || (topics.length == 0)) {
					logger.debug("Removing event interceptor for event class {0}", [clazz]);
					eventBusUserRegistry.removeEventClassInterceptor(clazz, interceptor);
				} else {
					for each (topic in topics) {
						logger.debug("Removing event interceptor for event class {0} and topic '{1}'", [clazz, topic]);
						eventBusUserRegistry.removeEventClassInterceptor(clazz, interceptor, topic);
					}
				}
			}
		}

	}
}
