/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.objectdefinition.event {

	import flash.events.Event;

	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinitionEvent extends Event {

		public static const INSTANCES_DEPENDENCIES_UPDATED:String = "instancesDependenciesUpdated";

		private var _instances:Vector.<Object>;
		private var _objectDefinition:IObjectDefinition;

		/**
		 * Creates a new <code>ObjectDefinitionEvent</code> instance.
		 */
		public function ObjectDefinitionEvent(type:String, definition:IObjectDefinition, instances:Vector.<Object>, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_instances = instances;
			_objectDefinition = definition;
		}

		public function get objectDefinition():IObjectDefinition {
			return _objectDefinition;
		}

		public function get instances():Vector.<Object> {
			return _instances;
		}

		override public function clone():Event {
			return new ObjectDefinitionEvent(type, _objectDefinition, _instances, bubbles, cancelable);
		}

	}
}
