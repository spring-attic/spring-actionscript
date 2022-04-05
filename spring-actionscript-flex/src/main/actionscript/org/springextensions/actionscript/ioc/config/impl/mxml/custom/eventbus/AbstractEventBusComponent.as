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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus {

	import flash.events.Event;

	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.AbstractCustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	[DefaultProperty("childContent")]
	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractEventBusComponent extends AbstractCustomObjectDefinitionComponent implements IEventBusUserRegistryAware {
		public static const INSTANCE_CHANGED_EVENT:String = "instanceChanged";
		public static const CHILDCONTENT_CHANGED_EVENT:String = "childContentChanged";

		private var _eventBusUserRegistry:IEventBusUserRegistry;
		private var _childContent:Array;
		private var _instance:String;

		/**
		 * Creates a new <code>AbstractEventBusComponent</code> instance.
		 */
		public function AbstractEventBusComponent() {
			super();
		}

		[Bindable(event="childContentChanged")]
		public function get childContent():Array {
			return _childContent;
		}

		public function set childContent(value:Array):void {
			if (_childContent != value) {
				_childContent = value;
				dispatchEvent(new Event(CHILDCONTENT_CHANGED_EVENT));
			}
		}

		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return _eventBusUserRegistry;
		}

		public function set eventBusUserRegistry(value:IEventBusUserRegistry):void {
			_eventBusUserRegistry = value;
		}

		[Bindable(event="instanceChanged")]
		public function get instance():String {
			return _instance;
		}

		public function set instance(value:String):void {
			if (_instance != value) {
				_instance = value;
				dispatchEvent(new Event(INSTANCE_CHANGED_EVENT));
			}
		}

	}
}
