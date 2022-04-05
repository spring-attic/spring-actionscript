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
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventBusAwareObjectPostProcessor implements IObjectPostProcessor {

		private static var logger:ILogger = getClassLogger(EventBusAwareObjectPostProcessor);
		private var _objectFactory:IObjectFactory;

		/**
		 * Creates a new <code>EventBusObjectPostProcessor</code> instance.
		 */
		public function EventBusAwareObjectPostProcessor(objectFactory:IObjectFactory) {
			super();
			_objectFactory = objectFactory;
		}

		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			var eba:IEventBusAware = (object as IEventBusAware);
			if (eba != null) {
				eba.eventBus = IEventBusAware(_objectFactory).eventBus;
				logger.debug("object is IEventBusAware injecting eventbus");
			}
			var ebura:IEventBusUserRegistryAware = (object as IEventBusUserRegistryAware);
			if ((ebura != null) && (_objectFactory is IEventBusUserRegistryAware)) {
				ebura.eventBusUserRegistry = IEventBusUserRegistryAware(_objectFactory).eventBusUserRegistry;
				logger.debug("object is IEventBusUserRegistryAware injecting eventBusUserRegistry");
			}
			return object;
		}

		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}
	}
}
