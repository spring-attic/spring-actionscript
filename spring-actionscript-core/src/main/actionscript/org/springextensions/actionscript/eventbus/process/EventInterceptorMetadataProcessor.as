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
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.Type;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventInterceptorMetadataProcessor extends AbstractEventBusMetadataProcessor {

		private static var logger:ILogger = getClassLogger(EventInterceptorMetadataProcessor);

		/** The EventInterceptor metadata */
		public static const EVENT_INTERCEPTOR_METADATA_NAME:String = "EventInterceptor";

		public function EventInterceptorMetadataProcessor() {
			super();
			metadataNames[metadataNames.length] = EVENT_INTERCEPTOR_METADATA_NAME;
		}

		override public function process(target:Object, metadataName:String, params:Array=null):* {
			var container:IMetadataContainer = params[0];
			var type:Type = (container as Type);
			if (type == null) {
				return;
			}
			if (!ClassUtils.isImplementationOf(type.clazz, IEventInterceptor, objFactory.applicationDomain)) {
				return;
				logger.warn("{0} is not an IEventInterceptor implementation", type.clazz);
			}
			var metaDatas:Array = type.getMetadata(EVENT_INTERCEPTOR_METADATA_NAME);
			for each (var metaData:Metadata in metaDatas) {
				processMetaData(target, type, metaData);
			}
		}

		protected function processMetaData(object:Object, type:Type, metaData:Metadata):void {
			var interceptor:IEventInterceptor = IEventInterceptor(object);
			logger.debug("Examining [EventInterceptor] metadata on {0}", [interceptor]);
			var className:String = getEventInterceptClassName(metaData);
			var topics:Array = getTopics(metaData, object);
			var topic:Object;

			if (className == null) {
				var eventName:String = getEventName(metaData);
				if (eventName == null) {
					if ((topics == null) || (topics.length == 0)) {
						eventBusUserRegistry.addInterceptor(interceptor);
					} else {
						for each (topic in topics) {
							eventBusUserRegistry.addInterceptor(interceptor, topic);
						}
					}
				} else {
					if ((topics == null) || (topics.length == 0)) {
						eventBusUserRegistry.addEventInterceptor(eventName, interceptor);
					} else {
						for each (topic in topics) {
							eventBusUserRegistry.addEventInterceptor(eventName, interceptor, topic);
						}
					}
				}
			} else {
				var clazz:Class = ClassUtils.forName(className, objFactory.applicationDomain);
				if ((topics == null) || (topics.length == 0)) {
					eventBusUserRegistry.addEventClassInterceptor(clazz, interceptor);
				} else {
					for each (topic in topics) {
						eventBusUserRegistry.addEventClassInterceptor(clazz, interceptor, topic);
					}
				}
			}
		}

		/**
		 *
		 * @param metaData
		 * @return
		 */
		protected function getEventInterceptClassName(metaData:Metadata):String {
			var result:String = null;

			if (metaData.hasArgumentWithKey(CLASS_KEY)) {
				result = metaData.getArgument(CLASS_KEY).value;
				logger.debug("Found class name metadata argument: {0}", [result]);
			}

			return result;
		}

		/**
		 *
		 * @param metaData
		 * @return
		 */
		protected function getEventName(metaData:Metadata):String {
			var result:String = null;
			if (metaData.hasArgumentWithKey(NAME_KEY)) {
				result = metaData.getArgument(NAME_KEY).value;
				logger.debug("Found event name metadata argument: {0}", [result]);
			} else {
				// no explicit name defined, look for the default argument
				var args:Array = metaData.arguments;
				for each (var arg:MetadataArgument in args) {
					if (!arg.key) {
						logger.debug("Found default metadata argument: {0}", [result]);
						result = arg.value;
					}
				}
			}
			return result;
		}

	}
}
