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
package org.springextensions.actionscript.ioc.event {

	import flash.events.Event;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class WireEvent extends Event {

		public static const WIRE_REQUEST:String = "wireRequest";

		private var _objectInstance:Object;

		public function WireEvent(type:String, instance:Object, bubbles:Boolean=true, cancelable:Boolean=true) {
			super(type, bubbles, cancelable);
			_objectInstance = instance;
		}

		public function get objectInstance():Object {
			return _objectInstance;
		}

		public function set objectInstance(value:Object):void {
			_objectInstance = value;
		}

		override public function clone():Event {
			return new WireEvent(type, objectInstance, bubbles, cancelable);
		}

	}
}
