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
package org.springextensions.actionscript.core.event {
	import org.as3commons.eventbus.IEventBusAware;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventBusAwareObjectPostProcessor implements IObjectPostProcessor {

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
				eba.eventBus = _objectFactory.eventBus;
			}
		}

		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}
	}
}
