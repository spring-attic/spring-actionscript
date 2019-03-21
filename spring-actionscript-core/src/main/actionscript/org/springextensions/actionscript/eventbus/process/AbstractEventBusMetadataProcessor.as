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
	import flash.errors.IllegalOperationError;

	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Metadata;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.metadata.processor.AbstractSpringMetadataProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractEventBusMetadataProcessor extends AbstractSpringMetadataProcessor implements IObjectFactoryAware, IDisposable {

		/** The "clazz" property of the EventHandler metadata */
		protected static const CLASS_KEY:String = "clazz";
		protected static const COMMA:String = ",";
		/** The "name" property of the EventHandler metadata */
		protected static const NAME_KEY:String = "name";
		/** The "topic" property of the EventHandler metadata */
		protected static const TOPICS_KEY:String = "topics";
		/** The "topicProperties" property of the EventHandler metadata */
		protected static const TOPIC_PROPERTIES_KEY:String = "topicProperties";

		private static var logger:ILogger = getClassLogger(AbstractEventBusMetadataProcessor);

		public function AbstractEventBusMetadataProcessor() {
			super();
		}

		protected var objFactory:IObjectFactory;
		private var _isDisposed:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return IEventBusUserRegistryAware(objFactory).eventBusUserRegistry;
		}

		/**
		 * @inheritDoc
		 */
		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function set objectFactory(objectFactory:IObjectFactory):void {
			if (objectFactory is IEventBusUserRegistryAware) {
				objFactory = objectFactory;
			} else {
				throw new IllegalOperationError("IObjectFactory instance must implement IEventBusUserRegistryAware");
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			_isDisposed = true;
		}

		/**
		 *
		 * @param metaData
		 * @param object
		 * @return
		 */
		protected function getTopics(metaData:Metadata, object:Object):Array {
			var result:Array = [];
			var topicsValue:String;
			var name:String;
			if (metaData.hasArgumentWithKey(TOPICS_KEY)) {
				topicsValue = metaData.getArgument(TOPICS_KEY).value;
				var topics:Array = topicsValue.split(' ').join('').split(COMMA);
				for each (name in topics) {
					result[result.length] = name;
					logger.debug("Topic named '{0}' found in metadata on object {1}", [name, object]);
				}
			}
			if (metaData.hasArgumentWithKey(TOPIC_PROPERTIES_KEY)) {
				topicsValue = metaData.getArgument(TOPIC_PROPERTIES_KEY).value;
				var props:Array = topicsValue.split(' ').join('').split(COMMA);
				for each (name in props) {
					if (object.hasOwnProperty(name)) {
						result[result.length] = object[name];
						logger.debug("Topic property {0} found on object {1}", [object[name], object]);
					} else {
						logger.warn("Topic property {0} not found on object {1}", [name, object]);
					}
				}
			}
			return result;
		}
	}
}
