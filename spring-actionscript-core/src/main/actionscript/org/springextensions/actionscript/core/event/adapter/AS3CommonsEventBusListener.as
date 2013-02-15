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
package org.springextensions.actionscript.core.event.adapter {

	import flash.events.Event;
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventBusListener;
	import org.springextensions.actionscript.core.event.EventBus;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AS3CommonsEventBusListener implements IEventBusListener {

		/**
		 * Creates a new <code>NewEventBusListener</code> instance.
		 */
		public function AS3CommonsEventBusListener() {
			super();
		}

		public function onEvent(event:Event):void {
			if (adapter.events[event] == null) {
				events[event] = true;
				EventBus.dispatchEvent(event);
			}
		}

		public var events:Dictionary = new Dictionary(true);
		public var adapter:EventBusAdapter;
	}
}