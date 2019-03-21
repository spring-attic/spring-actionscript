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

	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.as3commons.lang.Assert;


	public class AbstractEventBusCustomConfigurator implements ICustomConfigurator, IEventBusUserRegistryAware {
		private var _eventBusUserRegistry:IEventBusUserRegistry;

		public function AbstractEventBusCustomConfigurator(eventBusUserRegistry:IEventBusUserRegistry) {
			Assert.notNull(eventBusUserRegistry, "eventBusUserRegistry argument must not be null");
			super();
			_eventBusUserRegistry = eventBusUserRegistry;
		}

		public function execute(instance:*, objectDefinition:IObjectDefinition):* {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return _eventBusUserRegistry;
		}

		public function set eventBusUserRegistry(value:IEventBusUserRegistry):void {
			_eventBusUserRegistry = value;
		}

	}
}
