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
package integration.testtypes {

	import flash.events.Event;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventInterceptor;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class DummyEventInterceptor implements IEventInterceptor {
		private var _blockEvent:Boolean;
		private var _eventBus:IEventBus;

		public var intercepted:Boolean = false;

		/**
		 * Creates a new <code>TestEventInterceptor</code> instance.
		 */
		public function DummyEventInterceptor() {
			super();
		}

		public function get blockEvent():Boolean {
			return _blockEvent;
		}

		public function set blockEvent(value:Boolean):void {
			_blockEvent = value;
		}

		public function intercept(event:Event, topic:Object=null):void {
			intercepted = true;
		}

		public function get eventBus():IEventBus {
			return _eventBus;
		}

		public function set eventBus(value:IEventBus):void {
			_eventBus = value;
		}
	}
}
