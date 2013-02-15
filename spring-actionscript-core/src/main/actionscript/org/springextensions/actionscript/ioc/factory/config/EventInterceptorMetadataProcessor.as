/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.springextensions.actionscript.ioc.factory.config {

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.Type;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventInterceptorMetadataProcessor extends AbstractEventBusMetadataProcessor {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = getLogger(EventInterceptorMetadataProcessor);

		/** The EventInterceptor metadata */
		private static const EVENT_INTERCEPTOR_METADATA_NAME:String = "EventInterceptor";

		public function EventInterceptorMetadataProcessor() {
			super(true, [EVENT_INTERCEPTOR_METADATA_NAME]);
		}

		override public function process(instance:Object, container:IMetadataContainer, name:String, objectName:String):void {
			var type:Type = (container as Type);
			if (type == null) {
				return;
			}
			if (!ClassUtils.isImplementationOf(type.clazz, IEventInterceptor, objFactory.applicationDomain)) {
				return;
				logger.debug("{0} is not an IEventInterceptor implementation", type.clazz);
			}
			var metaDatas:Array = type.getMetadata(EVENT_INTERCEPTOR_METADATA_NAME);
			for each (var metaData:Metadata in metaDatas) {
				processMetaData(instance, type, metaData);
			}
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function processMetaData(object:Object, type:Type, metaData:Metadata):void {
			var interceptor:IEventInterceptor = IEventInterceptor(object);
			var className:String = getEventInterceptClassName(metaData);
			var topics:Array = getTopics(metaData, object);
			var topic:Object;

			if (className == null) {
				var eventName:String = getEventName(metaData);
				if (eventName == null) {
					if ((topics == null) || (topics.length == 0)) {
						objFactory.eventBus.addInterceptor(interceptor);
					} else {
						for each (topic in topics) {
							objFactory.eventBus.addInterceptor(interceptor, topic);
						}
					}
				} else {
					if ((topics == null) || (topics.length == 0)) {
						objFactory.eventBus.addEventInterceptor(eventName, interceptor);
					} else {
						for each (topic in topics) {
							objFactory.eventBus.addEventInterceptor(eventName, interceptor, topic);
						}
					}
				}
			} else {
				var clazz:Class = ClassUtils.forName(className, objFactory.applicationDomain);
				if ((topics == null) || (topics.length == 0)) {
					objFactory.eventBus.addEventClassInterceptor(clazz, interceptor);
				} else {
					for each (topic in topics) {
						objFactory.eventBus.addEventClassInterceptor(clazz, interceptor, topic);
					}
				}
			}
		}

		protected function getEventInterceptClassName(metaData:Metadata):String {
			var result:String = null;

			if (metaData.hasArgumentWithKey(CLASS_KEY)) {
				result = metaData.getArgument(CLASS_KEY).value;
			}

			return result;
		}

		protected function getEventName(metaData:Metadata):String {
			var result:String = null;
			if (metaData.hasArgumentWithKey(NAME_KEY)) {
				result = metaData.getArgument(NAME_KEY).value;
			} else {
				// no explicit name defined, look for the default argument
				var args:Array = metaData.arguments;
				for each (var arg:MetadataArgument in args) {
					if (!arg.key) {
						result = arg.value;
					}
				}
			}
			return result;
		}

	}
}
